package  
{
	import flash.net.SharedObject;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author Max Dohme
	 */
	public class StoryLevel2 extends FlxState
	{
		
		private var _pause:Number = 10;
		
		public function StoryLevel2() 
		{
			var so:SharedObject = SharedObject.getLocal("userData");
			so.data.lastLevel = 2;
			so.flush();
			
			var txt:FlxText;
			
			//txt = new FlxText(0, 100, FlxG.width, "The Dodo had no natural enemies.")
			//txt.setFormat("NES", 16, 0xFFFFFFFF, "center");
			//this.add(txt);
			
			txt = new FlxText(0, 150, FlxG.width, "The Dodo had no natural enemies.")
			txt.setFormat("NES", 16, 0xFFFFFFFF, "center");
			this.add(txt);
			
			//txt = new FlxText(0, 200, FlxG.width, "It lived in peace and harmony with its surroundings.")
			//txt.setFormat("NES", 16, 0xFFFFFFFF, "center");
			//this.add(txt);
			
			txt = new FlxText(0, 250, FlxG.width, "Until humans discovered the island...")
			txt.setFormat("NES", 16, 0xFFFFFFFF, "center");
			this.add(txt);
			
			txt = new FlxText(0, 432, FlxG.width, "PRESS X TO START")
			txt.setFormat("NES", 16, 0xFFFFFFFF, "center");
			this.add(txt);
		}
		
		override public function update():void {
			super.update();
			
			_pause -= FlxG.elapsed;
			
			if (_pause < 0) {
				FlxG.fade(0xff000000, 2, nextLevel);
			}
			if (FlxG.keys.pressed("X") || FlxG.keys.pressed("CONTROL") || FlxG.keys.pressed("SPACE"))
			{
				FlxG.fade(0xff000000, 0.75, nextLevel);
			}
			if (FlxG.keys.pressed("N") && FlxState.isInDebugMode)
			{
				nextLevel();
			}
		}
		
		public function nextLevel():void {
			FlxG.switchState( Level2 );
		}
		
	}

}