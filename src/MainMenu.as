package  
{

	import org.flixel.*;
	
	public class MainMenu extends FlxState
	{
		[Embed(source = "img/nokiafc22.ttf", fontFamily = "NES", embedAsCFF = "false")]
		public var nokiafc22:String;
		
		[Embed(source = "snd/DodoMain.mp3")] private var TitleMusic: Class
		
		protected static var layer:FlxLayer;
		private var _walkingDodo:WalkingDodo;
		
		override public function MainMenu() 
		{
			super();
			var txt:FlxText
			
			txt = new FlxText(0, 0, FlxG.width, "v0.22")
			txt.setFormat("NES", 16, 0xFFFFFFFF, "right");
			this.add(txt);
			
			txt = new FlxText(0, 48, FlxG.width, "DarwinVsDodo")
			txt.setFormat("NES", 32, 0xFFFFFFFF, "center");
			this.add(txt);
			
			txt = new FlxText(0, 128, FlxG.width, "by Max Dohme, Johann Scholz, Christiaan Janssen & Volando")
			txt.setFormat("NES", 16, 0xFFFFFFFF, "center");
			this.add(txt);
			
			txt = new FlxText(0, 280, FlxG.width, "Arrow Keys or WSAD - Move")
			txt.setFormat("NES", 16, 0xFFFFFFFF, "center");
			this.add(txt);
			
			txt = new FlxText(0, 310, FlxG.width, "X, Space or Ctrl - Perform Dodo Action")
			txt.setFormat("NES", 16, 0xFFFFFFFF, "center");
			this.add(txt);
			
			txt = new FlxText(0, 432, FlxG.width, "PRESS X TO START")
			txt.setFormat("NES", 16, 0xFFFFFFFF, "center");
			this.add(txt);
			
			
			layer = new FlxLayer;
			this.add(layer);
			_walkingDodo = new WalkingDodo( Preloader.dodoPosX + 20, 350);
			layer.add(_walkingDodo);
			FlxG.play(TitleMusic, 1.0, true);
		}
		
		
		override public function update():void
		{
			_walkingDodo.x += 1.8;
			if ( _walkingDodo.x > FlxG.width ) _walkingDodo.x = -90;
			
			if (FlxG.keys.pressed("X"))
			{
				FlxState.isInDebugMode = false;
				FlxG.flash(0xffffffff, 0.75);
				FlxG.fade(0xff000000, 1, onFade);
			} 
			if (FlxG.keys.pressed("F12"))
			{
				FlxState.isInDebugMode = true;
				onFade();
			} 
			super.update();
		}
		
		private function onFade():void
		{
			FlxG.switchState(Level1);
		}
	}
	
}