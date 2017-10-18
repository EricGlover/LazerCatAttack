package  {
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.geom.Vector3D;
	
	
	public class Cat extends MovieClip {
		public var hitPoints:int = 5;
		public var presetHitPoints:int = 5;
		public var h:int = 0;
		private var flicker:int = 0;
		private var flickerTimer:int = 0;
		private var flickerTime:Number = .21;
		public var testing:Boolean = false;
		private var player:Player;
		public var catScreen:CatScreen = new CatScreen();
		public var firstTime:Boolean = true;
		public var onScreen:Boolean = false;
		//consider adding a button for the cat screen
		public var screenTime:int = 7;
		private var count:int = 0;
		public var invincible:Boolean = false;
		public static var daCat:Cat;
		private var counter:int = 0;
		//attached = true == cat is onboard your ship
		public var attached:Boolean = false;
		private var ejected:Boolean = false;
		private var deacceleration:Number = 1.01;
		private var detachedTimer:int = 0;
		private var detachedTime:Number = 1.3;
		
		//movement vars
		public var position:Vector3D = new Vector3D();
		public var velocity:Vector3D = new Vector3D();
		public var maxVelocity:int = 2;
		public var target:Vector3D = new Vector3D;
		public var selectedTarget:*;
		private var desired:Vector3D = new Vector3D;
		
		
		public function Cat(myMoveTarget) {
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
			player = LazerCatAttack.you;
			position.x = this.x;
			position.y = this.y;
			selectedTarget = myMoveTarget;
			mouseEnabled = false;
		}
		public function loop(e:TimerEvent) {
			position.x = this.x;
			position.y = this.y;
			if (counter == 0) {
				Cat.daCat = this;
			}
			counter ++;
			//collision avoidance would be cool for the cat
			target.x = selectedTarget.x;
			target.y = selectedTarget.y;
			//movin yo
			desired = target.subtract(position);
			truncate(desired, maxVelocity);
			//give the cat some movement after he's ejected later, but for now he'll just passively fly off in space
			if (firstTime) {
				velocity = desired.clone();
			}
			//add code to stop nearness spazzzz
			if (player != null && !attached && (firstTime || (counter - detachedTimer) > detachedTime * LazerCatAttack.frameSpeed)) {
				if (hitTestObject(player)) {
					//add cat to the ship
					//later add a button or something to the screen, dear god...
					if (firstTime) {
						catScreen.x = 50;
						catScreen.y = 100;
						LazerCatAttack.game.addChild(catScreen);
						firstTime = false;
						LazerCatAttack.gameTimer.stop();
						Player.playerTimer.addEventListener(TimerEvent.TIMER, loop);
						onScreen = true;
						player.lazerEnabled = true;
						LazerCatAttack.game.cdHud.updateLazer(true, 1);
					}
					//everytime you run into the cat you should pick him up
					attached = true;
					ejected = false;
					/*LazerCatAttack.game.removeChild(this);*/
					/*player.addChild(this);*/
					player.addCat();
				}
			}
			if (!firstTime && onScreen) {
				count ++;
				if (count >= screenTime * LazerCatAttack.frameSpeed) {
					LazerCatAttack.game.removeChild(catScreen);
					LazerCatAttack.gameTimer.start();
					Player.playerTimer.removeEventListener(TimerEvent.TIMER, loop);
					onScreen = false;
					count = 0;
				}
			}
			//velocity = ?
			if (!attached && ejected) {
				var newPos:Vector3D = new Vector3D();
				newPos = position.add(velocity);
				//resultin sticking to screen and not using the other velocity bit but idk if I like it
				if (newPos.x + this.width/2 < 500 && newPos.x - this.width/2 > 0 && newPos.y + this.height/2 < 600 && newPos.y - this.height/2 > 0) {
					//further if going to the top of the screen stop, if already there and traveling up bounce off the top
					if (newPos.y < 50) {
						if (position.y < 50) {
							//if traveling up
							if (velocity.y <= 0) {
								velocity.y  = velocity.y * -1;
							}
						}else {
							velocity.y = 0;
							velocity.x = 0;
						}
					}
					position = position.add(velocity);
					velocity.x /= deacceleration;
					velocity.y /= deacceleration;
				}	
			}else if (!attached) {
				//add if velocity angle is towards the screen then it's ok otherwise when starting offscreen cat can't move onscreen
				//var newPos:Vector3D = new Vector3D();
				//newPos = position.add(velocity);
				////resultin sticking to screen and not using the other velocity bit but idk if I like it
				//if (newPos.x + this.width/2 < 500 && newPos.x - this.width/2 > 0 && newPos.y + this.height/2 < 600 && newPos.y - this.height/2 > 0) {
				//	
				position = position.add(velocity);
				/*}	*/
			}
			this.x = position.x;
			this.y = position.y;
		}
		public function thankYou() {
			//display new Upgrade screen and remove the cat, maybe have him fly off or something...
			
		}
		public function unattach (velocityAngle) {
			//until I figure out reParenting I'll keep killing these cats
			var oldH:int = this.h;
			Cat.daCat.hitPoints = 0;
			Cat.daCat.invincible = false;
			Cat.daCat.testing = false;
			Cat.daCat.destroyYourself();
			//this is mighty weird but will change the read only velocity length
			// I'll even make him move to you after he's  off the ship
			var cat = new Cat(player);
			cat.h = oldH;
			cat.x = player.x;
			cat.y = player.y;
			cat.attached = false;
			cat.firstTime = false;
			cat.ejected = true;
			LazerCatAttack.game.addChild(cat);
			var vel:Vector3D = new Vector3D(1000, 1000, 0);
			truncate(vel, maxVelocity);
			setAngle(vel, velocityAngle);
			cat.velocity.x = vel.x;
			cat.velocity.y = vel.y;
			cat.detachedTimer = 0;
		}
		private function setAngle(vector:Vector3D, angle:Number):void {
			var length1:Number = vector.length;
			vector.x = Math.cos(angle) * length1;
			vector.y = Math.sin(angle) * length1;
		}
		private function truncate(vector:Vector3D, max:Number):void {
			var i:int;
			i = vector.length/max;
			if (i > 1) {
				if (max == 0){
					trace("error, @lv2BossBullet truncate");
				}else {
					vector.scaleBy(1/i);
				}
			}
		}
		public function justHit(e:TimerEvent) {
			//flicker, invincible for one or so seconds
			flicker ++;
			flickerTimer ++;
			if (flicker == 1) {
				this.alpha -= .7;
			} else if (flicker == 2) {
				flicker = 0;
				this.alpha += .7;
			}
			if (flickerTimer >= flickerTime * 60) {
				LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, justHit);
				flickerTimer = 0;
				flicker = 0;
				invincible = false;
				this.alpha = 1;
			}
		}
		public function revive() {
			//since pokeball called destroyYourself() once reset h
			h --;
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
			hitPoints = presetHitPoints;
			Cat.daCat = this;
		}
		public function destroyYourself() {
			//if player later gets any vars based on the cat remove them too
			if (!invincible && !testing) {
				h ++;
				/*trace("CAT HAS BEEN HIT MY H = " + h);*/
				invincible = true;
				LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, justHit);
				if (hitPoints == 0) {
				//	//remove this later if restart and normal death work the same
					LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
					LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, justHit);
					if (this.parent == LazerCatAttack.game) {
						LazerCatAttack.game.removeChild(this);
					}else if (player.contains(this)){
						player.removeChild(this);
					}
					Cat.daCat = null;
				}else if (h >= hitPoints) {
					LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
					if (LazerCatAttack.game.contains(this)) {
						LazerCatAttack.game.removeChild(this);
					}else if (player.contains(this)){
						player.removeChild(this);
					}
					player.invincible = false;
					player.hitPoints = 0;
					player.killPlayer();
					Cat.daCat = null;
					//crash the game plzl
				}
			}
		}
	}
	
}
