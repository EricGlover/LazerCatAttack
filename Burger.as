package  {
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	
	public class Burger extends MovieClip {
		private var points:int = 0;
		private var speed:int = 2;
		
		public function Burger() {
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
			x = Math.random() * 500;
			if (x - this.width < 0) {
				x = 30;
			}else if (x + this.width > 500) {
				x = 500 - 30;
			}
			y = -20;
			this.mouseEnabled = false;
		}
		public function loop(e:TimerEvent) {
			//movement
			this.y += speed;
			
			if (LazerCatAttack.you != null) {
				if (hitTestObject(LazerCatAttack.you)) {
					destroyYourself();
					LazerCatAttack.you.eat();
				}
			}
			//off-screen delete
			if (this.y > 630) {
				destroyYourself();
			}
		}
		public function destroyYourself() {
			LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
			parent.removeChild(this);
			//remove from any lists
		}
	}
}
