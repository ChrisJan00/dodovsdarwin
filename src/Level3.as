
package 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
    import org.flixel.*;

    public class Level3 extends PlayState
    {
		[Embed(source = 'maps/level1x2.txt', mimeType = "application/octet-stream")] protected var _LevelMap:Class;
        //[Embed(source = 'maps/level3.txt', mimeType = "application/octet-stream")] protected var _LevelMap:Class;
		[Embed(source = 'img/level_01x2.jpg')] protected var _Background:Class;
        [Embed(source = 'img/Level2_goal.png')] protected var _Level2_GoalPNG:Class;
		[Embed(source = "img/dodo_child_small.png")] private var ImgChild:Class;
		
        
        override public function Level3():void
        {
            super();
			LevelMap = _LevelMap;	
			BackgroundImg = _Background;
			_backgroundRect = new Rectangle(0,0,1600,1200);
			_transparent_tile = "17";
			//_backgroundRect = new Rectangle(44,150,1680,1280);
			//_transparent_tile = "4";
			
			_playerStartPos = new Point( 780, 200 );
			super.Init();
			
			var _loc_flxSprite:FlxSprite;
			addSprite(new Pig(525, 750, this), _pigs );
			addSprite(new Pig(950, 925, this), _pigs );
			
			addSprite(new Nest(330, 720), _nests);
			addSprite(new Nest(1260, 340), _nests);
			
			addSprite( new Stone(590, 310, true), _stones );
			addSprite( new Stone(690, 390, false), _stones );
			addSprite( new Stone(1060, 340, false), _stones );
			addSprite( new Stone(1000, 460, true), _stones );
			addSprite( new Stone(920, 570, false), _stones );
			addSprite( new Stone(960, 680, true), _stones );
			
			addSprite( new Tree(450, 670, this), _trees );
			addSprite( new Tree(630, 960, this), _trees );
			addSprite( new Tree(1080, 820, this), _trees );
			
			addSprite( new Rat(780, 510, this), _rats );
			addSprite( new Rat(1230, 765, this), _rats );
			
			addSprite( new Human(480, 430, this), _humans );
			addSprite( new Human(830, 815, this), _humans );
			addSprite( new Human(1200, 580, this), _humans );
			
			//addSprite( new Egg( 1200, 600, this, false), _eggs);
			//addSprite( new Egg( 1220, 630, this, false), _eggs);
			//addSprite( new Egg( 1190, 620, this, false), _eggs);
			
			// second child is born
			hudDisplay.setGoal( _dodoChildren, 2, ImgChild, false);
		}
	    
		override public function isVictoryAchieved() : Boolean
		{
			return ( hudDisplay.isVictoryAchieved() );
		}
		
		override public function nextLevel() : Class
		{
			// should return class of the next level, E.G. "Level2" or "MainMenu"
			return StoryLevel4;
		}
		
		override public function resetLevel() : void 
		{
			FlxG.switchState( StoryLevel3 );
		}
    }    
} 