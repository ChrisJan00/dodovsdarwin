
package 
{
	import flash.geom.Point;
    import org.flixel.*;

    public class Level1 extends PlayState
    {
        
        [Embed(source = 'maps/level1.txt', mimeType = "application/octet-stream")] protected var _LevelMap:Class;
		[Embed(source = 'img/level_01.png')] protected var _Background:Class;
		
		
        
        override public function Level1():void
        {
            super();
			LevelMap = _LevelMap;	
			BackgroundImg = _Background;
			_transparent_tile = "17";
			
			_playerStartPos = new Point( 500, 440 );
			super.Init();
			
			var _loc_flxSprite:FlxSprite;
			//addSprite( new Pig(670, 250, this), _pigs );
			//addSprite( new Rat(360, 200, this), _rats );
			//addSprite( new Rat(400, 600, this), _rats );
			//addSprite( new Rat(890, 500, this), _rats );
			//addSprite( new Human(600, 370, this), _humans );
			//addSprite( new Human(800, 700, this), _humans );
			//addSprite( new Stone(640, 480), _stones );
			//addSprite( new Stone(440, 580), _stones );
			addSprite( new Tree(740, 320, this), _trees );
			addSprite( new Tree(640, 320, this), _trees );
			addSprite( new Dodo(640, 320, this), _dodos );
		}
	    
		override public function isVictoryAchieved() : Boolean
		{
			//return _player.eatenFruitCount > 1;
			return( false) ;
		}
		
		override public function nextLevel() : Class
		{
			// should return class of the next level, E.G. "Level1" or "MainMenu"
			return Level2;
		}
    }    
} 