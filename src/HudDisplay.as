package  {
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.Event;
	import org.flixel.FlxG;
	
	/**
	 * The HudDisplay decides which one of the two displays to show and tweens them in and out.
	 * @author Max Dohme
	 */
	public class HudDisplay extends Sprite {
		
		[Embed(source = "img/fruit_03.png")] private var ImgPoopSeed:Class;
		[Embed(source = "img/egg_02.png")] private var ImgEgg:Class;
		[Embed(source = "img/buttonPressIcon_smaller.png")] private var ImgButton:Class;
		//[Embed(source = "img/buttonPressIcon.jpg")] private var ImgOK:Class;
		
		private const GOAL_DISPLAY_TIME:Number = 3;
		
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
				if ( _goalArray.length != _goalArrayLastLength ) {
					_goalArrayLastLength = _goalArray.length;
					if ( _goalValueIsAbsolute ) {
						onGoalProgress( _goalArrayLastLength / _goalValue );
					} else {
						// Do stuff for relative goal display
						// must work for positive and negative goal values
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
		public function setGoalDisplay( a_array:Array, a_value:int, a_imageClass:Class, a_valueIsAbsolute:Boolean = true ):void {
			if ( !a_valueIsAbsolute ) {
				trace( "only absolute goal values work for now, goal display deactivated" );
				return;
			}
			_goalArray = a_array;
			_goalValue = a_value;
			_goalValueIsAbsolute = a_valueIsAbsolute;
			
			_goalDisplay = new HudIcon( a_imageClass );
			addChild( _goalDisplay );
			
			// Setting lastLength so that it doesn't display at the start of the level
			_goalArrayLastLength = _goalArray.length;
			_goalDisplay.x -= 5;
			_goalDisplay.y -= 30;
			updateIcon( _goalDisplay, (_goalArrayLastLength / _goalValue) );
		}
		
		private function updateIcon( a_hudIcon:HudIcon, a_percentage:Number ):void {
			a_hudIcon.doJump();
			a_hudIcon.setFillTo( a_percentage );
			if ( a_percentage >= 1 ) {
				a_hudIcon.keepBlinkingAndScaling();
			}
		}
		
		private function onGoalProgress( a_goalProgress:Number ):void {
			updateIcon( _goalDisplay, a_goalProgress );
			_goalDisplayTimer = GOAL_DISPLAY_TIME;
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