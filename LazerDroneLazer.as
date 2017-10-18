package  {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.display.MovieClip;
	import flash.globalization.LastOperationStatus;
	
	public class LazerDroneLazer extends MovieClip{
		private var target:LazerDrones;
		private var handedness:String;
		private var xTimes:int = 0;
		//change this later lawls
		public var points:int = 1;
		public var playerKilledMe:Boolean = false;
		private var reset:int = 1;
		private var reset2:int = 1;
		private var xTimes2:int = 0;
		public var lazerHits:int = 0;
		public var invincible:Boolean = true;
		
		public function LazerDroneLazer() {
			/*target = thisTarget;
			var length = length;
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
			this.width = length;*/
		}
		public function recycle(length1, thisTarget) {
			target = thisTarget;
			this.width = length1;
			/*target.target.y = this.y;*/
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
		}
		
		private function loop (e:TimerEvent) {
			//move with the lazerDrones
			/*if (handedness === "righty") {
				this.x = (target.x + this.width/2) + (target.width /2);
			}
			else {
				this.x = (target.x -this.width/2) + (target.width /2);
			}*/
			//destroy your ship. if you're in it it only does one damage until you run through it again.
			if (LazerCatAttack.you != null) {
				
				if (LazerCatAttack.you.shipSplit){
					if(hitTestObject(LazerCatAttack.you.leftHalf)) {
						if (hitTestObject(LazerCatAttack.you.leftHalf) && xTimes < 1 && reset == 1) {
						LazerCatAttack.you.killPlayer();
						xTimes ++;
						/*LazerCatAttack.huD.updateScore(-this.points);*/
						reset = 0;
					} else {
						reset = 1;
						}
					}else if(hitTestObject(LazerCatAttack.you.rightHalf)) {
						if (hitTestObject(LazerCatAttack.you.rightHalf) && xTimes < 1 && reset == 1) {
							LazerCatAttack.you.killPlayer();
							xTimes ++;
							/*LazerCatAttack.huD.updateScore(-this.points);*/
							reset = 0;
						} else {
							reset = 1;
						}
					}
				}else{
					if (hitTestObject(LazerCatAttack.you) && xTimes < 1 && reset == 1) {
						LazerCatAttack.you.killPlayer();
						xTimes ++;
						/*LazerCatAttack.huD.updateScore(-this.points);*/
						reset = 0;
					} else {
						reset = 1;
					}
				}
			}
			if (Cat.daCat != null) {
				if (hitTestObject(Cat.daCat) && xTimes2 < 1 && reset2 == 1) {
					Cat.daCat.destroyYourself();
					xTimes2 ++;
					/*LazerCatAttack.huD.updateScore(-this.points);*/
					reset2 = 0;
				} else {
					reset2 = 1;
				}
			}
			//destroy enemy ships //recent change, da fuk was I thinking with this
			/*for (var i:int = 0; i < LazerCatAttack.enemyList.length; i++) {
				if (hitTestObject(LazerCatAttack.enemyList[i]) && !LazerCatAttack.enemyList[i] is DeathBallerz) {
					LazerCatAttack.enemyList[i].destroyYourself();
				}
			}	*/
		}
		public function remove():void {
			if (!invincible) {
				LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
				LazerDrones.lazers.splice(LazerDrones.lazers.indexOf(this), 1);
				LazerDrones.lazerPool.push(this);
				target = null;
				LazerCatAttack.game.removeChild(this);
				if (playerKilledMe) {
					LazerCatAttack.huD.updateScore(this.points);
				}
				playerKilledMe = false;
			}	
		}

	}
	
}
