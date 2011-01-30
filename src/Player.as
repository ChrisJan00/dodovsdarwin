﻿package  
{
    import org.flixel.*;

    public class Player extends FlxSprite implements IDodo
    {
        [Embed(source = "img/dodo_walk.png")] private var ImgPlayer:Class;
        public var _max_health:int = 1;
		private var _MaxVelocity_walking:int = 200;
		private var _playstate:PlayState;
		private var _looking_angle: Number = 0;
		
		private const PLAYER_MOVEMENT_SPEED:Number = 500;
		
		private const PLAYER_EAT_ANIMATION_DURATION:Number = 2;
		private var _eatAnimationTimer:Number = 0;
		
		private var shitBlocked:Boolean = false;
		public var eatenFruitCount:Number = 0;
		public const SHIT_THRESHOLD:Number = 5;
		
		private var hatchReady:Boolean = true;
		
        public function  Player(X:Number,Y:Number, p:PlayState):void
        {
            super(X, Y);
			
			_playstate = p;
            loadGraphic(ImgPlayer, true, true, 80, 70);
			
			_MaxVelocity_walking = 200;
            maxVelocity.x = 100;
            maxVelocity.y = 100;
            health = 1;
            drag.x = 400;
            drag.y = 400;
			
            width = 33;
            height = 17;
            offset.x = 11;
            offset.y = 49;
			
            addAnimation("normal", [0, 1, 2, 3], 5);
            addAnimation("eating", [4,5.6,7], 7);
            addAnimation("stopped", [1, 3], 2);
            facing = RIGHT;
        }
        override public function update():void
        {
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
				if (hatchReady) {
					hatchReady = false;
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
			if ( _eatAnimationTimer > 0 ) {
				_eatAnimationTimer -= FlxG.elapsed;
				play("eating");
			} else {
				if (velocity.x == 0 && velocity.y == 0) {
					play("stopped");
				} else {
					play("normal");
				}
			}
			
			
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
		}
		
		/* INTERFACE IDodo */
		
		public function takeHumanDamage():void
		{
			trace("Taking Human Damage: " + this);
		}
		
		public function takeRatDamage():void
		{
			trace("Taking Rat Damage: " + this);
		}
    }
    
} 