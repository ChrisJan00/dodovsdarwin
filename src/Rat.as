package  
{
	import flash.geom.ColorTransform;
	import flash.geom.Vector3D;
    import org.flixel.*;

    public class Rat extends FlxSprite
    {
        [Embed(source = "img/rat_anim.png")] private var ImgPlayer:Class;
        public var _max_health:int = 1;
        private var _stars:Array;
		private var _MaxVelocity_walking:int = 200;
		private var _playstate:PlayState;
		
		private const RAT_MOVEMENT_SPEED:Number = 40;
		private const RAT_CHASE_DODO_DISTANCE:Number = 200;
		private const RAT_FLEE_HUMAN_DISTANCE:Number = 130;
		private const RAT_APPROACH_EGG_DISTANCE:Number = 250;
		
		private var _aiState:String;
		private var _aiUpdateTimer:Number = 0;
		
		private const RAT_STATE_WANDER:String = "RatStateWander";
		private const RAT_STATE_CHASE:String = "RatStateChase";
		private const RAT_STATE_FLEE:String = "RatStateFlee";
		private const RAT_STATE_APPROACH:String = "RatStateApproach";
		
		private const RAT_WANDER_AIUPDATE_DELAY_MIN:Number = 0.5;
		private const RAT_WANDER_AIUPDATE_DELAY_RANGE:Number = 2.5;
		
		private var _lastWanderVector:Vector3D;
		
        public function  Rat(X:Number,Y:Number, p:PlayState):void
        {
            super(X, Y);
			
			_playstate = p;
            loadGraphic(ImgPlayer, true, true, 56, 28);
			
			_MaxVelocity_walking = 200;
            maxVelocity.x = 100;
            maxVelocity.y = 100;
            health = 1;         
            drag.x = 40;
            drag.y = 40;
			
            width = 37;
            height = 7;
            offset.x = 9;
            offset.y = 17;
			
            addAnimation("normal", [0, 1, 2, 3], 5);
            addAnimation("stopped", [1]);
            facing = RIGHT;
        }
        override public function update():void
        {
			
			_aiUpdateTimer -= FlxG.elapsed;
			
			var _loc_toVector:Vector3D = getSteering();
			if ( _loc_toVector ) {
				_loc_toVector.normalize();
				velocity.x = _loc_toVector.x * RAT_MOVEMENT_SPEED;
				velocity.y = _loc_toVector.y * RAT_MOVEMENT_SPEED;
			} else if ( _aiUpdateTimer <= 0 ) {
				_loc_toVector = getWander();
				_loc_toVector.normalize();
				_loc_toVector.scaleBy(0.9);
				velocity.x = _loc_toVector.x * RAT_MOVEMENT_SPEED;
				velocity.y = _loc_toVector.y * RAT_MOVEMENT_SPEED;
			}
			
			if (velocity.x < 0) {
				_facing = LEFT;
			} else {
				_facing = RIGHT;
			}
			
			if (velocity.x == 0 && velocity.y == 0) {
				play("stopped");
			} else {
				play("normal");
			}
			if (health <= 0) { _playstate.reload(); }
			
            super.update();
        }
		
		private function getSteering():Vector3D {
			var _loc_toVector:Vector3D = _playstate.getClosestDodoVector( this );
			if ( _loc_toVector && _loc_toVector.length < RAT_CHASE_DODO_DISTANCE ) {
				_aiState = RAT_STATE_CHASE;
				return( _loc_toVector );
			} else {
				_loc_toVector = _playstate.getClosestHumanVector( this );
				if ( _loc_toVector && _loc_toVector.length < RAT_FLEE_HUMAN_DISTANCE ) {
					_aiState = RAT_STATE_FLEE;
					_loc_toVector.scaleBy( -1 );
					return ( _loc_toVector );
				} else {
					_loc_toVector = _playstate.getClosestEggVector( this );
					if ( _loc_toVector && _loc_toVector.length < RAT_APPROACH_EGG_DISTANCE ) {
						_aiState = RAT_STATE_APPROACH;
						return ( _loc_toVector );
					}
				}
			}
			return ( null );
		}
		
		private function getWander():Vector3D {
			if (_aiState == RAT_STATE_WANDER ) {
				_aiUpdateTimer = ( RAT_WANDER_AIUPDATE_DELAY_MIN + Math.random() * RAT_WANDER_AIUPDATE_DELAY_RANGE );
				_lastWanderVector.normalize();
				_lastWanderVector = new Vector3D( _lastWanderVector.x + 1 - (Math.random() * 2), _lastWanderVector.y + 1 - (Math.random() * 2) );
				return _lastWanderVector;
			}
			_aiState = RAT_STATE_WANDER;
			_lastWanderVector = new Vector3D( 1 - (Math.random() * 2), 1 - (Math.random() * 2) );
			return _lastWanderVector;
		}
        
        override public function hitFloor(Contact:FlxCore=null):Boolean
        {
            return super.hitFloor();
        }
		
		override public function hitCeiling(Contact:FlxCore=null):Boolean
        {
            return super.hitFloor();
        }
    }
} 

