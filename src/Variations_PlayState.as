
package 
{
    import org.flixel.*;

    public class Variations_PlayState extends PlayState
    {
    
        [Embed(source = 'maps/map_variations.txt', mimeType = "application/octet-stream")] protected var _LevelMap:Class;
	
        
        override public function Variations_PlayState():void
        {
            super();
			LevelMap = _LevelMap;
			
			super.Init();
		}
        
    }    
} 