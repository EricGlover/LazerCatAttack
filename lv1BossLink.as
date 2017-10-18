package  {
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	
	public class lv1BossLink extends MovieClip{
		
		public var reflectorEnabled:Boolean = false;
		public var lazerHits:int = 0;
		public var points:int = 0;
		public var playerKilledMe:Boolean = false;
		
		public function lv1BossLink(x,y,length,rotation) {
			this.x = x;
			this.y = y;
			this.width = length;
			this.rotation = rotation;
			/*LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);*/
			mouseEnabled = false;
		}
		///left boss1 does updates
		/*private function loop (e:TimerEvent) {
			
		}
		*/
		public function remove () {
			if (playerKilledMe) {
				LazerCatAttack.huD.updateScore(this.points);
			}
			/*trace("Link trying to remove");*/
			lv1Boss.lv1BossLinks.splice(lv1Boss.lv1BossLinks.indexOf(this), 1);
			playerKilledMe = false;
			/*LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);*/
			LazerCatAttack.game.removeChild(this);
		}

	}
	
}
