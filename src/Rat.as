package  
{
	import flash.geom.ColorTransform;
	import flash.geom.Vector3D;
    import org.flixel.*;

    public class Rat extends FlxSprite
    {
        [Embed(source = "img/rat_anim.png")] private var ImgPlayer:Class;
		
		[Embed(source = "snd/enemydie.mp3")] private var DeathSound:Class;		
		[Embed(source = "snd/angryrat.mp3")] private var AngrySound:Class;
		
		
		private var _MaxVelocity_walking:int = 200;
		private var _playstate:PlayState;
		
		private const RAT_MOVEMENT_SPEED:Number = 45;
		private const RAT_CHASE_DODO_DISTANCE:Number = 200;
		private const RAT_FLEE_HUMAN_DISTANCE:Number = 130;
		private const RAT_APPROACH_EGG_DISTANCE:Number = 250;
		private const RAT_EAT_EGG_DISTANCE:Number = 25;
		
		private var _aiState:String;
		private var _aiUpdateTimer:Number = 0;
		
		private const RAT_STATE_WANDER:String = "RatStateWander";
		private const RAT_STATE_CHASE:String = "RatStateChase";
		private const RAT_STATE_FLEE:String = "RatStateFlee";
		private const RAT_STATE_APPROACH:String = "RatStateApproach";
		private const RAT_STATE_ATTACK:String = "RatStateAttack";
		private const RAT_STATE_EAT:String = "RatStateEat";
		
		private const RAT_WANDER_AIUPDATE_DELAY_MIN:Number = 0.5;
		private const RAT_WANDER_AIUPDATE_DELAY_RANGE:Number = 2.5;
		
		private var _lastWanderVector:Vector3D;
		
		private const RAT_ATTACK_ANIMATION_DURATION:Number = 1;
		private var _attackAnimationTimer:Number = 0;
		private var _keepFlashingRedTimer:Number = 0;
		
		private var _remainDeadTimer:Number = 0;
		
        public function  Rat(X:Number,Y:Number, p:PlayState):void
        {
            super(X, Y);
			
			_playstate = p;
            loadGraphic(ImgPlayer, true, true, 56, 42);
			
			_MaxVelocity_walking = 200;
            maxVelocity.x = 100;
            maxVelocity.y = 100;
            health = 1;         
            drag.x = 40;
            drag.y = 40;
			
            width = 47;
            height = 11;
            offset.x = 5;
            offset.y = 28;
			
            addAnimation("normal", [0, 1, 2, 3], 5);
            addAnimation("approaching", [7,8,9,10], 2);
            addAnimation("dead", [4]);
            addAnimation("eating", [5,6], 4);
            addAnimation("chasing", [7,8,9,10], 8);
            addAnimation("fleeing", [0,1,2,3], 10);
            addAnimation("attacking", [5,6], 8);
            facing = RIGHT;
        }
        override public function update():void
        {
			var oldState: String = _aiState;
			
			if ( _remainDeadTimer > 0 ) {
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
					this.kill();
				}
				super.update();
				return;
			}
			
			_aiUpdateTimer -= FlxG.elapsed;
			
			var _loc_toVector:Vector3D = getSteering();
			if ( _loc_toVector ) {
				_loc_toVector.normalize();
				if (_aiState == RAT_STATE_APPROACH) {
					_loc_toVector.scaleBy(0.5);
				}
				velocity.x = _loc_toVector.x * RAT_MOVEMENT_SPEED;
				velocity.y = _loc_toVector.y * RAT_MOVEMENT_SPEED;
			} else if ( _aiUpdateTimer <= 0 ) {
				_loc_toVector = getWander();
				_loc_toVector.normalize();
				_loc_toVector.scaleBy(0.9);
				velocity.x = _loc_toVector.x * RAT_MOVEMENT_SPEED;
				velocity.y = _loc_toVector.y * RAT_MOVEMENT_SPEED;
			}
			
			if ( _attackAnimationTimer > 0 ) {
				_attackAnimationTimer -= FlxG.elapsed;
				velocity.x = velocity.y = 0;
				_aiState = RAT_STATE_ATTACK;
			} else if (velocity.x < 0) {
				_facing = LEFT;
			} else {
				_facing = RIGHT;
			}
			if ( _aiState == RAT_STATE_ATTACK ) {
				play("attacking");
			} else
			if ( _aiState == RAT_STATE_WANDER ) {
				play("normal");
			} else
			if ( _aiState == RAT_STATE_APPROACH ) {
				play("approaching");
			} else
			if ( _aiState == RAT_STATE_CHASE ) {
				play("chasing");
			} else
			if ( _aiState == RAT_STATE_FLEE ) {
				play("fleeing");
			} else
			if ( _aiState == RAT_STATE_EAT ) {
				play("eating");
			}
			
			if (_aiState != oldState) {
				if (_aiState == RAT_STATE_CHASE)
					FlxG.play(AngrySound, _playstate._player.distance2Volume(this) );
				
			}
			
            super.update();
        }
		
		private function getSteering():Vector3D {
			var _loc_toVector:Vector3D = _playstate.getClosestDodoAdultVector( this );
			if ( _loc_toVector && _loc_toVector.length < RAT_CHASE_DODO_DISTANCE ) {
				_aiState = RAT_STATE_CHASE;
				return( _loc_toVector );
			} else {
				_loc_toVector = _playstate.getClosestDodoChildVector( this );
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
						if ( _loc_toVector && _loc_toVector.length < RAT_EAT_EGG_DISTANCE ) {
							_aiState = RAT_STATE_EAT;
							(_playstate.getClosestEgg( this ) as Egg).takeRatDamage();
							return ( new Vector3D() );
						}
						if ( _loc_toVector && _loc_toVector.length < RAT_APPROACH_EGG_DISTANCE ) {
							_aiState = RAT_STATE_APPROACH;
							return ( _loc_toVector );
						}
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
		
		public function attack():void {
			_attackAnimationTimer = RAT_ATTACK_ANIMATION_DURATION;
		}
		
		public function killedByHuman():void {
			FlxG.play(DeathSound, _playstate._player.distance2Volume(this) );
			_remainDeadTimer = 5;
			_keepFlashingRedTimer = 0.2;
		}
    }
} 

