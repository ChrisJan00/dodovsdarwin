package  
{
    import org.flixel.*;

    public class WalkingDodo extends FlxSprite
    {
        [Embed(source = "img/dodo_walk.png")] private var ImgPlayer:Class;
		
       public function  WalkingDodo(X:Number,Y:Number):void
        {
            super(X, Y);
			
            loadGraphic(ImgPlayer, true, true, 80, 70);
			
            addAnimation("normal", [0, 1, 2, 3], 6);
			facing = RIGHT;
        }
		
        override public function update():void
        {
			play("normal");
			super.update();
		}
	
    }
} 

