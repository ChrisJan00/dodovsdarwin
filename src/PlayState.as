
package 
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	import flash.geom.Point;
	import flash.geom.Vector3D;
    import org.flixel.*;

    public class PlayState extends FlxState
    {
		[Embed(source = "img/fruit_01.png")] private var ImgFruit01:Class;
		
		protected var LevelMap:Class;
		protected var BlockMap:String;
		
		protected var BackgroundImg:Class;
		
        public var _player:Player;
        public var _block_map:FlxTilemap;
		private var _background:Background;
		
		protected var _playerStartPos:Point;
		
	    public static var lyrStage:FlxLayer;
        public static var lyrSprites:FlxLayer;
        public static var lyrHUD:FlxLayer;
		
		protected var _transparent_tile:String
		public var _rats:Array;
		public var _dodos:Array;
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
		
		private const TREE_MIN_CHOPPING:Number = 5;
        
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
			_dodos = new Array();
			_humans = new Array();
			_pigs = new Array();

			_background = new Background(BackgroundImg);
			lyrStage.add(_background);
			
			if ( _playerStartPos ) {
				_player = new Player(_playerStartPos.x, _playerStartPos.y, this);
			} else {
				_player = new Player(648, 240, this);
			}
			_dodos.push( _player );
            lyrSprites.add(_player);
			
			_stones = new Array();
			_trees = new Array();
			_fruits = new Array();
			_seeds = new Array();
			_eggs = new Array();
	
            FlxG.follow(_player,2.5);
            FlxG.followAdjust(0.5, 0.5);
            FlxG.followBounds(1,1,1280-1,960-1);
            
			parseMap(new LevelMap);
			
            _block_map = new FlxTilemap;
			_block_map.loadMap(BlockMap, ImgFruit01, 8);
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
				if (dodo != _player && (dodo as Dodo).isFlying())
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
					if ( rat.overlaps(_loc_dodo2) ) {
						rat.attack();
						(dodo as IDodo).takeRatDamage();
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
					if ( human.overlaps(_loc_dodo) ) {
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
				
				for each(var _loc_fruit:FlxSprite in _fruits) {
					if ( pig.overlaps(_loc_fruit) ) {
						pig.eat();
						removeEntity(_loc_fruit, _fruits);
					}
				}
			}
			
			for each(var tree:Tree in _trees) {
				if (tree.wantsFruit())
					addSprite(tree.getFruit(), _fruits);
			}
			
			for each(var fruit:FlxSprite in _fruits) {
				if ( _player.overlaps(fruit) ) {
					_player.eat();
					removeEntity(fruit, _fruits);
				}
			}
			
			if ( _trees.length > TREE_MIN_CHOPPING ) {
				isOkToChopTree = true;
			}
			
			var newTreeKillerTimer:Number = treeKillerTimer;
			if (_trees.length > 1)
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
			
			// New Dodos
			if (_dodos.length == 1) {
				dodoArrivingTimer -= FlxG.elapsed;
				if (dodoArrivingTimer <= 0) {
					var probability: Number = Math.max(0, Math.min(1.0, ( _trees.length - TREE_MIN_CHOPPING + 1) * 0.04));
					var num:Number = Math.random();
					if ( num < probability ) {
						var newDodo:Dodo = new Dodo( -100, -100, this);
						newDodo.flyIn();
						addSprite( newDodo, _dodos );
					} else {
						// 1 second until the next candidate
						dodoArrivingTimer = 2;
					}
				}
			} else {
				dodoArrivingTimer = 10;
			}
			
			lyrSprites.sortByY();
			_poopDisplay.update();
			_eggDisplay.update();
			
			if (FlxG.keys.justPressed("R")) {
				resetLevel();
			}
			
			if (FlxG.keys.justPressed("ESC")) {
				FlxG.switchState(MainMenu);
			}
			
			checkLevelAndChange();
        }
		
		public function reload():void
		{
			_player.reload();
		}
		
		public function getClosestRatVector( a_target:FlxSprite ):Vector3D {
			return ( getClosestVectorFrom(a_target, _rats ) );
		}
		public function getClosestDodoVector( a_target:FlxSprite ):Vector3D {
			return ( getClosestVectorFrom(a_target, _dodos ) );
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
		
		public function getClosestEgg( a_target:FlxSprite ):FlxSprite {
			if ( _eggs.length == 0 ) return null;
			if ( _eggs.length == 1 && _eggs[0] == a_target ) return null;
			
			var _loc_closestFlxSprite:FlxSprite;
			var _loc_closestDistanceSquare:Number = Number.MAX_VALUE;
			
			for each (var flxSprite:FlxSprite in _eggs) {
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
		
		public function spawnDodo(dodoX:Number, dodoY:Number) : void
		{
			// until the new dodos are ready, spawn rats instead
			addSprite( new Dodo(dodoX, dodoY, this), _dodos );
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
		
		public function checkLevelAndChange() : void
		{
			if (isVictoryAchieved())
				FlxG.switchState( nextLevel() );
		}
    }    
} 