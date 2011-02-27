package  
{
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import org.flixel.FlxG;
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author Max Dohme
	 */
	public class HudIcon extends Sprite
	{
		[Embed(source = "img/nokiafc22.ttf", fontFamily = "NES", embedAsCFF = "false")] private var junk:String;
		
		//private var _playState:PlayState;
		private var _iconBackground:Bitmap;
		private var _iconFilling:Bitmap;
		private var _iconMask:Sprite;
		
		private var _isBlinkTimeLineRunning:Boolean;
		private var blinkTimeLine:TimelineMax;
		
		// Needed to scale from center
		private var _imageHolder:Sprite;
		
		private var _showing:Boolean;
		private var _scaleStrength:Number;
		private var _scaleDownTo:Number;
		private var _scaleUpTo:Number;
		
		//public function HudIcon( a_ImageClass:Class, a_playState:PlayState ) 
		public function HudIcon( a_ImageClass:Class ) 
		{
			// Might be needed later for calling pState to display text, keep for now
			//_playState = a_playState;
			
			_imageHolder = new Sprite();
			addChild( _imageHolder );
			alpha = 0;
			
			_iconBackground = new a_ImageClass();
			_iconBackground.alpha = 0.2;
			_imageHolder.addChild(_iconBackground);
			
			_iconFilling = new a_ImageClass();
			_imageHolder.addChild(_iconFilling);
			
			_iconMask = new Sprite();
			_iconMask.graphics.beginFill(0x0000FF);
			_iconMask.graphics.drawRect( 0, 0, _iconFilling.width, _iconFilling.height);
			_iconMask.graphics.endFill();
			_imageHolder.addChild( _iconMask );
			_iconFilling.mask = _iconMask;
			_iconMask.y = _iconFilling.height;
			
			_imageHolder.x = (_iconBackground.width / 2);
			_imageHolder.y = (_iconBackground.height / 2);
			_iconBackground.x = -(_iconBackground.width / 2);
			_iconBackground.y = -(_iconBackground.height / 2);
			_iconFilling.x = -(_iconBackground.width / 2);
			_iconFilling.y = -(_iconBackground.height / 2);
			_iconMask.x = -(_iconBackground.width / 2);
			_iconMask.y = -(_iconBackground.height / 2);
			
			blinkTimeLine = new TimelineMax();
			_showing = false;
			_isBlinkTimeLineRunning = false;
			_scaleStrength = 1;
			_scaleDownTo = 0.8;
			_scaleUpTo = 1.1;
			
			x = FlxG.width - 50 - (_iconBackground.width / 2);
			y = FlxG.height - 70;
		}
		
		public function keepBlinkingAndScaling():void {
			_isBlinkTimeLineRunning = true;
			blinkTimeLine = new TimelineMax();
			blinkTimeLine.repeat = -1;
			blinkTimeLine.append( new TweenLite( _imageHolder, 0.3, { alpha:0.75, scaleX:_scaleDownTo, scaleY:_scaleDownTo } ) );
			blinkTimeLine.append( new TweenLite( _imageHolder, 0.2, { alpha:1, scaleX:_scaleUpTo, scaleY:_scaleUpTo } ) );
		}
		
		public function stopBlinkingAndScaling():void {
			_isBlinkTimeLineRunning = false;
			blinkTimeLine.complete(true);
			TweenLite.to( _imageHolder, 0.05, { alpha:1, scaleX:1, scaleY:1 } );
		}
		
		public function doJump():void {
			blinkTimeLine = new TimelineMax();
			blinkTimeLine.append( new TweenLite( _imageHolder, 0.05, { scaleX:1.1, scaleY:1.1 } ) );
			blinkTimeLine.append( new TweenLite( _imageHolder, 0.1, { scaleX:0.9, scaleY:0.9 } ) );
			blinkTimeLine.append( new TweenLite( _imageHolder, 0.05, { scaleX:1, scaleY:1 } ) );
		}
		
		public function setFillTo( a_num:Number, a_speed:Number = 0.2 ):void {
			var _loc_fillHeight:Number = Math.max ( 0, _iconFilling.height - ( a_num * _iconFilling.height));
			TweenLite.to( _iconMask, a_speed, { y:_loc_fillHeight-(_iconBackground.height / 2) });
		}
		
		public function setFillEmpty():void {
			TweenLite.to( _iconMask, 0.05, { y:(_iconBackground.height / 2) });
		}
		
		public function fadeIn():void {
			if ( _showing ) { return; }
			TweenLite.to( this, 0.2, { alpha:1 } );
			_showing = true;
		}
		
		public function fadeOut():void {
			if ( !_showing ) { return; }
			TweenLite.to( this, 0.2, { alpha:0 } );
			_showing = false;
		}
		
		public function get showing():Boolean { return _showing; }
		
		public function get isBlinkTimeLineRunning():Boolean { return _isBlinkTimeLineRunning; }
		
		public function set scaleStrength(value:Number):void 
		{
			_scaleStrength = value;
			_scaleDownTo = 1 - (0.2 * _scaleStrength);
			_scaleUpTo = 1 + (0.1 * _scaleStrength);
		}
	}

}