package  
{
    import org.flixel.*;

    public class Player extends FlxSprite implements IDodo
    {
        [Embed(source = "img/dodo_walk.png")] private var ImgPlayer:Class;
		
		[Embed(source = "snd/eat.mp3")] private var EatSound:Class;
		[Embed(source = "snd/playerhurt.mp3")] private var HurtSound:Class;
		[Embed(source = "snd/playerdie.mp3")] private var DeathSound:Class;
		[Embed(source = "snd/poop.mp3")] private var PoopSound:Class;
		
		private var FlxEatSound:FlxSound;
		
		private var _playstate:PlayState;
		private var _looking_angle: Number = 0;
		
		private const PLAYER_MOVEMENT_SPEED:Number = 500;
		
		private const PLAYER_EAT_ANIMATION_DURATION:Number = 1.8;
		private var _eatAnimationTimer:Number = 0;
		
		private var shitBlocked:Boolean = false;
		public var eatenFruitCount:Number = 0;
		public const SHIT_THRESHOLD:Number = 4;
		
		public var isReadyToGiveBirth:Boolean = false;
		public var isPregnant:Boolean = false;
		public var matingProgress:Number = 0;
		protected var matingSpeed:Number = 0.5; // 2 seconds of sex
		protected var lover:Dodo = null;
		
		private var _keepFlashingRedTimer:Number = 0;
		private var _invincibleTimer:Number = 0;
		private var _isFlashing:Boolean = true;
		private var _flashTimer:Number = 0;
		
		private var _remainDeadTimer:Number = 0;
		
		private var _sinceLastMadeLove:Number = Number.MAX_VALUE;
		private var _sinceLastPooped:Number = Number.MAX_VALUE;
		
		private var _PLAYER_GAIN_HEALTH_TIME:int = 3;
		private var _gainHealthTimer:Number = _PLAYER_GAIN_HEALTH_TIME;
		
		private var _family:int = 1;
		
		private var _eatenFruitEggCount:Number = 0;
		private const EGG_THRESHOLD:Number = 8;
		
		private const PLAYER_MAX_SPEED:Number = 120;
		private const PLAYER_MAX_SPEED_DIAGONAL:Number = PLAYER_MAX_SPEED * Math.PI * 0.25;
		
        public function  Player(X:Number,Y:Number, p:PlayState):void
        {
            super(X, Y);
			this.health
			_playstate = p;
            loadGraphic(ImgPlayer, true, true, 80, 70);
			
            maxVelocity.x = PLAYER_MAX_SPEED;
            maxVelocity.y = PLAYER_MAX_SPEED;
            health = 1;
            drag.x = 500;
            drag.y = 500;
			
            width = 40;
            height = 17;
            offset.x = 20;
            offset.y = 48;
						
            addAnimation("normal", [0, 1, 2, 3], 5);
            addAnimation("normal_wounded", [0, 1, 4, 3], 5);
            addAnimation("normal_wounded_badly", [4, 1, 4, 3], 5);
            addAnimation("eating", [4,5,6,7], 6);
            addAnimation("stopped", [1]);
            addAnimation("stopped_wounded", [8, 1, 1], 2);
            addAnimation("stopped_wounded_badly", [8, 1], 1.5);
            addAnimation("dead", [12]);
            addAnimation("pooping", [8, 9], 4);
            addAnimation("mating", [10, 11], 5);
            facing = RIGHT;
			
			// initialize with silent sound
			FlxEatSound = FlxG.play(EatSound,0,false);
        }
        override public function update():void
        {
			if ( _remainDeadTimer > 0 ) {
				velocity.x = velocity.y = 0;
				acceleration.x = acceleration.y = 0;
				if ( _keepFlashingRedTimer > 0 ) {
					_keepFlashingRedTimer -= FlxG.elapsed;
					color = 0xFF0000;
				} else {
					color = 0x00ffffff;
					_keepFlashingRedTimer = 0;
				}
				alpha = 1;
				play("dead");
				_remainDeadTimer -= FlxG.elapsed;
				if ( _remainDeadTimer <= 0 ) {
					_playstate.resetLevel();
				}
				super.update();
				return;
			}
			
			acceleration.x = acceleration.y = 0;
			
			//move left and right   
			if (FlxG.keys.LEFT || FlxG.keys.A)	{
				facing = LEFT;
				acceleration.x = -1 * PLAYER_MOVEMENT_SPEED;
			}
			if (FlxG.keys.RIGHT || FlxG.keys.D) {
				facing = RIGHT;
				acceleration.x = PLAYER_MOVEMENT_SPEED;
			}
			if (FlxG.keys.UP || FlxG.keys.W) {
				acceleration.y = -1 * PLAYER_MOVEMENT_SPEED;
			}
			if (FlxG.keys.DOWN || FlxG.keys.S)	{
				acceleration.y = PLAYER_MOVEMENT_SPEED;
			}
			if (FlxG.keys.X || FlxG.keys.CONTROL || FlxG.keys.SPACE) {
				if ( isReadyToGiveBirth ) {
					isReadyToGiveBirth = false;
					isPregnant = false;
					_eatenFruitEggCount = 0;
					shitBlocked = true;
					matingProgress = 0;
					launchEgg();
				}
				// Pooing time!
				if (!shitBlocked) {
					shitBlocked = true;
					unleashShit();
				}
			} else if (shitBlocked) 
				shitBlocked = false;
			
			if (acceleration.x != 0 && acceleration.y != 0) {
				acceleration.x /= Math.pow(2, 0.5);
				acceleration.y /= Math.pow(2, 0.5);
				maxVelocity.x = PLAYER_MAX_SPEED_DIAGONAL;
				maxVelocity.y = PLAYER_MAX_SPEED_DIAGONAL;
			} else {
				maxVelocity.x = PLAYER_MAX_SPEED;
				maxVelocity.y = PLAYER_MAX_SPEED;
			}
			
			if (acceleration.x != 0 || acceleration.y != 0) {
				_looking_angle = recomputeLookingAngle( acceleration.x, acceleration.y );
			}
			if ( _sinceLastPooped <= 0.6 ) {
				play("pooping");
			} else if ( _sinceLastMadeLove <= 0.1 ) {
				play("mating");
			} else if ( _eatAnimationTimer > 0 ) {
				_eatAnimationTimer -= FlxG.elapsed;
				play("eating");
			} else {
				if ( health < 0.3 ) {
					if (velocity.x == 0 && velocity.y == 0) {
						play("stopped_wounded_badly");
					} else {
						play("normal_wounded_badly");
					}
				} else if ( health < 0.6 ) {
					if (velocity.x == 0 && velocity.y == 0) {
						play("stopped_wounded");
					} else {
						play("normal_wounded");
					}
				} else {
					if (velocity.x == 0 && velocity.y == 0) {
						play("stopped");
					} else {
						play("normal");
					}
				}
			}
			
			if ( _keepFlashingRedTimer > 0 ) {
				_keepFlashingRedTimer -= FlxG.elapsed;
				color = 0xFF1111;
			} else {
				color = 0x00ffffff;
				_keepFlashingRedTimer = 0;
			}
			if ( _invincibleTimer > 0 ) {
				_invincibleTimer -= FlxG.elapsed;
				_flashTimer -= FlxG.elapsed;
				if ( _flashTimer <= 0 ) {
					if ( _isFlashing ) {
						alpha = 1;
						_flashTimer = 0.09;
						_isFlashing = false;
					} else {
						alpha = 0;
						_flashTimer = 0.09;
						_isFlashing = true;
					}
				}
			} else {
				alpha = 1;
				_isFlashing = true;
				_flashTimer = 0;
			}
			
			_sinceLastMadeLove += FlxG.elapsed;
			_sinceLastPooped += FlxG.elapsed;
			
			if (health <= 0) { 
				_playstate.reload(); 
			}
			
			if (health < 1 && health > 0) {
				_gainHealthTimer -= FlxG.elapsed;
				if (_gainHealthTimer < 0) {
					health = Math.min( 1, health + 0.01);
					_gainHealthTimer = _PLAYER_GAIN_HEALTH_TIME;
				}
			}
			
			super.update();
		}
		
		private function recomputeLookingAngle( vecx:Number, vecy:Number ) : Number
		{
			if (vecx == 0 && vecy == 0) return 0;
			if (vecx > 0 && vecy == 0) return 0;
			if (vecx > 0 && vecy < 0) return -Math.PI/4;
			if (vecx > 0 && vecy > 0) return Math.PI/4;
			if (vecx < 0 && vecy == 0) return Math.PI;
			if (vecx < 0 && vecy < 0) return -3*Math.PI/4;
			if (vecx < 0 && vecy > 0) return 3*Math.PI/4;
			if (vecx == 0 && vecy < 0) return -Math.PI/2;
			if (vecx == 0 && vecy > 0) return Math.PI / 2;
			return 0;
		}
		
		public function reload():void
		{
			x = 48;
			y = 240;
			velocity.x = 0;
			velocity.y = 0;
			health = 1;
		}
		
		public function save(X:int=-1,Y:int=-1):void
		{
			if (X == -1) { X = x; }
			if (Y == -1) { Y = y; }
		}
		
		public function eat() : Boolean
		{
			if ( isPregnant ) {
				if ( birthReadyProgress == 1) {
					return false;
				} else {
					_eatenFruitEggCount = Math.min( _eatenFruitEggCount + 1, EGG_THRESHOLD);
					if ( birthReadyProgress == 1 ) {
						isReadyToGiveBirth = true;
					}
				}
			} else {
				if (eatenFruitCount + 1 > SHIT_THRESHOLD) {
					return false;
				} else {
					eatenFruitCount = Math.min( eatenFruitCount + 1, SHIT_THRESHOLD);
				}
			}
			health = Math.min( 1, health + 0.1 );
			_eatAnimationTimer = PLAYER_EAT_ANIMATION_DURATION;
			FlxEatSound.stop();
			FlxEatSound = FlxG.play(EatSound);
			_playstate.hudDisplay.onEat();
			return true;
		}
		
		public function unleashShit() : void
		{
			if (eatenFruitCount < SHIT_THRESHOLD)
				return;
			eatenFruitCount -= SHIT_THRESHOLD;
			_playstate.hudDisplay.onPoop();
		
			// direction
			var dirX : Number = Math.cos( _looking_angle + Math.PI );
			var dirY : Number = Math.sin( _looking_angle + Math.PI );
			
			// originalPos
			var oX : Number = (x + width / 2) + dirX * Math.max(width,height)/2;
			var oY : Number = (y + height / 2) + dirY * Math.max(width,height)/2;
			
			// feetPos
			var feetX : Number = x + width / 2;
			var feetY : Number = y + height;
			
			//var egg:Egg = new Egg(oX, oY, _playstate);
			//egg.launch( oX, oY, feetX, feetY, dirX, dirY );
			//
			//_playstate.addSprite(egg, _playstate._seeds);
			var seed:Seed = new Seed(oX, oY, _playstate);
			seed.launch( oX, oY, feetX, feetY, dirX, dirY );
			
			_playstate.addSprite(seed, _playstate._seeds);
			
			_sinceLastPooped = 0;
			FlxG.play(PoopSound);
		}
		
		public function launchEgg() : void
		{
			// direction
			var dirX : Number = Math.cos( _looking_angle + Math.PI );
			var dirY : Number = Math.sin( _looking_angle + Math.PI );
			
			// originalPos
			var oX : Number = (x + width / 2) + dirX * Math.max(width,height)/2;
			var oY : Number = (y + height / 2) + dirY * Math.max(width,height)/2;
			
			// feetPos
			var feetX : Number = x + width / 2;
			var feetY : Number = y + height;
			
			if ( facing == RIGHT ) {
				feetX -= 20;
			}
			
			var egg:Egg = new Egg(oX, oY, _playstate, true, _family);
			egg.launch( oX, oY, feetX, feetY, dirX, dirY );
			
			_playstate.addSprite(egg, _playstate._eggs);
			
			_sinceLastPooped = 0;
			_playstate.hudDisplay.onLayEgg();
			FlxG.play(PoopSound);
		}
		
		// Mating
		public function makeLove( dodo: Dodo ) : void
		{
			if (lover == dodo) {
				matingProgress += FlxG.elapsed * matingSpeed;
				if (matingProgress >= 1) {
					matingProgress = 1;
					isPregnant = true;
					_eatenFruitEggCount = 0;
					lover.flyAway();
					lover = null;
					_playstate.hudDisplay.onGetPregnant();
				}
			}
			else if (lover == null) {
				lover = dodo;
			}
			_sinceLastMadeLove = 0;
		}
		
		public function dontMakeLove( dodo: Dodo ) : void
		{
			if (lover == dodo) {
				matingProgress = 0;
				lover = null;
			}
		}
		
		public function killedByEnemy():void {
			FlxG.play(DeathSound);
			_remainDeadTimer = 5;
			_keepFlashingRedTimer = 0.2;
			_playstate.removeEntityFromArrayOnly(this, _playstate._dodos);
			_playstate.removeEntityFromArrayOnly(this, _playstate._dodoAdults);
		}
		
		/* INTERFACE IDodo */
		
		public function takeHumanDamage():void
		{
			if ( _invincibleTimer <= 0 ) {
				FlxG.play(HurtSound);
				health -= 0.6;
				if ( health <= 0 ) {
					killedByEnemy();
				} else {
					_keepFlashingRedTimer += 0.3;
					_invincibleTimer += 1.2;
				}
			}
		}
		
		public function takeRatDamage():void
		{
			if ( _invincibleTimer <= 0 ) {
				FlxG.play(HurtSound);
				health -= 0.3;
				if ( health <= 0 ) {
					killedByEnemy();
				} else {
					_keepFlashingRedTimer += 0.3;
					_invincibleTimer += 1.2;
				}
			}
		}
		
		public function isFlying():Boolean {
			return (false);
		}
		
		public function get birthReadyProgress():Number {
			if ( !isPregnant ) return 0;
			if ( EGG_THRESHOLD == 0 ) return 1;
			return ( Math.min( 1, _eatenFruitEggCount / EGG_THRESHOLD ));
		}
		
		public function get poopReadyProgress():Number {
			if ( SHIT_THRESHOLD == 0 ) return 1;
			return ( Math.min( 1, eatenFruitCount / SHIT_THRESHOLD ));
		}
		
		public function get family():int { return _family; }
		
		public function resetScaredPigTimer():void {
			// Empty implementation for player
		}
    }
}