package  {
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.geom.Vector3D;
	
	
	public class lv2BossBullet extends MovieClip {
		private var selectedTarget:*;
		private var position:Vector3D = new Vector3D();
		private var target:Vector3D = new Vector3D();
		private var desired:Vector3D = new Vector3D();
		private var maxVelocity:int = 2;
		private var velocity:Vector3D = new Vector3D();
		
		public function lv2BossBullet(fireTarget:Object, myX:Number, myY:Number) {
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop); 
			mouseEnabled = false;
			selectedTarget = fireTarget;
			this.x = myX;
			this.y = myY;
			position.x = this.x;
			position.y = this.y;
			target.x = selectedTarget.x;
			target.y = selectedTarget.y;
			desired = target.subtract(position);
			truncate(desired, maxVelocity);
			velocity = desired.clone();
		}
		
		public function loop(e:TimerEvent) {
			//movement, find the line between you and player when fired and ride it 
			position.x = this.x;
			position.y = this.y;
			if (LazerCatAttack.you != null) {
				if (LazerCatAttack.you.crushMasta != null) {
					if (hitTestObject(LazerCatAttack.you.crushMasta)) {
						destroyYourself();
					}
				}
				if (hitTestObject(LazerCatAttack.you)) {
					LazerCatAttack.you.killPlayer();
					destroyYourself();
				}
			}	
			if (Cat.daCat != null) {
				if (hitTestObject(Cat.daCat)) {
					Cat.daCat.destroyYourself();
					/*LazerCatAttack.huD.updateScore(this.points);*/
					destroyYourself();
				} 
			}
			position = position.add(velocity);
			this.x = position.x;
			this.y = position.y;
			if (this.x > 500 + this.width || this.x < 0 - this.width || this.y > 600 + this.height || this.y < 0 -this.height) {
				destroyYourself();
			}
		}
		private function truncate(vector:Vector3D, max:Number):void {
			var i:int;
			i = vector.length/max;
			if (i > 1) {
				if (max == 0){
					trace("error, @lv2BossBullet truncate");
				}else {
					vector.scaleBy(1/i);
				}
			}
		}
		
		public function destroyYourself() {
			LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
			lv2Boss.bullet.splice(lv2Boss.bullet.indexOf(this), 1);
			if (LazerCatAttack.game.contains(this)) {
				LazerCatAttack.game.removeChild(this);
			}
		}
	}
	
}
