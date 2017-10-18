package  {
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.geom.Vector3D;
	import flash.media.Sound;
	
	
	public class lv3BossPylon extends MovieClip {
		public var position:Vector3D = new Vector3D();
		public var construct:int = 0;
		public var constructTotal:int = 5;
		public static var totalHealth:int = 3;
		public var health:int;
		public var playerKilledMe:Boolean = false;
		public var lazerHits:int = 0;
		public var points:int = 2;
		public var complete:Boolean = false;
		public var bulletSpeed:int = 2;
		public var fireTimer:int = 0;
		public var fireInterval:Number = 1;
		public var angle:Number = 0.00;
		public var number:int = 0;
		public static var turn1:Array = new Array(0, 15, 30, 45, 0);
		public static var turn2:Array = new Array(-15, 0, 15, 0);
		public static var turn3:Array = new Array(-15, -30, -45, 0);
		public var myTurn:Array;
		public var turn:int = 0;
		public var pylonNumber:int = 0;
		public var justWarped:Boolean = false;
		//pokeball vars
		private var rCounter:int = 0;
		private var stunTime:Number = 3.2;
		//if pylons change to be moving then change wormhole glitch class
		
		public function lv3BossPylon() {
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
			/*position = new Vector3D(this.x, this.y, 0);*/
			this.rotation = 0;
			this.health = lv3BossPylon.totalHealth;
			mouseEnabled = false;
		}
		private function loop(e:TimerEvent) {
			for (var i:int = 0; i < lv3Boss.parts.length; i ++) {
				if (hitTestObject(lv3Boss.parts[i])) {
					construct ++;
					lv3Boss.parts[i].health = 0;
					lv3Boss.parts[i].destroyYourself();
				}
			}
			if (construct >= constructTotal) {
				complete = true;
				//dont continually run this, so set it to start evaluating it to false
				construct = 0;
				findTurn();
				trace("completed pylon");
			}
			if (complete) {
				//fire weapons and such
				//add gun
				rotate();
				fireTimer ++;
				if (fireTimer >= fireInterval * 60) {
					fire();
					fireTimer = 0;
					//if turn array is empty reset it, else take off the last item
					if (myTurn.length < 1) {
						findTurn();
					}else {
						myTurn.shift();
					}
				}	
			}		
		}
		private function rotate() {
			//rotate gun, rotate pylon, update gun coordinates
			//rotate 15, 30, 45 degrees to center screen:if outer two pylons
			//or something if inner
			turn = myTurn[0] - this.rotation;
			/*trace("turn = " + turn);*/
			/*turn = myTurn[0] - myTurn[1];*/
			var time:Number = fireInterval * 60;
			/*trace("time = " + time);*/
			angle += turn / time;
			/*trace("angle = " + angle);*/
			this.rotation = angle;
			/*trace("this rotation is now " + this.rotation);*/
		}
		private function fire() {
			//set new addChild bullet x y, set bullet rotation, set bullet velocity
			//bullet needs a target but won't seek if homing = false
			/*gun.height*/
			var bullVel:Vector3D = new Vector3D(Math.sin(radians(angle))* -1* bulletSpeed, Math.cos(radians(angle))* bulletSpeed, 0);
			var bullet = new lv3BossBullet(bullVel, LazerCatAttack.you);
			bullet.homing = false;
			/*var l:int = pylon.height/2 + gun.height/2 + lv3BossBullet.height/2;*/
			//16.2 == lv3BossBullet.height
			var l:int = this.height/2 + 16.2/2;
			bullet.x = this.x - (Math.sin(radians(angle)) * l);
			bullet.y = this.y + (Math.cos(radians(angle)) * l);
			bullet.rotation = angle;
			if (lv3Boss.bob != null) {
				lv3Boss.bob.bobsBurgers.push(bullet);
			}
			LazerCatAttack.game.addChild(bullet);
		}
		public function findTurn() {
			switch (number) {
					case 1:
						myTurn = lv3BossPylon.turn1.concat();
						break;
					case 2:
						myTurn = lv3BossPylon.turn2.concat();
						break;
					case 3:
						myTurn = lv3BossPylon.turn3.concat();
						break;
					default:
						trace("lv3BossPylon.loop.switch problem");
				}
		}
		private function radians(angle) {
			var radians:Number = angle * Math.PI/180;
			return radians;
		}
		private function degrees(angle) {
			var degrees:Number = angle * 180/Math.PI;
			return degrees;
		}
		public function onCatch(xDif, yDif) {
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, revive);
			LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
			//do stun animation
			//do damage
			for (var i:int = 0; i < LazerCatAttack.you.ball.damage; i ++) {
				/*trace("dealing the lv2Boss da damages");*/
				if (i -1 == LazerCatAttack.you.ball.damage) {
					destroyYourself();
				}else {
					health --;
				}
			}
		}	
		public function revive(e:TimerEvent) {
			rCounter ++;
			if (rCounter >= stunTime *60) {
				//unstun
				LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
				LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, revive);
				alpha = 1;
				rCounter = 0;
			}
		}
		public function destroyYourself() {
			health --;
			if (health <= 0) {
				if (rCounter > 0 ) {
					LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, revive);
					rCounter = 0;
				}else {
					LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
				}
				LazerCatAttack.game.removeChild(this);
				LazerCatAttack.enemyList.splice(LazerCatAttack.enemyList.indexOf(this), 1);
				lv3Boss.pylons.splice(lv3Boss.pylons.indexOf(this), 1);
				if (lv3Boss.bob != null && lv3Boss.bob.defendMe == this) {
					lv3Boss.bob.defendMe = undefined;
				}
				if (playerKilledMe) {
					LazerCatAttack.huD.updateScore(this.points);
					/*var snd:Sound = new EnemyDeathSound;
					Main.sound.playFX(snd); */
				}
			/*}else if (playerKilledMe) {
				var snd:Sound = new HitSound;
				Main.sound.playFX(snd); */
			}
			playerKilledMe = false;
		}
	}
	
}
