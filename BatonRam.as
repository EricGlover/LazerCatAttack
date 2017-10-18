package  {
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	
	
	public class BatonRam extends MovieClip {
		private var hits:int = 0;
		private var damage:int = 3;
		public var playerKilledMe:Boolean;
		
		public function BatonRam() {
			// constructor code
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
			mouseEnabled = false;
		}
		public function loop (e:TimerEvent) {
			//block everything
			//player bulelts, and lazers and pokeballs? should block crusher
			//if (LazerCatAttack.you != null) {
			//	if (LazerCatAttack.you.crushMasta != null) {
			//		if (hitTestObject(crushMasta) {
			//			//do something...
			//		}
			//	}
			// if (you.pokeball) {
			//      //do something
			//	}
			//}
			for (var i:int = 0; i < Player.playerBullets.length; i ++) {
				if (hitTestObject(Player.playerBullets[i])) {
					Player.playerBullets[i].removeBullet();
					//do a flash hit animation
				}
			}
			if (LazerCatAttack.you != null) {
				if (hits < damage && hitTestObject(LazerCatAttack.you)) {
					LazerCatAttack.you.killPlayer();
					hits++;
				}
			}
			
		}
		public function onCatch(xDif, yDif) {
			//fuck up that pokeBall
		}
		public function remove() {
			LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
			LazerCatAttack.game.removeChild(this);
			LazerCatAttack.enemyList.splice(LazerCatAttack.enemyList.indexOf(this), 1);
		}
	}
	
}
