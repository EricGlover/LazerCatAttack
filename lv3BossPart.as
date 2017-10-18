package  {
	
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	import flash.events.TimerEvent;
	
	
	public class lv3BossPart extends MovieClip {
		public var velocity:Vector3D;
		public var position:Vector3D;
		public var health:int = 1;
		public var points:int = 1;
		public var playerKilledMe:Boolean = false;
		public var key:Boolean = false;
		public var lazerHits:int = 0;
		
		public function lv3BossPart(vel:Vector3D) {
			velocity = vel;
			mouseEnabled = false;
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
			position = new Vector3D(this.x, this.y, 0);
		}
		
		private function loop (e:TimerEvent) {
			position.x = this.x;
			position.y = this.y;
			position = position.add(velocity);
			this.x = position.x;
			this.y = position.y;
			if (hitTestObject(LazerCatAttack.you)) {
				destroyYourself();
			}
		}
		public function onCatch(xDif, yDif) {
			//explode
			health = 0;
			destroyYourself();
		}
		public function destroyYourself() {
			if (health <= 0) {
				LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
				LazerCatAttack.enemyList.splice(LazerCatAttack.enemyList.indexOf(this), 1);
				lv3Boss.parts.splice(lv3Boss.parts.indexOf(this),1);
				LazerCatAttack.game.removeChild(this);
				if (playerKilledMe) {
					LazerCatAttack.huD.updateScore(this.points);
				}
			}
			health --;
			playerKilledMe = false;
		}
	}
	
}
