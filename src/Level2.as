
package 
{
	import flash.geom.Point;
    import org.flixel.*;

    public class Level2 extends PlayState
    {
        [Embed(source = 'maps/level1.txt', mimeType = "application/octet-stream")] protected var _LevelMap:Class;
		[Embed(source = 'img/level_01.png')] protected var _Background:Class;
        [Embed(source = 'img/Level2_goal.png')] protected var _Level2_GoalPNG:Class;
		
        
        override public function Level2():void
        {
            super();
			LevelMap = _LevelMap;	
			BackgroundImg = _Background;
			_transparent_tile = "17";
			
			_playerStartPos = new Point( 300, 580 );
			super.Init();
			
			var _loc_flxSprite:FlxSprite;
			addSprite( new Pig(720, 500, this), _pigs );
			
			addSprite( new Stone(312, 349), _stones );
			
			addSprite( new Stone(350, 300), _stones );
			
			addSprite( new Stone(800, 235), _stones );
			addSprite( new Stone(880, 270), _stones );
			
			addSprite( new Stone(759, 712), _stones );
			
			addSprite( new Tree(683, 222, this), _trees );
			//addSprite( new Tree(590, 245, this), _trees );
			addSprite( new Tree(561, 282, this), _trees );
			
			addSprite( new Tree(985, 361, this), _trees );
			//addSprite( new Tree(900, 550, this), _trees );
			addSprite( new Tree(950, 550, this), _trees );
			
			//addSprite( new Tree(590, 670, this), _trees );
			
			addSprite( new Rat(520, 320, this), _rats );
			addSprite( new Rat(420, 255, this), _rats );
			addSprite( new Rat(720, 301, this), _rats );
			addSprite( new Human(871, 692, this), _humans );
			
			
			displayGoal( _Level2_GoalPNG );
		}
	    
		override public function isVictoryAchieved() : Boolean
		{
			return ( _dodos.length > 1 );
		}
		
		override public function nextLevel() : Class
		{
			// should return class of the next level, E.G. "Level2" or "MainMenu"
			return Level3;
		}
    }    
} 