package  {
	import flash.display.*;
	import flash.events.TimerEvent;
	import flash.geom.Vector3D;
	
	public class lv1BossBullet extends MovieClip{
		private var bulletSpeed:int;
		public var lazerHits:int = 0;
		public var points:int = 0;
		public var playerKilledMe:Boolean = false;
		//list the 6 potential paths
		//or program in an initial burst from the boss, and do some vector velocity shit

		public function lv1BossBullet(/*seeking, targetObject,*/ bulletSpeed/*, totalMass, velocity*/) {
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
			this.bulletSpeed = bulletSpeed/2;
			mouseEnabled = false;
		}
		
		private function loop (e:TimerEvent) {
			this.y += bulletSpeed;
			if (LazerCatAttack.you != null) {
				if (hitTestObject(LazerCatAttack.you)) {
				LazerCatAttack.you.killPlayer();
				remove();
			}
			}
			if (this.y > 600) {
				remove();
			}
		}
		public function remove () {
			if (playerKilledMe) {
				LazerCatAttack.huD.updateScore(this.points);
			}
			playerKilledMe = false;
			LazerCatAttack.game.removeChild(this);
			lv1Boss.bullet.splice(lv1Boss.bullet.indexOf(this), 1);
			LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
		}

	}
	
}
