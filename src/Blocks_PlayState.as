
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
			addSprite( new Rat(360, 200, this), _rats );
			addSprite( new Rat(460, 600, this), _rats );
			addSprite( new Human(600, 320, this), _humans );
			addSprite( new Stone(640, 480), _stones );
			addSprite( new Stone(440, 580), _stones );
			addSprite( new Tree(640, 280, this), _trees );
		}
	    
    }    
} 