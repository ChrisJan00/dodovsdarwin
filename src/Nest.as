package  
{
    import org.flixel.*;
	import flash.display.Bitmap;

    public class Nest extends FlxSprite
    {
        [Embed(source = "img/nest.png")] private var ImgNest01:Class;
		
        public function  Nest(X:Number,Y:Number):void
        {
			super(X, Y);
			
			var ImgData:Bitmap = new ImgNest01();
			
			width = (ImgData as Bitmap).width;
			height = (ImgData as Bitmap).height;
			
			fixed = true;
			loadGraphic(ImgNest01);
			
			//offset.x = width / 10;
			//width *= 8 / 10;
			//offset.y = height / 3;
			//height *= 2 / 3;
     
        }

    }
    
} 