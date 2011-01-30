package  
{
    import org.flixel.*;
	import flash.display.Bitmap;

    public class Tree extends FlxSprite
    {
        [Embed(source = "img/tree_01_anim.png")] private var ImgTree01:Class;
        [Embed(source = "img/tree_02_anim.png")] private var ImgTree02:Class;
        [Embed(source = "img/tree_03_anim.png")] private var ImgTree03:Class;
		
		private var imgWidth:Number;
		private var imgHeight:Number;
		private var imgX:Number;
		private var imgY:Number;
		
		private var fruitTimer:Number = 0;
		private const growthLimit:Number = 6;
		private var growthTimer:Number = growthLimit;
		private const childSize:Number = 0.3;
		
		private var ageTimer:Number = 0;
		private const dyingTime:Number = 20;
		private var startDecay:Boolean = false;
		
		private var _playstate:PlayState;
		
		private var _keepFlashingRedTimer:Number = 0;
		private var _invincibleTimer:Number = 0;
		
		private var _remainDeadTimer:Number = 0;
		
        public function Tree(X:Number,Y:Number, p:PlayState, adult:Boolean = true):void
        {
			super(X, Y);
			
			_playstate = p;
			
			var index:Number = Math.floor(Math.random() * 3);
			var ImgData:Bitmap;
			var Img:Class
			
			switch(index) {
				case 0: 
					ImgData = new ImgTree01();
					Img = ImgTree01;
				break;
				case 1:
					ImgData = new ImgTree02();
					Img = ImgTree02;
				break;
				case 2:
					ImgData = new ImgTree03();
					Img = ImgTree03;
				break;
			}
			
			imgWidth = (ImgData as Bitmap).width/4;
			imgHeight = (ImgData as Bitmap).height;
			imgX = x;
			imgY = y;
			
			fruitTimer = Math.random() * 10 + 5;
			if (adult)
				growthTimer = 0;
			else {
				scale.x = childSize;
				scale.y = childSize;
			}
			if (scale.y <= 1) {
				y = imgY + imgHeight * (1 - scale.y) * 0.45;
			}
			fixed = true;
			
			
			loadGraphic(Img, true, false, imgWidth, imgHeight);
			addAnimation("normal", [0], 10);
			addAnimation("decay", [0, 1, 2, 3], 0.2);
			addAnimation("dead", [3], 10);
			
			switch(index) {
				case 0: 
					width = 48;
					height = 19;
					offset.x = 61;
					offset.y = 179;
				break;
				case 1:
					width = 53;
					height = 18;
					offset.x = 54;
					offset.y = 198;
				break;
				case 2:
					width = 47;
					height = 22;
					offset.x = 62;
					offset.y = 166;
				break;
			}
			
        }
		
        override public function update():void
        {	
			if ( _remainDeadTimer > 0 ) {
				velocity.x = velocity.y = 0;
				if ( _keepFlashingRedTimer > 0 ) {
					_keepFlashingRedTimer -= FlxG.elapsed;
					color = 0xFF0066;
				} else {
					color = 0x00ffffff;
					_keepFlashingRedTimer = 0;
				}
				// TODO needs to be "chopped"
				play("dead");
				_remainDeadTimer -= FlxG.elapsed;
				if ( _remainDeadTimer <= 0 ) {
					kill();
				}
				super.update();
				return;
			}
			
            super.update();
			if (growthTimer > 0) {
				growthTimer -= FlxG.elapsed; 
				var newScale:Number = (growthLimit - growthTimer) * (1 - childSize) / growthLimit + childSize;
				if (growthTimer <= 0)
					newScale = 1;
				scale.x = newScale;
				scale.y = newScale;
			} else {
				if (!startDecay) {
					if (fruitTimer > 0)
						fruitTimer -= FlxG.elapsed;
					play("normal");
				} else {
					ageTimer += FlxG.elapsed;
					if (ageTimer < dyingTime) {
						play("decay");
					} else {
						_playstate.removeEntity(this, _playstate._trees);
						play("dead");
					}
				}
				
			}
			
			if (scale.y <= 1) {
				y = imgY + imgHeight * (1 - scale.y) * 0.45;
			}
			
			if ( _keepFlashingRedTimer > 0 ) {
				_keepFlashingRedTimer -= FlxG.elapsed;
				color = 0xFF0066;
			} else {
				color = 0x00ffffff;
				_keepFlashingRedTimer = 0;
			}
			if ( _invincibleTimer > 0 ) {
				_invincibleTimer -= FlxG.elapsed;
			}
        }
		
		public function wantsFruit():Boolean
		{
			return growthTimer <= 0 && fruitTimer <= 0;
		}
		
		public function getFruit():Fruit
		{
			fruitTimer = Math.random() * 10 + 5;
			
			
			// originalPos
			var oX : Number = imgX - offset.x + (Math.random() * 0.5 + 0.25) * imgWidth;
			var oY : Number = imgY - offset.y + (Math.random() * 0.25 + 0.25) * imgHeight;
			
			// feetPos
			var feetX : Number = x + width / 2;
			var feetY : Number = y + height / 2;
			
			var fruit:Fruit = new Fruit(oX, oY, _playstate);
			fruit.launch( oX, oY, feetX, feetY );
			
			return fruit;
		}
		
		
		public function markForDeath() : void
		{
			startDecay = true;
		}
		
		public function killedByEnemy():void {
			_remainDeadTimer = 5;
			_keepFlashingRedTimer = 0.2;
			_playstate.isOkToChopTree = false;
			_playstate.removeEntityFromArrayOnly( this, _playstate._trees);
		}
		
		public function takeHumanDamage():void
		{
			if ( _invincibleTimer <= 0 ) {
				health -= 0.2;
				if ( health <= 0 ) {
					killedByEnemy();
				} else {
					_keepFlashingRedTimer += 0.3;
					_invincibleTimer += 1.2;
				}
			}
		}
    }
    
} 