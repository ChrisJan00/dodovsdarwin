
package 
{
    import org.flixel.*;

    public class Blocks_PlayState extends PlayState
    {
        
        [Embed(source = 'maps/level1.txt', mimeType = "application/octet-stream")] protected var _LevelMap:Class;
		[Embed(source = 'img/background.png')] protected var _Background:Class;
		
		
		
        
        override public function Blocks_PlayState():void
        {
            super();
			LevelMap = _LevelMap;	
			BackgroundImg = _Background;
			_transp_tile = "15";
			super.Init();
			
			var _loc_rat:Rat = new Rat(60, 200, this);
			_rats.push(_loc_rat);
            lyrSprites.add(_loc_rat);
		}
        
    }    
} 