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
		[Embed(source = "snd/hist.mp3")] private var BetweenMusic: Class
		
		private var _pause:Number = 10;
		
		public function StoryLevel1() 
		{
			var txt:FlxText;
			
			txt = new FlxText(0, 100, FlxG.width, "1 - Fruit")
			txt.setFormat("NES", 24, 0xFFFFFFFF, "center");
			this.add(txt);
			
			//txt = new FlxText(0, 150, FlxG.width, "Not that long ago")
			//txt.setFormat("NES", 16, 0xFFFFFFFF, "center");
			//this.add(txt);
			
			txt = new FlxText(0, 200, FlxG.width, "Not that long ago")
			txt.setFormat("NES", 16, 0xFFFFFFFF, "center");
			this.add(txt);
			
			txt = new FlxText(0, 250, FlxG.width, "on an island off the coast of Africa...")
			txt.setFormat("NES", 16, 0xFFFFFFFF, "center");
			this.add(txt);
			
			txt = new FlxText(0, 432, FlxG.width, "Press X")
			txt.setFormat("NES", 16, 0xFFFFFFFF, "center");
			this.add(txt);
			
			FlxG.play(BetweenMusic, 1.0, true);
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