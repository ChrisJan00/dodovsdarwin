package  
{
	import flash.geom.ColorTransform;
	import flash.geom.Vector3D;
    import org.flixel.*;

    public class Human extends FlxSprite
    {
        [Embed(source = "img/conqui_anim.png")] private var ImgPlayer:Class;
		[Embed(source = "snd/angryhuman.mp3")] private var AngrySound:Class;
		
		private var _MaxVelocity_walking:int = 200;
		private var _playstate:PlayState;
		
		private const HUMAN_MOVEMENT_SPEED:Number = 50;
		private const HUMAN_CHASE_RAT_DISTANCE:Number = 150;
		private const HUMAN_CHASE_DODO_DISTANCE:Number = 150;
		private const HUMAN_APPROACH_TREE_DISTANCE:Number = 100;
		
		private var _aiState:String;
		private var _aiUpdateTimer:Number = 0;
		
		private const HUMAN_STATE_WANDER:String = "HumanStateWander";
		private const HUMAN_STATE_CHASE:String = "HumanStateChase";
		private const HUMAN_STATE_ATTACK:String = "HumanStateAttack";
		
		private const HUMAN_ATTACK_ANIMATION_DURATION:Number = 1.5;
		private var _attackAnimationTimer:Number = 0;
		
        public function  Human(X:Number,Y:Number, p:PlayState):void
        {
            super(X, Y);
			
			_playstate = p;
            loadGraphic(ImgPlayer, true, true, 112, 112);
     
			_MaxVelocity_walking = 200;
            maxVelocity.x = 100;
            maxVelocity.y = 100;
            health = 1;
			
            width = 51;
            height = 26;
            offset.x = 16;
            offset.y = 83;
			
            addAnimation("normal", [0, 1, 2, 3], 5);
            addAnimation("chasing", [4, 5, 6, 7], 4);
            addAnimation("attacking", [8, 9, 10], 6);
            addAnimation("stopped", [1]);
            facing = RIGHT;
        }
        override public function update():void
        {
			var oldState:String = _aiState;
			
			_aiUpdateTimer -= FlxG.elapsed;
			
			var _loc_toVector:Vector3D = getSteering();
			if ( _loc_toVector ) {
				_loc_toVector.normalize();
				velocity.x = _loc_toVector.x * HUMAN_MOVEMENT_SPEED;
				velocity.y = _loc_toVector.y * HUMAN_MOVEMENT_SPEED;
			} else if ( _aiUpdateTimer <= 0 ) {
				_loc_toVector = getWander();
				_loc_toVector.normalize();
				_loc_toVector.scaleBy( 0.4 - Math.random() * 0.2 );
				velocity.x = _loc_toVector.x * HUMAN_MOVEMENT_SPEED;
				velocity.y = _loc_toVector.y * HUMAN_MOVEMENT_SPEED;
			}
			
			if ( _attackAnimationTimer > 0 ) {
				_attackAnimationTimer -= FlxG.elapsed;
				velocity.x = velocity.y = 0;
				_aiState = HUMAN_STATE_ATTACK;
			} else if (velocity.x < 0) {
				_facing = LEFT;
			} else {
				_facing = RIGHT;
			}
			
			if ( _aiState == HUMAN_STATE_ATTACK ) {
				play("attacking");
			} else
			if ( _aiState == HUMAN_STATE_WANDER ) {
				play("normal");
			} else
			if ( _aiState == HUMAN_STATE_CHASE ) {
				play("chasing");
			}
			
			if (health <= 0) { _playstate.reload(); }
			
			if (_aiState != oldState) {
				if (_aiState == HUMAN_STATE_CHASE)
					FlxG.play(AngrySound);
			}
			
            super.update();
            
        }
		
		private function getSteering():Vector3D {
			var _loc_toVector:Vector3D = _playstate.getClosestRatVector( this );
			if ( _loc_toVector && _loc_toVector.length < HUMAN_CHASE_RAT_DISTANCE ) {
				_aiState = HUMAN_STATE_CHASE;
				return( _loc_toVector );
			} else {
				_loc_toVector = _playstate.getClosestDodoAdultVector( this );
				if ( _loc_toVector && _loc_toVector.length < HUMAN_CHASE_DODO_DISTANCE ) {
					_aiState = HUMAN_STATE_CHASE;
					return ( _loc_toVector );
				} else {
					_loc_toVector = _playstate.getClosestDodoChildVector( this );
					if ( _loc_toVector && _loc_toVector.length < HUMAN_CHASE_DODO_DISTANCE ) {
						_aiState = HUMAN_STATE_CHASE;
						return ( _loc_toVector );
					} else {
						_loc_toVector = _playstate.getClosestTreeVector( this );
						if ( _loc_toVector && _playstate.isOkToChopTree && _loc_toVector.length < HUMAN_APPROACH_TREE_DISTANCE ) {
							_aiState = HUMAN_STATE_CHASE;
							return( _loc_toVector );
						}
					}
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
		
		public function attack():void {
			_attackAnimationTimer = HUMAN_ATTACK_ANIMATION_DURATION;
		}
    }
} 

