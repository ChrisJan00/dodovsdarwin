package  
{
    import org.flixel.*;
	import flash.display.Bitmap;

    public class Tree extends FlxSprite
    {
        [Embed(source = "img/tree_01.png")] private var ImgTree01:Class;
        [Embed(source = "img/tree_02.png")] private var ImgTree02:Class;
        [Embed(source = "img/tree_03.png")] private var ImgTree03:Class;
		
        public function Tree(X:Number,Y:Number):void
        {
			super(X, Y);
			
			var index:Number = Math.floor(Math.random() * 3);
			var ImgData:Bitmap;
			var Img:Class
			
			switch(index) {
				case 0: 
					ImgData = new ImgTree01();
					Img = ImgTree01;
				break;
				case 1:
					ImgData = new ImgTree02();
					Img = ImgTree02;
				break;
				case 2:
					ImgData = new ImgTree03();
					Img = ImgTree03;
				break;
			}
			
			width = (ImgData as Bitmap).width;
			height = (ImgData as Bitmap).height;
			
			fixed = true;
			loadGraphic(Img);
     
        }
        //override public function update():void
        //{			
            //super.update();   
        //}
    }
    
} 