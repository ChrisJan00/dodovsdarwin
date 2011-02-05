
package 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
    import org.flixel.*;

    public class Level3 extends PlayState
    {
        [Embed(source = 'maps/level3.txt', mimeType = "application/octet-stream")] protected var _LevelMap:Class;
		[Embed(source = 'img/level_01x3.png')] protected var _Background:Class;
        [Embed(source = 'img/Level2_goal.png')] protected var _Level2_GoalPNG:Class;
		
        
        override public function Level3():void
        {
            super();
			LevelMap = _LevelMap;	
			BackgroundImg = _Background;
			_backgroundRect = new Rectangle(44,150,1680,1280);
			_transparent_tile = "4";
			
			_playerStartPos = new Point( 400, 580 );
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
			addSprite( new Tree(1100, 550, this), _trees );
			addSprite( new Tree(950, 550, this), _trees );
			
			addSprite( new Tree(590, 670, this), _trees );
			
			addSprite( new Rat(520, 620, this), _rats );
			addSprite( new Human(871, 712, this), _humans );
			
			addSprite( new Human(871, 512, this), _humans );
			
			addSprite( new Human(671, 412, this), _humans );
			
			addSprite( new Egg( 1200, 600, this, false), _eggs);
			addSprite( new Egg( 1220, 630, this, false), _eggs);
			addSprite( new Egg( 1190, 620, this, false), _eggs);
			
			
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