package  
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Max Dohme
	 */
	public class EggDisplay extends Sprite
	{
		[Embed(source = "img/egg_02.png")] private var ImgEgg:Class;
		
		private var _playState:PlayState;
		private var _iconFarBackground:Bitmap;
		private var _iconBackground:Bitmap;
		private var _iconFilling:Bitmap;
		private var _iconBackgroundMask:Sprite;
		private var _iconMask:Sprite;
		private var _blinkTimer:Number = 0;
		
		public function EggDisplay( a_playState:PlayState ) 
		{
			_playState = a_playState;
			
			_iconFarBackground = new ImgEgg();
			_iconFarBackground.alpha = 0.1;
			addChild(_iconFarBackground);
			
			_iconBackground = new ImgEgg();
			_iconBackground.alpha = 0.5;
			addChild(_iconBackground);
			
			_iconFilling = new ImgEgg();
			addChild(_iconFilling);
			
			_iconBackgroundMask = new Sprite();
			_iconBackgroundMask.graphics.beginFill(0x0000FF);
			_iconBackgroundMask.graphics.drawRect( 0, 0, _iconBackground.width, _iconBackground.height);
			_iconBackgroundMask.graphics.endFill();
			addChild( _iconBackgroundMask );
			_iconBackground.mask = _iconBackgroundMask;
			_iconBackgroundMask.y = _iconBackground.height;
			
			_iconMask = new Sprite();
			_iconMask.graphics.beginFill(0x0000FF);
			_iconMask.graphics.drawRect( 0, 0, _iconFilling.width, _iconFilling.height);
			_iconMask.graphics.endFill();
			addChild( _iconMask );
			_iconFilling.mask = _iconMask;
			_iconMask.y = _iconFilling.height;
		}
		
		public function update():void {
			if (_playState._player) {
				_iconMask.y = Math.max ( 0, _iconBackground.height - _playState._player.matingProgress * _iconBackground.height );
				
				// Blinking display
				if ( _playState._player.isPregnant ) {
					_blinkTimer += FlxG.elapsed;
					if ( (( Math.floor(_blinkTimer / 0.3) % 2 ) == 1) ) 
					{
						_iconFilling.visible = true;
					} else 
					{
						_iconFilling.visible = false;
					}
				} else {
					_blinkTimer = 0;
					_iconFilling.visible = true;
				}
			}
		}
		
	}

}