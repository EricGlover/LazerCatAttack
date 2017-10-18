package  {
	import flash.display.Sprite;
	import flash.display.Shape;
	
	public class Background extends Sprite{
		private var speed:Number = .5;
		/*private var layer1:Sprite;
		private var layer2:Sprite;
		private var layer3:Sprite;*/
		//starCount was 35, testing frame rate drops
		//change how you use star count in this
		private var starCount = 35;
		private var startW:int = 4;
		private var mod1:Number = .28;
		private var mod2:Number = .2;
		private var mod3:Number = .16;
		//attempted modification
		/*private var star1:Shape;
		private var star2:Shape;
		private var star3:Shape;*/
		private var layer1 = new Sprite;
		private var layer2 = new Sprite;
		private var layer3 = new Sprite;
		
		public function Background() {
			var layer;
			layer1.mouseEnabled = false;
			layer2.mouseEnabled = false;
			layer3.mouseEnabled = false;
			for (var l:int = 1; l <= 3; l ++) {
				if (l == 1) {
					layer = layer1;
				}else if (l == 2) {
					layer = layer2;
					starCount = 50;
				}else {
					layer = layer3;
					starCount = 190;
				}
				var star:Shape;
				var w:int; /*= startW - (l*1);*/
				var Sx:int;
				var Sy:int;
				
				for (var q:int = 0; q < starCount * l; q++) {
					//star = new Shape;
					//w = startW - (l*1);
					////DONT USE THIS.WIDTH OR HEIGHT, DEAR GOD
					////star.x = /*this.width * */Math.random();
					////star.y = /*this.height * */ Math.random();
					//star.x = 1000 * Math.random();
					//star.y = 1000 * Math.random();
					//star.graphics.beginFill(0xFFFFFF, 1);
					//star.graphics.lineStyle();
					//star.graphics.drawRect(0,0,w,w);
					//star.graphics.endFill();
					//layer.addChild(star);
					///*LazerCatAttack.game.addChild(star);*/
					w = startW - (l*1);
					Sx = 1000 * Math.random();
					Sy = 1000 * Math.random();
					layer.graphics.beginFill(0xFFFFFF, 1);
					layer.graphics.lineStyle();
					layer.graphics.drawRect(Sx,Sy,w,w);
					layer.graphics.endFill();
				}
				starCount = 35;
				addChild(layer);
			}	
			/*layer1.graphics.beginFill(0xCCCCCC, 1);
				layer1.graphics.lineStyle();
				var yl = layer1.x;
				var yy = layer1.y;
				var yz = layer1.width;
				var yx = layer1.height;
				layer1.graphics.drawRect(yl,yy,yz,yx);
				layer1.graphics.endFill();*/
		}
		//moves via the main game LCA file
		public function move() {
			/*this.y += speed;*/
			layer1.y += speed * mod1 * 3;
			layer2.y += speed * mod2 * 2;
			layer3.y += speed * mod3 * 1;
			if (this.y >= 600) {
				this.y = -1200;
				/*if (name == "b1") { 
					this
				}*/
			}	
		}
		//the player calls this to move the background and create the illusion of parallax
		public function parallax(xChange,yChange) {
			//layer differences and this.x += speed * -1 or something?
			layer1.x += xChange * -1 * mod1;
			layer1.y += yChange * -1 * mod1;
			layer2.x += xChange * -1 * mod2;
			layer2.y += yChange * -1 * mod2;
			layer3.x += xChange * -1 * mod3;
			layer3.y += yChange * -1 * mod3;
		}
	}
	
}
