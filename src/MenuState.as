package  
{

	import org.flixel.*;
	
	public class MenuState extends FlxState
	{
		private var _option:int = 0;
		private var _numoptions:int = 6;
		private var _marker:FlxText;
		override public function MenuState() 
		{
			super();
			var txt:FlxText
			txt = new FlxText(0, FlxG.height  -24, FlxG.width, "PRESS JUMP TO START")
			txt.setFormat(null, 8, 0xFFFFFFFF, "center");
			this.add(txt);
			
			var textoption:Array = [ "only blocks and spikes", "fake blocks, invisible blocks", "variations", "bouncing blocks", "falling spikes" ];
			for (var i:Number = 0; i < _numoptions; i++)
			{
				txt = new FlxText(0, i * 16 + 10, FlxG.width, textoption[i] );
				txt.setFormat(null, 8, 0xFFFFFFFF, "center");
				this.add(txt);
			}
			
			_marker = new FlxText(0, 10, FlxG.width, ">>");
			_marker.setFormat(null, 8, 0xFFFFFFFF, "left");
			this.add(_marker);
		}
		
		
		override public function update():void
		{
			if (FlxG.keys.pressed("J"))
			{
				FlxG.flash(0xffffffff, 0.75);
				FlxG.fade(0xff000000, 1, onFade);
			}            
			if (FlxG.keys.justPressed("UP"))
			{
				_option = (_option + _numoptions - 1) % _numoptions;
			}
			if (FlxG.keys.justPressed("DOWN"))
			{
				_option = (_option + 1) % _numoptions;
			}
			
			_marker.y = 10 + (_option * 16);
			super.update();
		}
		
		private function onFade():void
		{
			switch(_option) {
				case 0:
					FlxG.switchState(Blocks_PlayState);
					break;
			    case 1:
					FlxG.switchState(Fake_PlayState);
					break;
				case 2:
					FlxG.switchState(Variations_PlayState);
				break;
				case 3:
					FlxG.switchState(Bounce_PlayState);
				break;
				case 4:
					FlxG.switchState(Falling_PlayState);
				break;
				case 5:
					FlxG.switchState(Moving_PlayState);
				break;
			}
		}
	}
	
}