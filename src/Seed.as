package  
{
	import flash.geom.Point;
    import org.flixel.*;
	import flash.display.Bitmap;

    public class Seed extends FlxSprite
    {
        [Embed(source = "img/egg_01.png")] private var ImgSeed01:Class;
        [Embed(source = "img/egg_02.png")] private var ImgSeed02:Class;
        [Embed(source = "img/egg_03.png")] private var ImgSeed03:Class;
		
		private var projectionVector: Point;
		private var launchVector: Point;
		private var launchSpeed : Point;
		private var launchFeet : Point;
		private var launchDistance : Number;
		private var launchState: Number;
		private var gravity: Number;
		
		private var _playstate:PlayState;
		
        public function Seed(X:Number,Y:Number, p:PlayState):void
        {
			super(X, Y);
			
			_playstate = p;
			
			var index:Number = Math.floor(Math.random() * 3);
			var ImgData:Bitmap;
			var Img:Class
			
			switch(index) {
				case 0: 
					ImgData = new ImgSeed01();
					Img = ImgSeed01;
				break;
				case 1:
					ImgData = new ImgSeed02();
					Img = ImgSeed02;
				break;
				case 2:
					ImgData = new ImgSeed03();
					Img = ImgSeed03;
				break;
			}
			
			width = (ImgData as Bitmap).width;
			height = (ImgData as Bitmap).height;
			
			fixed = true;
			loadGraphic(Img);
			
			launchState = 0;
			gravity = 200; // pixels per second
     
        }
        override public function update():void
        {			
            super.update();
			
			// falling
			if (launchState == 1 || launchState == 2) {
				// update projection
				launchSpeed.y = launchSpeed.y + gravity * FlxG.elapsed;
				launchVector.x = launchVector.x + launchSpeed.x * FlxG.elapsed;
				launchVector.y = launchVector.y + launchSpeed.y * FlxG.elapsed;
				if (launchVector.y > 0) {
					if (launchState == 1)
						launchState = 2;
					else if (launchState == 2)
					{
						launchState = 0;
						if ( _playstate._block_map.overlaps( this ) ) {
							_playstate.removeEntity( this, _playstate._seeds );
							return;
						}
					}
					launchVector.y = -launchVector.y;
					launchSpeed.y = -launchSpeed.y / 2;
				}
				
				// project result
				x = launchVector.x * projectionVector.x / launchDistance + launchFeet.x;
				y = launchVector.x * projectionVector.y / launchDistance + launchVector.y + launchFeet.y;
			}
        }
		
		public function launch(originalX:Number, originalY:Number, feetX: Number, feetY: Number) : void
		{
			launchDistance = Math.random() * 200 + 30;
			var launchAngle : Number = Math.random() * Math.PI * 2;
			projectionVector = new Point( launchDistance * Math.cos(launchAngle), launchDistance * Math.sin(launchAngle) );
			launchFeet = new Point( feetX, feetY );
			launchDistance = Math.sqrt( projectionVector.x * projectionVector.x + projectionVector.y + projectionVector.y );
			var launchTime:Number = Math.random() * 2 + 1; // max 3 seconds
			launchSpeed = new Point( launchDistance / launchTime, 0 );
			x = originalX;
			y = originalY;
			launchVector = new Point( 0, originalY - feetY );
			
			launchState = 1;
		}
    }
    
} 