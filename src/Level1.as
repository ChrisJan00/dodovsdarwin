
package 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
    import org.flixel.*;

    public class Level1 extends PlayState
    {
        
        [Embed(source = 'maps/level1.txt', mimeType = "application/octet-stream")] protected var _LevelMap:Class;
		[Embed(source = 'img/level_01x3.png')] protected var _Background:Class;
        [Embed(source = 'img/Level1_goal.png')] protected var _Level1_GoalPNG:Class;
		[Embed(source = "img/tree_01_small.png")] private var ImgTree01:Class;
		
        
        override public function Level1():void
        {
            super();
			LevelMap = _LevelMap;	
			BackgroundImg = _Background;
			_backgroundRect = new Rectangle(120, 425, 1280, 960);
			_transparent_tile = "5";
			
			
			_playerStartPos = new Point( 300, 500 );
			super.Init();
			
			var _loc_flxSprite:FlxSprite;
			addSprite( new Pig(520, 240, this), _pigs );
			addSprite( new Pig(720, 450, this), _pigs );
			//addSprite( new Rat(360, 200, this), _rats );
			//addSprite( new Rat(400, 600, this), _rats );
			//addSprite( new Rat(890, 500, this), _rats );
			//addSprite( new Human(600, 370, this), _humans );
			//addSprite( new Human(800, 700, this), _humans );
			addSprite( new Stone(312, 309), _stones );
			
			addSprite( new Stone(350, 250), _stones );
			//addSprite( new Stone(598, 260), _stones );
			
			addSprite( new Stone(800, 185), _stones );
			addSprite( new Stone(880, 220), _stones );
			
			addSprite( new Stone(759, 712), _stones );
			
			addSprite( new Tree(590, 215, this), _trees );
			addSprite( new Tree(900, 520, this), _trees );
			addSprite( new Tree(590, 620, this), _trees );
			//addSprite( new Tree(300, 630, this), _trees );
			//addSprite( new Tree(880, 630, this), _trees );
			//addSprite( new Dodo(640, 320, this), _dodos );
			
			//displayGoal( _Level1_GoalPNG );
			// TODO Add this when each level has a win image
			//setWinDisplay( _Level1_GoalPNG );
			
			hudDisplay.setGoalDisplay( _trees, 5, ImgTree01 );
		}
	    
		override public function isVictoryAchieved() : Boolean
		{
			return ( _trees.length >= 5 );
		}
		
		override public function nextLevel() : Class
		{
			// should return class of the next level, E.G. "Level1" or "MainMenu"
			return StoryLevel2;
		}
		
		override public function resetLevel() : void 
		{
			FlxG.switchState( StoryLevel1 );
		}
    }    
} 