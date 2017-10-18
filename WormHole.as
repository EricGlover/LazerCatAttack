package  {
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.geom.Vector3D;
	
	
	public class WormHole extends MovieClip {
		public var position:Vector3D;
		public var wormHoleVec:Vector3D = new Vector3D();
		public var oldDistance;
		public var oldDist1;
		public var oldD2;
		public var closer:int = 0;
		public var closer1:int = 0;
		public var closer2:int = 0;
		
		// lv3Boss sets up the wormHoleVec
		// possible names are : a, b, ///c, d
		public function WormHole(myName) {
			this.name = myName;
			mouseEnabled = false;
			this.alpha = .3;
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
			position = new Vector3D(this.x, this.y, 0);
		}
		private function loop(e:TimerEvent) {
			//add player array later
			//add lv1Boss array stuff later
			//current warping things: player, maybe lv3Boss, drone ship, drone bullets, lv3Boss bullets
			//maybe pylons, lv3Boss parts not yet, medBots, no warping db's, no warping lazerDrones 
			if (hitTestObject(LazerCatAttack.you)) {
				//if headed into the wormhole
				with (LazerCatAttack) {
					/*vx vy
					var playerVec:Vector3D = new Vector3D(vx,vy,0);
					var playerAngle = getAngle(playerVec);
					playerAngle *= 180 / Math.PI;
					var vecToMe:Vector3D = new Vector3D(position.x - you.x, position.y - you.y, 0);
					var angleToThis = getAngle(vecToMe);
					angleToThis *= 180 / Math.PI;*/
					//could use angles but try if the distance between me and him decreases three times in a row
					var newDistance = distance(this, you);
					trace("old distance = " + oldDistance);
					trace("closer = " + closer);
					if (oldDistance == undefined) {
						oldDistance = newDistance;
						trace("old distance was undefined but is now = " + oldDistance);
					}//moving away //then moving towards
					if (oldDistance <= newDistance) {
						//I believe adding in the commented section will enabled you to turn immmediately back into the wormhole
						//and worm-over CONSIDER REWORKING THIS ASPECT
						oldDistance = newDistance;
						closer = 0;
						/*oldDistance = undefined;*/
					}else if (oldDistance > newDistance) {
						oldDistance = newDistance;
						closer ++;
					}
					if (closer > 3){
						var oldVx = you.vx;
						var oldVy = you.vy;
						you.vx = -1 * oldVy;
						you.vy = -1* oldVx;
						var deltaX = you.x - this.x;
						var deltaY = you.y - this.y;
						you.x = this.x + wormHoleVec.x; 
						you.y = this.y + wormHoleVec.y - deltaX;
						oldDistance = undefined;
						closer = 0;
					}
				}
			}	
			for (var i:int = 0; i < Player.playerBullets.length; i ++) {
				if (hitTestObject(Player.playerBullets[i]) && !Player.playerBullets[i].justWarped) {
					var oldVx = Player.playerBullets[i].velocity.x;
					var oldVy = Player.playerBullets[i].velocity.y; 
					Player.playerBullets[i].velocity.x = oldVy * -1;
					Player.playerBullets[i].velocity.y = oldVx * -1;
					var deltaX = Player.playerBullets[i].x - this.x;
					/*trace("deltaX = " + deltaX);*/
					var deltaY = Player.playerBullets[i].y - this.y;
					/*trace("deltaY = " + deltaY);*/
					/*trace("wormHoleVec.x = " + wormHoleVec.x);*/
					Player.playerBullets[i].x = this.x + wormHoleVec.x; 
					Player.playerBullets[i].y = this.y + wormHoleVec.y - deltaX;
					Player.playerBullets[i].justWarped = true;
				}				
			}
			for (var i:int = 0; i < DroneShip.bullet.length; i++) {
				if (hitTestObject(DroneShip.bullet[i]) && !DroneShip.bullet[i].justWarped) {
					var oldVx = DroneShip.bullet[i].velocity.x;
					var oldVy = DroneShip.bullet[i].velocity.y;
					DroneShip.bullet[i].velocity.x = oldVy * -1;
					DroneShip.bullet[i].velocity.y = oldVx * -1;
					var deltaX = DroneShip.bullet[i].x - this.x;
					var deltaY = DroneShip.bullet[i].y - this.y;
					DroneShip.bullet[i].x = this.x + wormHoleVec.x;
					DroneShip.bullet[i].y = this.y + wormHoleVec.y - deltaX;
					DroneShip.bullet[i].justWarped = true;
				}
			}
			for (var i:int = 0; i < LazerCatAttack.enemyList.length; i ++) {
				//drone ships //lv3Boss //pylons //boss parts // db's 
				if (hitTestObject(LazerCatAttack.enemyList[i])) {
					with (LazerCatAttack) {
						if (enemyList[i] is DroneShip && !enemyList[i].justWarped) {
							var oldVx = enemyList[i].vx;
							var oldVy = enemyList[i].vy;
							enemyList[i].vx = oldVy * -1;
							enemyList[i].vy = oldVx * -1;
							var deltaX = enemyList[i].x - this.x;
							var deltaY = enemyList[i].y - this.y;
							enemyList[i].x = this.x + wormHoleVec.x;
							enemyList[i].y = this.y + wormHoleVec.y - deltaX;
							enemyList[i].justWarped = true;
						}else if (enemyList[i] is lv3Boss) {
							var newDistance = distance(this, you);
				
							if (oldD2== undefined) {
								oldD2 = newDistance;
							}//moving away //then moving towards
							if (oldD2 <= newDistance) {
								//I believe adding in the commented section will enabled you to turn immmediately back into the wormhole
								//and worm-over CONSIDER REWORKING THIS ASPECT
								oldD2= newDistance;
								closer2 = 0;
								/*oldD2 = undefined;*/
							}else if (oldD2 > newDistance) {
								oldD2 = newDistance;
								closer2 ++;
							}
							if (closer2 > 3){
								var oldVx = enemyList[i].velocity.x;
								var oldVy = enemyList[i].velocity.y;
								enemyList[i].velocity.x = oldVy * -1;
								enemyList[i].velocity.y = oldVx * -1;
								var deltaX = enemyList[i].x - this.x;
								var deltaY = enemyList[i].y - this.y;
								enemyList[i].x = this.x + wormHoleVec.x;
								enemyList[i].y = this.y + wormHoleVec.y - deltaX;
								enemyList[i].position.x = this.x;
								enemyList[i].position.y = this.y;
								oldD2 = undefined;
								closer2 = 0;
							}
						}
						else if (enemyList[i] is lv3BossPylon && !enemyList[i].justWarped) {
							enemyList[i].x = this.x + wormHoleVec.x;
							enemyList[i].y = this.y + wormHoleVec.y - deltaX;
							enemyList[i].justWarped = true;
						}
						else if (enemyList[i] is lv3BossPart) {
							
						}
					}	
				}
			}
			for (var i:int = 0; i < LazerCatAttack.medDroneList.length; i++) {
				if (hitTestObject(LazerCatAttack.medDroneList[i]) && !LazerCatAttack.medDroneList[i].justWarped) {
					LazerCatAttack.medDroneList[i].x = this.x + wormHoleVec.x;
					LazerCatAttack.medDroneList[i].y = this.y + wormHoleVec.y;
					LazerCatAttack.medDroneList[i].justWarped = true;
				}
			}
			for (var i:int = 0; i < lv3Boss.bob.bobsBurgers.length; i++) {
				//boss bullets //boss pylon bullets
				if (lv3Boss.bob.bobsBurgers[i] is lv3BossBullet) {
					if (hitTestObject(lv3Boss.bob.bobsBurgers[i])) {
						with (lv3Boss.bob) {
							var newDistance = distance(this, bobsBurgers[i]);
							if (oldDist1 == undefined) {
								oldDist1 = newDistance;
							}//moving away //then moving towards
							if (oldDist1 <= newDistance) {
								oldDist1 = newDistance;
								closer1 = 0;
								/*oldDist1 = undefined;*/
							}else if (oldDist1 > newDistance) {
								oldDist1 = newDistance;
								closer1 ++;
							}
							if (closer1 > 3){
								var oldVx = bobsBurgers[i].velocity.x;
								var oldVy = bobsBurgers[i].velocity.y;
								bobsBurgers[i].velocity.x = -1 * oldVy;
								bobsBurgers[i].velocity.y = -1* oldVx;
								var deltaX = bobsBurgers[i].x - this.x;
								var deltaY = bobsBurgers[i].y - this.y;
								bobsBurgers[i].x = this.x + wormHoleVec.x; 
								bobsBurgers[i].y = this.y + wormHoleVec.y - deltaX;
								oldDist1 = undefined;
								closer1 = 0;
							}
						}
					}
				}	
			}	
		}
		public function getAngle(vector :Vector3D) :Number {
			return Math.atan2(vector.y, vector.x);
		}
		public function distance(a, b):int {
			return (Math.sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y)));
		}
		public function remove() {
			LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER,loop);
			LazerCatAttack.game.removeChild(this);
		}
	}
	
}
