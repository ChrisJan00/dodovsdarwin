
package 
{
    import org.flixel.*;

    public class Moving_PlayState extends PlayState
    {
        
        [Embed(source = 'maps/map_platforms.txt', mimeType = "application/octet-stream")] protected var _LevelMap:Class;
		
        
        override public function Moving_PlayState():void
        {
            super();
			LevelMap = _LevelMap;			
			super.Init();
		}
        
    }    
} 