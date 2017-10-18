package
{
 
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.utils.*;
	import flash.geom.Vector3D;
	import flash.media.Sound;
	
	/*add function to remove bullets from display list.
	currently they just live forever*/
 
	public class Bullet extends MovieClip{
		
		private var reflected:Boolean = false;
		public var position:Vector3D = new Vector3D();
		public var velocity:Vector3D = new Vector3D();
		public var bulletSpeed:int;
		public var justWarped:Boolean = false;
		private var killedShit:Boolean = false;
		public var sheep:Boolean = false;
		
		public function Bullet() {
			/*this.bulletSpeed = bulletSpeed;
			this.x = x;
			this.y = y;
			position.x = this.x;
			position.y = this.y;
			velocity.y = -1 * bulletSpeed;
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);*/
		}
		public function recycle(x:Number, y:Number, bulletSpeed:int) {
			this.bulletSpeed = bulletSpeed;
			this.x = x;
			this.y = y;
			position.x = this.x;
			position.y = this.y;
			velocity.y = -1 * bulletSpeed;
			reflected = false;
			/*if (LazerCatAttack.you.passive1 == "Sheep 4 The Win" || LazerCatAttack.you.passive2 == "Sheep 4 The Win") {
				gotoAndStop(10);
			}*/
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
		}
		private function loop (e:TimerEvent):void {
			position.x = this.x;
			position.y = this.y;
			position = position.add(velocity);
			this.x = position.x;
			this.y = position.y;
			
			if (this.y > 600 || this.y < 0) {
				removeBullet();
			}
			
			// hit test between your bullets and the enemy ships
			for (var i:int = 0; i < LazerCatAttack.enemyList.length; i++) {
				if (LazerCatAttack.enemyList[i] != null) {
					if (hitTestObject(LazerCatAttack.enemyList[i])) {
						if (LazerCatAttack.enemyList[i] is BatonRam) {
							removeBullet();
							killedShit = true;
							trace("found a baton");
							//graphical animation
							break;
						}
						/*LazerCatAttack.huD.updateScore(LazerCatAttack.enemyList[i].points);*/
						LazerCatAttack.enemyList[i].playerKilledMe = true;
						LazerCatAttack.enemyList[i].destroyYourself();
						//remove the bullet now
						var snd:Sound = new HitSound;
						Main.sound.playFX(snd);
						removeBullet();
						killedShit = true;
					}
				}	
			}
			for (var a:int = 0; a < LazerCatAttack.lazerDroneList.length; a++) {
				if (LazerCatAttack.lazerDroneList[a] != null && !killedShit) {
					if (hitTestObject(LazerCatAttack.lazerDroneList[a])) {
						LazerCatAttack.lazerDroneList[a].playerKilledMe = true;
						LazerCatAttack.lazerDroneList[a].destroyYourself();
						/*LazerCatAttack.huD.updateScore(LazerCatAttack.lazerDroneList[a].points)*/
						//remove the bullet now
						var snd:Sound = new HitSound;
						Main.sound.playFX(snd);
						removeBullet();
						killedShit = true;
					}
				}	
			}
			for (var lv:int = 0; lv < LazerCatAttack.bossVector.length; lv++) {
				if (LazerCatAttack.bossVector[lv] != null && !killedShit) {
					if (hitTestObject(LazerCatAttack.bossVector[lv])) {
						LazerCatAttack.bossVector[lv].playerKilledMe = true;
						LazerCatAttack.bossVector[lv].remove();
						var snd:Sound = new HitSound;
						Main.sound.playFX(snd);
						removeBullet();
						killedShit = true;
					}
				}
			}
			/*for (var i:int = 0; i < lv1Boss.lv1BossLinks.length; i ++) {*/
			/*var i:int = 0;*/
				if (lv1Boss.lv1BossLinks.length == 1 && !killedShit) {
					if (!reflected && hitTestObject(lv1Boss.lv1BossLinks[0])) {
						reflected = true;
						velocity.y *= -1;
					}/*else{
						removeBullet();
					}*/
				}
			/*}*/
			if (reflected && !killedShit) {
				if (hitTestObject(LazerCatAttack.you)) {
					LazerCatAttack.you.killPlayer();
					killedShit = true;
					removeBullet();
				}
			}
			
		}
		public function kick() {
			/*if (LazerCatAttack.game != null) {*/
				if (LazerCatAttack.game.contains(this)){
					LazerCatAttack.game.removeChild(this);
				}
			/*}*/
			Player.bulletPool.push(this);
			if (!sheep) {
				gotoAndStop(1);
			}
			killedShit = false;
		}
		public function removeBullet() {
			LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
			Player.playerBullets.splice(Player.playerBullets.indexOf(this), 1);
			if (killedShit && !sheep) {
				gotoAndPlay(2);
			}else {
				Player.bulletPool.push(this);
				if (LazerCatAttack.game.contains(this)){
					LazerCatAttack.game.removeChild(this);
				}
			}
			killedShit = false;
		}
	}
 
}
