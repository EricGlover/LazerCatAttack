package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	
	public class PlayerLazer extends MovieClip {
		private var displayTime:int = 10;
		private var t:int = 0;
		public var damage:int = 2;
		private var xTimes1:int = 0;
		private var xTimes2:int = 0;
		private var xTimes3:int = 0;
		private var bossDamageDone:int = 0;
		public var bossDamage:int = 4;
		
		public function PlayerLazer() {
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
			mouseEnabled = false;
		}
		
		public function loop (e:TimerEvent) {
			t ++;
			if(t == displayTime) {
				remove();
			}
			//hit tests: consider reflection
			//remember everything now updates points on that objects remove()
			//ram blocks the lazer
			
			/*if (daRam != null) {
				if (hitTestObject(Baton.daRam)) {
					var bottomPoint = this.y + height/2;
					var bottomRam = Baton.daRam.y + height/2;
					var distance = bottomRam - bottomPoint;
					this.height = distance;
					this.y = bottomPoint - height/2;
				}
			}*/
			for (var i:int = 0; i < LazerCatAttack.enemyList.length; i++) {
				if (LazerCatAttack.enemyList[i] != null) {
					if (hitTestObject(LazerCatAttack.enemyList[i]) /*&& ((LazerCatAttack.enemyList[i].lazerHits < damage) || Main.difSet == 1)*/) {
					//	if (LazerCatAttack.enemyList[i] is BatonRam) {
					//		
					//	}
						var foe = LazerCatAttack.enemyList[i];
						if (foe is lv2Boss || foe is lv3Boss) {
							if (bossDamageDone < bossDamage) {
								LazerCatAttack.enemyList[i].playerKilledMe = true;
								LazerCatAttack.enemyList[i].destroyYourself();
								bossDamageDone ++;
							}
						}else {
							LazerCatAttack.enemyList[i].playerKilledMe = true;
							LazerCatAttack.enemyList[i].destroyYourself();
						}	
						/*LazerCatAttack.enemyList[i].lazerHits ++;*/
					}
				}	
			}
			for (var a:int = 0; a < LazerCatAttack.lazerDroneList.length; a++) {
				if (LazerCatAttack.lazerDroneList[a] != null) {
					if (hitTestObject(LazerCatAttack.lazerDroneList[a]) /*&& ((LazerCatAttack.lazerDroneList[a].lazerHits < damage) || Main.difSet == 1)*/) {
						LazerCatAttack.lazerDroneList[a].playerKilledMe = true;
						LazerCatAttack.lazerDroneList[a].destroyYourself();
						/*LazerCatAttack.huD.updateScore(LazerCatAttack.lazerDroneList[a].points)*/
						/*LazerCatAttack.lazerDroneList[a].lazerHits ++;*/
					}
				}	
			}
			for (var lv:int = 0; lv < LazerCatAttack.bossVector.length; lv++) {
				if (LazerCatAttack.bossVector[lv] != null) {
					if (hitTestObject(LazerCatAttack.bossVector[lv]) /*&& ((LazerCatAttack.bossVector[lv].lazerHits < damage) || Main.difSet == 1)*/) {
						LazerCatAttack.bossVector[lv].playerKilledMe = true;
						LazerCatAttack.bossVector[lv].remove();	
						/*LazerCatAttack.bossVector[lv].lazerHits ++;*/
					}
				}	
			}
			/*if (reflected) {
				if (hitTestObject(LazerCatAttack.you)) {
					LazerCatAttack.you.killPlayer();
					removeBullet();
				}
			}*/
		}
		public function remove() {
			LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
			LazerCatAttack.game.removeChild(this);
		}
	}
	
}
