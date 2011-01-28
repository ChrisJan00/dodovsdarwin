
package 
{
    import org.flixel.*;

    public class Fake_PlayState extends PlayState
    {
        
        [Embed(source = 'maps/map_fake.txt', mimeType = "application/octet-stream")] protected var _LevelMap:Class;
		
        
        override public function Fake_PlayState():void
        {
            super();
			LevelMap = _LevelMap;			
			super.Init();
		}
        
    }    
} 