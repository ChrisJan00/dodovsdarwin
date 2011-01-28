package  
{
	import org.flixel.*;
	
	public class Trap extends FlxSprite
	{
		[Embed(source = "img/Trap.png")] private var ImgTrap:Class;
		
		private var _activating_counter:Number = 0;
		private var _active:Boolean = false;
		public function Trap(X:Number, Y:Number, Direction:uint) 
		{
			super(X,Y);
            loadGraphic(ImgTrap, true, false, 16, 16);
			fixed = true;
			
            addAnimation("idle", [0], 10);
			
			_facing = Direction;
			
			switch (Direction) {
				case UP:
					addAnimation("trig", [3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,1,1,1,1,1,1,1,1,1,1,1,2, 3, 0], 20);
				break;
				case DOWN:
					addAnimation("trig", [6, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,4,4,4,4,4,4,4,4,4,4,4,5, 6, 0], 20);
				break;
				case RIGHT:
					addAnimation("trig", [9, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,7,7,7,7,7,7,7,7,7,7,7,8, 9, 0], 20);
				break;
				case LEFT:
					addAnimation("trig", [12, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,10,10,10,10,10,10,10,10,10,10,10,11, 12, 0], 20);
				break;
			}
		}
		
		override public function update():void
		{
			if (_activating_counter > 0)
			{
				_activating_counter -= FlxG.elapsed;
			}
			if (_activating_counter > 0)
			{
				play("trig");
			} else {
				play("idle");
			}
			super.update();
		}
		
		public function activate():void
		{
			_activating_counter = 1.2;
			_active = true;
		}
		public function deactivate():void
		{
			_activating_counter = 0;
			_active = false;			
		}
		
	}
	
}