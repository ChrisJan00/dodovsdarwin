
package 
{
    import org.flixel.*;

    public class Falling_PlayState extends PlayState
    {
        
        [Embed(source = 'maps/map_fallingspikes.txt', mimeType = "application/octet-stream")] protected var _LevelMap:Class;
		
        
        override public function Falling_PlayState():void
        {
            super();
			LevelMap = _LevelMap;			
			super.Init();
		}
        
    }    
} 