package  {
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	
	
	public class Checkpoint extends MovieClip {
		private var count:int;
		private var screenTime:Number = 2.5;
		
		public function Checkpoint() {
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
		}
		public function loop(e:TimerEvent) {
			//flicker
			/*if (count > flickerRate) {
				flickerRate *= 2;
				this.visible = false;
			}*/
			if (count > screenTime * 60) {
				remove();
			}
			count ++;
		}
		public function remove() {
			parent.removeChild(this);
			LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
			/*var schim = parent;
			schim is LazerCatAttack;
			schim.checkpoint = null;*/
		}
	}
	
}
