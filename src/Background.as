package  
{
    import org.flixel.*;

    public class Background extends FlxSprite
    {
        public function Background(img:Class):void
        {
            super(0,0);
			
	       loadGraphic(img, false, false, 1280, 960);
 
        }
            
    }
    
} 