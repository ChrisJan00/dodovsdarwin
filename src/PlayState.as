
package 
{
    import org.flixel.*;

    public class PlayState extends FlxState
    {
		[Embed(source = 'img/Tiles.png')] protected var ImgTiles:Class;

		protected var LevelMap:Class;
		protected var BlockMap:String;
		
		protected var BackgroundImg:Class;
		
        public var _player:Player;
        private var _block_map:FlxTilemap;
		private var _background:Background;

		
	    public static var lyrStage:FlxLayer;
        public static var lyrSprites:FlxLayer;
        public static var lyrHUD:FlxLayer;
		
		protected var _transp_tile:String
		protected var _rats:Array;
		protected var _dodos:Array;
		protected var _humans:Array;
		protected var _stones:Array;
		protected var _trees:Array;
        
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

			_background = new Background(BackgroundImg);
			lyrStage.add(_background);
			
            _player = new Player(648, 240, this);
			_dodos.push( _player );
            lyrSprites.add(_player);
			
			_stones = new Array();
			_trees = new Array();
	
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
						if (tiles == _transp_tile) // the magick number! probably different in every map :(
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
				rat.collideArray(_stones);
				rat.collideArray(_trees);
			}
				
			for each(var human:FlxSprite in _humans) {
				human.collideArray(_stones);
				human.collideArray(_trees);
			}
			
			
			//if (_spike_map.overlaps(_player)) {
				//_player.kill()
				//_player.hurt(1);
			//}
			
			//if (_player.dead) FlxG.score = 0;
			
			if (FlxG.keys.justPressed("ESC")) {
			}
            
			
			lyrSprites.sortByY();
        }
		
		public function reload():void
		{
			_player.reload();
		}
		
		public function getClosestRat( a_target:FlxSprite ):FlxSprite {
			return (getClosestFrom( a_target, _rats ));
		}
		public function getClosestDodo( a_target:FlxSprite ):FlxSprite {
			return (getClosestFrom( a_target, _dodos ));
		}
		public function getClosestHuman( a_target:FlxSprite ):FlxSprite {
			return (getClosestFrom( a_target, _humans ));
		}
		
		private var _currentTarget:FlxSprite;
		
		private function getClosestFrom( a_target:FlxSprite, a_flxSprites:Array ):FlxSprite {
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
		}
    }    
} 