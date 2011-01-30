package  
{

	import org.flixel.*;
	
	public class MainMenu extends FlxState
	{
		[Embed(source = "img/nokiafc22.ttf", fontFamily = "NES", embedAsCFF = "false")]
		public var nokiafc22:String;
		
		override public function MainMenu() 
		{
			super();
			var txt:FlxText
			
			txt = new FlxText(0, 48, FlxG.width, "DarwinVsDodo")
			txt.setFormat("NES", 32, 0xFFFFFFFF, "center");
			this.add(txt);
			
			txt = new FlxText(0, 128, FlxG.width, "by Max Dohme, Johann Scholz & Christiaan Janssen")
			txt.setFormat("NES", 16, 0xFFFFFFFF, "center");
			this.add(txt);
			
			
			txt = new FlxText(0, FlxG.height  -48, FlxG.width, "PRESS X TO START")
			txt.setFormat("NES", 16, 0xFFFFFFFF, "center");
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
			FlxG.switchState(Level1);
		}
	}
	
}