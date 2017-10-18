package  {
	
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	public class Boomerang extends MovieClip {
		//movement vars
		public var position:Vector3D;
		private var selectedTarget;
		private var target:Vector3D;
		private var speed:int = 3;
		private var velocity:Vector3D;
		private var maxVelocity:int = 8;
		private var presetMaxV:int = 5;
		private var steering:Vector3D = new Vector3D();
		private var maxForce:Number = .1;
		private var mass:int = 1;
		private var acceleration:Number = .03;
		private var initialVel:Vector3D;
		
		private var released:Boolean = false;
		//explosion
		private var explosionRadius:int = 10;
		
		
		public function Boomerang(initX,initY){
			selectedTarget = LazerCatAttack.you;
			//set initial velocity
			position = new Vector3D;
			target = new Vector3D;
			velocity = new Vector3D(initX *18, initY*18 + 30);
			trace("creating boomerang");
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
		}
		
		private function loop(e:TimerEvent) {
			//movement
			position.x = this.x;
			position.y = this.y;
			target.x = selectedTarget.x;
			target.y =selectedTarget.y;
			steering = seek(target);
			truncate(steering, maxForce);
			steering.scaleBy(1/mass);
			velocity = velocity.add(steering);
			truncate(velocity, maxVelocity);
			position.x += velocity.x;
			position.y += velocity.y;
			this.x = position.x;
			this.y = position.y;
			
			//hitTests
			for (var i:int = 0; i < LazerCatAttack.enemyList.length; i++) {
				if (LazerCatAttack.enemyList[i] != null) {
					if (hitTestObject(LazerCatAttack.enemyList[i])) {
						if (LazerCatAttack.enemyList[i] is BatonRam) {
							trace("found a baton");
							break;
						}
						/*LazerCatAttack.huD.updateScore(LazerCatAttack.enemyList[i].points);*/
						LazerCatAttack.enemyList[i].playerKilledMe = true;
						LazerCatAttack.enemyList[i].destroyYourself();
						//remove the bullet now
						var snd:Sound = new HitSound;
						Main.sound.playFX(snd);
					}
				}	
			}
			//check to see if the player caught you....
			//it starts out on the ship so notice when you're not still onboard
			if (hitTestObject(selectedTarget)){
				if (released) {
					selectedTarget.boomerangCaught();
					destroyYourself();
				}
			}else if (!released){
				//now that it's not touching notify the boomerang that it's flying free
				released = true;
			}
			
			//check for the player bullets if hit explode
			for (var i:int = 0; i < Player.playerBullets.length; i++) {
				if (Player.playerBullets[i] != null) {
					if (hitTestObject(Player.playerBullets[i])){
						explode();
						Player.playerBullets[i].removeBullet();
					}
				}
			}
			//check to see if you went off-screen & if so tell the player
			if (this.x - width/2 > 500 || this.x + width/2 < 0 || this.y - height/2 > 600 || this.y + height < 0){
				destroyYourself();
			}
		}
		private function explode() {
			//check area for enemies
			var explosionArea = new Sprite;
			explosionArea.width = explosionRadius * 2;
			explosionArea.height = explosionRadius *2;
			explosionArea.x = this.x;
			explosionArea.y = this.y;
			explosionArea.visible = false;
			
			//tell these enemies to explode
			for (var i:int = 0; i < LazerCatAttack.enemyList.length; i++) {
				if (LazerCatAttack.enemyList[i] != null) {
					if (hitTestObject(LazerCatAttack.enemyList[i])) {
						if (LazerCatAttack.enemyList[i] is BatonRam) {
							//do nothing?
						}
						/*LazerCatAttack.huD.updateScore(LazerCatAttack.enemyList[i].points);*/
						LazerCatAttack.enemyList[i].playerKilledMe = true;
						LazerCatAttack.enemyList[i].destroyYourself();
					}
				}	
			}
			/*for (var a:int = 0; a < LazerCatAttack.lazerDroneList.length; a++) {
				if (LazerCatAttack.lazerDroneList[a] != null) {
					if (hitTestObject(LazerCatAttack.lazerDroneList[a])) {
						LazerCatAttack.lazerDroneList[a].playerKilledMe = true;
						LazerCatAttack.lazerDroneList[a].destroyYourself();
						//LazerCatAttack.huD.updateScore(LazerCatAttack.lazerDroneList[a].points)
					}
				}	
			} */
			for (var lv:int = 0; lv < LazerCatAttack.bossVector.length; lv++) {
				if (LazerCatAttack.bossVector[lv] != null) {
					if (hitTestObject(LazerCatAttack.bossVector[lv])) {
						LazerCatAttack.bossVector[lv].playerKilledMe = true;
						LazerCatAttack.bossVector[lv].remove();
					}
				}
			}
			//run some sort of graphic
			//run some sort of audio effect
			destroyYourself();
		}
		private function truncate(vector:Vector3D, max:Number):void {
			var i:int;
			i = vector.length/max;
			if (i > 1) {
				if (max == 0) {
					trace("error @ boomerang truncate");
				}else{
					vector.scaleBy(1/i);
				}
			}
		}
		private function seek (target) {
			var force:Vector3D;
			var desired:Vector3D = new Vector3D;
			desired.y = target.y - position.y;
			desired.x = target.x - position.x;
			desired.normalize();
			desired.scaleBy(maxVelocity);
			force = desired.subtract(velocity);
			truncate(force, maxForce);
			return force;
		}
		//?
		public function destroyYourself() {
			LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
			LazerCatAttack.you.boomerangDied();
			if (LazerCatAttack.game.contains(this)){
				LazerCatAttack.game.removeChild(this);	
			}
		}
	}
	
}
