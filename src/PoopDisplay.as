package  
{
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Matrix;
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
		
		private var _isBlinkTimeLineRunning:Boolean = false;
		private var blinkTimeLine:TimelineMax;
		
		// Needed to scale from center
		private var _imageHolder:Sprite;
		private var _useScale:Boolean = true;
		
		public function PoopDisplay( a_playState:PlayState ) 
		{
			_playState = a_playState;
			_imageHolder = new Sprite();
			addChild( _imageHolder );
			
			_iconBackground = new ImgPoopSeed();
			_iconBackground.alpha = 0.3;
			_imageHolder.addChild(_iconBackground);
			
			_iconFilling = new ImgPoopSeed();
			_imageHolder.addChild(_iconFilling);
			
			_iconMask = new Sprite();
			_iconMask.graphics.beginFill(0x0000FF);
			_iconMask.graphics.drawRect( 0, 0, _iconFilling.width, _iconFilling.height);
			_iconMask.graphics.endFill();
			_imageHolder.addChild( _iconMask );
			_iconFilling.mask = _iconMask;
			
			if ( _useScale ) {
				_iconBackground.x = -(_iconBackground.width / 2);
				_iconBackground.y = -(_iconBackground.height / 2);
				_iconFilling.x = -(_iconBackground.width / 2);
				_iconFilling.y = -(_iconBackground.height / 2);
				_iconMask.x = -(_iconBackground.width / 2);
				_iconMask.y = -(_iconBackground.height / 2);
			}
		}
		
		public function update():void {
			if (_playState._player) {
				var _loc_poopPercentage:Number;
				if ( _playState._player.SHIT_THRESHOLD == 0 ) {
					_loc_poopPercentage = 1;
				} else {
					_loc_poopPercentage = _playState._player.eatenFruitCount / _playState._player.SHIT_THRESHOLD;
				}
				
				var _loc_fillHeight:Number = Math.max ( 0, _iconFilling.height - ( _loc_poopPercentage * _iconFilling.height));
				if ( _loc_fillHeight == 0 ) {
					if ( _useScale ) {
						TweenLite.to( _iconMask, 0.1, { y:_loc_fillHeight-(_iconBackground.height / 2) });
					} else {
						TweenLite.to( _iconMask, 0.1, { y:_loc_fillHeight });
					}
				} else {
					if ( _useScale ) {
						TweenLite.to( _iconMask, 0.3, { y:_loc_fillHeight-(_iconBackground.height / 2) });
					} else {
						TweenLite.to( _iconMask, 0.3, { y:_loc_fillHeight });
					}
				}
				
				if ( !_isBlinkTimeLineRunning && _loc_poopPercentage >= 1 ) {
					blinkTimeLine = new TimelineMax();
					blinkTimeLine.repeat = -1;
					if ( _useScale ) {
						blinkTimeLine.append( new TweenLite( _imageHolder, 0.3, { alpha:0.2, scaleX:0.9, scaleY:0.9 } ) );
						blinkTimeLine.append( new TweenLite( _imageHolder, 0.3, { alpha:1, scaleX:1.1, scaleY:1.1 } ) );
					} else {
						blinkTimeLine.append( new TweenLite( _imageHolder, 0.3, { alpha:0.2 } ) );
						blinkTimeLine.append( new TweenLite( _imageHolder, 0.3, { alpha:1 } ) );
					}
					_isBlinkTimeLineRunning = true;
				} else if ( _isBlinkTimeLineRunning && _loc_poopPercentage < 1) {
					blinkTimeLine.complete(true);
					blinkTimeLine = null;
					if ( _useScale ) {
						TweenLite.to( _imageHolder, 0.2, { alpha:1, scaleX:1, scaleY:1 } );
					} else {
						TweenLite.to( _imageHolder, 0.2, { alpha:1 } );
					}
					_isBlinkTimeLineRunning = false;
				}
			}
		}
	}

}