
package 
{
    import org.flixel.*;

    public class PlayState extends FlxState
    {
		[Embed(source = 'img/Tiles.png')] protected var ImgTiles:Class;

		protected var LevelMap:Class;
		protected var BlockMap:String;
        protected var SpikeMap:String;
		
		protected var BackgroundImg:Class;
		
        public var _player:Player;
        private var _block_map:FlxTilemap;
		private var _spike_map:FlxTilemap;
		private var _background:Background;
		
	    public static var lyrStage:FlxLayer;
        public static var lyrSprites:FlxLayer;
        public static var lyrHUD:FlxLayer;
		
		protected var _transp_tile:String
		protected var _rats:Vector.<Rat>;
        
        override public function PlayState():void
        {
            super();
		}
            
		public function Init():void
		{
            lyrStage = new FlxLayer;
            lyrSprites = new FlxLayer;
            lyrHUD = new FlxLayer;
           
			
            _player = new Player(248, 240, this);
            lyrSprites.add(_player);
			
			_background = new Background(BackgroundImg);
			lyrStage.add(_background);
			_rats = new Vector.<Rat>();
			
            FlxG.follow(_player,2.5);
            FlxG.followAdjust(0.5, 0.5);
            FlxG.followBounds(1,1,600-1,400-1);
            
			parseMap(new LevelMap);
			
            _block_map = new FlxTilemap;
			_block_map.loadMap(BlockMap, ImgTiles, 8);
            _block_map.drawIndex = 1;
            _block_map.collideIndex = 1;
            _spike_map = new FlxTilemap;
            _spike_map.loadMap(SpikeMap, ImgTiles, 8);
            _spike_map.drawIndex = 1;
            _spike_map.collideIndex = 1;
			
            lyrStage.add(_block_map);
			lyrStage.add(_spike_map);
			
            this.add(lyrStage);
            this.add(lyrSprites);
            this.add(lyrHUD);
			
        }
		
		public function parseMap(map:String):void
		{
			var last:String;
			BlockMap = new String("");
			SpikeMap = new String("");
			
			
			var col:Number = 0;
			var row:Number = 0;
			
			//var rows:Array = map.split('\n');
			for each (var rows:String in map.split("\n")) {
				// it's actually CRLF, so we have to strip one more character away
				rows = rows.substr(0, rows.length - 1);
				if (rows.length > 0) 
					{ 
						col = 0;
						for each (var tiles:String in rows.split(",")) {
								if (tiles == _transp_tile) // the magick number! probably different in every map :(
									BlockMap += "0,";
								else
									BlockMap += "1,";
							SpikeMap += "0,";
							
				//{	
					//col = 0;
					//for each (var tiles:String in rows.split(",")) {	
							// "Normal" maps
							//switch (tiles) {
								//case "0":
									//BlockMap += "0,";
									//SpikeMap += "0,";
									//break;
								//case "1":
								//case "2":
								//case "9":
									//BlockMap += tiles + ",";
									//SpikeMap += "0,";
									//break;
								//case "3":
								//case "4":
								//case "5":
								//case "6":
								//case "14":
									//BlockMap += "0,";
									//SpikeMap += tiles + ",";
									//break;
								//case "8":
									//BlockMap += "0,";
									//SpikeMap += "0,";
									//break;
								//default:
									//BlockMap += "0,";
									//SpikeMap += "0,";
									//break;
							//}
							
						col += 1;
					}
					BlockMap = BlockMap.substr(0, BlockMap.length - 1) + "\n";
					SpikeMap = SpikeMap.substr(0, SpikeMap.length - 1) + "\n";
					
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
				_player.kill()
				_player.hurt(1);
			}
			
			//if (_player.dead) FlxG.score = 0;
			
			if (FlxG.keys.justPressed("ESC")) {
			}
            
        }
		
		public function reload():void
		{
			_player.reload();

		}

        
    }    
} 