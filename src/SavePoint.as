package  
{
	import org.flixel.*;
	
	public class SavePoint extends FlxSprite
	{
		[Embed(source = "img/ElderSign.png")] private var ImgSign:Class;
		
		private var _activating_counter:Number = 0;
		private var _active:Boolean = false;
		public function SavePoint(X:Number, Y:Number) 
		{
			super(X,Y);
            loadGraphic(ImgSign, true, false, 16, 16);
     
            addAnimation("idle", [1], 10);
            addAnimation("activating", [2, 3, 4], 5);
            addAnimation("active", [4,4,4,4,4,4,4,4,4,3,2,3], 7);
			
			//play("idle");
		}
		
		override public function update():void
		{
			if (_activating_counter > 0)
			{
				_activating_counter -= FlxG.elapsed;
			}
			if (_activating_counter > 0)
			{
				play("activating");
			} else if (_active) { 
				play("active"); 
			} else {
				play("idle");
			}
			super.update();
		}
		
		public function activate():void
		{
			_activating_counter = 0.6;
			_active = true;
		}
		public function deactivate():void
		{
			_activating_counter = 0;
			_active = false;			
		}
		
	}
	
}