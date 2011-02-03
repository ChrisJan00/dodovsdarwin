package  
{
    import org.flixel.*;

    public class Background extends FlxSprite
    {
        public function Background(img:Class, a_width:Number, a_height:Number):void
        {
            super(0,0);
			
			loadGraphic(img, false, false, a_width, a_height);
        }
            
    }
    
} 