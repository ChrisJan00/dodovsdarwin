
// ToDos:
// - falling spikes, spikes coming from the floor, cruising spikes
// - moving platforms
// - falling platforms
// - wall of doom
// - enemies?
// - bouncing blocks
// - change graphics
// - prizes (coins)
// - design with savegames/design with prizes: unreachable, useless, bad position
// - limited lifes

 

package 
{
    import org.flixel.*;

    public class PlayState extends FlxState
    {
		[Embed(source = 'img/Tiles.png')] protected var ImgTiles:Class;

		protected var LevelMap:Class;
		
		protected var BlockMap:String;
        protected var FakeMap:String;
        protected var SpikeMap:String;
		protected var PlatformsMap:String;
		
        private var _player:Player;
        private var _block_map:FlxTilemap;
		private var _spike_map:FlxTilemap;
		private var _fake_map:FlxTilemap;
		private var _platforms_map:FlxTilemap;
		private var _savepoints:Array;
		//private var _savepoint_list:Array;
		private var _lastsavepoint:SavePoint;
		private var _traps:Array;
		private var _bouncers:Array;
		private var _rubberbands:Array;
		private var _fallingspikes:Array;
		private var _platforms:Array;
		
	    public static var lyrStage:FlxLayer;
        public static var lyrSprites:FlxLayer;
        public static var lyrHUD:FlxLayer;
        
        override public function PlayState():void
        {
            super();
		}
            
		public function Init():void
		{
            lyrStage = new FlxLayer;
            lyrSprites = new FlxLayer;
            lyrHUD = new FlxLayer;
           
			
            _player = new Player(48, 240, this);
            lyrSprites.add(_player);
			
			_lastsavepoint = null;
		

            FlxG.follow(_player,2.5);
            FlxG.followAdjust(0.5, 0.5);
            FlxG.followBounds(1,1,1600-1,288-1);
            
			parseMap(new LevelMap);
			
            _block_map = new FlxTilemap;
			_block_map.loadMap(BlockMap, ImgTiles, 16);
            _block_map.drawIndex = 1;
            _block_map.collideIndex = 1;
            _spike_map = new FlxTilemap;
            _spike_map.loadMap(SpikeMap, ImgTiles, 16);
            _spike_map.drawIndex = 1;
            _spike_map.collideIndex = 1;
			_fake_map = new FlxTilemap;
			_fake_map.loadMap(FakeMap, ImgTiles, 16);
            _fake_map.drawIndex = 1;
            _fake_map.collideIndex = 1;
			_platforms_map = new FlxTilemap;
			_platforms_map.loadMap(PlatformsMap, ImgTiles, 16);
            _platforms_map.drawIndex = 1;
            _platforms_map.collideIndex = 1;
			
			
            lyrStage.add(_block_map);
			lyrStage.add(_spike_map);
			lyrStage.add(_fake_map);
            
            this.add(lyrStage);
            this.add(lyrSprites);
            this.add(lyrHUD);
			
        }
		
		public function parseMap(map:String):void
		{
			var last:String;
			BlockMap = new String("");
			SpikeMap = new String("");
			FakeMap = new String("");
			PlatformsMap = new String("");
			
			//_savepoint_list = new Array;
			_savepoints = new Array;
			_traps = new Array;
			_bouncers = new Array;
			_rubberbands = new Array;
			_fallingspikes = new Array;
			
			
			
			var col:Number = 0;
			var row:Number = 0;
			
			//var rows:Array = map.split('\n');
			for each (var rows:String in map.split("\n")) {
				// it's actually CRLF, so we have to strip one more character away
				rows = rows.substr(0, rows.length - 1);
				if (rows.length > 0) {	
					col = 0;
					for each (var tiles:String in rows.split(",")) {	
							// "Normal" maps
							switch (tiles) {
								case "0":
									BlockMap += "0,";
									SpikeMap += "0,";
									FakeMap += "0,";
									break;
								case "1":
								case "2":
								case "9":
									BlockMap += tiles + ",";
									SpikeMap += "0,";
									FakeMap += "0,";
									break;
								case "3":
								case "4":
								case "5":
								case "6":
								case "14":
									BlockMap += "0,";
									SpikeMap += tiles + ",";
									FakeMap += "0,";
									break;
								case "8":
									BlockMap += "0,";
									SpikeMap += "0,";
									FakeMap += tiles+",";
									break;
								default:
									BlockMap += "0,";
									SpikeMap += "0,";
									FakeMap += "0,";
									break;
							}
							
							
							
							// moving platforms
							switch (tiles)
							{
								case "25":
								case "26":
								case "27":
								case "28":
								case "29":
								case "30":
								case "32":
								case "33":
								case "34":
								case "35":
								case "36":
									PlatformsMap += tiles + ",";
									break;
								default:
									PlatformsMap += "0,";
									break;
							}
						col += 1;
					}
					BlockMap = BlockMap.substr(0, BlockMap.length - 1) + "\n";
					SpikeMap = SpikeMap.substr(0, SpikeMap.length - 1) + "\n";
					FakeMap = FakeMap.substr(0, FakeMap.length - 1) + "\n";
					PlatformsMap = PlatformsMap.substr(0, PlatformsMap.length - 1) + "\n";
					
				}
				row += 1;
			}			
		}
        
		
        override public function update():void
        {
		   super.update();
            //map collisions
			
            _block_map.collide(_player);
			if (_spike_map.overlaps(_player)) {
				//_player.kill()
				_player.hurt(1);
			}
			
			FlxG.overlapArray( _savepoints, _player, SavePointHit);
			
			// don't fall away
			if (_player.y > 288-16) { _player.y = 288-16 }
			
			//if (_player.dead) FlxG.score = 0;
			
			if (FlxG.keys.justPressed("ESC")) {
				//FlxG.switchState(MenuState);
			}
            
        }
		
		//public function SavePointHit(savepoint:FlxSprite, P:Player):void
		public function SavePointHit(savepoint:SavePoint, P:Player):void
		{
			if (_player.health > 0) {
				if (savepoint != _lastsavepoint) 
				{
					if (_lastsavepoint) { _lastsavepoint.deactivate(); }
					_player.save(savepoint.x, savepoint.y);
					_lastsavepoint =  savepoint;
					_lastsavepoint.activate();

				}
				
			}
		}
		
		public function reload():void
		{
			_player.reload();

		}

        
    }    
} 