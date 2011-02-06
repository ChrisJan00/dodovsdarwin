
package 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
    import org.flixel.*;

    public class LevelTest extends PlayState
    {
        [Embed(source = 'maps/level4.txt', mimeType = "application/octet-stream")] protected var _LevelMap:Class;
		[Embed(source = 'img/level_01x3.jpg')] protected var _Background:Class;
        [Embed(source = 'img/Level2_goal.png')] protected var _Level2_GoalPNG:Class;
		
        
        override public function LevelTest():void
        {
            super();
			LevelMap = _LevelMap;	
			BackgroundImg = _Background;		
			_backgroundRect = new Rectangle(0,0,1920,1440);
			_transparent_tile = "30";
			mapTileSize = 8;
			
			_playerStartPos = new Point( 610, 274 );
			super.Init();
			
			var _loc_flxSprite:FlxSprite;
			addSprite( new Pig(1620, 420, this), _pigs );
			
			addSprite( new Stone(800, 250), _stones );
			addSprite( new Stone(900, 350), _stones );
			addSprite( new Stone(1000, 450), _stones );
			addSprite( new Stone(1100, 550), _stones );
			addSprite( new Stone(1200, 650), _stones );
			addSprite( new Stone(1300, 750), _stones );
			addSprite( new Stone(1400, 850), _stones );
			addSprite( new Stone(1500, 950), _stones );
			addSprite( new Stone(1600, 1050), _stones );
			addSprite( new Stone(1700, 1150), _stones );
			addSprite( new Stone(1800, 1250), _stones );
			addSprite( new Stone(1900, 1350), _stones );
			
			//addSprite( new Stone(1350, 300), _stones );
			//addSprite( new Stone(1800, 235), _stones );
			//addSprite( new Stone(1880, 270), _stones );
			//addSprite( new Stone(1759, 712), _stones );
			
			//addSprite( new Tree(900, 200, this), _trees );
			addSprite( new Tree(900, 300, this), _trees );
			//addSprite( new Tree(900, 400, this), _trees );
			addSprite( new Tree(900, 500, this), _trees );
			//addSprite( new Tree(900, 600, this), _trees );
			addSprite( new Tree(900, 700, this), _trees );
			//addSprite( new Tree(900, 800, this), _trees );
			addSprite( new Tree(900, 900, this), _trees );
			//addSprite( new Tree(900, 1000, this), _trees );
			addSprite( new Tree(900, 1100, this), _trees );
			//addSprite( new Tree(900, 1200, this), _trees );
			addSprite( new Tree(900, 1300, this), _trees );
			//addSprite( new Tree(1300, 200, this), _trees );
			addSprite( new Tree(1300, 300, this), _trees );
			//addSprite( new Tree(1300, 400, this), _trees );
			addSprite( new Tree(1300, 500, this), _trees );
			//addSprite( new Tree(1300, 600, this), _trees );
			addSprite( new Tree(1300, 700, this), _trees );
			//addSprite( new Tree(1300, 800, this), _trees );
			addSprite( new Tree(1300, 900, this), _trees );
			//addSprite( new Tree(1300, 1000, this), _trees );
			addSprite( new Tree(1300, 1100, this), _trees );
			//addSprite( new Tree(1300, 1200, this), _trees );
			addSprite( new Tree(1300, 1300, this), _trees );
			
			addSprite( new Fruit( 620, 350, this), _fruits );
			addSprite( new Fruit( 620, 400, this), _fruits );
			addSprite( new Fruit( 620, 450, this), _fruits );
			addSprite( new Fruit( 620, 500, this), _fruits );
			
			spawnDodo(620, 800);
			
			//addSprite( new Tree(1590, 245, this), _trees );
			//addSprite( new Tree(1561, 282, this), _trees );
			//addSprite( new Tree(1985, 361, this), _trees );
			//addSprite( new Tree(1900, 550, this), _trees );
			//addSprite( new Tree(1950, 550, this), _trees );
			//addSprite( new Tree(1590, 670, this), _trees );
			
			//spawnDodo(1600, 600);
			//
			//addSprite( new Rat(1200, 500, this), _rats );
			//addSprite( new Rat(1200, 500, this), _rats );
			//addSprite( new Rat(1200, 500, this), _rats );
			//addSprite( new Rat(1200, 500, this), _rats );
			//addSprite( new Rat(1200, 500, this), _rats );
			//addSprite( new Rat(1200, 500, this), _rats );
			//addSprite( new Rat(1200, 500, this), _rats );
			//addSprite( new Rat(1200, 500, this), _rats );
			//addSprite( new Rat(1200, 500, this), _rats );
			//addSprite( new Rat(1200, 500, this), _rats );
			//addSprite( new Rat(1200, 500, this), _rats );
			//addSprite( new Rat(1200, 500, this), _rats );
			
			//addSprite( new Rat(520, 320, this), _rats );
			//addSprite( new Rat(420, 255, this), _rats );
			//addSprite( new Rat(720, 301, this), _rats );
			
			//addSprite( new Human(900, 900, this), _humans );
			//addSprite( new Human(900, 900, this), _humans );
			//addSprite( new Human(900, 900, this), _humans );
			//addSprite( new Human(900, 900, this), _humans );
			//addSprite( new Human(900, 900, this), _humans );
			//addSprite( new Human(900, 900, this), _humans );
			//addSprite( new Human(900, 900, this), _humans );
			//addSprite( new Human(900, 900, this), _humans );
			//addSprite( new Human(900, 900, this), _humans );
			//addSprite( new Human(900, 900, this), _humans );
			//addSprite( new Human(900, 900, this), _humans );
			//addSprite( new Human(900, 900, this), _humans );
			
			//addSprite( new Human(871, 692, this), _humans );
			//addSprite( new Human(871, 692, this), _humans );
			//addSprite( new Human(871, 692, this), _humans );
			
			//_player.isPregnant = true;
			//_player.matingProgress = 1;
			//_player.eatenFruitCount = _player.SHIT_THRESHOLD - 1;
			
			displayGoal( _Level2_GoalPNG );
		}
	    
		override public function isVictoryAchieved() : Boolean
		{
			return (false);
		}
		
		override public function nextLevel() : Class
		{
			// should return class of the next level, E.G. "Level2" or "MainMenu"
			return Level1;
		}
    }    
} 