package  {
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.geom.Vector3D;
	import flash.media.Sound;
	
	
	public class RocketDrone extends MovieClip {
		public var justWarped:Boolean = false;
		public static var rockets:Array = new Array();
		public static var rocketPool:Vector.<Rocket> = new Vector.<Rocket>;
		private var position:Vector3D;
		private var selectedTarget;
		private var target:Vector3D;
		private var speed:int = 3;
		private var velocity:Vector3D;
		private var maxVelocity:int = 2;
		private var steering:Vector3D = new Vector3D();
		private var maxForce:int = 2;
		private var mass:int = 1;
		//there position warp problem
		private var there:Boolean = false;
		private var fireRange:int = 2;
		public var right:Boolean = false;
		public var left:Boolean = false;
		
		private var hitPoints:int = 1;
		private var presetHitPoints:int = 1;
		public var points:int = 1;
		public var lazerHits:int = 0;
		public var playerKilledMe:Boolean = false;
		
		public function RocketDrone() {
			/*LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);*/
			position = new Vector3D(this.x, this.y, 0);
			velocity = new Vector3D(0, speed, 0);
			selectedTarget = LazerCatAttack.you;
			target = new Vector3D(selectedTarget.x, selectedTarget.y, 0);
		}
		public function recycle() {
			target.setTo(selectedTarget.x, selectedTarget.y, 0);
			position.setTo(this.x, this.y, 0);
			velocity.setTo(0, speed, 0);
			hitPoints = presetHitPoints;
			lazerHits = 0;
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
		}
		public function loop(e:TimerEvent) {
			//fall towards player y
			position.x = this.x;
			position.y = this.y;
			target.x = selectedTarget.x;
			target.y = selectedTarget.y;
			if (target.y > this.y) {
				velocity.y = 2;
			}
			if (target.y < this.y) {
				velocity.y = -2;
			}
			truncate(velocity, maxVelocity);
			position.y += velocity.y;
			this.x = position.x;
			this.y = position.y;
			
			if (this.y + fireRange > selectedTarget.y && this.y - fireRange < selectedTarget.y) {
				there = true;
			}
			if (there) {
				fire();
			}
			//when both in position shoot targeting missiles towards player
		}
		private function fire() {
			//fire targeting rocket packs
			if (right) {
				if (RocketDrone.rocketPool.length > 0) {
					var rockette:Rocket = RocketDrone.rocketPool.pop();
				}else {
					var rockette:Rocket = new Rocket();
				}
				rockette.recycle(1);
				rockette.right = true;
				rockette.rotation = -90;
			}
			if (left) {
				if (RocketDrone.rocketPool.length > 0) {
					var rockette:Rocket = RocketDrone.rocketPool.pop();
				}else {
					var rockette:Rocket = new Rocket();
				}
				rockette.recycle(0);
				rockette.left = true;
				rockette.rotation = 90;
			}
			rockette.y = this.y;
			rockette.x = this.x;
			RocketDrone.rockets.push(rockette);
			LazerCatAttack.game.addChild(rockette);
			//remove self
			destroyYourself();
		}
		private function seek (target) {
			var force:Vector3D;
			var desired:Vector3D = new Vector3D();
			desired = target.subtract(position);
			desired.normalize();
			desired.scaleBy(maxVelocity);
			force = desired.subtract(velocity);
			return force;
		}
		private function truncate(vector:Vector3D, max:Number):void {
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
		public function onCatch(xDif, yDif) {
			//just destroy it for now
			hitPoints = 0;
			destroyYourself();
		}
		public function destroyYourself () {
			hitPoints --;
			if (hitPoints <= 0) {
				//remove
				there = false;
				//10/6/14
				right = false;
				left = false;
				LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
				LazerCatAttack.game.removeChild(this);
				LazerCatAttack.enemyList.splice(LazerCatAttack.enemyList.indexOf(this), 1);
				LazerCatAttack.game.rocketDPool.push(this);
				if (playerKilledMe) {
					LazerCatAttack.huD.updateScore(this.points);
					/*var snd:Sound = new HitSound;
					Main.sound.playFX(snd);*/
				}
			/*}else {
				var snd:Sound = new HitSound;
				Main.sound.playFX(snd);*/
			}
		}
	}
	
}
