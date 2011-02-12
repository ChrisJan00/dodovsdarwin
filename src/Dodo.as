package  
{
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Vector3D;
    import org.flixel.*;

    public class Dodo extends FlxSprite implements IDodo
    {
        [Embed(source = "img/dodo_male_walk.png")] private var ImgPlayer:Class;
		[Embed(source = "snd/playerhurt.mp3")] private var HurtSound:Class;
		[Embed(source = "snd/playerdie.mp3")] private var DeathSound:Class;
		
		[Embed(source = "snd/mating.mp3")] private var MateSound:Class;		
		[Embed(source = "snd/birdcome.mp3")] private var FlySound:Class;
		[Embed(source = "snd/eat.mp3")] private var EatSound:Class;
		
		private var FlxMateSound:FlxSound;
		
		private var _MaxVelocity_walking:int = 200;
		private var _playstate:PlayState;
		
		private const DODO_MOVEMENT_SPEED:Number = 80;
		private const DODO_FLEE_HUMAN_DISTANCE:Number = 100;
		private const DODO_FLEE_RAT_DISTANCE:Number = 80;
		private const DODO_KEEP_FLEEING_ENEMY_DISTANCE:Number = 210;
		private const DODO_APPROACH_DODO_DISTANCE:Number = 120;
		private const DODO_APPROACH_DODO_DISTANCE_STOP:Number = 30;
		private const DODO_APPROACH_PIG_DISTANCE:Number = 200;
		private const DODO_APPROACH_FRUIT_DISTANCE:Number = 200;
		
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
		
		private var _family:int;
		
		private const PLAYER_EAT_ANIMATION_DURATION:Number = 1;
		private var _eatAnimationTimer:Number = 0;
		private var _poopCountdown:Number = 0;
		public var eatenFruitCount:Number = 0;
		public const SHIT_THRESHOLD:Number = 3;
		public const POOP_COUNTDOWN_TIME:Number = 3;
		
		private var _scaredPigTimer:Number = 0;
		private const DODO_SCARE_PIG_PAUSE:Number = 8;
		
        public function  Dodo(X:Number,Y:Number, p:PlayState, a_family:int = 2):void
        {
            super(X, Y);
			
			_playstate = p;
			_family = a_family;
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
			addAnimation("eating", [0, 5], 7);
            addAnimation("stopped", [1]);
			// TODO Need dead state image
            addAnimation("dead", [5]);
            facing = RIGHT;
			
			// Initialize with silent sound
			FlxMateSound = FlxG.play(MateSound, 0);
        }
        override public function update():void
        {
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
			_poopCountdown -= FlxG.elapsed;
			_scaredPigTimer -= FlxG.elapsed;
			
			if (isFlying()) {
				_loc_toVector = new Vector3D( destination.x - cX, destination.y - cY );
				if (_aiState == DODO_STATE_FLYING_IN && _loc_toVector.length < DODO_APPROACH_DODO_DISTANCE_STOP)
					_aiState = DODO_STATE_WANDER;
				else if (_aiState == DODO_STATE_FLYING_OUT && _loc_toVector.length < DODO_APPROACH_DODO_DISTANCE_STOP ) {
					_playstate.removeEntity(this, _playstate._dodos);
					_playstate.removeEntityFromArrayOnly(this, _playstate._dodoAdults);
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
					_loc_toVector.scaleBy(0.75);
					velocity.x = _loc_toVector.x * DODO_MOVEMENT_SPEED;
					velocity.y = _loc_toVector.y * DODO_MOVEMENT_SPEED;
				}
			}
			
			if (velocity.x < 0) {
				_facing = LEFT;
			} else {
				_facing = RIGHT;
			}
			
			if ( eatenFruitCount == SHIT_THRESHOLD && _poopCountdown <= 0) {
				eatenFruitCount = 0;
				var seed:Seed = new Seed(cX, cY, _playstate);
				seed.launch( cX, cY, cX, cY + 5, Math.random(), Math.random());
				_playstate.addSprite(seed, _playstate._seeds);
			}
			
			if ( _eatAnimationTimer > 0 ) {
				_eatAnimationTimer -= FlxG.elapsed;
				play("eating");
			} else {
				if (isFlying()) {
					play("flying");
				}
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
				if ( _aiState == DODO_STATE_MATE ) {
					play("mating");
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
			
			if (_aiState == DODO_STATE_MATE) {
				velocity.x = velocity.y = 0;
				_playstate._player.makeLove( this );
			} else { 
				_playstate._player.dontMakeLove( this );
			}
			
			if (oldState != _aiState) {
				if (_aiState == DODO_STATE_MATE) {
					FlxMateSound.stop();
					FlxMateSound = FlxG.play(MateSound, _playstate.distance2Volume(this));
				}
				if (isFlying())
					FlxG.play(FlySound, _playstate.distance2Volume(this));
			}
			
            super.update();
            
        }
		
		private function getSteering():Vector3D {
			
			var _loc_toVector:Vector3D = _playstate.getClosestHumanVector( this );
			if ( _loc_toVector && _aiState == DODO_STATE_FLEE && _loc_toVector.length < DODO_KEEP_FLEEING_ENEMY_DISTANCE ) {
				_loc_toVector.scaleBy( -1 );
				return( _loc_toVector );
			} else {
				if ( _loc_toVector && _loc_toVector.length < DODO_FLEE_HUMAN_DISTANCE ) {
					_aiState = DODO_STATE_FLEE;
					_loc_toVector.scaleBy( -1 );
					return( _loc_toVector );
				} else {
					_loc_toVector = _playstate.getClosestRatVector( this );
					if ( _loc_toVector && _aiState == DODO_STATE_FLEE && _loc_toVector.length < DODO_KEEP_FLEEING_ENEMY_DISTANCE ) {
						_loc_toVector.scaleBy( -1 );
						return( _loc_toVector );
					} else {
						if ( _loc_toVector && _loc_toVector.length < DODO_FLEE_RAT_DISTANCE ) {
							_aiState = DODO_STATE_FLEE;
							_loc_toVector.scaleBy( -1 );
							return ( _loc_toVector );
						} else {
							_loc_toVector = _playstate.getClosestPlayerVector( this );
							if ( _playstate._player.family != _family && !_playstate._player.isPregnant ) {
								if ( _loc_toVector && _loc_toVector.length < DODO_APPROACH_DODO_DISTANCE && _loc_toVector.length > DODO_APPROACH_DODO_DISTANCE_STOP ) {
									_aiState = DODO_STATE_APPROACH;
									return ( _loc_toVector );
								} else if ( _loc_toVector && _loc_toVector.length < DODO_APPROACH_DODO_DISTANCE_STOP) {
									if ( _family == _playstate._player.family ) {
										_aiState = DODO_STATE_WANDER;
									} else {
										_aiState = DODO_STATE_MATE;
										return ( new Vector3D( _loc_toVector.x + 1 - (Math.random() * 2), _loc_toVector.y + 1 - (Math.random() * 2) ) );
									}
								}
							} else {
								_loc_toVector = _playstate.getClosestPigVector( this );
								if ( _loc_toVector && _scaredPigTimer < 0 && _loc_toVector.length < DODO_APPROACH_PIG_DISTANCE ) {
									_aiState = DODO_STATE_APPROACH;
									return( _loc_toVector );
								} else {
									_loc_toVector = _playstate.getClosestFruitVector( this );
									if ( _loc_toVector && _loc_toVector.length < DODO_APPROACH_FRUIT_DISTANCE && eatenFruitCount != SHIT_THRESHOLD) {
										_aiState = DODO_STATE_APPROACH;
										return( _loc_toVector );
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
			
			var _loc_flyIn:uint;
			var _loc_flyInFrom:Point;
			
			if (Math.random() < 0.5) {
				if (Math.random() < 0.5) {
					_loc_flyIn = DOWN;
				} else {
					_loc_flyIn = UP;
				}
			} else {
				if (Math.random() < 0.5) {
					_loc_flyIn = RIGHT;
				} else {
					_loc_flyIn = LEFT;
				}
			}
			
			// origin
			_loc_flyInFrom = new Point();
			switch ( _loc_flyIn ) {
				case DOWN:
					_loc_flyInFrom.y = _playstate.mapSize.y;
					_loc_flyInFrom.x = (Math.random() * 0.4 + 0.3) * _playstate.mapSize.x;
				break;
				case UP:
					_loc_flyInFrom.y = -1 * height;
					_loc_flyInFrom.x = (Math.random() * 0.4 + 0.3) * _playstate.mapSize.x;
				break;
				case RIGHT:
					_loc_flyInFrom.x = _playstate.mapSize.x;
					_loc_flyInFrom.y = (Math.random() * 0.4 + 0.3) * _playstate.mapSize.y;
				break;
				case LEFT:
					_loc_flyInFrom.x = -1 * width;
					_loc_flyInFrom.y = (Math.random() * 0.4 + 0.3) * _playstate.mapSize.y;
				break;
				default:
					
				break;
			}
			
			// destination
			
			// a quarter of the distance to the screen limit
			var spawnCenter:Point = new Point( _playstate._player.x + 0.25 * (_loc_flyInFrom.x - _playstate._player.x ) , 
											   _playstate._player.y + 0.25 * (_loc_flyInFrom.y - _playstate._player.y) );
			x = spawnCenter.x;
			y = spawnCenter.y;
			var distanceFromPlayer:Number = _playstate.distanceFromPlayer(this);
			
			// try random points until we find one valid (against the map, it could still be an obstacle
			// but the collision detection will hopefully spit him towards a valid point nearby)
			do {
				x = spawnCenter.x + (Math.random() * 2 - 1) * distanceFromPlayer;
				y = spawnCenter.y + (Math.random() * 2 - 1) * distanceFromPlayer;
			} while ( _playstate._block_map.overlaps(this) );
		
			// store results
			destination = new Point(x, y);
			x = _loc_flyInFrom.x;
			y = _loc_flyInFrom.y;
		}
		
		public function flyAway():void {
			var _loc_buffer:Number = 100;
			_aiState = DODO_STATE_FLYING_OUT;
			destination = new Point();
			if (Math.random() < 0.5) {
				if (Math.random() < 0.5)
					destination.y = _playstate.mapSize.y + _loc_buffer;
				else
					destination.y = -height - _loc_buffer;
				destination.x = Math.floor(Math.random() * _playstate.mapSize.x);
			} else {
				if (Math.random() < 0.5)
					destination.x = _playstate.mapSize.x + _loc_buffer;
				else
					destination.x = -width - _loc_buffer;
				destination.y = Math.floor(Math.random() * _playstate.mapSize.y);
			}
		}

		public function isFlying():Boolean {
			return _aiState == DODO_STATE_FLYING_IN || _aiState == DODO_STATE_FLYING_OUT;
		}
		
		public function eat() : Boolean
		{
			eatenFruitCount = Math.min( SHIT_THRESHOLD, eatenFruitCount + 1 );
			if (eatenFruitCount >= SHIT_THRESHOLD ) {
				_poopCountdown = POOP_COUNTDOWN_TIME;
			}
			health = Math.min( 1, health + 0.1 );
			_eatAnimationTimer = PLAYER_EAT_ANIMATION_DURATION;
			FlxG.play(EatSound);
			return true;
		}
		
		public function killedByEnemy():void {
			FlxG.play(DeathSound, _playstate.distance2Volume(this) );
			_remainDeadTimer = 5;
			_keepFlashingRedTimer = 0.2;
			_playstate.removeEntityFromArrayOnly(this, _playstate._dodos);
			_playstate.removeEntityFromArrayOnly(this, _playstate._dodoAdults);
		}
		
		/* INTERFACE IDodo */
		
		public function takeHumanDamage():void
		{
			if ( _invincibleTimer <= 0 ) {
				health -= 1;
				FlxG.play(HurtSound, _playstate.distance2Volume(this) );
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
				FlxG.play(HurtSound, _playstate.distance2Volume(this) );
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
			_scaredPigTimer = DODO_SCARE_PIG_PAUSE;
		}
    }
} 

