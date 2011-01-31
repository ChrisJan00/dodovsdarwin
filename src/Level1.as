
package 
{
	import flash.geom.Point;
    import org.flixel.*;

    public class Level1 extends PlayState
    {
        
        [Embed(source = 'maps/level1.txt', mimeType = "application/octet-stream")] protected var _LevelMap:Class;
		[Embed(source = 'img/level_01.png')] protected var _Background:Class;
        [Embed(source = 'img/Level1_goal.png')] protected var _Level1_GoalPNG:Class;
		
		
        
        override public function Level1():void
        {
            super();
			LevelMap = _LevelMap;	
			BackgroundImg = _Background;
			_transparent_tile = "17";
			
			_playerStartPos = new Point( 300, 580 );
			super.Init();
			
			var _loc_flxSprite:FlxSprite;
			addSprite( new Pig(520, 290, this), _pigs );
			addSprite( new Pig(720, 500, this), _pigs );
			//addSprite( new Rat(360, 200, this), _rats );
			//addSprite( new Rat(400, 600, this), _rats );
			//addSprite( new Rat(890, 500, this), _rats );
			//addSprite( new Human(600, 370, this), _humans );
			//addSprite( new Human(800, 700, this), _humans );
			addSprite( new Stone(312, 349), _stones );
			
			addSprite( new Stone(350, 300), _stones );
			//addSprite( new Stone(598, 260), _stones );
			
			addSprite( new Stone(800, 235), _stones );
			addSprite( new Stone(880, 270), _stones );
			
			addSprite( new Stone(759, 712), _stones );
			
			addSprite( new Tree(590, 245, this), _trees );
			addSprite( new Tree(900, 550, this), _trees );
			addSprite( new Tree(590, 670, this), _trees );
			//addSprite( new Tree(300, 630, this), _trees );
			//addSprite( new Tree(880, 630, this), _trees );
			//addSprite( new Dodo(640, 320, this), _dodos );
			
			displayGoal( _Level1_GoalPNG );
		}
	    
		override public function isVictoryAchieved() : Boolean
		{
			return ( _trees.length > 3 );
		}
		
		override public function nextLevel() : Class
		{
			// should return class of the next level, E.G. "Level1" or "MainMenu"
			return Level2;
		}
    }    
} 