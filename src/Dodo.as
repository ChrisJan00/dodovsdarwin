package  
{
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Vector3D;
    import org.flixel.*;

    public class Dodo extends FlxSprite implements IDodo
    {
        [Embed(source = "img/dodo_male_walk.png")] private var ImgPlayer:Class;
		private var _MaxVelocity_walking:int = 200;
		private var _playstate:PlayState;
		
		private const DODO_MOVEMENT_SPEED:Number = 80;
		private const DODO_FLEE_HUMAN_DISTANCE:Number = 150;
		private const DODO_FLEE_RAT_DISTANCE:Number = 150;
		private const DODO_APPROACH_DODO_DISTANCE:Number = 150;
		private const DODO_APPROACH_DODO_DISTANCE_STOP:Number = 30;
		private const DODO_APPROACH_PIG_DISTANCE:Number = 100;
		private const DODO_APPROACH_FRUIT_DISTANCE:Number = 400;
		
		private var _aiState:String;
		private var _aiUpdateTimer:Number = 0;
		
		private const DODO_STATE_WANDER:String = "DodoStateWander";
		private const DODO_STATE_FLEE:String = "DodoStateFlee";
		private const DODO_STATE_MATE:String = "DodoStateMate";
		private const DODO_STATE_APPROACH:String = "DodoStateApproach";
		private const DODO_STATE_FLYING_IN:String = "DodoStateFlyingIn";
		private const DODO_STATE_FLYING_OUT:String = "DodoStateFlyingOut";
		
		private const DODO_WANDER_AIUPDATE_DELAY_MIN:Number = 0.5;
		private const DODO_WANDER_AIUPDATE_DELAY_RANGE:Number = 2.5;
		
		private var _keepFlashingRedTimer:Number = 0;
		private var _invincibleTimer:Number = 0;
		private var _isFlashing:Boolean = true;
		private var _flashTimer:Number = 0;
		
		
		private var destination: Point;
		private var _remainDeadTimer:Number = 0;

		
        public function  Dodo(X:Number,Y:Number, p:PlayState):void
        {
            super(X, Y);
			
			_playstate = p;
            loadGraphic(ImgPlayer, true, true, 80, 70);
			
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
			addAnimation("flying", [2, 5], 10);
			addAnimation("mating", [4, 5], 10);
			addAnimation("fleeing", [0, 1, 2, 3], 8);
			// TODO Need dead state image
            addAnimation("dead", [5]);
            facing = RIGHT;
        }
        override public function update():void
        {
			var _loc_toVector:Vector3D;
			if ( _remainDeadTimer > 0 ) {
				velocity.x = velocity.y = 0;
				if ( _keepFlashingRedTimer > 0 ) {
					_keepFlashingRedTimer -= FlxG.elapsed;
					color = 0xFF0000;
				} else {
					color = 0x00ffffff;
					_keepFlashingRedTimer = 0;
				}
				play("dead");
				_remainDeadTimer -= FlxG.elapsed;
				if ( _remainDeadTimer <= 0 ) {
					kill();
				}
				super.update();
				return;
			}
			
			_aiUpdateTimer -= FlxG.elapsed;
			
			if (isFlying()) {
				_loc_toVector = new Vector3D( destination.x - cX, destination.y - cY );
					if (_aiState == DODO_STATE_FLYING_IN && _loc_toVector.length < DODO_APPROACH_DODO_DISTANCE_STOP)
						_aiState = DODO_STATE_WANDER;
					else if (_aiState == DODO_STATE_FLYING_OUT && (x<0 || x>=FlxG.width || y<0 || y>=FlxG.height) ) {
						_playstate.removeEntity(this, _playstate._dodos);
						return;
					}
				_loc_toVector.normalize();
				_loc_toVector.scaleBy(3);
				velocity.x = _loc_toVector.x * DODO_MOVEMENT_SPEED;
				velocity.y = _loc_toVector.y * DODO_MOVEMENT_SPEED;
				
			} else {
				_loc_toVector = getSteering();
				if ( _loc_toVector ) {
					_loc_toVector.normalize();
					if ( _aiState == DODO_STATE_APPROACH ) {
						_loc_toVector.scaleBy(0.7);
					}
					if ( _aiState == DODO_STATE_MATE ) {
						_loc_toVector.scaleBy(0.2);
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
			}
			
			if (velocity.x < 0) {
				_facing = LEFT;
			} else {
				_facing = RIGHT;
			}
			
			if (isFlying()) {
				play("flying");
			}
			if ( _aiState == DODO_STATE_WANDER ) {
				play("normal");
			}
			if ( _aiState == DODO_STATE_APPROACH ) {
				play("normal");
			}
			if ( _aiState == DODO_STATE_FLEE ) {
				play("fleeing");
			}
			if ( _aiState == DODO_STATE_MATE ) {
				play("mating");
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
			
			if (health <= 0) { _playstate.reload(); }
			
			if (_aiState == DODO_STATE_MATE) {
				velocity.x = velocity.y = 0;
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
		
		public function flyIn():void 
		{
			_aiState = DODO_STATE_FLYING_IN;
			if (Math.random() < 0.5) {
				if (Math.random() < 0.5)
					y = FlxG.height;
				else
					y = -height;
				x = Math.floor(Math.random() * FlxG.width);
			} else {
				if (Math.random() < 0.5)
					x = FlxG.width;
				else
					x = -width;
				y = Math.floor(Math.random() * FlxG.height);
			}
			
			destination = new Point( (Math.random() * 0.4 + 0.3) * 1280, (Math.random() * 0.4 + 0.3) * 960 );
		}
		
		public function flyAway():void {
			_aiState = DODO_STATE_FLYING_OUT;
			destination = new Point();
			if (Math.random() < 0.5) {
				if (Math.random() < 0.5)
					destination.y = FlxG.height;
				else
					destination.y = -height;
				destination.x = Math.floor(Math.random() * FlxG.width);
			} else {
				if (Math.random() < 0.5)
					destination.x = FlxG.width;
				else
					destination.x = -width;
				destination.y = Math.floor(Math.random() * FlxG.height);
			}
		}

		public function isFlying():Boolean {
			return _aiState == DODO_STATE_FLYING_IN || _aiState == DODO_STATE_FLYING_OUT;
		}
		
		public function killedByEnemy():void {
			_remainDeadTimer = 5;
			_keepFlashingRedTimer = 0.2;
			_playstate.removeEntityFromArrayOnly(this, _playstate._dodos);
		}
		
		/* INTERFACE IDodo */
		
		public function takeHumanDamage():void
		{
			if ( _invincibleTimer <= 0 ) {
				health -= 1;
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
				health -= 0.3;
				if ( health <= 0 ) {
					killedByEnemy();
				} else {
					_keepFlashingRedTimer += 0.3;
					_invincibleTimer += 1.2;
				}
			}
		}
    }
} 

