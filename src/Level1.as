
package 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
    import org.flixel.*;

    public class Level1 extends PlayState
    {
		[Embed(source = 'maps/level1x2.txt', mimeType = "application/octet-stream")] protected var _LevelMap:Class;
		[Embed(source = 'img/level_01x2.png')] protected var _Background:Class;
        [Embed(source = 'img/Level1_goal.png')] protected var _Level1_GoalPNG:Class;
		[Embed(source = "img/tree_01_small.png")] private var ImgTree01:Class;
		
        
        override public function Level1():void
        {
            super();
			LevelMap = _LevelMap;	
			BackgroundImg = _Background;
			
			_backgroundRect = new Rectangle(0,0,1600,1200);
			_transparent_tile = "17";
			
			_playerStartPos = new Point( 400, 580 );
			super.Init();
			
			var _loc_flxSprite:FlxSprite;
			addSprite( new Pig(520, 240, this), _pigs );
			addSprite( new Pig(1200, 450, this), _pigs );
			addSprite( new Pig(700, 820, this), _pigs );
			addSprite( new Stone(1100, 709), _stones );
			
			addSprite( new Stone(424, 400), _stones );
			addSprite( new Stone(800, 385), _stones );
			addSprite( new Stone(880, 450), _stones );
			addSprite( new Stone(909, 762), _stones );
			
			addSprite( new Tree(590, 215, this), _trees );
			addSprite( new Tree(1100, 520, this), _trees );
			addSprite( new Tree(690, 720, this), _trees );
			
			// Player must plant 3 trees
			hudDisplay.setGoal( _trees, 3, ImgTree01, false );
		}
	    
		override public function isVictoryAchieved() : Boolean
		{
			return ( hudDisplay.isVictoryAchieved() );
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