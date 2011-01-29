
package 
{
    import org.flixel.*;

    public class Blocks_PlayState extends PlayState
    {
        
        [Embed(source = 'maps/level1.txt', mimeType = "application/octet-stream")] protected var _LevelMap:Class;
		[Embed(source = 'img/level_01.png')] protected var _Background:Class;
		
		
		
        
        override public function Blocks_PlayState():void
        {
            super();
			LevelMap = _LevelMap;	
			BackgroundImg = _Background;
			_transp_tile = "17";
			super.Init();
			
			var _loc_flxSprite:FlxSprite
			_loc_flxSprite = new Rat(360, 200, this);
			_rats.push(_loc_flxSprite);
            lyrSprites.add(_loc_flxSprite);
			_loc_flxSprite = new Rat(460, 600, this);
			_rats.push(_loc_flxSprite);
            lyrSprites.add(_loc_flxSprite);
			_loc_flxSprite = new Human(600, 320, this);
			_humans.push(_loc_flxSprite);
            lyrSprites.add(_loc_flxSprite);
		}
        
    }    
} 