package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	
	
	/**
	 * ...
	 * @author Max Dohme
	 */
	public class Preloader extends MovieClip {
		
		[Embed(source = "img/dodo_male_walk.png")] private var ImgPlayer:Class;
		[Embed(source = "img/PreloaderScreenBackground.jpg")] private var ImgBackground:Class;
		[Embed(source="img/nokiafc22.ttf",fontFamily="system")] protected var junk:String;
		
		private var _loadingBar:Sprite;
		
		private var _imageData:BitmapData;
		private var _blitData:BitmapData;
		private var _bitmap:Bitmap;
		
		private var _backgroundImageData:BitmapData; 
		private var _backgroundBlitData:BitmapData;
		private var _backgroundBitmap:Bitmap;
		
		public static var dodoPosX:Number = 0;
		
		public function Preloader() {
			if (stage) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			_loadingBar = new Sprite();
			_loadingBar.graphics.beginFill(0x00FF00);
			_loadingBar.graphics.drawRect(0, 0, 640, 5);
			_loadingBar.graphics.endFill();
			_loadingBar.scaleX = 0;
			_loadingBar.y = 475;
			
			_backgroundImageData = (new ImgBackground).bitmapData;
			_backgroundBlitData = new BitmapData(640, 480);
			_backgroundBitmap = new Bitmap( _backgroundBlitData );
			_backgroundBlitData.fillRect( _backgroundBlitData.rect, 0 );
			_backgroundBlitData.copyPixels( _backgroundImageData, new Rectangle(0, 0, 640, 390), new Point());
			addChild( _backgroundBitmap );
			
			_imageData = (new ImgPlayer).bitmapData;
			_blitData = new BitmapData(80, 70);
			_bitmap = new Bitmap( _blitData );
			_bitmap.x = dodoPosX = -90;
			_bitmap.y = 350;
			addChild( _bitmap );
			
			_frameCounter = 0;
			_currentFrame = 0;
			_currentFrameRect = new Rectangle(0, 0, 80, 70);
		}
		
		private function ioError(e:IOErrorEvent):void {
			trace(e.text);
		}
		
		private var _frameCounter:Number;
		private var _currentFrame:int;
		private var _currentFrameRect:Rectangle;
		
		private function progress(e:ProgressEvent):void {
			
			var _loc_1:Number = ((e.bytesLoaded / e.bytesTotal));
			_loadingBar.scaleX = _loc_1;
		}
		
		
		//private var counter:uint = 0;
		private function checkFrame(e:Event):void {
			//counter++;
			//var _loc_e:ProgressEvent = new ProgressEvent("progress", false, false, counter, 100);
			//progress(_loc_e);
			//if (counter == 100) loadingFinished();
			
			_frameCounter++;
			if (_frameCounter == 1) {
				addChild(_loadingBar);
			}
			_currentFrame = Math.floor( _frameCounter / 10 ) % 4;
			_currentFrameRect.x = _currentFrame * 80;
			_blitData.fillRect( _blitData.rect, 0 );
			_blitData.copyPixels( _imageData, _currentFrameRect, new Point() );
			_bitmap.x += 2;
			if ( _bitmap.x > 640 ) _bitmap.x = -90;
			dodoPosX = _bitmap.x;
			
			if (currentFrame == totalFrames && !_isLoadingFinished) {
				stop();
				loadingFinished();
				_isLoadingFinished = true;
			}
		}
		
		private var _isLoadingFinished:Boolean = false;
		
		private function loadingFinished():void {
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			try {
				removeChild(_loadingBar);
			} catch ( e:Error ) {
				trace(e);
			}
			
			_backgroundBlitData.copyPixels( _backgroundImageData, _backgroundBlitData.rect, new Point());
			
			stage.addEventListener(MouseEvent.CLICK, startup, false, 0, true);
		}
		
		private function startup( e:Event ):void {
			stage.removeEventListener(MouseEvent.CLICK, startup);
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			removeChild(_bitmap);
			removeChild(_backgroundBitmap);
			
			var mainClass:Class = getDefinitionByName("Main") as Class;
			if (parent == stage) stage.addChildAt(new mainClass() as DisplayObject, 0);
			else addChildAt(new mainClass() as DisplayObject, 0);
		}
		
	}
	
}