package  {
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	
	
	public class batonHit extends MovieClip {
		public var playerKilledMe:Boolean = false;
		public var points:int = 0;
		public var lazerHit;
		public var invincible:Boolean = false;
		public var myPops;
		private var first:int = 0;
		
		public function batonHit() {
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
			mouseEnabled = false;
		}
		private function loop (e:TimerEvent) {
			//collision tests here
			if (first == 0) {
				myPops = parent;
				myPops is Baton;
				first++;
			}
		}
		//this funciton takes the hits
		public function destroyYourself() {
			if (!invincible) {
				switch (name) {
					case "rightHit":
						myPops.rightHit();
						break;
					case "midHit":
						myPops.midHit();
						break;
					case "leftHit":
						myPops.leftHit();
						break;
					default:
						//nothing
				}
			}
		}
		public function onCatch(xDif, yDif) {
			myPops.onCatch(xDif, yDif);
			trace("batonhit was hit by pokeball");
		}
		//parent calls this function to remove the hitboxes
		public function remove() {
			LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
			LazerCatAttack.enemyList.splice(LazerCatAttack.enemyList.indexOf(this), 1);
			if (parent.contains(this)){
				parent.removeChild(this);
			}
		}
	}
	
}
