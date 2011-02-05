package  
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Rectangle;
    import org.flixel.*;

    public class Background extends FlxSprite
    {
		//public var size:Point;
		
        public function Background(img:Class, rect:Rectangle):void
        {
            super(0, 0);
			
			//var ImgData:Bitmap = new img();
			//size = new Point();
			//size.x = (ImgData as Bitmap).width;
			//size.y = (ImgData as Bitmap).height;
			
			loadGraphic(img, false, false);
			offset.x = rect.x;
			offset.y = rect.y;
			width = rect.width;
			height = rect.height;
        }
		    
    }
    
} 