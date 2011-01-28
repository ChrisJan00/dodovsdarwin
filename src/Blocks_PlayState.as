
package 
{
    import org.flixel.*;

    public class Blocks_PlayState extends PlayState
    {
        
        [Embed(source = 'maps/map_blocks.txt', mimeType = "application/octet-stream")] protected var _LevelMap:Class;
		
        
        override public function Blocks_PlayState():void
        {
            super();
			LevelMap = _LevelMap;			
			super.Init();
		}
        
    }    
} 