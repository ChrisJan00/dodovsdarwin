package  
{
    import org.flixel.*;
	import flash.display.Bitmap;

    public class Tree extends FlxSprite
    {
        [Embed(source = "img/tree_01.png")] private var ImgTree01:Class;
        [Embed(source = "img/tree_02.png")] private var ImgTree02:Class;
        [Embed(source = "img/tree_03.png")] private var ImgTree03:Class;
		
		private var imgWidth:Number;
		private var imgHeight:Number;
		private var fruitTimer:Number;
		
		private var _playstate:PlayState;
		
        public function Tree(X:Number,Y:Number, p:PlayState):void
        {
			super(X, Y);
			
			_playstate = p;
			
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
			
			imgWidth = (ImgData as Bitmap).width;
			imgHeight = (ImgData as Bitmap).height;
			
			fixed = true;
			loadGraphic(Img, false, false, imgWidth, imgHeight);
			
			switch(index) {
				case 0: 
					width = 48;
					height = 19;
					offset.x = 58;
					offset.y = 176;
				break;
				case 1:
					width = 53;
					height = 18;
					offset.x = 51;
					offset.y = 192;
				break;
				case 2:
					width = 47;
					height = 22;
					offset.x = 54;
					offset.y = 161;
				break;
			}
			fruitTimer = Math.random() * 10 + 5;
        }
		
        override public function update():void
        {			
            super.update();
			if (fruitTimer > 0)
				fruitTimer -= FlxG.elapsed;
        }
		
		public function wantsFruit():Boolean
		{
			return fruitTimer <= 0;
			
		}
		
		public function getFruit():Fruit
		{
			fruitTimer = Math.random() * 10 + 5;
			
			var spriteX : Number = x - offset.x;
			var spriteY : Number = y - offset.y;
			// originalPos
			var oX : Number = spriteX + (Math.random() * 0.5 + 0.25) * imgWidth;
			var oY : Number = spriteY + (Math.random() * 0.25 + 0.25) * imgHeight;
			// feetPos
			var feetX : Number = x + width / 2;
			var feetY : Number = y + height / 2;
			
			var fruit:Fruit = new Fruit(oX, oY, _playstate);
			fruit.launch( oX, oY, feetX, feetY );
			
			return fruit;
		}
    }
    
} 