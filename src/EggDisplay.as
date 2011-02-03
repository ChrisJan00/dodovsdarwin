package  
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Max Dohme
	 */
	public class EggDisplay extends Sprite
	{
		[Embed(source = "img/egg_02.png")] private var ImgEgg:Class;
		
		private var _playState:PlayState;
		private var _iconBackground:Bitmap;
		private var _iconFilling:Bitmap;
		private var _iconBackgroundMask:Sprite;
		private var _iconMask:Sprite;
		
		public function EggDisplay( a_playState:PlayState ) 
		{
			_playState = a_playState;
			
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
			
			_iconMask = new Sprite();
			_iconMask.graphics.beginFill(0x0000FF);
			_iconMask.graphics.drawRect( 0, 0, _iconFilling.width, _iconFilling.height);
			_iconMask.graphics.endFill();
			addChild( _iconMask );
			_iconFilling.mask = _iconMask;
			
			visible = false;
		}
		
		public function update():void {
			if (_playState._player) {
				_iconBackgroundMask.y = Math.max ( 0, _iconFilling.height - _playState._player.matingProgress * _iconFilling.height );
				visible = (_iconBackgroundMask.y < _iconFilling.height);
				
				_iconMask.y = Math.max ( 0, _iconFilling.height - _playState._player.birthReadyProgress  * _iconFilling.height );
			}
		}
		
	}

}