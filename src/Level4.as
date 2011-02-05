
package 
{
	import flash.geom.Point;
    import org.flixel.*;

    public class Level4 extends PlayState
    {
        [Embed(source = 'maps/level4.txt', mimeType = "application/octet-stream")] protected var _LevelMap:Class;
		[Embed(source = 'img/level_01x3.png')] protected var _Background:Class;
        [Embed(source = 'img/Level2_goal.png')] protected var _Level2_GoalPNG:Class;
		
        
        override public function Level4():void
        {
            super();
			LevelMap = _LevelMap;	
			BackgroundImg = _Background;
			_backgroundRect = new Rectangle(0,0,1920,1440);
			_transparent_tile = "30";
			
			_playerStartPos = new Point( 300, 580 );
			super.Init();
			
			var _loc_flxSprite:FlxSprite;
			addSprite( new Pig(720, 500, this), _pigs );
			
			//addSprite( new Stone(312, 349), _stones );
			
			addSprite( new Pig(450, 300, this), _pigs );
			
			addSprite( new Stone(800, 235), _stones );
			addSprite( new Stone(880, 270), _stones );
			
			addSprite( new Stone(759, 712), _stones );
			
			addSprite( new Tree(683, 222, this), _trees );
			//addSprite( new Tree(590, 245, this), _trees );
			addSprite( new Tree(561, 282, this), _trees );
			
			addSprite( new Tree(985, 361, this), _trees );
			addSprite( new Tree(100, 550, this), _trees );
			addSprite( new Tree(950, 550, this), _trees );
			
			addSprite( new Tree(590, 670, this), _trees );
			
			addSprite( new Rat(520, 620, this), _rats );
			addSprite( new Human(871, 712, this), _humans );
			
			addSprite( new Human(871, 512, this), _humans );
			
			addSprite( new Human(671, 412, this), _humans );
			
			addSprite( new Egg( 200, 600, this, false), _eggs);
			addSprite( new Egg( 220, 630, this, false), _eggs);
			addSprite( new Egg( 190, 620, this, false), _eggs);
			
			
			displayGoal( _Level2_GoalPNG );
		}
	    
		override public function isVictoryAchieved() : Boolean
		{
			return false;
		}
		
		override public function nextLevel() : Class
		{
			// should return class of the next level, E.G. "Level2" or "MainMenu"
			return MainMenu;
		}
		
		override public function resetLevel() : void 
		{
			FlxG.switchState( StoryLevel3 );
		}
    }    
} 