package  
{
	import flash.geom.ColorTransform;
	import flash.geom.Vector3D;
    import org.flixel.*;

    public class Human extends FlxSprite
    {
        [Embed(source = "img/Player.png")] private var ImgPlayer:Class;
        public var _max_health:int = 1;
        public var _hurt_counter:Number = 0;
        private var _stars:Array;
		private var _MaxVelocity_walking:int = 200;
		private var _playstate:PlayState;
		
		private const HUMAN_MOVEMENT_SPEED:Number = 50;
		private const HUMAN_CHASE_RAT_DISTANCE:Number = 90;
		private const HUMAN_CHASE_DODO_DISTANCE:Number = 100;
		
		private var _aiState:String;
		private var _aiUpdateTimer:Number = 0;
		
		private const HUMAN_STATE_WANDER:String = "HumanStateWander";
		private const HUMAN_STATE_CHASE:String = "HumanStateChase";
		
        public function  Human(X:Number,Y:Number, p:PlayState):void
        {
            super(X, Y);
			
			_playstate = p;
            loadGraphic(ImgPlayer, true, true, 16, 16);
			pixels.colorTransform( pixels.rect, new ColorTransform( 5, 0.2, 0.5) );
     
			_MaxVelocity_walking = 200;
            maxVelocity.x = 100;
            maxVelocity.y = 100;
            health = 1;         
            //drag.x = 400;
            //drag.y = 400;
			
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
					velocity.x = _loc_toVector.x * HUMAN_MOVEMENT_SPEED;
					velocity.y = _loc_toVector.y * HUMAN_MOVEMENT_SPEED;
				} else if ( _aiUpdateTimer <= 0 ) {
					_loc_toVector = getWander();
					_loc_toVector.normalize();
					_loc_toVector.scaleBy(0.35);
					velocity.x = _loc_toVector.x * HUMAN_MOVEMENT_SPEED;
					velocity.y = _loc_toVector.y * HUMAN_MOVEMENT_SPEED;
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
			var _loc_toVector:Vector3D = _playstate.getClosestRatVector( this );
			if ( _loc_toVector && _loc_toVector.length < HUMAN_CHASE_RAT_DISTANCE ) {
				_aiState = HUMAN_STATE_CHASE;
				return( _loc_toVector );
			} else {
				_loc_toVector = _playstate.getClosestDodoVector( this );
				if ( _loc_toVector && _loc_toVector.length < HUMAN_CHASE_DODO_DISTANCE ) {
					_aiState = HUMAN_STATE_CHASE;
					return ( _loc_toVector );
				}
			}
			return ( null );
		}
		
		private function getWander():Vector3D {
			var _loc_toVector:Vector3D;
			if (_aiState == HUMAN_STATE_WANDER ) {
				_aiUpdateTimer = 0.7;
				_loc_toVector = new Vector3D( velocity.x, velocity.y );
				_loc_toVector.normalize();
				_loc_toVector = new Vector3D( _loc_toVector.x + 1 - (Math.random() * 2), _loc_toVector.y + 1 - (Math.random() * 2) );
				return _loc_toVector;
			}
			
			_aiState = HUMAN_STATE_WANDER;
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
    }
} 

