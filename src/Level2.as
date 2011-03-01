
package 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
    import org.flixel.*;

    public class Level2 extends PlayState
    {
		[Embed(source = 'maps/level1x2.txt', mimeType = "application/octet-stream")] protected var _LevelMap:Class;
        //[Embed(source = 'maps/level2.txt', mimeType = "application/octet-stream")] protected var _LevelMap:Class;
		[Embed(source = 'img/level_01x2.jpg')] protected var _Background:Class;
        [Embed(source = 'img/Level2_goal.png')] protected var _Level2_GoalPNG:Class;
		[Embed(source = "img/dodo_small.png")] private var ImgDodo:Class;
		
		
        override public function Level2():void
        {
            super();
			LevelMap = _LevelMap;	
			BackgroundImg = _Background;
			_backgroundRect = new Rectangle(0,0,1600,1200);
			_transparent_tile = "17";
			
			_playerStartPos = new Point( 1180, 800 );
			super.Init();
			
			var _loc_flxSprite:FlxSprite;
			addSprite( new Pig(650, 730, this), _pigs );
			addSprite( new Pig(1050, 460, this), _pigs );
			
			addSprite( new Stone(1155, 680, false), _stones );
			addSprite( new Stone(1025, 740, false), _stones );
			addSprite( new Stone(850, 580, false), _stones );
			addSprite( new Stone(580, 450, false), _stones );
			addSprite( new Stone(730, 400, false), _stones );
			addSprite( new Stone(820, 300, false), _stones );
			
			addSprite( new Tree(520, 720, this), _trees );
			addSprite( new Tree(1140, 430, this), _trees );
			
			addSprite( new Rat(1040, 290, this), _rats );
			addSprite( new Rat(600, 270, this), _rats );
			addSprite( new Rat(420, 740, this), _rats );
			addSprite( new Rat(700, 890, this), _rats );
			
			
			hudDisplay.setGoalMatingProgress( _dodoAdults, ImgDodo );
		}
	    
		override public function isVictoryAchieved() : Boolean
		{
			return ( _player.matingProgress > 0 );
		}
		
		override public function nextLevel() : Class
		{
			// should return class of the next level, E.G. "Level2" or "MainMenu"
			return StoryLevel3;
		}
		
		override public function resetLevel() : void 
		{
			FlxG.switchState( StoryLevel2 );
		}
    }    
} 