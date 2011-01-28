package  
{
	
	import org.flixel.*;
	
	public class RubberBand extends FlxSprite
	{
		[Embed(source = "img/RubberBand-45.png")] private var ImgRubberBand_45:Class;
		[Embed(source = "img/RubberBand-135.png")] private var ImgRubberBand_135:Class;
		[Embed(source = "img/RubberBand-0.png")] private var ImgRubberBand_0:Class;
		[Embed(source = "img/RubberBand-90.png")] private var ImgRubberBand_90:Class;
		
		private var _activating_counter:Number = 0;
		private var _active:Boolean = false;
		private var _angle_facing:uint;
		private var _bounce_factor:Number = 1.2;
		
		public function RubberBand(X:Number, Y:Number, Angle:uint) 
		{
			super(X, Y);
			
			switch (Angle) {
				case 45:
					loadGraphic(ImgRubberBand_45, true, false, 16, 16);
					break;
				case 135:
					loadGraphic(ImgRubberBand_135, true, false, 16, 16);
					break;
				case 0:
					loadGraphic(ImgRubberBand_0, true, false, 16, 16);
					break;
				case 90:
					loadGraphic(ImgRubberBand_90, true, false, 16, 16);
					break;
				
			}			
			
			width = 16;
			height = 16;	
			//offset.x = 4;
			//offset.y = 4;
			fixed = true;
            
            addAnimation("idle", [0], 5);
			addAnimation("trig", [1, 2, 1, 0, 3, 4, 3, 0, 1, 2, 1, 0, 3, 4, 3, 0, 1, 0, 3, 0, 1, 0, 3, 0], 16);
			
			_angle_facing = Angle;
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
			_activating_counter = 20.0/16.0;
			_active = true;
		}
		public function deactivate():void
		{
			_activating_counter = 0;
			_active = false;			
		}
		
		public function resolveBounce(P:Player):void
		{
			var vx:Number = P.velocity.x;
			var vy:Number = P.velocity.y;

			collide(P);				
			P._floor_was_hit = false;
					
			switch (_angle_facing) {
				case 45:					
					P.velocity.y = -vx * _bounce_factor;
					P.velocity.x = -vy * _bounce_factor;					
				break;
				
				case 135:
					P.velocity.y = vx * _bounce_factor;
					P.velocity.x = vy * _bounce_factor;
				break;
				
				case 0:
					P.velocity.y = -vy * _bounce_factor;
				break;
				
				case 90:
					P.velocity.x = -vx * _bounce_factor;
				break;
			}
			
			//P.x += P.velocity.x * FlxG.elapsed;
			//P.y += P.velocity.y * FlxG.elapsed;
			
			activate();
		}
	}
}
	
