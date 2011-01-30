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
		
				
		private var _MaxVelocity_walking:int = 200;
		private var _playstate:PlayState;
		private var _looking_angle: Number = 0;
		
		private const PLAYER_MOVEMENT_SPEED:Number = 500;
		
		private const PLAYER_EAT_ANIMATION_DURATION:Number = 2;
		private var _eatAnimationTimer:Number = 0;
		
		private var shitBlocked:Boolean = false;
		public var eatenFruitCount:Number = 0;
		public const SHIT_THRESHOLD:Number = 5;
		
		private var pregnant:Boolean = false;
		public var matingProgress:Number = 0;
		protected var matingSpeed:Number = 0.2; // 5 seconds of sex
		protected var lover:Dodo = null;
		
		private var _keepFlashingRedTimer:Number = 0;
		private var _invincibleTimer:Number = 0;
		private var _isFlashing:Boolean = true;
		private var _flashTimer:Number = 0;
		
		private var _remainDeadTimer:Number = 0;
		
		private var _sinceLastMadeLove:Number = Number.MAX_VALUE;
		private var _sinceLastPooped:Number = Number.MAX_VALUE;
		
        public function  Player(X:Number,Y:Number, p:PlayState):void
        {
            super(X, Y);
			this.health
			_playstate = p;
            loadGraphic(ImgPlayer, true, true, 80, 70);
			
			_MaxVelocity_walking = 200;
            maxVelocity.x = 100;
            maxVelocity.y = 100;
            health = 1;
            drag.x = 400;
            drag.y = 400;
			
            width = 40;
            height = 17;
            offset.x = 20;
            offset.y = 48;
						
            addAnimation("normal", [0, 1, 2, 3], 5);
            addAnimation("eating", [4,5.6,7], 7);
            addAnimation("stopped", [1]);
            addAnimation("dead", [5]);
            addAnimation("pooping", [8, 9], 4);
            addAnimation("mating", [10, 11], 5);
            facing = RIGHT;
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
				if (pregnant) {
					pregnant = false;
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
				if (velocity.x == 0 && velocity.y == 0) {
					play("stopped");
				} else {
					play("normal");
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
		
		public function eat() : void
		{
			eatenFruitCount += 1;
			_eatAnimationTimer = PLAYER_EAT_ANIMATION_DURATION;
			FlxG.play(EatSound);
		}
		
		public function unleashShit() : void
		{
			if (eatenFruitCount < SHIT_THRESHOLD)
				return;
			eatenFruitCount -= SHIT_THRESHOLD;
		
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
			
			var egg:Egg = new Egg(oX, oY, _playstate);
			egg.launch( oX, oY, feetX, feetY, dirX, dirY );
			
			_playstate.addSprite(egg, _playstate._eggs);
			
			_sinceLastPooped = 0;
			FlxG.play(PoopSound);
		}
		
		// Mating
		public function makeLove( dodo: Dodo ) : void
		{
			if (lover == dodo) {
				matingProgress += FlxG.elapsed * matingSpeed;
				if (matingProgress >= 1) {
					matingProgress = 1;
					pregnant = true;
					lover.flyAway();
					lover = null;
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
    }
}