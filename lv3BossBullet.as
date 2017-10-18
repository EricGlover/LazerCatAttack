package  {
	
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	import flash.events.TimerEvent;
	
	//fix bullets so that they can't turn around more than once or twice tops.
	public class lv3BossBullet extends MovieClip {
		public var position:Vector3D = new Vector3D();
		public var velocity:Vector3D;
		private var steering:Vector3D = new Vector3D();
		private var desired:Vector3D = new Vector3D();
		private var target:Vector3D = new Vector3D();
		private var selectedTarget:*;
		private var mass = 1;
		private var maxForce = .2;
		private var maxVelocity = 10; 
		private var maxXForce = 4;
		private var maxYForce = 1.1;
		public var homing:Boolean = true;
		private var homingCutOff:int = 170;
		public var lazerHits:int = 0;
		public var swipe:Boolean = false;
		public var focus:Boolean = false;
		public var playerKilledMe:Boolean = false;
		public var points:int = 0;
		
		public function lv3BossBullet(firstVelocity:Vector3D, target/*,attackAngle*/) {
			//sets the direction from which the bullet attacks the player
		/*	if (attackAngle == true) {
				swipe = true;
			}else if (attackAngle == false) {
				focus = true;
				maxVelocity = 15;
				maxForce = 1;
			}*/
			velocity = firstVelocity;
			selectedTarget = target;
			this.target.setTo(selectedTarget.x, selectedTarget.y, 0);
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
			position.setTo(this.x, this.y, 0);
			mouseEnabled = false;
		}
		
		private function loop(e:TimerEvent) {
			//movement stuffs
			position.x = this.x;
			position.y = this.y;
			/*target.setTo(selectedTarget.x, selectedTarget.y, 0);*/
			//turn off tracking behavior if bullets are about to hit player
			if (homing) {
				target.setTo(selectedTarget.x, selectedTarget.y, 0);
				if (LazerCatAttack.you.y < this.y && this.velocity.y < 0 && distance(this, target) < homingCutOff) {
					if (LazerCatAttack.you.x > this.x && this.velocity.x > 0) { 
						homing = false;
					}
				}else if (LazerCatAttack.you.y > this.y && this.velocity.y > 0 && distance(this, target) < homingCutOff) {
					if (LazerCatAttack.you.x < this.x && this.velocity.x < 0) { 
						homing = false;
					}
				}else {
					//nothing
				}
				steering = seek(target);
				truncate(steering, maxForce);
				steering.scaleBy(1/mass);
				velocity = velocity.add(steering);
			}
			truncate(velocity, maxVelocity);
			position = position.add(velocity);
			this.x = position.x;
			this.y = position.y;
			if (hitTestObject(LazerCatAttack.you)) {
				LazerCatAttack.you.invincible = false;
				LazerCatAttack.you.killPlayer();
				this.remove();
			}
			if (this.x + this.width > 550 * 2 || this.x - this.width < 0 - 555|| this.y - this.height < 0 - 600|| this.y + this.height > 650 + 650) {
				remove();
			}
		}
		
		//consider using composition for this stuff 
		public function seek(target:Vector3D):Vector3D {
			var force:Vector3D;
			desired = target.subtract(position);
			desired.normalize();
			desired.scaleBy(maxVelocity);
			/*desired.x *= maxXForce;
			desired.y *= maxYForce;*/
			force = desired.subtract(velocity);
			return force;
		}
		public function truncate(vector:Vector3D, max:Number):void {
			var i:int;
			i = vector.length/max;
			if (i > 1) {
				if (max == 0) {
					trace("error, @ lv2 boss truncate");
				}else{
					vector.scaleBy(1/i);	
				}
			}
		}
		public function distance(a, b):int {
			return (Math.sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y)));
		}
		
		public function remove() {
			LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
			//recent change
			if (lv3Boss.bob != null) {
				lv3Boss.bob.bobsBurgers.splice(lv3Boss.bob.bobsBurgers.indexOf(this), 1);
			}
			LazerCatAttack.game.removeChild(this);
			if (playerKilledMe) {
				LazerCatAttack.huD.updateScore(this.points);
			}
			playerKilledMe = false;
		}
	}
	
}
