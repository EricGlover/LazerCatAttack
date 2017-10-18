package  {
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	
	
	public class Crusher extends MovieClip {
		private var bossDamageDone:int = 0;
		public var bossDamage:int = 2;
		private var count:int = 0;
		private var bossDamageTime:int = 0;
		public var thingsWrecked:int;
		
		public function Crusher() {
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
			mouseEnabled = false;
		}
		
		public function loop (e:TimerEvent) {
			/*this.x += LazerCatAttack.you.changeX;
			this.y += LazerCatAttack.you.changeY;*/
			//crusher can do bossDamage amount of damage per half second
			if (LazerCatAttack.you != null) {
				this.x = LazerCatAttack.you.x;
				this.y = LazerCatAttack.you.y;
				for (var i:int = 0; i < LazerCatAttack.enemyList.length; i ++) {
					var foe = LazerCatAttack.enemyList[i];
					if (hitTestObject(LazerCatAttack.enemyList[i])) {
						if (LazerCatAttack.enemyList[i] is BatonRam) {
						//do nothing or move 
						}else if (foe is lv2Boss || foe is lv3Boss) {
							//consider reworking the damage tick mechanism.
							if (bossDamageDone < bossDamage) {
								foe.playerKilledMe = true;
								foe.destroyYourself();
								var snd:Sound = new CrusherSound;
								Main.sound.playFX(snd);
								bossDamageDone ++;
								thingsWrecked ++;
							}else if (bossDamageDone == bossDamage) {
								bossDamageTime = count;
							}else if ((count - bossDamageTime) >= 30) {
								bossDamageDone = 0;
							}
						}else {
							LazerCatAttack.enemyList[i].playerKilledMe = true;
							LazerCatAttack.enemyList[i].destroyYourself();
							var snd:Sound = new CrusherSound;
							Main.sound.playFX(snd);
							thingsWrecked ++;
						}	
					}
				}
				if (lv3Boss.bob != null) {
					for (var i:int = lv3Boss.bob.bobsBurgers.length - 1; i >= 0 ; i --) {
						if (hitTestObject(lv3Boss.bob.bobsBurgers[i])) {
							lv3Boss.bob.bobsBurgers[i].remove();
							thingsWrecked ++;
							var snd:Sound = new CrusherSound;
							Main.sound.playFX(snd);
						}
					}
				}
				for (var i:int = 0; i < DroneShip.bullet.length; i ++) {
					if (DroneShip.bullet[i] == null) {
						trace("droneship bullet found to be null @crusher");
					}
					if (hitTestObject(DroneShip.bullet[i])) {
						DroneShip.bullet[i].playerKilledMe = true;
						DroneShip.bullet[i].removeDroneShipBullet();
						thingsWrecked ++;
						var snd:Sound = new CrusherSound;
						Main.sound.playFX(snd);
					}
				}
				// add bosses 
				for (var i:int = 0; i < LazerCatAttack.lazerDroneList.length; i ++) {
					if (!LazerCatAttack.lazerDroneList[i].invincible && hitTestObject(LazerCatAttack.lazerDroneList[i])) {
						LazerCatAttack.lazerDroneList[i].playerKilledMe = true;
						LazerCatAttack.lazerDroneList[i].destroyYourself();
						thingsWrecked ++;
						var snd:Sound = new CrusherSound;
						Main.sound.playFX(snd);
					}
				}
				//add crusher blocks lv2Bullets
			}	
			//counter for per second damage
			count ++;
		}
		//does this work independent of the player??
		public function remove() {
			if (LazerCatAttack.you != null) {
				LazerCatAttack.you.thingsWrecked += thingsWrecked;
				LazerCatAttack.you.crushMasta = null;
				/*trace("CrushMasta found a null player");*/
			}
			LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
			if (LazerCatAttack.game.contains(this)) {
				LazerCatAttack.game.removeChild(this);
			}
		}
	}
	
}
