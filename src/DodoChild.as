package  
{
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Vector3D;
    import org.flixel.*;

    public class DodoChild extends FlxSprite implements IDodo
    {
        [Embed(source = "img/dodoChildFemale.png")] private var ImgChildFemale:Class;
        [Embed(source = "img/dodoChildMale.png")] private var ImgChild:Class;
		[Embed(source = "snd/playerhurt.mp3")] private var HurtSound:Class;
		[Embed(source = "snd/playerdie.mp3")] private var DeathSound:Class;
		
		[Embed(source = "snd/dodochildpeep.mp3")] private var ChildPeepSound:Class;		
		[Embed(source = "snd/eat.mp3")] private var EatSound:Class;
		
		private var _MaxVelocity_walking:int = 200;
		private var _playstate:PlayState;
		
		private const DODO_MOVEMENT_SPEED:Number = 80;
		private const DODO_FLEE_HUMAN_DISTANCE:Number = 60;
		private const DODO_FLEE_RAT_DISTANCE:Number = 50;
		private const DODO_KEEP_FLEEING_DISTANCE:Number = 100;
		private const DODO_APPROACH_DODO_DISTANCE:Number = 200;
		private const DODO_APPROACH_DODO_DISTANCE_STOP:Number = 40;
		private const DODO_APPROACH_PIG_DISTANCE:Number = 50;
		private const DODO_APPROACH_FRUIT_DISTANCE:Number = 60;
		
		private const DODO_CHILD_GROWUP_TIMER:Number = 20;
		private const DODO_CHILD_GROWUP_FOOD:Number = 5;
		
		private var _growupTimer:Number = 0;
		private var _growupFood:Number = 0;
		
		private var _aiState:String;
		private var _aiUpdateTimer:Number = 0;
		
		private const DODO_STATE_WANDER:String = "DodoStateWander";
		private const DODO_STATE_FLEE:String = "DodoStateFlee";
		private const DODO_STATE_APPROACH:String = "DodoStateApproach";
		private const DODO_STATE_STAY_CLOSE:String = "DodoStateStayClose";
		
		private const DODO_WANDER_AIUPDATE_DELAY_MIN:Number = 1;
		private const DODO_WANDER_AIUPDATE_DELAY_RANGE:Number = 1.5;
		private const DODO_WANDER_STAYCLOSE_DELAY_MIN:Number = 0.5;
		private const DODO_WANDER_STAYCLOSE_DELAY_RANGE:Number = 1;
		
		private const PLAYER_EAT_ANIMATION_DURATION:Number = 1;
		private var _eatAnimationTimer:Number = 0;
		
		private var _keepFlashingRedTimer:Number = 0;
		private var _invincibleTimer:Number = 0;
		private var _isFlashing:Boolean = true;
		private var _flashTimer:Number = 0;
		
		private var destination: Point;
		private var _remainDeadTimer:Number = 0;
		
		private var _justBornTimer:Number = 2;
		private var _lastVelocity:Point;
		
		private var _family:int = 1;
		
		private var _facingChangeTimer:Number = 0;
		private const CHANGE_FACING_PAUSE:Number = 1;
		private var _lastFacing:uint = RIGHT;
		
        public function  DodoChild(X:Number,Y:Number, p:PlayState, a_family:int = 1):void
        {
            super(X, Y);
			
			_playstate = p;
            loadGraphic(ImgChild, true, true, 56, 49);
			
			_MaxVelocity_walking = 200;
            maxVelocity.x = 200;
            maxVelocity.y = 200;
            health = 1;
            drag.x = 70;
            drag.y = 70;
			
            width = 25;
            height = 12;
            offset.x = 14;
            offset.y = 35;
			
            addAnimation("normal", [0, 1, 2, 3], 5);
            addAnimation("eating", [4,5,6,7], 7);
			addAnimation("fleeing", [0, 1, 2, 3], 8);
			addAnimation("stayingClose", [0, 1, 2, 3], 5);
			addAnimation("stopped", [1]);
			// TODO Need dead state image
            addAnimation("dead", [5]);
            facing = RIGHT;
			
			_lastVelocity = new Point();
			_growupTimer = DODO_CHILD_GROWUP_TIMER;
			_growupFood = DODO_CHILD_GROWUP_FOOD;
        }
        override public function update():void
        {
			if ( _growupFood <= 0 && _growupTimer <= 0) {
				_playstate.removeEntityFromArrayOnly(this, _playstate._dodos);
				_playstate.removeEntityFromArrayOnly(this, _playstate._dodoChildren);
				kill();
				
				var newDodo:Dodo = new Dodo( x, y, _playstate, _family );
				_playstate.addSprite( newDodo, _playstate._dodos );
				_playstate.addToArrayOnly( newDodo, _playstate._dodoAdults );
			}
			
			if ( velocity.x && velocity.y ) {
				_lastVelocity.x = velocity.x;
				_lastVelocity.y = velocity.y;
			}
			var oldState: String = _aiState;
			
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
			
			_loc_toVector = null;
			if ( _justBornTimer < 0 ) {
				_loc_toVector = getSteering();
			}
			if ( _loc_toVector ) {
				_loc_toVector.normalize();
				if ( _aiState == DODO_STATE_APPROACH ) {
					_loc_toVector.scaleBy(0.9);
				}
				if ( _aiState == DODO_STATE_STAY_CLOSE ) {
					if ( _aiUpdateTimer <= 0 ) {
						if (Math.random() < 0.3) {
							FlxG.play(ChildPeepSound, _playstate._player.distance2Volume(this) );
						}
						addWander( _loc_toVector, 0.5 );
						_loc_toVector.normalize();
						_loc_toVector.scaleBy( 0.25 + Math.random() * 0.5 );
						velocity.x = _loc_toVector.x * DODO_MOVEMENT_SPEED;
						velocity.y = _loc_toVector.y * DODO_MOVEMENT_SPEED;
						_aiUpdateTimer = ( DODO_WANDER_STAYCLOSE_DELAY_MIN + Math.random() * DODO_WANDER_STAYCLOSE_DELAY_RANGE );
					}
				} else {
					velocity.x = _loc_toVector.x * DODO_MOVEMENT_SPEED;
					velocity.y = _loc_toVector.y * DODO_MOVEMENT_SPEED;
				}
			} else if ( _aiUpdateTimer <= 0) {
				if (Math.random() < 0.9) {
					FlxG.play(ChildPeepSound, _playstate._player.distance2Volume(this) );
				}
				_loc_toVector = getWander();
				_loc_toVector.normalize();
				_loc_toVector.scaleBy( 0.25 + Math.random() * 0.5 );
				velocity.x = _loc_toVector.x * DODO_MOVEMENT_SPEED;
				velocity.y = _loc_toVector.y * DODO_MOVEMENT_SPEED;
			}
			
			_justBornTimer -= FlxG.elapsed;
			_fleePeepTimer -= FlxG.elapsed;
			_growupTimer -= FlxG.elapsed;
			_facingChangeTimer -= FlxG.elapsed;
			
			if ( _facingChangeTimer < 0 ) {
				if (velocity.x < 0) {
					_facing = LEFT;
				} else if (velocity.x > 0) {
					_facing = RIGHT;
				}
				if ( _facing != _lastFacing ) {
					_facingChangeTimer = CHANGE_FACING_PAUSE;
					_lastFacing = _facing;
				}
			}
			
			if ( _eatAnimationTimer > 0 ) {
				_eatAnimationTimer -= FlxG.elapsed;
				play("eating");
			} else {
				if ( _aiState == DODO_STATE_WANDER ) {
					if ( velocity.length > 0 ) {
						play("normal");
					} else {
						play("stopped");
					}
				}
				if ( _aiState == DODO_STATE_APPROACH ) {
					play("normal");
				}
				if ( _aiState == DODO_STATE_FLEE ) {
					play("fleeing");
				}
				if ( _aiState == DODO_STATE_STAY_CLOSE ) {
					if ( velocity.length > 0 ) {
						play("stayingClose");
					} else {
						play("stopped");
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
			
			if (health <= 0) { _playstate.reload(); }
			
            super.update();
            
        }
		
		private var _fleePeepTimer:Number = 0;
		
		private function getSteering():Vector3D {
			
			var _loc_toVector:Vector3D = _playstate.getClosestHumanVector( this );
			if ( _loc_toVector && _aiState == DODO_STATE_FLEE && _loc_toVector.length < DODO_KEEP_FLEEING_DISTANCE ) {
				if ( _fleePeepTimer <= 0 ) {
					FlxG.play(ChildPeepSound, _playstate._player.distance2Volume(this) );
					_fleePeepTimer = 0.4 + Math.random() * 0.2;
				}
				_loc_toVector.scaleBy( -1 );
				return( _loc_toVector );
			} else {
				if ( _loc_toVector && _loc_toVector.length < DODO_FLEE_HUMAN_DISTANCE ) {
					if ( _fleePeepTimer <= 0 ) {
						FlxG.play(ChildPeepSound, _playstate._player.distance2Volume(this) );
						_fleePeepTimer = 0.4 + Math.random() * 0.2;
					}
					_aiState = DODO_STATE_FLEE;
					_loc_toVector.scaleBy( -1 );
					return( _loc_toVector );
				} else {
					_loc_toVector = _playstate.getClosestRatVector( this );
					if ( _loc_toVector && _aiState == DODO_STATE_FLEE && _loc_toVector.length < DODO_KEEP_FLEEING_DISTANCE ) {
						if ( _fleePeepTimer <= 0 ) {
							FlxG.play(ChildPeepSound, _playstate._player.distance2Volume(this) );
							_fleePeepTimer = 0.4 + Math.random() * 0.2;
						}
						_aiState = DODO_STATE_FLEE;
						_loc_toVector.scaleBy( -1 );
						return ( _loc_toVector );
					} else {
						if ( _loc_toVector && _loc_toVector.length < DODO_FLEE_RAT_DISTANCE ) {
							if ( _fleePeepTimer <= 0 ) {
								FlxG.play(ChildPeepSound, _playstate._player.distance2Volume(this) );
								_fleePeepTimer = 0.4 + Math.random() * 0.2;
							}
							_aiState = DODO_STATE_FLEE;
							_loc_toVector.scaleBy( -1 );
							return ( _loc_toVector );
						} else {
							_loc_toVector = _playstate.getClosestFruitVector( this );
							if ( _aiState == DODO_STATE_STAY_CLOSE && _loc_toVector && _loc_toVector.length < DODO_APPROACH_FRUIT_DISTANCE ) {
								_aiState = DODO_STATE_APPROACH;
								return ( _loc_toVector );
							} else {
								_loc_toVector = _playstate.getClosestPlayerVector( this );
								if ( _loc_toVector && _loc_toVector.length < DODO_APPROACH_DODO_DISTANCE && _loc_toVector.length > DODO_APPROACH_DODO_DISTANCE_STOP ) {
									_aiState = DODO_STATE_APPROACH;
									return ( _loc_toVector );
								} else if ( _loc_toVector && _loc_toVector.length < DODO_APPROACH_DODO_DISTANCE_STOP) {
									_aiState = DODO_STATE_STAY_CLOSE;
									return ( _loc_toVector );
								} else {
									_loc_toVector = _playstate.getClosestDodoAdultVector( this );
									if ( _loc_toVector && _loc_toVector.length < DODO_APPROACH_DODO_DISTANCE && _loc_toVector.length > DODO_APPROACH_DODO_DISTANCE_STOP ) {
										_aiState = DODO_STATE_APPROACH;
										return ( _loc_toVector );
									} else if ( _loc_toVector && _loc_toVector.length < DODO_APPROACH_DODO_DISTANCE_STOP) {
										_aiState = DODO_STATE_STAY_CLOSE;
										return ( _loc_toVector );
									}
								}
							}
						}
					}
				}
			}
			return ( null );
		}
		
		private function getWander():Vector3D {
			var _loc_toVector:Vector3D;
			if (_aiState == DODO_STATE_WANDER ) {
				_aiUpdateTimer = ( DODO_WANDER_AIUPDATE_DELAY_MIN + Math.random() * DODO_WANDER_AIUPDATE_DELAY_RANGE );
				_loc_toVector = new Vector3D( _lastVelocity.x, _lastVelocity.y );
				_loc_toVector.normalize();
				_loc_toVector = new Vector3D( _loc_toVector.x + 1 - (Math.random() * 2), _loc_toVector.y + 1 - (Math.random() * 2) );
				return _loc_toVector;
			}
			
			_aiState = DODO_STATE_WANDER;
			_loc_toVector = new Vector3D( 1 - (Math.random() * 2), 1 - (Math.random() * 2) );
			return _loc_toVector;
		}
		
		private function addWander( a_vector:Vector3D, a_amount:Number = 1 ):void {
			var _loc_vector:Vector3D = new Vector3D( a_amount - (Math.random() * 2 * a_amount), a_amount - (Math.random() * 2 * a_amount) );
			a_vector.x += _loc_vector.x;
			a_vector.y += _loc_vector.y;
		}
		
		public function isFlying():Boolean {
			return false;
		}
		
		public function eat() : void
		{
			_growupFood--;
			health = Math.min( 1, health + 0.1 );
			_eatAnimationTimer = PLAYER_EAT_ANIMATION_DURATION;
			FlxG.play(EatSound, _playstate._player.distance2Volume(this) );
		}
		
		public function killedByEnemy():void {
			FlxG.play(DeathSound, _playstate._player.distance2Volume(this) );
			_remainDeadTimer = 5;
			_keepFlashingRedTimer = 0.2;
			_playstate.removeEntityFromArrayOnly(this, _playstate._dodos);
			_playstate.removeEntityFromArrayOnly(this, _playstate._dodoChildren);
		}
		
		/* INTERFACE IDodo */
		
		public function takeHumanDamage():void
		{
			if ( _invincibleTimer <= 0 ) {
				health -= 0.6;
				FlxG.play(HurtSound, _playstate._player.distance2Volume(this) );
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
				FlxG.play(HurtSound, _playstate._player.distance2Volume(this) );
				health -= 0.3;
				if ( health <= 0 ) {
					killedByEnemy();
				} else {
					_keepFlashingRedTimer += 0.3;
					_invincibleTimer += 1.2;
				}
			}
		}
		
		public function get family():int { return _family; }
		
		public function resetScaredPigTimer():void {
			// Empty for DodoChild, it's Ai doesn't "want" to scare pigs
		}
    }
} 

