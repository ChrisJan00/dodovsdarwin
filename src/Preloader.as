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
		
		private var _loadingBar:Sprite;
		private var _imageData:BitmapData;
		private var _blitData:BitmapData;
		private var _bitmap:Bitmap;
		private var _text:TextField;
		
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
			_loadingBar.graphics.drawRect(0, 0, 640, 20);
			_loadingBar.graphics.endFill();
			_loadingBar.scaleX = 0;
			_loadingBar.y = 460;
			
			_imageData = (new ImgPlayer).bitmapData;
			_blitData = new BitmapData(80, 70);
			_bitmap = new Bitmap( _blitData );
			_bitmap.x = -90;
			_bitmap.y = 320;
			addChild( _bitmap );
			
			_frameCounter = 0;
			_currentFrame = 0;
			_currentFrameRect = new Rectangle(0, 0, 80, 70);
			
			_text = new TextField();
			var _textFormat:TextFormat = _text.getTextFormat();
			_textFormat.font = "Calibri";
			_textFormat.size = 12;
			_textFormat.color = 0xFFFFFF;
			_textFormat.bold = true;
			_textFormat.align = "right";
			_text.defaultTextFormat = _textFormat;
			_text.height = 50;
			_text.width = 50;
			_text.selectable = false;
			_text.text = "v0.2";
			_text.x = 590;
			_text.y = 0;
			addChild(_text);
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
			// Fake preloading for debugging
			//counter++;
			//var _loc_e:ProgressEvent = new ProgressEvent("progress", false, false, counter, 1000);
			//progress(_loc_e);
			
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
			
			if (currentFrame == totalFrames) {
				stop();
				loadingFinished();
			}
		}
		
		private function loadingFinished():void {
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			removeChild(_loadingBar);
			removeChild(_bitmap);
			removeChild(_text);
			
			startup();
		}
		
		private function startup():void {
			var mainClass:Class = getDefinitionByName("Main") as Class;
			if (parent == stage) stage.addChildAt(new mainClass() as DisplayObject, 0);
			else addChildAt(new mainClass() as DisplayObject, 0);
		}
		
	}
	
}