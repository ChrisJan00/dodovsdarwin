package  
{
    import org.flixel.*;
	import flash.display.Bitmap;

    public class Stone extends FlxSprite
    {
        [Embed(source = "img/stone_01.png")] private var ImgStone01:Class;
        [Embed(source = "img/stone_02.png")] private var ImgStone02:Class;
        [Embed(source = "img/stone_03.png")] private var ImgStone03:Class;
		
		private var _ratHome:Boolean;
		
        public function  Stone(X:Number,Y:Number, ratHome:Boolean=true):void
        {
			super(X, Y);
			
			_ratHome = ratHome;
			
			var index:Number = Math.floor(Math.random() * 3);
			var ImgData:Bitmap;
			var Img:Class
			
			switch(index) {
				case 0: 
					ImgData = new ImgStone01();
					Img = ImgStone01;
				break;
				case 1:
					ImgData = new ImgStone02();
					Img = ImgStone02;
				break;
				case 2:
					ImgData = new ImgStone03();
					Img = ImgStone03;
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
		
		public function makesRats():Boolean
		{
			return _ratHome;
		}
        //override public function update():void
        //{			
            //super.update();   
        //}
    }
    
} 