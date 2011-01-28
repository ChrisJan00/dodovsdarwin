package  
{
	
	import org.flixel.*;
	
	public class Bouncer extends FlxSprite
	{
		[Embed(source = "img/Bouncer_up.png")] private var ImgBouncer_up:Class;
		[Embed(source = "img/Bouncer_dn.png")] private var ImgBouncer_dn:Class;
		[Embed(source = "img/Bouncer_lt.png")] private var ImgBouncer_lt:Class;
		[Embed(source = "img/Bouncer_rt.png")] private var ImgBouncer_rt:Class;
		
		private var _activating_counter:Number = 0;
		private var _active:Boolean = false;
		private var _bounce_small:Number = 300;
		private var _bounce_big:Number = 350;
		public function Bouncer(X:Number, Y:Number, Direction:uint) 
		{
			super(X, Y);
			
			switch (Direction) {
				case UP:
					loadGraphic(ImgBouncer_up, true, false, 16, 24);
					offset.x = 0;
					offset.y = 4;
					break;
				case DOWN:
					loadGraphic(ImgBouncer_dn, true, false, 16, 24);
					offset.x = 0;
					offset.y = 4;
					break;
				case LEFT:
					loadGraphic(ImgBouncer_lt, true, false, 24, 16);
					offset.x = 4;
					offset.y = 0;
					break;
				case RIGHT:
					loadGraphic(ImgBouncer_rt, true, false, 24, 16);
					offset.x = 4;
					offset.y = 0;
					break;
				
			}			
			
			width = 16;
			height = 16;			
			fixed = true;
            
            addAnimation("idle", [0, 1], 5);
			addAnimation("trig", [2, 3, 4], 5);
			
			_facing = Direction;
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
			_activating_counter = 0.6;
			_active = true;
		}
		public function deactivate():void
		{
			_activating_counter = 0;
			_active = false;			
		}
		
		public function resolveBounce(P:Player):void
		{
			collide(P);
			switch (facing) {
				case FlxSprite.UP:
				if (P.x + P.width >= x && P.x <= x + width && P.y + P.height <= y) {
					P._floor_was_hit = false;
					if (FlxG.keys.pressed("J")) {
						P.velocity.y = -_bounce_big;
					} else { P.velocity.y = -_bounce_small; }
					activate();
				}
				break;
				
				case FlxSprite.DOWN:
				if (P.x + P.width >= x && P.x <= x + width && P.y >= y+height) {
					P.velocity.y = _bounce_small;
					activate();
				}
				break;
				
				case FlxSprite.LEFT:
				if (P.y + P.height >= y && P.y <= y + height && P.x + P.width <= x) {
					if (FlxG.keys.pressed("LEFT")) {
						P.velocity.x = -_bounce_big;
					} else { P.velocity.x = -_bounce_small; }
					activate();
				}
				break;
				
				case FlxSprite.RIGHT:
				if (P.y + P.height >= y && P.y <= y + height && P.x >= x + width) {
					if (FlxG.keys.pressed("RIGHT")) {
						P.velocity.x = _bounce_big;
					} else { P.velocity.x = _bounce_small; }
					activate();
				}
				break;
			}
		}
	}
}