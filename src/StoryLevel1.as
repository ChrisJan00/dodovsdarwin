package  
{
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author Max Dohme
	 */
	public class StoryLevel1 extends FlxState
	{
		
		private var _pause:Number = 10;
		
		public function StoryLevel1() 
		{
			var txt:FlxText;
			
			//txt = new FlxText(0, 100, FlxG.width, "Not too long ago")
			//txt.setFormat("NES", 16, 0xFFFFFFFF, "center");
			//this.add(txt);
			
			txt = new FlxText(0, 150, FlxG.width, "Not too long ago, not too far away")
			txt.setFormat("NES", 16, 0xFFFFFFFF, "center");
			this.add(txt);
			
			txt = new FlxText(0, 200, FlxG.width, "there lived on an island in the Indian Ocean")
			txt.setFormat("NES", 16, 0xFFFFFFFF, "center");
			this.add(txt);
			
			txt = new FlxText(0, 250, FlxG.width, "the peaceful Dodo bird...")
			txt.setFormat("NES", 16, 0xFFFFFFFF, "center");
			this.add(txt);
			
			txt = new FlxText(0, 432, FlxG.width, "PRESS X TO SKIP")
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
			FlxG.switchState( Level1 );
		}
		
	}

}