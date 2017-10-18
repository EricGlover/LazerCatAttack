package  {
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.Point;
	import flash.media.Sound;
	
	public class DroneShip extends MovieClip{
		public var vy = 3;
		public var vx = 0;
		public var va = .1;
		public var maxVelocity = 1.5;
		public static var speed:Number = 1.5;
		public var speed:Number = 1.5;
		public var justWarped:Boolean = false;
		//drone firing add per second
		private var canFire:Boolean = false;
		private var fCount:int = 0;
		//in seconds
		public static var fInterval:Number = .5;
		public static var fireMod:Number = 1;
		public var fInterval:Number = .5;
		public var fireMod:Number = 1;
		/*private var fireTimer:Timer;*/
		public static var bulletPool:Vector.<DroneShipBullet> = new <DroneShipBullet>[];
		public var invincible:Boolean = false;
		public var freeMovement:Boolean = true;
		public var points:int = 1;
		public var lazerHits:int = 0;
		//deathBallerz uses this
		public var groupie:Boolean = false;
		public var xThere:Boolean = false;
		public var yThere:Boolean = false;
		public var inPosition:Boolean = false;
		public var dB:DeathBallerz;
		public static var width:int = 30;
		public static var height:int = 60;
		
		public var h:int = 0;
		public var hitPoints:int = 1;
		public var presetHitPoints:int = 1;
		public static var bullet:Array = new Array();
		public var playerKilledMe:Boolean = false;
		
		//listing
		public static var listing:Boolean = true;
		private var listSpeed = .2;
		
		//testing pokeball
		public var caught:Boolean = false;
		
		//I think changing the drone movement would make them more fearsome, if they listed lazily
		
		public function DroneShip() {
			/*LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);*/
			//x = Math.random() * 500; //LazerCatAttack.game width
			//y = -70;
			this.height = 38;
			this.width = 30;
			fInterval = DroneShip.fInterval;
			fireMod = DroneShip.fireMod;
			speed = DroneShip.speed;
			listing = DroneShip.listing;
			vy = speed;
			/*otherEnemies.splice(LazerCatAttack.enemyList.indexOf(this),1);*/
			/*LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, droneFireTimerHandler);*/
			//make DroneShips not overlap :not working.... try running a initialized complete listener to this as a function and put it out of the constructor method.
			/*for (var i:int = 0; i < otherEnemies.length; i++) {
					if (hitTestObject(otherEnemies[i])) {
						destroyYourself();
						trace("5..3..2.1.Kablewy");
					}
			}*/
		}
		public function recycle() {
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, droneFireTimerHandler);
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
			x = Math.random() * 500; //LazerCatAttack.game width
			y = -70;
			this.height = 38;
			this.width = 30;
			fInterval = DroneShip.fInterval;
			fireMod = DroneShip.fireMod;
			speed = DroneShip.speed;
			caught = false;
			vy = speed;
			h = 0;
			hitPoints = presetHitPoints;
		}
		
		public function loop (e:TimerEvent) {
			//drone movement :taking out acceleration for ease of glitch
			//otherwise they would all start accelerating to the right with vx += va;
			if (freeMovement) {
				this.y += vy;
				//listing needs horizontal movement
				this.x += vx;
				if (y > 600 + this.height/2) {
					destroyYourself();
				}
				//vx stuff
				if (x < 0 + this.width/2 || x > 500 + this.width/2) {
					destroyYourself();
				}
			}
			//AI firing mechanism if your ship is within the right and left bounded area based off this drone then fire
			/*if (this.x + 50 > LazerCatAttack.you.x && this.x - 50 < LazerCatAttack.you.x) {
				fireBullet();
			}*/
			//random firing drone method of AI
			//for consistent fire rates set fireMod to 100 and then specify the fireInterval 
			if (Math.random() < .01 * fireMod) {
				fireBullet();				
			}
			//decide if you are going to list lazily
			if (listing && Math.random() >.01 && vx > -2 && vx < 2) {
				if(Math.random() > .5) {
					vx += listSpeed * Math.random();
				}else {
					vx -= listSpeed * Math.random();
				}
			}
			if (LazerCatAttack.you != null) {
				
				if (LazerCatAttack.you.shipSplit){
					if(hitTestObject(LazerCatAttack.you.leftHalf)) {
						destroyYourself();
						LazerCatAttack.huD.updateScore(this.points);
						//and run player dies
						LazerCatAttack.you.killPlayer();
					}else if(hitTestObject(LazerCatAttack.you.rightHalf)) {
						destroyYourself();
						LazerCatAttack.huD.updateScore(this.points);
						//and run player dies
						LazerCatAttack.you.killPlayer();
					}
				}else{
					if (hitTestObject(LazerCatAttack.you)) {
						destroyYourself();
						LazerCatAttack.huD.updateScore(this.points);
						//and run player dies
						LazerCatAttack.you.killPlayer();
					}
				}
			}
			if (Cat.daCat != null) {
				if (hitTestObject(Cat.daCat)) {
					Cat.daCat.destroyYourself();
					/*LazerCatAttack.huD.updateScore(this.points);*/
					destroyYourself();
				} 
			}
			
			
		}
		//this is the shittiest thing I ever wrote @Oct/2015
		public function goTo(point:Point) {
			if (this.x == point.x) {
				xThere = true;
			}
			else {
				xThere = false;
			}
			if (this.y == point.y) {
				yThere = true;
			}
			else {
				yThere = false;
			}
			if (!xThere) {
					if (point.x > this.x) {
						if ((this.x += speed) > point.x) {
							this.x = point.x;
							xThere = true;
						}
						else {
							this.x += speed;
						}
					}
					else if (point.x < this.x) {
						if ((this.x -= speed) < point.x) {
							this.x = point.x;
							xThere = true;
						}
						else {
							this.x -= speed;
						}
					}
			}
			if (!yThere) {
					if (point.y > this.y) {
						if ((this.y += speed) > point.y) {
							this.y = point.y;
							yThere = true;
						}
						else {
							this.y += speed;
						}
					}
					else if (point.y < this.y) {
						if ((this.y -= speed) < point.y) {
							this.y = point.y;
							yThere = true;
						}
						else {
							this.y -= speed;
						}
					}
			}	
			if (yThere && xThere) {
				inPosition = true;
			}			
		}	
		public function revive() {
			h--;
			hitPoints = presetHitPoints;
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
			//recent change from just addEvent...don't know why it was like that
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, droneFireTimerHandler);
			LazerCatAttack.enemyList.push(this);
			caught = false;
			freeMovement = true;
			groupie = false;
			if (LazerCatAttack.you.passive1 == "Nyan Cats" || LazerCatAttack.you.passive2 == "Nyan Cats") {
				gotoAndStop(9);
			}
		}
		public function onCatch(xDif, yDif) {
			invincible = false;
			hitPoints = 0;
			caught = true;
			LazerCatAttack.you.ball.caught.push(this);
			this.x = xDif;
			this.y = yDif;
			if (groupie) {
				trace("db = " + dB);
				dB.groupies.splice(dB.groupies.indexOf(this),1);
				dB = null;
				groupie = false;
				freeMovement = true;
			}
			destroyYourself();
			LazerCatAttack.you.ball.addChild(this);
		}
		public function kick() {
			if (LazerCatAttack.game.contains(this)) {
				LazerCatAttack.game.removeChild(this);
			}
			gotoAndStop(1);
			LazerCatAttack.game.dronePool.unshift(this);
		}
		public function destroyYourself():void {
			if (!invincible) {
				h ++;
				if (h >= hitPoints && (currentFrame == 1 || currentFrame == 9)) {
					LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
					LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, droneFireTimerHandler);
					/*LazerCatAttack.game.dronePool.unshift(this);*/
					invincible = false;
					if (groupie) {
						dB.groupies.splice(dB.groupies.indexOf(this),1);
						dB = null;
						groupie = false;
					}
					freeMovement = true;
					lazerHits = 0;
					if (!caught) {
						groupie = false;
					}
					xThere = false;
					yThere = false;
					inPosition = false;
					/*if (LazerCatAttack.game.contains(this)) {
						LazerCatAttack.game.removeChild(this);
					}*/
					if (!caught && currentFrame == 1) {
						gotoAndPlay(2);
					}else{
						if (LazerCatAttack.game.contains(this)) {
							LazerCatAttack.game.removeChild(this);
						}
						if (currentFrame != 9) {
							gotoAndStop(1);
						}else if (!caught){
							//recent change
							LazerCatAttack.game.dronePool.unshift(this);
						}
						//LazerCatAttack.game.dronePool.unshift(this);
					}
					LazerCatAttack.enemyList.splice(LazerCatAttack.enemyList.indexOf(this),1);
					/*groupie = false;*/
					if (playerKilledMe) {
						LazerCatAttack.huD.updateScore(this.points);
						/*var snd:Sound = new EnemyDeathSound;
						Main.sound.playFX(snd); */
					}
				/*}else if (playerKilledMe) {
					var snd:Sound = new HitSound;
					Main.sound.playFX(snd);*/
				}else {
					if (LazerCatAttack.game.contains(this)) {
						LazerCatAttack.game.removeChild(this);
					}
					gotoAndStop(1);
					LazerCatAttack.game.dronePool.unshift(this);
				}	
			}	
			playerKilledMe = false;
		}
		public function execute() {
			if (LazerCatAttack.game.contains(this)) {
				LazerCatAttack.game.removeChild(this);
			}
			gotoAndStop(1);
			LazerCatAttack.game.dronePool.unshift(this);
		}
		
		private function fireBullet () {
			if (canFire) {
				/*var bullet = new DroneShipBullet(this.x,this.y + this.height/2);*/
				if (DroneShip.bulletPool.length > 0) {
					var bullet:DroneShipBullet = DroneShip.bulletPool.pop();
				}else {
					var bullet:DroneShipBullet = new DroneShipBullet;
				}
				bullet.recycle(this.x, this.y + this.height/2);
				DroneShip.bullet.push(bullet);
				LazerCatAttack.game.addChild(bullet);
				canFire = false;
				LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, droneFireTimerHandler);
			}	
			//sound effect for enemy fire??
		}
		
		private function droneFireTimerHandler (e:TimerEvent):void {
			fCount ++;
			if (fCount >= fInterval * 60) {
				canFire = true;
				LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, droneFireTimerHandler);
				fCount = 0;
			}
		}

	}
	
}
