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
	public class StoryLevel4 extends FlxState
	{
		
		private var _pause:Number = 10;
		
		public function StoryLevel4() 
		{
			var so:SharedObject = SharedObject.getLocal("userData");
			so.data.lastLevel = 3;
			so.flush();
			
			var txt:FlxText;
			
			txt = new FlxText(0, 100, FlxG.width, "4 - Survival");
			txt.setFormat("NES", 24, 0xFFFFFFFF, "center");
			this.add(txt);
			
			//txt = new FlxText(0, 150, FlxG.width, "More and more humans arrived");
			//txt.setFormat("NES", 16, 0xFFFFFFFF, "center");
			//this.add(txt);
			
			txt = new FlxText(0, 200, FlxG.width, "As the island got populated, there was less space for the dodo.");
			txt.setFormat("NES", 16, 0xFFFFFFFF, "center");
			this.add(txt);
			
			txt = new FlxText(0, 250, FlxG.width, "The new generations were the last hope for the future.");
			txt.setFormat("NES", 16, 0xFFFFFFFF, "center");
			this.add(txt);
			
			txt = new FlxText(0, 432, FlxG.width, "Press X")
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
			FlxG.switchState( Level4 );
		}
		
	}

}