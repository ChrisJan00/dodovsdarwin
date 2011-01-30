package  
{

	import org.flixel.*;
	
	public class MainMenu extends FlxState
	{
		[Embed(source = "img/nokiafc22.ttf", fontFamily = "NES", embedAsCFF = "false")]
		public var nokiafc22:String;
		
		[Embed(source = "snd/DodoMain.mp3")] private var TitleMusic: Class
		
		protected static var layer:FlxLayer;
		
		override public function MainMenu() 
		{
			super();
			var txt:FlxText
			
			txt = new FlxText(0, 48, FlxG.width, "DarwinVsDodo")
			txt.setFormat("NES", 32, 0xFFFFFFFF, "center");
			this.add(txt);
			
			txt = new FlxText(0, 128, FlxG.width, "by Max Dohme, Johann Scholz, Christiaan Janssen & Volando")
			txt.setFormat("NES", 16, 0xFFFFFFFF, "center");
			this.add(txt);
			
			
			txt = new FlxText(0, FlxG.height  -48, FlxG.width, "PRESS ACTION KEY (X) TO START")
			txt.setFormat("NES", 16, 0xFFFFFFFF, "center");
			this.add(txt);
			
			
			layer = new FlxLayer;
			this.add(layer);
			layer.add(new WalkingDodo(280, 240));
			FlxG.play(TitleMusic, 1.0, true);
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