﻿package  
{
	import flash.geom.ColorTransform;
	import flash.geom.Vector3D;
    import org.flixel.*;

    public class Pig extends FlxSprite
    {
        [Embed(source = "img/pig_anim.png")] private var ImgPlayer:Class;
		
		
        [Embed(source = "snd/pigeat.mp3")] private var EatSound:Class;
		[Embed(source = "snd/pigescape.mp3")] private var RunSound:Class;
		
		private var _MaxVelocity_walking:int = 200;
		private var _playstate:PlayState;
		
		private const PIG_MOVEMENT_SPEED:Number = 50;
		private const PIG_FLEE_DODO_DISTANCE:Number = 120;
		private const PIG_FLEE_TURN_DODO_DISTANCE:Number = 20;
		private const PIG_KEEP_FLEEING_DODO_DISTANCE:Number = 180;
		private const PIG_APPROACH_FRUIT_DISTANCE:Number = 300;
		
		private var _aiState:String;
		private var _aiUpdateTimer:Number = 0;
		
		private const PIG_STATE_WANDER:String = "PigStateWander";
		private const PIG_STATE_APPROACH:String = "PigStateApproach";
		private const PIG_STATE_FLEE:String = "PigStateFlee";
		private const PIG_STATE_FLEE_TURN:String = "PigStateFleeTurn";
		private const PIG_STATE_EAT:String = "PigStateEat";
		
		private const PIG_WANDER_AIUPDATE_DELAY_MIN:Number = 0.5;
		private const PIG_WANDER_AIUPDATE_DELAY_RANGE:Number = 2.5;
		
		private const PIG_EAT_ANIMATION_DURATION:Number = 2;
		private var _eatAnimationTimer:Number = 0;
		private var _fleeTurnTimer:Number = 0;
		private const PIG_FLEE_TURN_PAUSE:Number = 1;
		
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
            height = 22;
            offset.x = 20;
            offset.y = 24;
			
            addAnimation("normal", [0, 2], 5);
            addAnimation("fleeing", [4, 5, 6, 7], 7);
            addAnimation("eating", [8, 9], 5);
            addAnimation("stopped", [1]);
            facing = RIGHT;
			_fleeTurnTimer = 0;
        }
        override public function update():void
        {
			var oldState:String = _aiState;
			
			_aiUpdateTimer -= FlxG.elapsed;
			_fleeTurnTimer -= FlxG.elapsed;
			
			if ( _fleeTurnTimer <= 0 ) {
				var _loc_toVector:Vector3D = getSteering();
				if ( _loc_toVector ) {
					_loc_toVector.normalize();
					if ( _aiState == PIG_STATE_APPROACH ) {
						_loc_toVector.scaleBy(0.5);
					}
					if ( _aiState == PIG_STATE_FLEE ) {
						_loc_toVector.scaleBy(2.7);
					}
					if ( _aiState == PIG_STATE_FLEE_TURN ) {
						addWander( _loc_toVector, 1 );
						_loc_toVector.normalize();
						_loc_toVector.scaleBy(3);
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
			} else
			if ( _aiState == PIG_STATE_WANDER ) {
				play("normal");
			} else
			if ( _aiState == PIG_STATE_FLEE ) {
				play("fleeing");
			} else
			if ( _aiState == PIG_STATE_APPROACH ) {
				play("normal");
			} else
			
			
			
			if (health <= 0) { _playstate.reload(); }
			
			if (_aiState != oldState) {
				if (_aiState == PIG_STATE_FLEE)
					FlxG.play(RunSound, _playstate.distance2Volume(this) );
				else
				if (_aiState == PIG_STATE_EAT)
					FlxG.play(EatSound, _playstate.distance2Volume(this) );
			}
			
            super.update();
            
        }
		
		private function getSteering():Vector3D {
			var _loc_toVector:Vector3D = _playstate.getClosestDodoVector( this );
			if ( _loc_toVector && _loc_toVector.length < PIG_FLEE_TURN_DODO_DISTANCE ) {
				(_playstate.getClosestFrom( this, _playstate._dodos ) as IDodo).resetScaredPigTimer();
				_aiState = PIG_STATE_FLEE_TURN;
				_fleeTurnTimer = PIG_FLEE_TURN_PAUSE;
				return( _loc_toVector );
			} else {
				if ( _loc_toVector && _aiState == PIG_STATE_FLEE && _loc_toVector.length < PIG_KEEP_FLEEING_DODO_DISTANCE ) {
					_loc_toVector.scaleBy( -1 );
					return( _loc_toVector );
				} else {
					if ( _loc_toVector && _loc_toVector.length < PIG_FLEE_DODO_DISTANCE ) {
						(_playstate.getClosestFrom( this, _playstate._dodos ) as IDodo).resetScaredPigTimer();
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
		
		private function addWander( a_vector:Vector3D, a_amount:Number = 1 ):void {
			var _loc_vector:Vector3D = new Vector3D( a_amount - (Math.random() * 2 * a_amount), a_amount - (Math.random() * 2 * a_amount) );
			a_vector.x += _loc_vector.x;
			a_vector.y += _loc_vector.y;
		}
        
        override public function hitFloor(Contact:FlxCore=null):Boolean
        {
            return super.hitFloor();
        }
		
		override public function hitCeiling(Contact:FlxCore=null):Boolean
        {
            return super.hitFloor();
        }
		
		public function eat() : Boolean
		{
			_eatAnimationTimer = PIG_EAT_ANIMATION_DURATION;
			return true;
		}
    }
} 

