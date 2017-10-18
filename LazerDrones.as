package  {
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.*;
	import flash.media.Sound;
	
	//these drones spawn RIGHTEOUS LAZERs between two particular instances and then procede downscreen.
	//LazerCatAttack.lazerDroneList is the array containing them, and they remove themselves upon death only
	public class LazerDrones extends MovieClip {
			private var vy = 3; //.3
			private var vx = 3;
			private var startSpeed = 3;
			private var va = .2;
			private var maxVelocity = 3;
			private var point:Point;
			public var lazerOn:Boolean = false;
			public var target:LazerDrones;
			public var paired:Boolean = false;
			public static var lazerWidth:int = 130;
			public static var lazerMinWidth = 40;
			public var lazerWidth = 130;
			public var lazerMinWidth = 40;
			public var lazer;
			public static var lazers:Array = new Array();
			public static var lazerPool:Vector.<LazerDroneLazer> = new Vector.<LazerDroneLazer>;
			public var goToX:int;
			public var xReady:Boolean = false;
			public var righty:Boolean = false;
			public var lazerHits:int = 0;
			public var naturalHitPoints:int = 1;
			public var hitPoints:int = 1;
			public var h:int = 0;
			public var points:int = 1;
			public var invincible:Boolean = false;
			public var playerKilledMe:Boolean = false;
			public var caught:Boolean = false;
			
			private var laz:LazerDrones;

			//which one of the two drones fires the lazer
			public var firer = false;
		
		public function LazerDrones() {
			//600 is LazerCatAttack.game width but 550 ensures they are fully onscreen
			/*if (x== 0) {
				x = Math.random() * 550;
			}
			lazerWidth = LazerDrones.lazerWidth;
			lazerMinWidth = LazerDrones.lazerMinWidth;*/
			/*LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);*/
			
			
		}
		public function recycle() {
			x = Math.random() * 550;
			lazerWidth = LazerDrones.lazerWidth;
			lazerMinWidth = LazerDrones.lazerMinWidth;
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
			hitPoints = naturalHitPoints;
			h = 0;
			caught = false;
			invincible = false;
			firer = false;
			righty = false;
			lazerOn = false;
			paired = false;
			xReady = false;
		}

		public function loop (e:TimerEvent) {
			//crash into player ship
			if (LazerCatAttack.you != null && hitTestObject(LazerCatAttack.you)) {
				destroyYourself();
			}
			
			//not paired state functions
			if (!paired) {
				//find a pair (buddy system man)
				/*var laz:LazerDrones;*/
				for (var ld:int = LazerCatAttack.lazerDroneList.length - 1; ld >= 0; ld--) {
					laz = LazerCatAttack.lazerDroneList[ld];
					if (!laz.paired) {
						if (this == laz) {
							//do nothing
						}else{	
							paired = true;
							laz.paired = true;
							target = laz;
							target.target = this;
							target.y = this.y;
							target.invincible = true;
							invincible = true;
							firer = true;
							//use max lazerWidth;
							if (Math.abs((target.x - this.x)) > lazerWidth) {
								/*trace("greater than lazerWidth");*/
								/*trace("this.x = " + this.x + " target.x = " + target.x);*/
								if (Math.random() > .5) {
									if (this.x > target.x) {
										target.goToX = this.x - lazerWidth;
									}else {
										target.goToX = this.x + lazerWidth;
									}
									goToX = this.x;
									/*trace("ran 1");*/
								}else {
									if (this.x > target.x) {
										goToX = target.x + lazerWidth;
									}else {
										goToX = target.x - lazerWidth;
									}
									target.goToX = target.x;
									/*trace("ran 2");*/
								}
							}else if (Math.abs((target.x - this.x)) > lazerMinWidth) {
								fireTheLazer(target);
							}else {
								if (this.x > target.x) {
									goToX = this.x + 40;
									target.goToX = target.x;
								}else {
									goToX = this.x - 40;
									target.goToX = target.x;
								}
							}
							////implement goTo points
							//if (this.x == Math.max(this.x,target.x)) {
							//	var difference:int = this.x - target.x;
							//	goToX = this.x - difference/2 + lazerWidth/2; 
							//	target.goToX = target.x + difference/2 - lazerWidth/2;
							//}else if (this.x == Math.min(this.x,target.x)) {
							//	var difference:int = target.x - this.x;
							//	goToX = this.x + difference/2 - lazerWidth/2; 
							//	target.goToX = target.x - difference/2 + lazerWidth/2;
							//}else{
							//	trace("goTo issues");
							//}
							break;
						}
					}
				}
			}	
			//paired state functions
			if (paired && !lazerOn) {
				if (goToX > this.x) {
					if(this.x + vx > goToX) {
						this.x = goToX;
						xReady = true;
					}
					else{
						this.x += vx;	
					}
				}else if (goToX < this.x) {
					if(this.x - vx < goToX) {
						this.x = goToX;
						xReady = true;
					}
					else{
						this.x -= vx;
					}
				}else if(this.x == goToX) {
					xReady = true;
				}
				//only the one drone fires the lazer
				if (firer && this.xReady && target.xReady) {
					fireTheLazer(target);
				}
			}
			// no moving unless lazer is on
			if (lazerOn) {
				/*this.y += vy;*/
				if (firer) {
					this.y += vy;
					target.y = this.y;
					lazer.y = this.y;
				}
				/*if (vy < maxVelocity) {
					vy += va;
				}else {	
					vy = maxVelocity;
				}*/
				
			}
			if (this.y > 600 + this.height/2) {
				invincible = false;
				destroyYourself();
			}
			
		}
		//paired get and set method
		//public function get isPaired() {
		//	return(this.paired);
		//}
		//
		//public function set isPaired(thing:Boolean) {
		//	paired = thing;
		//}
		//
		//// get method for point
		//public function get myPoint () {
		//	return(this.point);
		//}
		public function onCatch() {
			//just destroy it, for fuck's sake I hate this class's code
			if (!caught) {
				invincible = false;
				hitPoints = 0;
				if (target != null) {
					//using target = null will allow you to determine if this was the first of the pair to get the notification
					//and then not have them contiunally telling one another to destroy themselves..
					if (target.caught) {
						target = null;
					}else if (!target.caught){
						target.invincible = false;
						target.hitPoints = 0;
						target.caught = true;
						target.destroyYourself();
						target = null;
					}
				}
				caught = true;
				destroyYourself();
			}else {
				//you've been called twice, just don't do anything
			}			
		}
		public function destroyYourself():void {
			if (!invincible) {
				h ++;
				if (h >= hitPoints) {
					LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
					if (firer && lazerOn) {
						lazer.invincible = false;
						lazer.remove();	
						lazer = null;
					}
					else {
						//nothing
					}
					if (playerKilledMe) {
						LazerCatAttack.huD.updateScore(this.points);
						/*var snd:Sound = new EnemyDeathSound;
						Main.sound.playFX(snd); */
					}
					playerKilledMe = false;
					/*trace("this lazerDrones index, that is being removed = " + LazerCatAttack.lazerDroneList.indexOf);*/
					LazerCatAttack.lazerDroneList.splice(LazerCatAttack.lazerDroneList.indexOf(this), 1);
					LazerCatAttack.game.removeChild(this);
					LazerCatAttack.game.lazerDPool.push(this);
					target = null;
					this.y = 0;
				/*}else if (playerKilledMe) {
					var snd:Sound = new HitSound;
					Main.sound.playFX(snd); */
				}				
			}	
			playerKilledMe = false;
		}
		//figure out how to reference instance points and use Point.distance() later
		//only righty fires the lazer it appears
		public function fireTheLazer (target:LazerDrones){
			//righty means shoots right
			var lazerLength = Math.abs(target.x - this.x) - this.width;
			if (LazerDrones.lazerPool.length > 0) {
				lazer = LazerDrones.lazerPool.pop();
			}else {
				lazer = new LazerDroneLazer();
			}
			lazer.recycle(lazerLength, target);
			LazerDrones.lazers.push(lazer);
			lazer.y = this.y;
			target.y = this.y;
			if (this.x < target.x) {
				righty = true;
				lazer.x = this.x + (this.width / 2) + (lazerLength/2);
			}else {
				righty = false;
				lazer.x = this.x - (this.width / 2) - (lazerLength/2);
				/*trace("lazerdrone is lefty");*/
			}
			LazerCatAttack.game.addChild(lazer);
			LazerDrones.lazers.push(lazer);
			target.lazerOn = true;
			lazerOn = true;
		}
	
	}
}
