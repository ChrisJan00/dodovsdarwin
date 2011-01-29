package  
{
    import org.flixel.*;

    public class Player extends FlxSprite
    {
        [Embed(source = "img/Player.png")] private var ImgPlayer:Class;
        public var _max_health:int = 1;
        public var _hurt_counter:Number = 0;
        private var _stars:Array;
		private var _MaxVelocity_walking:int = 200;
		private var _playstate:PlayState;
		
		private const PLAYER_MOVEMENT_SPEED:Number = 500;
		
        public function  Player(X:Number,Y:Number, p:PlayState):void
        {
            super(X, Y);
			
			_playstate = p;
            loadGraphic(ImgPlayer, true, true, 16, 16);
     
			_MaxVelocity_walking = 200;
            maxVelocity.x = 100;
            maxVelocity.y = 100;
            health = 1;         
            drag.x = 400;
            drag.y = 400;
			
            width = 10;
            height = 14;
            offset.x = 2;
            offset.y = 2;
			
            addAnimation("normal", [0, 1, 2, 3], 10);
            addAnimation("jump", [4, 5, 6], 25);
            addAnimation("attack", [4,5,6],10);
            addAnimation("stopped", [0]);
            addAnimation("hurt", [7,8,8,8,8,8,8,8],5);
            addAnimation("dead", [7, 8, 8], 5);
            facing = RIGHT;
        }
        override public function update():void
        {
            if (_hurt_counter > 0)
            {
                _hurt_counter -= FlxG.elapsed;
            }
			else {
				
			acceleration.x = acceleration.y = 0;
			
            //move left and right   
            if (FlxG.keys.LEFT)
			{
				facing = LEFT;
				acceleration.x = -1 * PLAYER_MOVEMENT_SPEED;
			}
			if (FlxG.keys.RIGHT)
			{
				facing = RIGHT;
				acceleration.x = PLAYER_MOVEMENT_SPEED;
			}
			if (FlxG.keys.UP)
			{
				// TODO Commented out for now because of animation?
				//facing = UP;
				facing = RIGHT;
				acceleration.y = -1 * PLAYER_MOVEMENT_SPEED;
			}
			if (FlxG.keys.DOWN)
			{
				//facing = DOWN;
				facing = RIGHT;
				acceleration.y = PLAYER_MOVEMENT_SPEED;
			}
			}
			
			if (acceleration.x != 0 && acceleration.y != 0) {
				acceleration.x /= Math.pow(2, 0.5);
				acceleration.y /= Math.pow(2, 0.5);
			}
            if (_hurt_counter > 0)
            {
                play("hurt");
                
            }
            else            
            {
				
				if (velocity.x == 0 && velocity.y == 0) {
					play("stopped");
				} else {
					play("normal");
				}
				
				if (health <= 0) { _playstate.reload(); }
            }
			
            super.update();
            
        }
        
        override public function hitFloor(Contact:FlxCore=null):Boolean
        {
            return super.hitFloor();
        }
		
		override public function hitCeiling(Contact:FlxCore=null):Boolean
        {
            return super.hitFloor();
        }
        
        override public function hurt(Damage:Number):void
        {
            if (health > 0) {
				_hurt_counter = 1.0;
				return super.hurt(Damage);
			}			
            
        }       
		
		override public function kill():void
		{
			//reload();
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
            
    }
    
} 