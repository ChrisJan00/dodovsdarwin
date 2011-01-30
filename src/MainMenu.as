package  
{

	import org.flixel.*;
	
	public class MainMenu extends FlxState
	{
		override public function MainMenu() 
		{
			super();
			var txt:FlxText
			txt = new FlxText(0, FlxG.height  -48, FlxG.width, "PRESS X TO START")
			txt.setFormat(null, 16, 0xFFFFFFFF, "center");
			this.add(txt);
			
		}
		
		
		override public function update():void
		{
			if (FlxG.keys.pressed("X"))
			{
				FlxG.flash(0xffffffff, 0.75);
				FlxG.fade(0xff000000, 1, onFade);
			} 
			super.update();
		}
		
		private function onFade():void
		{
			FlxG.switchState(Blocks_PlayState);
		}
	}
	
}