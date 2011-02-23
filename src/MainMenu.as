package  
{

	import flash.net.SharedObject;
	import org.flixel.*;
	
	public class MainMenu extends FlxState
	{
		[Embed(source = "img/nokiafc22.ttf", fontFamily = "NES", embedAsCFF = "false")]
		public var nokiafc22:String;
		
		[Embed(source = "snd/DodoMain.mp3")] private var TitleMusic: Class
		
		protected static var layer:FlxLayer;
		private var _walkingDodo:WalkingDodo;
		private var _lastLevel:int = 1;
		
		//This const allows you to switch between allowing debug mode or not
		//Don't forget to set to false before creating a release build!
		private static const DEBUG_VERSION:Boolean = true;
		
		override public function MainMenu() 
		{
			super();
			
			/*
			var so:SharedObject = SharedObject.getLocal("userData");
			if ( so.data.lastLevel == undefined ) {
				_lastLevel = so.data.lastLevel = 1;
				so.flush();
			} else {
				_lastLevel = so.data.lastLevel;
			}
			/*/
			_lastLevel = 1;
			//*/
			
			var txt:FlxText
			
			txt = new FlxText(0, 0, FlxG.width, "v0.28")
			txt.setFormat("NES", 16, 0xFFFFFFFF, "right");
			this.add(txt);
			
			if ( DEBUG_VERSION ) {
				txt = new FlxText(0, 22, FlxG.width, "DEBUG VERSION")
				txt.setFormat("NES", 16, 0xFFFFFFFF, "right");
				this.add(txt);
			}
			
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
			
			if ( _lastLevel == 1 ) {
				txt = new FlxText(0, 432, FlxG.width, "PRESS X - NEW GAME")
				txt.setFormat("NES", 16, 0xFFFFFFFF, "center");
				this.add(txt);
			} else {
				txt = new FlxText(0, 425, FlxG.width, "PRESS X TO CONTINUE")
				txt.setFormat("NES", 16, 0xFFFFFFFF, "center");
				this.add(txt);
				
				txt = new FlxText(0, 450, FlxG.width, "R TO RESET")
				txt.setFormat("NES", 16, 0xFFFFFFFF, "center");
				this.add(txt);
			}
			
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
				FlxG.fade(0xff000000, 1, onFade);
			} 
			if (FlxG.keys.pressed("R") && _lastLevel != 1)
			{
				var so:SharedObject = SharedObject.getLocal("userData");
				so.data.lastLevel = 1;
				so.flush();
				_lastLevel = 0;
				FlxG.fade(0xff000000, 0.75, onFade);
			} 
			if (FlxG.keys.pressed("T") && DEBUG_VERSION)
			{
				var so2:SharedObject = SharedObject.getLocal("userData");
				so2.data.lastLevel = 2;
				so2.flush();
				_lastLevel = 0;
				FlxG.fade(0xff000000, 0.5, onFade);
			}
			if (FlxG.keys.pressed("F11") && DEBUG_VERSION)
			{
				FlxState.isInDebugMode = true;
				FlxG.switchState(LevelTest);
			} 
			if (FlxG.keys.pressed("F12") && DEBUG_VERSION)
			{
				FlxState.isInDebugMode = true;
				FlxG.switchState(StoryLevel1);
			} 
			super.update();
		}
		
		private function onFade():void
		{
			switch (_lastLevel) 
			{
				case 0:
					FlxG.switchState( MainMenu );
				break;
				case 1:
					FlxG.switchState( StoryLevel1 );
				break;
				case 2:
					FlxG.switchState( StoryLevel2 );
				break;
				case 3:
					FlxG.switchState( StoryLevel3 );
				break;
				case 4:
					//TODO needs to be level 4
					FlxG.switchState( StoryLevel3 );
				break;
				case 5:
					//TODO needs to be level 5
					FlxG.switchState( StoryLevel3 );
				break;
				default:
					FlxG.switchState( StoryLevel1 );
				break;
			}
		}
	}
	
}