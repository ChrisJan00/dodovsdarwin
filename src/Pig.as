package  
{
	import flash.geom.ColorTransform;
	import flash.geom.Vector3D;
    import org.flixel.*;

    public class Pig extends FlxSprite
    {
        [Embed(source = "img/pig_anim.png")] private var ImgPlayer:Class;
        public var _max_health:int = 1;
		private var _MaxVelocity_walking:int = 200;
		private var _playstate:PlayState;
		
		private const PIG_MOVEMENT_SPEED:Number = 50;
		private const PIG_FLEE_DODO_DISTANCE:Number = 70;
		private const PIG_APPROACH_FRUIT_DISTANCE:Number = 300;
		
		private var _aiState:String;
		private var _aiUpdateTimer:Number = 0;
		
		private const PIG_STATE_WANDER:String = "PigStateWander";
		private const PIG_STATE_APPROACH:String = "PigStateApproach";
		private const PIG_STATE_FLEE:String = "PigStateFlee";
		private const PIG_STATE_EAT:String = "PigStateEat";
		
		private const PIG_WANDER_AIUPDATE_DELAY_MIN:Number = 0.5;
		private const PIG_WANDER_AIUPDATE_DELAY_RANGE:Number = 2.5;
		
		private const PIG_EAT_ANIMATION_DURATION:Number = 2;
		private var _eatAnimationTimer:Number = 0;
		
        public function  Pig(X:Number,Y:Number, p:PlayState):void
        {
            super(X, Y);
			
			_playstate = p;
            loadGraphic(ImgPlayer, true, true, 77, 49);
			
			_MaxVelocity_walking = 200;
            maxVelocity.x = 100;
            maxVelocity.y = 100;
            health = 1;         
            drag.x = 5;
            drag.y = 5;
			
            width = 31;
            height = 15;
            offset.x = 20;
            offset.y = 30;
			
            addAnimation("normal", [0, 2], 5);
            addAnimation("fleeing", [4, 5, 6, 7], 7);
            addAnimation("eating", [8, 9], 5);
            addAnimation("stopped", [1]);
            facing = RIGHT;
        }
        override public function update():void
        {
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
			
			
			if ( _eatAnimationTimer > 0 ) {
				_eatAnimationTimer -= FlxG.elapsed;
				velocity.x = velocity.y = 0;
				_aiState = PIG_STATE_EAT;
			} else if (velocity.x < 0) {
				_facing = LEFT;
			} else {
				_facing = RIGHT;
			}
			
			if ( _aiState == PIG_STATE_EAT ) {
				play("eating");
			}
			if ( _aiState == PIG_STATE_WANDER ) {
				play("normal");
			}
			if ( _aiState == PIG_STATE_FLEE ) {
				play("fleeing");
			}
			if ( _aiState == PIG_STATE_APPROACH ) {
				play("normal");
			}
			
			
			
			if (health <= 0) { _playstate.reload(); }
			
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
		
		public function eat() : void
		{
			_eatAnimationTimer = PIG_EAT_ANIMATION_DURATION;
		}
    }
} 

