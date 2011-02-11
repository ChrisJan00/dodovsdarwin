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
		
		private var _player:Player;
		private var _poopDisplay:HudIcon;
		private var _eggDisplay:HudIcon;
		
		public function HudDisplay( a_playState:PlayState ) {
			
			_player = a_playState._player;
			
			_poopDisplay = new HudIcon( ImgPoopSeed );
			addChild( _poopDisplay );
			
			_eggDisplay = new HudIcon( ImgEgg );
			addChild( _eggDisplay );
			
		}
		
		private var _goalArray:Array;
		private var _goalValue:int;
		private var _goalValueIsAbsolute:Boolean;
		private var _goalDisplay:HudIcon;
		
		public function update():void {
			// Check if goal array is set
			
			// check if length of goal array has changed
			
			// modify goalvalue if relative
			
			// hide whatever diplay is showing
			
			// call on goalDisplay to update itself and show
		}
		public function setGoalDisplay( a_array:Array, a_value:int, a_imageClass:Class, a_valueIsAbsolute:Boolean = true ):void {
			_goalArray = a_array;
			_goalValue = a_value;
			_goalValueIsAbsolute = a_valueIsAbsolute;
			
			_goalDisplay = new HudIcon( a_imageClass );
			addChild( _goalDisplay );
		}
		
		public function onEat():void {
			
			if ( _poopDisplay.showing ) {
				updateIcon( _poopDisplay, _player.poopReadyProgress );
			} else if ( _eggDisplay.showing ) {
				updateIcon( _eggDisplay, _player.birthReadyProgress );
			} else {
				_poopDisplay.fadeIn();
				updateIcon( _poopDisplay, _player.poopReadyProgress );
			}
		}
		
		private function updateIcon( a_hudIcon:HudIcon, a_percentage:Number ):void {
			a_hudIcon.doJump();
			a_hudIcon.setFillTo( a_percentage );
			if ( a_percentage >= 1 ) {
				a_hudIcon.keepBlinkingAndScaling();
			}
		}
		
		public function onPoop():void {
			_poopDisplay.stopBlinkingAndScaling();
			_poopDisplay.setFillEmpty();
		}
		
		public function onLayEgg():void {
			_eggDisplay.stopBlinkingAndScaling();
			_eggDisplay.setFillEmpty();
			_eggDisplay.fadeOut();
			_poopDisplay.fadeIn();
		}
		
		public function onGetPregnant():void {
			_eggDisplay.setFillEmpty();
			_poopDisplay.fadeOut();
			_eggDisplay.fadeIn();
		}
	}
}