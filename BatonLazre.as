package  {
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
	public class BatonLazre extends MovieClip {
		private var count:int = 0;
		
		public function BatonLazre() {
			// constructor code
			//kill shit
			mouseEnabled = false;
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
		}
		public function loop(e:TimerEvent) {
			count ++;
			if (LazerCatAttack.you != null) {
				if (hitTestObject(LazerCatAttack.you)) {
					LazerCatAttack.you.killPlayer();
				}
			}
		}
		public function remove() {
			LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
			if (LazerCatAttack.game.contains(this)) {
				LazerCatAttack.game.removeChild(this);
			}
		}
	}
	
}
