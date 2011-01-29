package  
{
    import org.flixel.*;
	import flash.display.Bitmap;

    public class Fruit extends FlxSprite
    {
        [Embed(source = "img/egg_01.png")] private var ImgFruit01:Class;
        [Embed(source = "img/egg_02.png")] private var ImgFruit02:Class;
        [Embed(source = "img/egg_03.png")] private var ImgFruit03:Class;
		
        public function Fruit(X:Number,Y:Number):void
        {
			super(X, Y);
			
			var index:Number = Math.floor(Math.random() * 3);
			var ImgData:Bitmap;
			var Img:Class
			
			switch(index) {
				case 0: 
					ImgData = new ImgFruit01();
					Img = ImgFruit01;
				break;
				case 1:
					ImgData = new ImgFruit02();
					Img = ImgFruit02;
				break;
				case 2:
					ImgData = new ImgFruit03();
					Img = ImgFruit03;
				break;
			}
			
			width = (ImgData as Bitmap).width;
			height = (ImgData as Bitmap).height;
			
			fixed = true;
			loadGraphic(Img);
			
			offset.x = width / 10;
			width *= 8 / 10;
			offset.y = height / 3;
			height *= 2 / 3;
     
        }
        //override public function update():void
        //{			
            //super.update();   
        //}
    }
    
} 