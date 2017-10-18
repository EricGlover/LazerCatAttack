package  {
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.geom.Vector3D;
	import flash.media.Sound;
	
	
	public class Rocket extends MovieClip {
		public var justWarped:Boolean = false;
		
		public var position:Vector3D;
		private var selectedTarget;
		private var target:Vector3D;
		private var speed:int = 3;
		private var velocity:Vector3D;
		private var maxVelocity:int = 5;
		private var presetMaxV:int = 5;
		private var steering:Vector3D = new Vector3D();
		private var maxForce:Number = .08;
		private var mass:int = 1;
		private var acceleration:Number = .01;
		
		public var attached:Boolean = false;
		public var passed:Boolean = false;
		public var right:Boolean = false;
		public var left:Boolean = false;
		public var invincible:Boolean = false;
		//consider reworking the hitDelay to to greater granularity if it feels off.
		private var hitDelay:Number = .1;
		private var counter:int = 0;
		
		private var presetHP:int = 1;
		public var hitPoints:int = 1;
		public var points:int = 1;
		public var lazerHits:int = 0;
		public var playerKilledMe:Boolean = false;
		
		//direction 1=right 0=left
		public function Rocket() {
			/*LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);*/
			selectedTarget = LazerCatAttack.you;
			//set initial x velocity
			position = new Vector3D();
			target = new Vector3D();
			velocity = new Vector3D();
		}
		public function recycle(direction) {
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
			if (direction == 0) {
				velocity.setTo(speed, 0, 0);
			}else if (direction == 1) {
				velocity.setTo(-speed, 0, 0);	
			}			
			selectedTarget = LazerCatAttack.you;
			maxVelocity = presetMaxV;
			target.setTo(selectedTarget.x, selectedTarget.y, 0);
			hitPoints = presetHP;
			lazerHits = 0;
			steering.setTo(0,0,0);
			invincible = false;
		}
		private function loop(e:TimerEvent) {
			if (!attached) {
				if (hitTestObject(selectedTarget)) {
					velocity.x = 0;
					velocity.y = 0;
					maxVelocity = 1;
					//later change this to rotate slowly
					rotation = 0;
					//add a thing to rotate the graphic later
					//rework this
					var otherLeft:Boolean = false;
					var otherRight:Boolean = false;
					for (var i:int = 0; i < RocketDrone.rockets.length; i++) {
						if (RocketDrone.rockets[i].attached) {
							if (RocketDrone.rockets[i].left) {
								otherLeft = true;
							}
							if (RocketDrone.rockets[i].right) {
								otherRight = true;
							}
						}					
					}
					if (left && otherLeft) {
						hitPoints = 0;
						invincible = false;
						destroyYourself();
					}else if (right && otherRight) {
						hitPoints = 0;
						invincible = false;
						destroyYourself();
					}else {
						attached = true;
					}
				}
				position.x = this.x;
				position.y = this.y;
				if (left && !passed) {
					if (this.x > selectedTarget.x) {
						passed = true;
					}
				}else if (right && !passed) {
					if (this.x < selectedTarget.x) {
						passed = true;
					}
				}
				if (!passed) {
					target.x = selectedTarget.x;
					target.y = selectedTarget.y;
					steering = seek(target);
					//edited
					steering.x = 0;
					truncate(steering, maxForce);
					steering.scaleBy(1/mass);
					velocity = velocity.add(steering);
					truncate(velocity, maxVelocity);
				}
				position.x += velocity.x;
				position.y += velocity.y;
				this.x = position.x;
				this.y = position.y;
			}else if (attached) {
				velocity.y -= acceleration;
				truncate(velocity, maxVelocity);
				//this only works with player cause vy
				//consider adding a x velocity component
				selectedTarget.y += velocity.y; 
				if (right) {
					this.x = selectedTarget.x + selectedTarget.width/2 + this.width/2;
					this.y = selectedTarget.y;
				}
				if (left) {
					this.x = selectedTarget.x - selectedTarget.width/2 - this.width/2;
					this.y = selectedTarget.y;
				}
				//if you hit something then die:player bullets, player lazer, crusher?, enemies, 
				//consider adding if (!invincible) { code below}
				for (var i:int = 0; i < LazerCatAttack.enemyList.length; i++) {
					if (LazerCatAttack.enemyList[i] != null) {
						if (hitTestObject(LazerCatAttack.enemyList[i])) {
							/*LazerCatAttack.huD.updateScore(LazerCatAttack.enemyList[i].points);*/
							if (LazerCatAttack.enemyList[i] is BatonRam) {
								destroyYourself();
								invincible = true;
								/*LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, hitTimer);*/
							}else {
								LazerCatAttack.enemyList[i].playerKilledMe = true;
								LazerCatAttack.enemyList[i].destroyYourself();
								//remove the rocket
								this.destroyYourself();
								this.invincible = true;
								/*LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, hitTimer);*/
							}	
						}
					}	
				}
				for (var i:int = 0; i < DroneShip.bullet.length; i++) {
					if (hitTestObject(DroneShip.bullet[i])) {
						DroneShip.bullet[i].removeDroneShipBullet();
						this.destroyYourself();
						this.invincible = true;
						/*LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, hitTimer);*/
					}
				}
				for (var i:int = 0; i < LazerCatAttack.lazerDroneList.length; i ++) {
					if (hitTestObject(LazerCatAttack.lazerDroneList[i])) {
						LazerCatAttack.lazerDroneList[i].destroyYourself();
						destroyYourself();
						invincible = true;
						/*LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, hitTimer);*/
					}
				}
				for (var i:int = 0; i < LazerDrones.lazers.length; i++) {
					if (hitTestObject(LazerDrones.lazers[i])) {
						destroyYourself();
						invincible = true;
						/*LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, hitTimer);*/
					}
				}
				for (var i:int = 0; i < lv1Boss.bullet.length; i++) {
					if (hitTestObject(lv1Boss.bullet[i])){
						lv1Boss.bullet[i].remove();
						destroyYourself();
						invincible = true;
						/*LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, hitTimer);*/
					}
				}
				for (var lv:int = LazerCatAttack.bossVector.length - 1; lv >= 0; lv--) {
					if (hitTestObject(LazerCatAttack.bossVector[lv])) {
						LazerCatAttack.bossVector[lv].remove();
						destroyYourself();
						invincible = true;
						/*LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, hitTimer);*/
					}	
				}
			}
		}
		/*public function hitTimer(e:TimerEvent) {
			counter ++;
			if (counter >= hitDelay * LazerCatAttack.frameSpeed) {
				counter = 0;
				invincible = false;
				LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, hitTimer);
			}
		}*/
		private function seek (target) {
			var force:Vector3D;
			var desired:Vector3D = new Vector3D();
			//seek for just y value
			desired.y = target.y - position.y;
			desired.normalize();
			desired.scaleBy(maxVelocity);
			force = desired.subtract(velocity);
			truncate(force, maxForce);
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
		//this is called by pokeball to catch the enemy
		public function onCatch() {
			//just destroy it for now
			hitPoints = 0;
			invincible = false;
			destroyYourself();
		}
		public function destroyYourself () {
			if (!invincible) {
				hitPoints --;
				/*var snd:Sound = new HitSound;
				Main.sound.playFX(snd);*/
			}
			if (hitPoints <= 0) {
				//remove
				RocketDrone.rockets.splice(RocketDrone.rockets.indexOf(this), 1);
				LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
				/*LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, hitTimer);*/
				counter = 0;
				passed = false;
				LazerCatAttack.game.removeChild(this);
				//parent.removeChild(this);
				RocketDrone.rocketPool.push(this);
				attached = false;
				left = false;
				right = false;
				/*var snd:Sound = new EnemyDeathSound;
				Main.sound.playFX(snd);*/
				/*LazerCatAttack.enemyList.splice(LazerCatAttack.enemyList.indexOf(this), 1);*/
				if (playerKilledMe) {
					LazerCatAttack.huD.updateScore(this.points);
				}
			/*}else {
				var snd:Sound = new HitSound;
				Main.sound.playFX(snd);*/
			}
		}
	}
	
}
