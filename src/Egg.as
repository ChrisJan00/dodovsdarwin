package  
{
	import flash.geom.Point;
    import org.flixel.*;
	import flash.display.Bitmap;

    public class Egg extends FlxSprite
    {
        [Embed(source = "img/egg_01_hatch_anim.png")] private var ImgEgg01:Class;
        [Embed(source = "img/egg_02_hatch_anim.png")] private var ImgEgg02:Class;
        //[Embed(source = "img/egg_03.png")] private var ImgEgg03:Class;
        //[Embed(source = "img/egg_04.png")] private var ImgEgg04:Class;
		
		private var projectionVector: Point;
		private var launchVector: Point;
		private var launchSpeed : Point;
		private var launchFeet : Point;
		private var launchDistance : Number;
		private var launchState: Number = 0;
		private var gravity: Number;
		private var hatchTimer:Number = 15;
		private const birthTime:Number = 1.2;
		
		private var _playstate:PlayState;
		
        public function Egg(X:Number,Y:Number, p:PlayState):void
        {
			super(X, Y);
			
			_playstate = p;
			
			var index:Number = Math.floor(Math.random() * 2);
			var ImgData:Bitmap;
			var Img:Class
			
			switch(index) {
				case 0: 
					Img = ImgEgg01;
				break;
				case 1:
					Img = ImgEgg02;
				break;
			}
			
			//width = (ImgData as Bitmap).width;
			//height = (ImgData as Bitmap).height;
			width = 20
			height = 40
			offset.x = 10
			offset.y = 40
			
			fixed = true;
			loadGraphic(Img, true, false, 40, 80);
			addAnimation("normal", [0], 5);
			addAnimation("hatch", [0, 1, 2, 3, 4, 5], 10);
			addAnimation("birth", [6, 7, 8, 9, 10, 11], 5);
			
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
						launchState = 3;
						if ( _playstate._block_map.overlaps( this ) ) {
							_playstate.removeEntity( this, _playstate._eggs );
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
			
			// germination
			if (launchState == 3) {
				if (hatchTimer > 0)
					hatchTimer -= FlxG.elapsed;
					if (hatchTimer > birthTime * 2)
						play("normal");
					else if (hatchTimer > birthTime)
						play("hatch");
					else
						play("birth");
				if (hatchTimer <= 0) {
					// grow tree
					_playstate.spawnDodo( x, y );
					launchState = 4;
					_playstate.removeEntity( this, _playstate._eggs );
				}
			} else {
				play("normal");
			}
        }
		
		public function launch(originalX:Number, originalY:Number, feetX: Number, feetY: Number, dirX : Number, dirY : Number) : void
		{
			launchDistance = Math.random() * 60 + 60;
			//var launchAngle : Number = Math.random() * Math.PI * 2;
			projectionVector = new Point( launchDistance * dirX, launchDistance * dirY );
			launchFeet = new Point( feetX, feetY );
			var launchTime:Number = Math.random() * 2 + 1; // max 3 seconds
			launchSpeed = new Point( launchDistance / launchTime, 0 );
			x = originalX;
			y = originalY;
			launchVector = new Point( 0, originalY - feetY );
			
			launchState = 1;
		}
    }
    
} 