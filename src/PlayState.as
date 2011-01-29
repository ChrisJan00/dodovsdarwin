
package 
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
    import org.flixel.*;

    public class PlayState extends FlxState
    {
		[Embed(source = 'img/Tiles.png')] protected var ImgTiles:Class;

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
		
		private var _poopDisplay:PoopDisplay;
        
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
	
            FlxG.follow(_player,2.5);
            FlxG.followAdjust(0.5, 0.5);
            FlxG.followBounds(1,1,1280-1,960-1);
            
			parseMap(new LevelMap);
			
            _block_map = new FlxTilemap;
			_block_map.loadMap(BlockMap, ImgTiles, 8);
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
            //map collisions
			
            _block_map.collide(_player);
			_player.collideArray(_stones);
			_player.collideArray(_trees);
			
			for each(var rat:Rat in _rats) {
				_block_map.collide(rat);
				rat.collideArray(_stones);
				rat.collideArray(_trees);
			}
			for each(var human:FlxSprite in _humans) {
				_block_map.collide(human);
				human.collideArray(_stones);
				human.collideArray(_trees);
				
				for each(var _loc_rat:Rat in _rats) {
					if ( human.overlaps(_loc_rat) ) {
						removeEntity(_loc_rat, _rats);
					}
				}
			}
			for each(var pig:FlxSprite in _pigs) {
				_block_map.collide(pig);
				pig.collideArray(_stones);
				pig.collideArray(_trees);
				
				for each(var _loc_fruit:Fruit in _fruits) {
					if ( pig.overlaps(_loc_fruit) ) {
						removeEntity(_loc_fruit, _fruits);
					}
				}
			}
			
			for each(var tree:Tree in _trees) {
				if (tree.wantsFruit())
					addSprite(tree.getFruit(), _fruits);
			}
			
			for each(var fruit:Fruit in _fruits) {
				if ( _player.overlaps(fruit) ) {
					_player.eat();
					removeEntity(fruit, _fruits);
				}
			}
			
			
			//if (_spike_map.overlaps(_player)) {
				//_player.kill()
				//_player.hurt(1);
			//}
			
			//if (_player.dead) FlxG.score = 0;
			
			if (FlxG.keys.justPressed("ESC")) {
			}
            
			lyrSprites.sortByY();
			_poopDisplay.update();
        }
		
		public function reload():void
		{
			_player.reload();
		}
		
		//public function getClosestRat( a_target:FlxSprite ):FlxSprite {
			//return (getClosestFrom( a_target, _rats ));
		//}
		//public function getClosestDodo( a_target:FlxSprite ):FlxSprite {
			//return (getClosestFrom( a_target, _dodos ));
		//}
		//public function getClosestHuman( a_target:FlxSprite ):FlxSprite {
			//return (getClosestFrom( a_target, _humans ));
		//}
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
		
		//private var _currentTarget:FlxSprite;
		
		private function getClosestVectorFrom( a_target:FlxSprite, a_flxSprites:Array ):Vector3D {
			if ( a_flxSprites.length == 0 ) return null;
			
			var _loc_closestFlxSprite:FlxSprite;
			var _loc_closestDistanceSquare:Number = Number.MAX_VALUE;
			
			for each (var flxSprite:FlxSprite in a_flxSprites) {
				if ( Math.pow( a_target.x - flxSprite.x, 2) + Math.pow( a_target.y - flxSprite.y, 2) < _loc_closestDistanceSquare ) {
					_loc_closestFlxSprite = flxSprite;
					_loc_closestDistanceSquare = Math.pow( a_target.x - flxSprite.x, 2) + Math.pow( a_target.y - flxSprite.y, 2);
				}
			}
			return ( new Vector3D( _loc_closestFlxSprite.x - a_target.x, _loc_closestFlxSprite.y - a_target.y ) );
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
		
		public function growTree(treeX:Number, treeY:Number) : void
		{
			addSprite( new Tree(treeX, treeY, this, false), _trees );
		}
    }    
} 