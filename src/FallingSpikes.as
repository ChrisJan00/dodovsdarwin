package  
{
	
	import org.flixel.*;
	
	public class FallingSpikes extends FlxSprite
	{
		[Embed(source = "img/Tiles.png")] private var ImgFallingSpikes_up:Class;
		
		//private var _activating_counter:Number = 0;
		private var _hanging:Boolean = true;
		private var _active:Boolean = true;
		private var _type:Number;
		private var _falling_velocity:Number = 200;
		private var _saved_y:Number;
		private var _saved_velocity:Number;
		private var _saved_active:Boolean; 
		private var _saved_hanging:Boolean;
		private var _original_y:Number;

		public function FallingSpikes(X:Number, Y:Number, Type:uint) 
		{
			super(X, Y);
			
			loadGraphic(ImgFallingSpikes_up, true, false, 16, 16);		
			
			width = 16;
			height = 16;			
			fixed = false;
			velocity.y = 0;
			_hanging = true;
			_original_y = y;
			
			save();
            
            addAnimation("vertical", [23], 5);
			addAnimation("piramid", [24], 5);
			
			_type = Type;
			
		}
		
		override public function update():void
		{
			//if (_activating_counter > 0)
			//{
				//_activating_counter -= FlxG.elapsed;
			//}
			//if (_activating_counter > 0)
			//{
				//play("trig");
			//} else {
				//play("idle");
			//}
			if (_active){ play("vertical");}
			if (_active && y > 18 * 16) { deactivate(); }
			super.update();
		}
		
		public function checkActivate(P:Player):void
		{
			if (!_active) { return; }
			if (overlaps(P)) { P.hurt(1); }
			if (!_hanging) { return; }
			switch(_type)
			{
				case 1: //vertical spike
				if (P.x + P.width > x && P.x < width + x && P.y > y) {
					activate();
				}
				break;
				case 2: // piramid spike
				var T:Number = (P.y-y)/_falling_velocity
				if (P.x + P.velocity.x * T + P.width > x && P.x + P.velocity.x * T < x + width) {
					activate();
				}
				break;
			}
		}
		
		public function activate():void
		{
			//_activating_counter = 0.6;
			_active = true;
			_hanging = false;
			velocity.y = _falling_velocity;
		}
		public function deactivate():void
		{
			//_activating_counter = 0;
			_active = false;	
			velocity.y = 0;
		}
		
		public function save():void
		{
			if (_hanging) {
				_saved_y = _original_y;
			} else {
				_saved_y = 18*16;
			}
			_saved_velocity = velocity.y;
			_saved_active = _active;
			_saved_hanging = _hanging;
			
		}
		
		public function reload():void
		{
			y = _saved_y;
			velocity.y = _saved_velocity;
			_active = _saved_active;
			_hanging = _saved_hanging;
		}
	}
}