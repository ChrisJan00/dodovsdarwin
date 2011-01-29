package  
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Max Dohme
	 */
	public class PoopDisplay extends Sprite
	{
		[Embed(source = "img/seed_02.png")] private var ImgPoopSeed:Class;
		
		private var _playState:PlayState;
		private var _iconBackground:Bitmap;
		private var _iconFilling:Bitmap;
		private var _iconMask:Sprite;
		
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
		}
		
		public function update():void {
			if (_playState._player) {
				_iconMask.y = Math.max ( 0, _iconFilling.height - ( _playState._player.eatenFruitCount / _playState._player.SHIT_THRESHOLD ) * _iconFilling.height);
			}
		}
		
	}

}