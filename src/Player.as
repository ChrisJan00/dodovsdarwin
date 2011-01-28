package  
{
    import org.flixel.*;

    public class Player extends FlxSprite
    {
        [Embed(source = "img/Player.png")] private var ImgPlayer:Class;
        private var _move_speed:int = 400;
        private var _jump_power:int = 100;   
        public var _max_health:int = 1;
        public var _hurt_counter:Number = 0;
        private var _stars:Array;
        private var _attack_counter:Number = 0;
		private var _jump_counter:Number = 0;
        public var _floor_was_hit:Boolean = false;
		private var _savestate_x:int = 48;
		private var _savestate_y:int = 240;
		private var _MaxVelocity_walking:int = 200;
		private var _playstate:PlayState;
		
        public function  Player(X:Number,Y:Number, p:PlayState):void
        {
            super(X, Y);
			
			_playstate = p;
            loadGraphic(ImgPlayer, true, true, 16, 16);
     
			_MaxVelocity_walking = 200;
            maxVelocity.x = 350;
            maxVelocity.y = 350;
            health = 1;
            acceleration.y = 420;            
            drag.x = 300;
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
			//var _old_jump_counter:Number = _jump_counter
            //if(dead)
            //{
				//kill();
                //if(finished) exists = false;
                //else
                    //super.update();
                //return;
			//}
            //}
            if (_hurt_counter > 0)
            {
                _hurt_counter -= FlxG.elapsed;
            }
			else {
			
			if (_jump_counter > 0)
			{
				_jump_counter -= FlxG.elapsed;
			}
           
            //move left and right   
            if (FlxG.keys.LEFT)
			{
				facing = LEFT;
				if (velocity.x > -_MaxVelocity_walking)
				{
					velocity.x -= _move_speed * FlxG.elapsed;
					if (velocity.x < -_MaxVelocity_walking) {
						velocity.x = -_MaxVelocity_walking;
					}
				}
			}
			else if (FlxG.keys.RIGHT)
			{
				facing = RIGHT;
				if (velocity.x < _MaxVelocity_walking)
				{
					velocity.x += _move_speed * FlxG.elapsed;
					if (velocity.x > _MaxVelocity_walking) {
						velocity.x = _MaxVelocity_walking;
					}
				}
				
			}
			//jumping
			//if (FlxG.keys.justPressed("J") && velocity.y == 0)
			if (FlxG.keys.pressed("J"))
			{
				if (_jump_counter <= 0 && _floor_was_hit) {
					_jump_counter = 0.63
				}
				if (_jump_counter>0) {
					velocity.y = -_jump_power*(Math.abs(0.3*velocity.x / maxVelocity.x)+0.7);
				}
			} else {
				_jump_counter = 0; 
			}
			
			//if (FlxG.keys.justPressed("S"))
			//{ // save
				//save();
			//}
			//
			//if (FlxG.keys.justPressed("D"))
			//{ // load
				//x = _savestate_x;
				//y = _savestate_y;
				//reload();
			//}
			

			//if (_jump_counter != _old_jump_counter)
			//{
				//PlayState._scoreDisplay.text = _jump_counter.toString();
			//}
			}
            if (_hurt_counter > 0)
            {
                play("hurt");
                
            }
            else            
            {
				if (health <= 0) { _playstate.reload(); }
                if (velocity.y != 0)
                {
                    play("jump");
                }
                else
                {
                    if (velocity.x == 0)
                    {
                        play("stopped");
                    }
                    else
                    {
                        play("normal");
                    }
                }
            }
			
			if (velocity.y != 0) {
				_floor_was_hit = false;
			}
			
            super.update();
            
        }
        
        override public function hitFloor(Contact:FlxCore=null):Boolean
        {
			_floor_was_hit = true;
            return super.hitFloor();
        }
		
		override public function hitCeiling(Contact:FlxCore=null):Boolean
        {
			_jump_counter = 0;
            return super.hitFloor();
        }
        
        override public function hurt(Damage:Number):void
        {
            if (health > 0) {
				//health -= Damage;
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
			x = _savestate_x;
			y = _savestate_y;
			velocity.x = 0;
			velocity.y = 0;
			_jump_counter = 0;
			health = 1;
		}
		
		public function save(X:int=-1,Y:int=-1):void
		{
			if (X == -1) { X = x; }
			if (Y == -1) { Y = y; }
			_savestate_x = X;
			_savestate_y = Y;
		}
            
    }
    
} 