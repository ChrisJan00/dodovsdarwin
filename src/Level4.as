
package 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
    import org.flixel.*;

    public class Level4 extends PlayState
    {
        [Embed(source = 'maps/level1x2.txt', mimeType = "application/octet-stream")] protected var _LevelMap:Class;
		[Embed(source = 'img/level_01x2.png')] protected var _Background:Class;
        [Embed(source = 'img/Level2_goal.png')] protected var _Level2_GoalPNG:Class;
		[Embed(source = "img/dodo_small.png")] private var ImgDodo:Class;
		
        
        override public function Level4():void
        {
            super();
			LevelMap = _LevelMap;	
			BackgroundImg = _Background;
			_backgroundRect = new Rectangle(0,0,1920,1440);
			_transparent_tile = "17";
			
			
			_playerStartPos = new Point( 790, 550 );
			//_playerStartPos = new Point( 300, 580 );
			super.Init();
			
			var _loc_flxSprite:FlxSprite;
			addSprite( new Pig(920, 970, this), _pigs );
			addSprite( new Pig(1030, 280, this), _pigs );
			
			addSprite( new Stone(474, 624, true), _stones );
			addSprite( new Stone(564, 742, false), _stones );
			addSprite( new Stone(922, 860, false), _stones );
			addSprite( new Stone(1184, 512, true), _stones );
			addSprite( new Stone(1112, 400, false), _stones );
			addSprite( new Stone(700, 292, false), _stones );
			
			addSprite( new Tree(660, 540, this), _trees );
			addSprite( new Tree(870, 440, this), _trees );
			addSprite( new Tree(920, 620, this), _trees );
			addSprite( new Tree(988, 774, this), _trees );
			
			addSprite( new Human(380, 460, this), _humans );
			addSprite( new Human(610, 996, this), _humans );
			addSprite( new Human(1246, 880, this), _humans );
			addSprite( new Human(1308, 356, this), _humans );
			
			addSprite( new Rat(726, 170, this), _rats );
			addSprite( new Rat(318, 764, this), _rats );
			
			addSprite( new Nest( 800, 644 ), _nests);
			
			//addSprite( new Egg( 200, 600, this, false), _eggs);
			//addSprite( new Egg( 220, 630, this, false), _eggs);
			//addSprite( new Egg( 190, 620, this, false), _eggs);
			
			
			hudDisplay.setGoal( _dodoAdults, 2, ImgDodo, false, true );
		}
	    
		override public function isVictoryAchieved() : Boolean
		{
			return ( hudDisplay.isVictoryAchieved() );
			
			/*
			// at least two adult children
			if (_dodoAdults.length > 2) {
				var adultChildrenCount:Number = 0;
				for each (var adultDodo:FlxSprite in _dodoAdults) {
					if (adultDodo != _player && (adultDodo as Dodo).family == _player.family) 
						adultChildrenCount++;
				}
				if (adultChildrenCount > 2)
					return true;
			}
			return false;
			/**/
		}
		
		
		override public function nextLevel() : Class
		{
			// should return class of the next level, E.G. "Level2" or "MainMenu"
			return StoryLevelEnd;
		}
		
		override public function resetLevel() : void 
		{
			FlxG.switchState( StoryLevel4 );
		}
    }    
} 