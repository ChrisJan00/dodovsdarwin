package  
{
	import flash.geom.ColorTransform;
	import flash.geom.Vector3D;
    import org.flixel.*;

    public class Pig extends FlxSprite
    {
        [Embed(source = "img/Player.png")] private var ImgPlayer:Class;
        public var _max_health:int = 1;
        public var _hurt_counter:Number = 0;
        private var _stars:Array;
		private var _MaxVelocity_walking:int = 200;
		private var _playstate:PlayState;
		
		private const PIG_MOVEMENT_SPEED:Number = 50;
		//private const PIG_FLEE_HUMAN_DISTANCE:Number = 100;
		private const PIG_FLEE_DODO_DISTANCE:Number = 50;
		private const PIG_APPROACH_FRUIT_DISTANCE:Number = 1000;
		
		private var _aiState:String;
		private var _aiUpdateTimer:Number = 0;
		
		private const PIG_STATE_WANDER:String = "PigStateWander";
		private const PIG_STATE_APPROACH:String = "PigStateApproach";
		private const PIG_STATE_FLEE:String = "PigStateFlee";
		
		private const PIG_WANDER_AIUPDATE_DELAY_MIN:Number = 0.5;
		private const PIG_WANDER_AIUPDATE_DELAY_RANGE:Number = 2.5;
		
        public function  Pig(X:Number,Y:Number, p:PlayState):void
        {
            super(X, Y);
			
			_playstate = p;
            loadGraphic(ImgPlayer, true, true, 16, 16);
			pixels.colorTransform( pixels.rect, new ColorTransform( 10, 0.5, 2) );
			
			_MaxVelocity_walking = 200;
            maxVelocity.x = 100;
            maxVelocity.y = 100;
            health = 1;         
            drag.x = 5;
            drag.y = 5;
			
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
				
				_aiUpdateTimer -= FlxG.elapsed;
				
				var _loc_toVector:Vector3D = getSteering();
				if ( _loc_toVector ) {
					_loc_toVector.normalize();
					if ( _aiState == PIG_STATE_APPROACH ) {
						_loc_toVector.scaleBy(0.5);
					}
					velocity.x = _loc_toVector.x * PIG_MOVEMENT_SPEED;
					velocity.y = _loc_toVector.y * PIG_MOVEMENT_SPEED;
				} else if ( _aiUpdateTimer <= 0 ) {
					_loc_toVector = getWander();
					_loc_toVector.normalize();
					_loc_toVector.scaleBy(0.7);
					velocity.x = _loc_toVector.x * PIG_MOVEMENT_SPEED;
					velocity.y = _loc_toVector.y * PIG_MOVEMENT_SPEED;
				}
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
		
		private function getSteering():Vector3D {
			var _loc_toVector:Vector3D = _playstate.getClosestDodoVector( this );
			if ( _loc_toVector && _loc_toVector.length < PIG_FLEE_DODO_DISTANCE ) {
				_aiState = PIG_STATE_FLEE;
				_loc_toVector.scaleBy( -1 );
				return( _loc_toVector );
			} else {
				_loc_toVector = _playstate.getClosestFruitVector( this );
				if ( _loc_toVector && _loc_toVector.length < PIG_APPROACH_FRUIT_DISTANCE ) {
					_aiState = PIG_STATE_APPROACH;
					return ( _loc_toVector );
				}
			}
			return ( null );
		}
		
		private function getWander():Vector3D {
			var _loc_toVector:Vector3D;
			if (_aiState == PIG_STATE_WANDER ) {
				_aiUpdateTimer = ( PIG_WANDER_AIUPDATE_DELAY_MIN + Math.random() * PIG_WANDER_AIUPDATE_DELAY_RANGE );
				_loc_toVector = new Vector3D( velocity.x, velocity.y );
				_loc_toVector.normalize();
				_loc_toVector = new Vector3D( _loc_toVector.x + 1 - (Math.random() * 2), _loc_toVector.y + 1 - (Math.random() * 2) );
				return _loc_toVector;
			}
			
			_aiState = PIG_STATE_WANDER;
			_loc_toVector = new Vector3D( 1 - (Math.random() * 2), 1 - (Math.random() * 2) );
			return _loc_toVector;
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
    }
} 

