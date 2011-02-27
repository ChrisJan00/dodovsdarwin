package  {
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.Event;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	/**
	 * The HudDisplay decides which one of the two displays to show and tweens them in and out.
	 * @author Max Dohme
	 */
	public class HudDisplay extends Sprite {
		
		[Embed(source = "img/fruit_03.png")] private var ImgPoopSeed:Class;
		[Embed(source = "img/egg_02.png")] private var ImgEgg:Class;
		[Embed(source = "img/buttonPressIcon_smaller.png")] private var ImgButton:Class;
		//[Embed(source = "img/buttonPressIcon.jpg")] private var ImgOK:Class;
		
		private const GOAL_CHANGE_FILL_TIME:Number = 3;
		private const GOAL_DISPLAY_TIME:Number = 4;
		
		private var _player:Player;
		private var _poopDisplay:HudIcon;
		private var _eggDisplay:HudIcon;
		private var _buttonDisplay:HudIcon;
		private var _okDisplay:HudIcon;
		private var _goalArray:Array;
		private var _goalValue:int;
		private var _goalValueIsAbsolute:Boolean;
		private var _goalDisplay:HudIcon;
		private var _goalArrayLastLength:int;
		private var _goalDisplayTimer:Number;
		private var _isPlayerPregnant:Boolean;
		private var _hasEatenFirstTime:Boolean;
		private var _hasBeenBlinkingTimer:Number;
		
		public function HudDisplay( a_playState:PlayState ) {
			
			_player = a_playState._player;
			
			_poopDisplay = new HudIcon( ImgPoopSeed );
			addChild( _poopDisplay );
			
			_eggDisplay = new HudIcon( ImgEgg );
			addChild( _eggDisplay );
			
			_buttonDisplay = new HudIcon( ImgButton );
			addChild( _buttonDisplay );
			_buttonDisplay.scaleStrength = 0.4;
			_buttonDisplay.x -= 20;
			_buttonDisplay.y -= 80;
			
			//_okDisplay = new HudIcon( ImgOK );
			//addChild( _okDisplay );
			
			_isPlayerPregnant = false;
			_hasEatenFirstTime = false;
			_goalDisplayTimer = 0;
			_hasBeenBlinkingTimer = 0;
			
			updateIcon( _poopDisplay, 0 );
			updateIcon( _eggDisplay, 0 );
		}
		
		public function update():void {
			if ( _goalArray ) {
				if ( _onlyFamily ) {
					if ( _goalArray.length != _goalArrayLastLength ) {
						var _loc_adultChildrenCount:int = 0;
						for each (var adultDodo:FlxSprite in _goalArray) {
							if (adultDodo != _player && (adultDodo as Dodo).family == _player.family) {
								_loc_adultChildrenCount++;
							}
						}
						if ( _loc_adultChildrenCount > _lastAdultChildrenCount ) {
							_goalGained++;
							onGoalProgress( _goalGained / _goalValue );
						}
						_goalArrayLastLength = _goalArray.length;
						_lastAdultChildrenCount = _loc_adultChildrenCount;
					}
				} else {
					if ( _isGoalMatingProgress ) {
						if ( _goalArray.length > _goalArrayLastLength ) {
							_goalArrayLastLength = _goalArray.length;
							onGoalProgress( 0.5 );
						}
						if ( _player.matingProgress > 0 && _hasMated == false) {
							onGoalProgress( 1 );
							_hasMated = true;
						}
					} else {
						if ( _goalArray.length != _goalArrayLastLength ) {
							if ( _goalValueIsAbsolute ) {
								onGoalProgress( _goalArray.length / _goalValue );
							} else {
								if ( _goalArray.length > _goalArrayLastLength ) {
									_goalGained++;
									onGoalProgress( _goalGained / _goalValue );
								}
							}
							_goalArrayLastLength = _goalArray.length;
						}
					}
				}
				if ( _goalDisplayTimer > 0 ) {
					_goalDisplayTimer -= FlxG.elapsed;
					_poopDisplay.fadeOut();
					_eggDisplay.fadeOut();
					_goalDisplay.fadeIn();
				} else {
					_goalDisplay.fadeOut();
					if ( !_hasEatenFirstTime ) { return; }
					if ( _isPlayerPregnant ) { 
						_poopDisplay.fadeOut();
						_eggDisplay.fadeIn();
					} else {
						_poopDisplay.fadeIn();
						_eggDisplay.fadeOut();
					}
				}
			} else {
				if ( !_hasEatenFirstTime ) { return; }
				if ( _isPlayerPregnant ) { 
					_poopDisplay.fadeOut();
					_eggDisplay.fadeIn();
				} else {
					_poopDisplay.fadeIn();
					_eggDisplay.fadeOut();
				}
			}
			if ( _poopDisplay.isBlinkTimeLineRunning || _eggDisplay.isBlinkTimeLineRunning ) {
				_hasBeenBlinkingTimer += FlxG.elapsed;
			} else {
				_hasBeenBlinkingTimer = 0;
			}
			if ( _hasBeenBlinkingTimer > 5 && _goalDisplayTimer <= 0 ) {
				if ( !_buttonDisplay.isBlinkTimeLineRunning ) {
					_buttonDisplay.fadeIn();
					_buttonDisplay.keepBlinkingAndScaling();
				}
			} else {
				_buttonDisplay.fadeOut();
				_buttonDisplay.stopBlinkingAndScaling();
			}
		}
		
		private var _goalGained:int;
		private var _onlyFamily:Boolean;
		private var _lastAdultChildrenCount:int;
		/**
		 * Method that sets the goal display for the current level and updates it depending on the passed arguments.
		 * An absolute display updates to a fill % between 0 and the amount passed as a_value, a relative display increases its
		 * fill each time the array grows, but not when it shrinks. Its fill % is the proportion of gained to a_value.
		 * @param	a_array				The array to check for changes
		 * @param	a_value				The 100% mark for an absolute display, or the amount needed to be gained for relative
		 * @param	a_imageClass		The image to display
		 * @param	a_valueIsAbsolute	Wether the display should be absolute or relative
		 */
		public function setGoal( a_array:Array, a_value:int, a_imageClass:Class, a_valueIsAbsolute:Boolean = true, a_onlyFamily:Boolean = false ):void {
			_goalArray = a_array;
			_goalValue = a_value;
			_goalValueIsAbsolute = a_valueIsAbsolute;
			_onlyFamily = a_onlyFamily;
			_lastAdultChildrenCount = 0;
			_isGoalMatingProgress = false;
			
			_goalDisplay = new HudIcon( a_imageClass );
			addChild( _goalDisplay );
			
			// Setting lastLength so that it doesn't display at the start of the level
			_goalArrayLastLength = _goalArray.length;
			_goalDisplay.x -= 5;
			_goalDisplay.y -= 30;
			
			if ( a_valueIsAbsolute ) {
				updateIcon( _goalDisplay, (_goalArrayLastLength / _goalValue) );
			} else {
				updateIcon( _goalDisplay, 0 );
				_goalGained = 0;
			}
		}
		
		private var _isGoalMatingProgress:Boolean;
		private var _hasMated:Boolean;
		public function setGoalMatingProgress( a_array:Array, a_imageClass:Class ):void {
			_goalArray = a_array;
			_isGoalMatingProgress = true;
			_hasMated = false;
			
			_goalDisplay = new HudIcon( a_imageClass );
			addChild( _goalDisplay );
			
			// Setting lastLength so that it doesn't display at the start of the level
			_goalArrayLastLength = _goalArray.length;
			_goalDisplay.x -= 5;
			_goalDisplay.y -= 30;
			
			updateIcon( _goalDisplay, 0 );
		}
		
		public function isVictoryAchieved():Boolean {
			if ( !_goalArray ) return false;
			
			if ( _goalValueIsAbsolute ) {
				return ( ( _goalArray.length / _goalValue ) >= 1 );
			} else {
				return ( ( _goalGained / _goalValue ) >= 1 );
			}
		}
		
		private function updateIcon( a_hudIcon:HudIcon, a_percentage:Number, a_speed:Number = 0.2 ):void {
			a_hudIcon.doJump();
			a_hudIcon.setFillTo( a_percentage, a_speed );
			if ( a_percentage >= 1 ) {
				a_hudIcon.keepBlinkingAndScaling();
			}
		}
		
		private function onGoalProgress( a_goalProgress:Number ):void {
			updateIcon( _goalDisplay, a_goalProgress, GOAL_CHANGE_FILL_TIME );
			if ( a_goalProgress >= 1 ) { 
				_goalDisplayTimer = 10;
			} else {
				_goalDisplayTimer = GOAL_DISPLAY_TIME;
			}
		}
		
		public function onEat():void {
			_hasEatenFirstTime = true;
			if ( _poopDisplay.showing ) {
				updateIcon( _poopDisplay, _player.poopReadyProgress );
			} else if ( _eggDisplay.showing ) {
				updateIcon( _eggDisplay, _player.birthReadyProgress );
			} else {
				_poopDisplay.fadeIn();
				updateIcon( _poopDisplay, _player.poopReadyProgress );
			}
		}
		
		public function onPoop():void {
			_poopDisplay.stopBlinkingAndScaling();
			_poopDisplay.setFillEmpty();
		}
		
		public function onLayEgg():void {
			_isPlayerPregnant = false;
			_eggDisplay.stopBlinkingAndScaling();
			_eggDisplay.setFillEmpty();
		}
		
		public function onGetPregnant():void {
			_isPlayerPregnant = true;
			_eggDisplay.setFillEmpty();
		}
	}
}