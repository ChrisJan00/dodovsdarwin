
package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	import flash.geom.Point;
	import flash.geom.Vector3D;
    import org.flixel.*;

    public class PlayState extends FlxState
    {
		[Embed(source = "img/fruit_01.png")] private var ImgFruit01:Class;
		//[Embed(source = "snd/endlevel.mp3")] private var EndLevelSound:Class;
		
		[Embed(source = "snd/dodo4.mp3")] private var BackgroundMusic:Class;
		
		protected var LevelMap:Class;
		protected var BlockMap:String;
		
		protected var BackgroundImg:Class;
		
        public var _player:Player;
        public var _block_map:FlxTilemap;
		private var _background:Background;
		protected var _backgroundRect:Rectangle;
		
		protected var _playerStartPos:Point;
		
	    public static var lyrStage:FlxLayer;
        public static var lyrSprites:FlxLayer;
        public static var lyrHUD:FlxLayer;
		
		protected var _transparent_tile:String
		public var _rats:Array;
		public var _players:Array;
		public var _dodos:Array;
		public var _dodoAdults:Array;
		public var _dodoChildren:Array;
		public var _humans:Array;
		public var _stones:Array;
		public var _trees:Array;
		public var _fruits:Array;
		public var _seeds:Array;
		public var _pigs:Array;
		public var _eggs:Array;
		
		private var _poopDisplay:PoopDisplay;
		private var _eggDisplay:EggDisplay;
		
		public var isOkToChopTree:Boolean = false;
		
		private var treeKillerTimer:Number = 0;
		private var dodoArrivingTimer:Number = 0;
		private var endOfLevelTimer:Number = -1;
		public var mapSize:Point;
		
		private const TREE_MIN_CHOPPING:Number = 5;
		private const TREE_MIN_DECAY:Number = 1;
		private const TREES_PER_DODO:Number = 5;
		private const DODO_GENERATION_PAUSE_MIN:Number = 4;
		private const DODO_GENERATION_PAUSE_RANGE:Number = 2;
		
		public var mapTileSize:int = 8;
        
        override public function PlayState():void
        {
            super();
		}
            
		public function Init():void
		{
            lyrStage = new FlxLayer;
            lyrSprites = new FlxLayer;
            lyrHUD = new FlxLayer;
           
			_rats = new Array();
			_players = new Array();
			_dodos = new Array();
			_dodoAdults = new Array();
			_dodoChildren = new Array();
			_humans = new Array();
			_pigs = new Array();

			_background = new Background(BackgroundImg, _backgroundRect);
			mapSize = new Point(_background.width, _background.height);
			lyrStage.add(_background);
			
			if ( _playerStartPos ) {
				_player = new Player(_playerStartPos.x, _playerStartPos.y, this);
			} else {
				_player = new Player(648, 240, this);
			}
			_players.push( _player );
			_dodos.push( _player );
			_dodoAdults.push( _player );
            lyrSprites.add(_player);
			
			_stones = new Array();
			_trees = new Array();
			_fruits = new Array();
			_seeds = new Array();
			_eggs = new Array();
	
            FlxG.follow(_player,2.5);
            FlxG.followAdjust(0.5, 0.5);
            FlxG.followBounds(1,1,mapSize.x-1,mapSize.y-1);
            
			parseMap(new LevelMap);
			
            _block_map = new FlxTilemap;
			_block_map.loadMap(BlockMap, ImgFruit01, mapTileSize, mapTileSize);
            _block_map.drawIndex = 1;
            _block_map.collideIndex = 1;
			_block_map.visible = false;
			
            lyrStage.add(_block_map);
			
            this.add(lyrStage);
            this.add(lyrSprites);
            this.add(lyrHUD);
			
			_poopDisplay = new PoopDisplay( this );
			_poopDisplay.x = FlxG.width - 60;
			_poopDisplay.y = FlxG.height - 70;
			addChild( _poopDisplay );
			
			_eggDisplay = new EggDisplay( this );
			_eggDisplay.x = 20;
			_eggDisplay.y = FlxG.height - 70;
			addChild( _eggDisplay );
			
			
			//FlxG.play(EndLevelSound);
			//if ( !FlxState.isInDebugMode ) {
				FlxG.play(BackgroundMusic, 1.0, true);
			//}
			
			_dodoGenerationWaitAtStart = DODO_GENERATION_PAUSE_MIN + Math.random() * DODO_GENERATION_PAUSE_RANGE;
        }
		
		public function parseMap(map:String):void
		{
			var last:String;
			BlockMap = new String("");
			
			var col:Number = 0;
			var row:Number = 0;
			
			//var rows:Array = map.split('\n');
			for each (var rows:String in map.split("\n")) {
				// it's actually CRLF, so we have to strip one more character away
				rows = rows.substr(0, rows.length - 1);
				if (rows.length > 0) { 
					col = 0;
					for each (var tiles:String in rows.split(",")) {
						if (tiles == _transparent_tile) // the magick number! probably different in every map :(
							BlockMap += "0,";
						else
							BlockMap += "1,";
						
						col += 1;
					}
					BlockMap = BlockMap.substr(0, BlockMap.length - 1) + "\n";
				}
				row += 1;
			}
		}
		
        override public function update():void
        {
			super.update();
		   
			for each(var dodo:FlxSprite in _dodos) {
				if (dodo != _player && (dodo as IDodo).isFlying())
					continue;
				_block_map.collide(dodo);
				dodo.collideArray(_stones);
				dodo.collideArray(_trees);
			}
			for each(var rat:Rat in _rats) {
				_block_map.collide(rat);
				rat.collideArray(_stones);
				rat.collideArray(_trees);
				for each(var _loc_dodo2:FlxSprite in _dodos) {
					if ( rat.overlaps(_loc_dodo2) && !(_loc_dodo2 as IDodo).isFlying()) {
						rat.attack();
						(_loc_dodo2 as IDodo).takeRatDamage();
					}
				}
			}
			for each(var human:Human in _humans) {
				_block_map.collide(human);
				human.collideArray(_stones);
				human.collideArray(_trees);
				for each(var _loc_rat:Rat in _rats) {
					if ( human.overlaps(_loc_rat) ) {
						human.attack();
						_loc_rat.killedByHuman();
						removeEntityFromArrayOnly(_loc_rat, _rats);
					}
				}
				for each(var _loc_dodo:FlxSprite in _dodos) {
					if ( human.overlaps(_loc_dodo) && !(_loc_dodo as IDodo).isFlying()) {
						human.attack();
						(_loc_dodo as IDodo).takeHumanDamage();
					}
				}
				// Bounding box hacks ftw
				human.x -= 1;
				human.y -= 1;
				human.height += 2;
				human.width += 2;
				for each(var _loc_tree:Tree in _trees) {
					if ( human.overlaps(_loc_tree) && isOkToChopTree ) {
						human.attack();
						_loc_tree.takeHumanDamage();
					}
				}
				human.x += 1;
				human.y += 1;
				human.height -= 2;
				human.width -= 2;
			}
			for each(var pig:Pig in _pigs) {
				_block_map.collide(pig);
				pig.collideArray(_stones);
				pig.collideArray(_trees);
				
				for each(var _loc_fruit:Fruit in _fruits) {
					if ( _loc_fruit.launchState ) {
						continue;
					}
					if ( pig.overlaps(_loc_fruit) ) {
						if (pig.eat())
							removeEntity(_loc_fruit, _fruits);
					}
				}
			}
			
			for each(var tree:Tree in _trees) {
				if (tree.wantsFruit())
					addSprite(tree.getFruit(), _fruits);
			}
			
			for each(var fruit:Fruit in _fruits) {
				if ( fruit.launchState ) {
					continue;
				}
				//if ( _player.overlaps(fruit) ) {
					//_player.eat();
					//removeEntity(fruit, _fruits);
					//continue;
				//}
				fruit.collideArray(_stones);
				fruit.collideArray(_trees);
				for each (var dodoDude:IDodo in _dodos ) {
					if ( dodoDude.overlaps(fruit) ) {
						if (dodoDude.eat())
							removeEntity(fruit, _fruits);
						continue;
					}
				}
			}
			
			for each(var egg:Egg in _eggs) {
				if ( egg.velocity.length == 0 ) {
					continue;
				}
				_block_map.collide(egg);
				egg.collideArray(_stones);
				egg.collideArray(_trees);
			}
			
			for each(var seed:Seed in _seeds) {
				if ( seed.velocity.length == 0 ) {
					continue;
				}
				_block_map.collide(seed);
				seed.collideArray(_stones);
				seed.collideArray(_trees);
			}
			
			if ( _trees.length > TREE_MIN_CHOPPING ) {
				isOkToChopTree = true;
			}
			
			var newTreeKillerTimer:Number = treeKillerTimer;
			if (_trees.length > TREE_MIN_DECAY)
				newTreeKillerTimer = 180 / _trees.length;
			if (newTreeKillerTimer < treeKillerTimer || (newTreeKillerTimer>0 && treeKillerTimer<=0))
				treeKillerTimer = newTreeKillerTimer;
			
			if (treeKillerTimer > 0) {
				treeKillerTimer -= FlxG.elapsed;
				if (treeKillerTimer <= 0) {
					if (_trees.length > 1) {
						_trees[0].markForDeath();
						_trees.shift();
					}
				}
			}
			
			lyrSprites.sortByY();
			_poopDisplay.update();
			_eggDisplay.update();
			
			if (FlxG.keys.justPressed("R")) {
				resetLevel();
			}
			
			// For debugging
			if (FlxG.keys.justPressed("N") && FlxState.isInDebugMode ) {
				FlxG.switchState(nextLevel());
			}
			
			if (FlxG.keys.justPressed("ESC")) {
				FlxG.switchState(MainMenu);
			}
			
			if ( _displayGoalTimer > 0 ) {
				_displayGoalTimer -= FlxG.elapsed;
				if ( _displayGoalTimer <= 0 ) {
					if ( _displayGoalImage ) {
						removeChild( _displayGoalImage );
						_displayGoalImage = null;
					}
				}
			}
			
			generateRats();
			generateDodos();
			
			checkLevelAndChange();
        }
		
		private var _ratGenerationCounter:Number = 0;
		private function generateRats():void {
			_ratGenerationCounter -= FlxG.elapsed;
			if ( _ratGenerationCounter <= 0 && _stones.length > 0 && _humans.length > 0 ) {
				var _loc_probRat:Number = 0.1 + Math.min( 0.9, Math.max( 0, ( _humans.length * 3 ) - _rats.length ) * 0.1 );
				
				if ( Math.random() < _loc_probRat ) {
					var _whichStone:Number = Math.floor( Math.random() * _stones.length );
					addSprite( new Rat( _stones[_whichStone].cX, _stones[_whichStone].cY, this), _rats);
				}
				_ratGenerationCounter = 4 + Math.random() * 2;
			}
		}
		
		private var _dodoGenerationTimer:Number = 0;
		private var _dodoGenerationWaitAtStart:Number = 0;
		private function generateDodos():void {
			_dodoGenerationWaitAtStart -= FlxG.elapsed;
			if ( _dodoGenerationWaitAtStart > 0 ) {
				return;
			}
			var shouldBeDodos:int = Math.floor( Number(_trees.length) / TREES_PER_DODO );
			if ( _dodoGenerationTimer == 0 && getAmountOfMatableDodos() < shouldBeDodos ) {
				_dodoGenerationTimer = DODO_GENERATION_PAUSE_MIN + Math.random() * DODO_GENERATION_PAUSE_RANGE;
			}
			if ( _dodoGenerationTimer > 0 ) {
				_dodoGenerationTimer -= FlxG.elapsed;
				if ( _dodoGenerationTimer <= 0 ) {
					_dodoGenerationTimer = 0;
					var newDodo:Dodo = new Dodo( -100, -100, this);
					newDodo.flyIn();
					addSprite( newDodo, _dodos );
					addToArrayOnly( newDodo, _dodoAdults );
				}
			}
		}
		
		private function getAmountOfMatableDodos():int {
			var counter:int = 0;
			for each (var dodo:IDodo in _dodoAdults) 
			{
				if ( dodo.family != _player.family ) {
					counter++;
				}
			}
			return counter;
		}
		
		public function reload():void
		{
			_player.reload();
		}
		
		public function getClosestPlayerVector( a_target:FlxSprite ):Vector3D {
			return ( getClosestVectorFrom(a_target, _players ) );
		}
		public function getClosestRatVector( a_target:FlxSprite ):Vector3D {
			return ( getClosestVectorFrom(a_target, _rats ) );
		}
		public function getClosestDodoVector( a_target:FlxSprite ):Vector3D {
			return ( getClosestVectorFrom(a_target, _dodos ) );
		}
		public function getClosestDodoChildVector( a_target:FlxSprite ):Vector3D {
			return ( getClosestVectorFrom(a_target, _dodoChildren ) );
		}
		public function getClosestDodoAdultVector( a_target:FlxSprite ):Vector3D {
			return ( getClosestVectorFrom(a_target, _dodoAdults ) );
		}
		public function getClosestHumanVector( a_target:FlxSprite ):Vector3D {
			return ( getClosestVectorFrom(a_target, _humans ) );
		}
		public function getClosestPigVector( a_target:FlxSprite ):Vector3D {
			return ( getClosestVectorFrom(a_target, _pigs ) );
		}
		public function getClosestFruitVector( a_target:FlxSprite ):Vector3D {
			return ( getClosestVectorFrom(a_target, _fruits ) );
		}
		public function getClosestEggVector( a_target:FlxSprite ):Vector3D {
			return ( getClosestVectorFrom(a_target, _eggs ) );
		}
		public function getClosestTreeVector( a_target:FlxSprite ):Vector3D {
			return ( getClosestVectorFrom(a_target, _trees ) );
		}
		
		
		private function getClosestVectorFrom( a_target:FlxSprite, a_flxSprites:Array ):Vector3D {
			if ( a_flxSprites.length == 0 ) return null;
			if ( a_flxSprites.length == 1 && a_flxSprites[0] == a_target ) return null;
			
			var _loc_closestFlxSprite:FlxSprite;
			var _loc_closestDistanceSquare:Number = Number.MAX_VALUE;
			
			for each (var flxSprite:FlxSprite in a_flxSprites) {
				if ( flxSprite == a_target ) {
					continue;
				}
				if ( Math.pow( a_target.cX - flxSprite.cX, 2) + Math.pow( a_target.cY - flxSprite.cY, 2) < _loc_closestDistanceSquare ) {
					_loc_closestFlxSprite = flxSprite;
					_loc_closestDistanceSquare = Math.pow( a_target.cX - flxSprite.cX, 2) + Math.pow( a_target.cY - flxSprite.cY, 2);
				}
			}
			return ( new Vector3D( _loc_closestFlxSprite.cX - a_target.cX, _loc_closestFlxSprite.cY - a_target.cY ) );
		}
		
		public function getClosestFrom( a_target:FlxSprite, a_flxSprites:Array ):FlxSprite {
			if ( a_flxSprites.length == 0 ) return null;
			if ( a_flxSprites.length == 1 && a_flxSprites[0] == a_target ) return null;
			
			var _loc_closestFlxSprite:FlxSprite;
			var _loc_closestDistanceSquare:Number = Number.MAX_VALUE;
			
			for each (var flxSprite:FlxSprite in a_flxSprites) {
				if ( flxSprite == a_target ) {
					continue;
				}
				if ( Math.pow( a_target.cX - flxSprite.cX, 2) + Math.pow( a_target.cY - flxSprite.cY, 2) < _loc_closestDistanceSquare ) {
					_loc_closestFlxSprite = flxSprite;
					_loc_closestDistanceSquare = Math.pow( a_target.cX - flxSprite.cX, 2) + Math.pow( a_target.cY - flxSprite.cY, 2);
				}
			}
			return(_loc_closestFlxSprite);
		}
		
		/*// TODO Remove if no longer needed
		private function TMPgetClosestFrom( a_target:FlxSprite, a_flxSprites:Array ):FlxSprite {
			_currentTarget = a_target;
			// Copy vector here so it isnt passed by reference
			var _loc_flxSprites:Array = a_flxSprites.slice();
			_loc_flxSprites.sort( compareDistancefromMe );
			
			if ( _loc_flxSprites.length > 0 ) {
				return _loc_flxSprites[0]
			} else {
				return null;
			}
		}
		private function compareDistancefromMe( a_flxSprite1:FlxSprite, a_flxSprite2:FlxSprite):Number {
			//if ( _owner.getDistanceSquared(a_combatObject_1.getMapPosition()) > _owner.getDistanceSquared(a_combatObject_2.getMapPosition()) )  {
			var _loc_distanceTo1:Number = Math.pow( _currentTarget.x - a_flxSprite1.x, 2) + Math.pow( _currentTarget.y - a_flxSprite1.y, 2);
			var _loc_distanceTo2:Number = Math.pow( _currentTarget.x - a_flxSprite2.x, 2) + Math.pow( _currentTarget.y - a_flxSprite2.y, 2);
			if ( _loc_distanceTo1 > _loc_distanceTo2 ) {
				return 1;
			}
			return ( -1);
		}*/
		
		public function addSprite(sprite:FlxSprite, destArray:Array) : void
		{
			destArray.push(sprite);
			lyrSprites.add(sprite);
		}
		public function addToArrayOnly(sprite:FlxSprite, destArray:Array) : void
		{
			destArray.push(sprite);
		}
		
		public function removeEntity(entity:FlxSprite, array:Array) : void
		{
			array = array.splice( array.indexOf( entity ), 1);
			entity.kill();
		}
		public function removeEntityFromArrayOnly(entity:FlxSprite, array:Array) : void
		{
			array = array.splice( array.indexOf( entity ), 1);
		}
		
		public function growTree(treeX:Number, treeY:Number) : void
		{
			addSprite( new Tree(treeX, treeY, this, false), _trees );
		}
		
		public function spawnDodo(dodoX:Number, dodoY:Number, a_family:int = 2) : void
		{
			var _loc_dodo:Dodo = new Dodo(dodoX, dodoY, this, a_family);
			addSprite( _loc_dodo, _dodos );
			addToArrayOnly( _loc_dodo, _dodoAdults );
		}
		
		public function spawnDodoChild(dodoX:Number, dodoY:Number, a_family:int = 1) : void
		{
			var _loc_dodoChild:DodoChild = new DodoChild(dodoX, dodoY, this, a_family);
			addSprite( _loc_dodoChild, _dodos );
			addToArrayOnly( _loc_dodoChild, _dodoChildren );
		}
		
		//////////////////// multi level: override this
		public function isVictoryAchieved() : Boolean
		{
			return false;
		}
		
		// override this
		public function nextLevel() : Class
		{
			// should return class of the next level, E.G. "Level1" or "MainMenu"
			return Class(getDefinitionByName(getQualifiedClassName(this)));
		}
		
		public function resetLevel() : void 
		{
			FlxG.switchState(Class(getDefinitionByName(getQualifiedClassName(this))));
		}
		
		private const PAUSE_WIN_LEVEL_CHANGE:Number = 7;
		public function checkLevelAndChange() : void
		{
			if (endOfLevelTimer == -1 && isVictoryAchieved()) {
				endOfLevelTimer = PAUSE_WIN_LEVEL_CHANGE;
				if ( _displayWinImage )
					addChild( _displayWinImage );
			}
			
			if (endOfLevelTimer > 0) {
				endOfLevelTimer -= FlxG.elapsed;
				if (endOfLevelTimer <= 0) {
					if ( _displayWinImage ) {
						removeChild( _displayWinImage );
						_displayWinImage = null;
					}
					FlxG.switchState( nextLevel() );
				}
			}
		}
		
		private var _displayGoalImage:Bitmap;
		private var _displayGoalTimer:Number = 0;
		public function displayGoal( a_ImageClass:Class, a_time:Number = 3 ) : void
		{
			_displayGoalImage = new a_ImageClass();
			_displayGoalImage.x = FlxG.width / 1.7 - _displayGoalImage.width / 2;
			_displayGoalImage.y = FlxG.height / 2.7 - _displayGoalImage.height / 2;
			addChild( _displayGoalImage );
			_displayGoalTimer = a_time;
		}
		
		private var _displayWinImage:Bitmap;
		public function setWinDisplay( a_ImageClass:Class ) : void 
		{
			_displayWinImage = new a_ImageClass();
			_displayWinImage.x = FlxG.width / 1.7 - _displayWinImage.width / 2;
			_displayWinImage.y = FlxG.height / 2.7 - _displayWinImage.height / 2;
		}
		
		/**
		 * Determines how how far sounds can be and still have full volume.
		 * Should probably be somewhere around the average distance from center
		 * of screen to bounds of visible area.
		 */
		private const SOUND_FULL_VOLUME_RANGE:Number = 300;
		/**
		 * Determines how how far sounds can be from full volume and still barely be heard.
		 * Should probably be quite low, as it is confusing to the player to 
		 * hear quiet sounds and not be sure where they are coming from.
		 */
		private const SOUND_SILENT_RANGE:Number = 200;
		
		/**
		 * This function returns the volume for a sprites position based on the two consts SOUND_FULL_VOLUME_RANGE
		 * and SOUND_SILENT_RANGE. Everything within a distance of SOUND_FULL_VOLUME_RANGE has full volume,
		 * everything outside falls at a linear rate until it is silent at distances above SOUND_SILENT_RANGE.
		 * @param	sprite	The sound-emitting sprite for which the volume should be determined
		 * @return	A Number that is 1 or larger for close sounds, and 0 or smaller for further away (FlxSound automatically limits volume range to 0-1)
		 */
		public function distance2Volume( sprite:FlxSprite ) : Number
		{
			var _loc_centerOfScreen:Point = new Point( (Math.abs( FlxG.scroll.x ) + FlxG.width / 2), (Math.abs( FlxG.scroll.y ) + FlxG.height / 2) + 40 );
			var _loc_diffX:Number = (sprite.x - _loc_centerOfScreen.x);
			var _loc_diffY:Number = (sprite.y - _loc_centerOfScreen.y);
			var _distanceFromFullVolumeSquare:Number = Math.abs( Math.min( 0, Math.pow( SOUND_FULL_VOLUME_RANGE, 2 ) - (Math.pow(_loc_diffX, 2) + Math.pow(_loc_diffY, 2)) ));
			//Test distances easily with a DodoChild
			//if (sprite is DodoChild) {
				//trace("_loc_diffX: " + _loc_diffX);
				//trace("_loc_diffY: " + _loc_diffY);
				//trace("_distanceFromCenter: " + _distanceFromFullVolumeSquare);
			//}
			return ( 1.0 - ( _distanceFromFullVolumeSquare / Math.pow(SOUND_SILENT_RANGE,2)) );
		}
		
		public function distanceFromPlayer( sprite:FlxSprite) : Number
		{
			return Math.sqrt( (sprite.x - _player.x) * (sprite.x - _player.x) + (sprite.y - _player.y) * (sprite.y - _player.y));
		}
    }
}