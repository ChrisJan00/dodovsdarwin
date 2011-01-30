package  
{
	import flash.geom.ColorTransform;
	import flash.geom.Vector3D;
    import org.flixel.*;

    public class Dodo extends FlxSprite
    {
        [Embed(source = "img/dodo_male_walk.png")] private var ImgPlayer:Class;
        public var _max_health:int = 1;
		private var _MaxVelocity_walking:int = 200;
		private var _playstate:PlayState;
		
		private const DODO_MOVEMENT_SPEED:Number = 80;
		private const DODO_FLEE_HUMAN_DISTANCE:Number = 100;
		private const DODO_FLEE_RAT_DISTANCE:Number = 100;
		private const DODO_APPROACH_DODO_DISTANCE:Number = 200;
		private const DODO_APPROACH_DODO_DISTANCE_STOP:Number = 30;
		private const DODO_APPROACH_PIG_DISTANCE:Number = 100;
		private const DODO_APPROACH_FRUIT_DISTANCE:Number = 400;
		
		private var _aiState:String;
		private var _aiUpdateTimer:Number = 0;
		
		private const DODO_STATE_WANDER:String = "DodoStateWander";
		private const DODO_STATE_FLEE:String = "DodoStateFlee";
		private const DODO_STATE_MATE:String = "DodoStateMate";
		private const DODO_STATE_CHASE:String = "DodoStateChase";
		private const DODO_STATE_APPROACH:String = "DodoStateApproach";
		
		private const DODO_WANDER_AIUPDATE_DELAY_MIN:Number = 0.5;
		private const DODO_WANDER_AIUPDATE_DELAY_RANGE:Number = 2.5;
		
        public function  Dodo(X:Number,Y:Number, p:PlayState):void
        {
            super(X, Y);
			
			_playstate = p;
            loadGraphic(ImgPlayer, true, true, 70, 70);
			
			_MaxVelocity_walking = 200;
            maxVelocity.x = 100;
            maxVelocity.y = 100;
            health = 1;         
            drag.x = 50;
            drag.y = 50;
			
            width = 33;
            height = 17;
            offset.x = 11;
            offset.y = 49;
			
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
				if ( _aiState == DODO_STATE_APPROACH ) {
					_loc_toVector.scaleBy(0.7);
				}
				velocity.x = _loc_toVector.x * DODO_MOVEMENT_SPEED;
				velocity.y = _loc_toVector.y * DODO_MOVEMENT_SPEED;
			} else if ( _aiUpdateTimer <= 0 ) {
				_loc_toVector = getWander();
				_loc_toVector.normalize();
				_loc_toVector.scaleBy(0.5);
				velocity.x = _loc_toVector.x * DODO_MOVEMENT_SPEED;
				velocity.y = _loc_toVector.y * DODO_MOVEMENT_SPEED;
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
			
			if (_aiState == DODO_STATE_MATE) {
				_playstate._player.makeLove( this );
			} else { 
				_playstate._player.dontMakeLove( this );
			}
			
            super.update();
            
        }
		
		private function getSteering():Vector3D {
			var _loc_toVector:Vector3D = _playstate.getClosestHumanVector( this );
			if ( _loc_toVector && _loc_toVector.length < DODO_FLEE_HUMAN_DISTANCE ) {
				_aiState = DODO_STATE_FLEE;
				_loc_toVector.scaleBy( -1 );
				return( _loc_toVector );
			} else {
				_loc_toVector = _playstate.getClosestRatVector( this );
				if ( _loc_toVector && _loc_toVector.length < DODO_FLEE_RAT_DISTANCE ) {
					_aiState = DODO_STATE_FLEE;
					_loc_toVector.scaleBy( -1 );
					return ( _loc_toVector );
				} else {
					_loc_toVector = _playstate.getClosestDodoVector( this );
					if ( _loc_toVector && _loc_toVector.length < DODO_APPROACH_DODO_DISTANCE && _loc_toVector.length > DODO_APPROACH_DODO_DISTANCE_STOP ) {
						_aiState = DODO_STATE_APPROACH;
						return ( _loc_toVector );
					} else if ( _loc_toVector && _loc_toVector.length < DODO_APPROACH_DODO_DISTANCE_STOP) {
						_aiState = DODO_STATE_MATE;
						return ( _loc_toVector );
					}
				}
			}
			return ( null );
		}
		
		private function getWander():Vector3D {
			var _loc_toVector:Vector3D;
			if (_aiState == DODO_STATE_WANDER ) {
				_aiUpdateTimer = ( DODO_WANDER_AIUPDATE_DELAY_MIN + Math.random() * DODO_WANDER_AIUPDATE_DELAY_RANGE );
				_loc_toVector = new Vector3D( velocity.x, velocity.y );
				_loc_toVector.normalize();
				_loc_toVector = new Vector3D( _loc_toVector.x + 1 - (Math.random() * 2), _loc_toVector.y + 1 - (Math.random() * 2) );
				return _loc_toVector;
			}
			
			_aiState = DODO_STATE_WANDER;
			_loc_toVector = new Vector3D( 1 - (Math.random() * 2), 1 - (Math.random() * 2) );
			return _loc_toVector;
		}
		
		private function getMatingWander():Vector3D {
			var _loc_toVector:Vector3D;
			if ( _aiUpdateTimer <= 0 )  {
				_aiUpdateTimer = ( DODO_WANDER_AIUPDATE_DELAY_MIN + Math.random() * DODO_WANDER_AIUPDATE_DELAY_RANGE );
				_loc_toVector = new Vector3D( velocity.x, velocity.y );
				_loc_toVector.normalize();
				_loc_toVector = new Vector3D( _loc_toVector.x + 1 - (Math.random() * 2), _loc_toVector.y + 1 - (Math.random() * 2) );
				return _loc_toVector;
			}
			
			_loc_toVector = new Vector3D( velocity.x, velocity.y );
			return _loc_toVector;
		}
		
		public function flyAway():void {
		}

    }
} 

