package  
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Max Dohme
	 */
	public class PoopDisplay extends Sprite
	{
		[Embed(source = "img/fruit_03.png")] private var ImgPoopSeed:Class;
		
		private var _playState:PlayState;
		private var _iconBackground:Bitmap;
		private var _iconFilling:Bitmap;
		private var _iconMask:Sprite;
		
		private var _blinkTimer:Number;
		
		public function PoopDisplay( a_playState:PlayState ) 
		{
			_playState = a_playState;
			
			_iconBackground = new ImgPoopSeed();
			_iconBackground.alpha = 0.3;
			addChild(_iconBackground);
			
			_iconFilling = new ImgPoopSeed();
			addChild(_iconFilling);
			
			_iconMask = new Sprite();
			_iconMask.graphics.beginFill(0x0000FF);
			_iconMask.graphics.drawRect( 0, 0, _iconFilling.width, _iconFilling.height);
			_iconMask.graphics.endFill();
			addChild( _iconMask );
			_iconFilling.mask = _iconMask;
			
			_blinkTimer = 0;
		}
		
		public function update():void {
			var _loc_poopPercentage:Number;
			if ( _playState._player.SHIT_THRESHOLD == 0 ) {
				_loc_poopPercentage = 1;
			} else {
				_loc_poopPercentage = _playState._player.eatenFruitCount / _playState._player.SHIT_THRESHOLD;
			}
			
			if (_playState._player) {
				_iconMask.y = Math.max ( 0, _iconFilling.height - ( _loc_poopPercentage * _iconFilling.height));
				// Blinking display
				if ( _loc_poopPercentage >= 1 ) {
					_blinkTimer += FlxG.elapsed;
					if ( (( Math.floor(_blinkTimer / 0.3) % 2 ) == 1) ) 
					{
						_iconFilling.alpha = 1;
					} else 
					{
						_iconFilling.alpha = 0.5;
					}
				} else {
					_blinkTimer = 0;
				}
			}
		}
	}

}