package  {
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.media.Sound;
	
	public class lv1Boss extends MovieClip{
		//score stuff
		public var points:int = 20;
		public var playerKilledMe:Boolean = false;
		
		//list points
		public var pointLead:Point = new Point(250, 200);
		public var pointRight:Point = new Point();
		public var pointLeft:Point = new Point();
		public var wanderPoint1:Point = new Point(40,150);
		public var wanderPoint2:Point = new Point(300,300);
		public var wanderPoint3:Point = new Point(250,270);
		public var wanderPoint4:Point = new Point(200,300);
		public var wanderPoint5:Point = new Point(100, 70);
		public var finalBossWander1:Point = new Point(250, 100);
		public var finalBossWander2:Point = new Point(250, 300);
		public var finalBossWander3:Point = new Point(70, 300);
		public var finalBossWander4:Point = new Point(430, 300);
		private var movePoint:Array = new Array();
		//triangle formation side length
		public var sideLength:int = 200;
		
		public var targetPoint:Point;
		public static var bullet:Vector.<lv1BossBullet> = new <lv1BossBullet>[];
		
		//currently acceleration is off due to link behavior
		/*private var vx:Number = 0.00;
		private var vy:Number = 0.00;
		private var accel:Number = .2;
		private var maxSpeed:Number = 5;*/
		
		private var speed:Number = 2;
		private var goToEnabled:Boolean = false;
		public var xThere:Boolean = false;
		public var yThere:Boolean = false;
		public var changeX:Number = 0;
		public var changeY:int = 0;
		public var wandering:Boolean = false;
		
		public var boss1Alive:Boolean = true;
		public var boss2Alive:Boolean = true;
		public var boss3Alive:Boolean = true;
		public var lead:Boolean = false;
		public var right:Boolean = false;
		public var left:Boolean = false;
		public var unitFormed:Boolean = false;
		public var linkEnabled:Boolean = false;
		public var goGo:int = 0;
		
		//cooldownHandler variables
		public var lt:int = 0;
		public var unLt:int = 0;
		
		public var linked:Boolean = false;
		public static var linkedTime:int = 7;
		public var unlinkedTime:int = 2;
		public static var lv1BossLinks = new Vector.<lv1BossLink>();
		public static var lv1BossDrones = new Vector.<DroneShip>();
		public var dronesSetup:Boolean = false;
		
		public var bossCount:int = 3;
		public var hitPoints:int = 5;
		public var lazerHits:int = 0;
		private var bossName:int;
		private var h:int = 0;
		
		//fireRate is in seconds
		private var fireRate:int = 1;
		private var fireEnabled:Boolean = false;
		private var canFireNow:Boolean = false;
		public static var firePickerList:Array = new Array();
		//counter for the fireHandler
		private var fire:int = 0;
		//bullet vars explode, targetPoint, and path are only relevant with bossCount =1 
	/*	private var seeking:Boolean = false;
		private var thisTarget:*;
		private var bulletSpeed = 13;
		private var totalMass = 10;*/
		//there will be 6 different velociies that give different paths, write a function for that
		/*private var velocity:Vector3D = new Vector3D(-5,-5);*/
		private var bulletSpeed = 13;
		
		//invincibility link 
		public var invincible:Boolean = false;
		public var invincibilityEnabled:Boolean = true;
		
		public function lv1Boss(thisName) {
			/*vy = maxSpeed;
			vx = maxSpeed;*/
			//I'm sure knowing the name will be useful
			switch (thisName) {
				case "lv1Boss1":
					bossName = 1;
					break;
				case "lv1Boss2":
					bossName = 2;
					break;
				case "lv1Boss3":
					bossName = 3;
					break;
				default:
					trace("Name problems");
			}
			/*set triangular points, doing it this way allows it to be easily changed
			set a standard lead point then use trig to make the other two points
			based off a standard side length
			(Math.sin(Math.PI/3)/2) = height of triangle
			Math.cos(Math.PI/3))/sideLength = width / 2
			*/
			pointLead.setTo(250,200);
			pointRight.setTo((250 + (Math.round((Math.cos(Math.PI/3))*sideLength))), 200 - Math.round(((Math.sin(Math.PI/3))*sideLength)));
			pointLeft.setTo((250 - (Math.round((Math.cos(Math.PI/3))*sideLength))), 200 - Math.round(((Math.sin(Math.PI/3))*sideLength)));
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, coolDownHandler);
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, fireTimerHandler);
		}
		
		public function loop (e:TimerEvent):void {
			//figure out lead left right if bossCount is 3

			//if you're supposed to be going somewhere go there
			//note that when moving the left boss updates the links and other bosses' position
			if (goToEnabled) {
				//x
				//if (bossCount == 1) {
				//	for (var i:int = 0; i < lv1Boss.lv1BossDrones.length; i++) {
				//		lv1Boss.lv1BossDrones[i].x += changeX;
				//		lv1Boss.lv1BossDrones[i].y += changeY;
				//	}
				//}else {
				//	//nothing
				//}
				if (!xThere) {
				/*	if (vx < maxSpeed) {
						vx += accel;
					}
					else {
						vx = maxSpeed;
					}*/
					changeX = 0;
					var oldX = this.x;
					if (targetPoint.x > this.x) {
						if ((this.x += speed) > targetPoint.x) {
							this.x = targetPoint.x;
						}
					}
					else if (targetPoint.x < this.x) {
						if ((this.x -= speed) < targetPoint.x) {
							this.x = targetPoint.x;
						}
					}
					else {
						xThere = true;
						/*vx = 0;*/
					}
					if (this.left) {
						var newX = this.x;
						changeX = newX - oldX;
					}
				}	
				//y
				if (!yThere) {
					/*if (vy < maxSpeed) {
						vy += accel;
					}
					else {
						vy = maxSpeed;
					}*/
					changeY = 0;		
					var oldY = this.y;
					if (targetPoint.y > this.y) {
						if ((this.y += speed) > targetPoint.y) {
							this.y = targetPoint.y;
						}
					}
					else if (targetPoint.y < this.y) {
						if ((this.y -= speed) < targetPoint.y) {
							this.y = targetPoint.y;
						}
					}
					else {
						yThere = true;
						/*vy = 0;*/
					}
					if (this.left) {
						var newY = this.y;
						changeY = newY - oldY;
					}
				}
				//not quite sure here..custom complete event would be better than checking
				//this in the loop every tick.....
				if (this.xThere && this.yThere && !wandering) {
					goToEnabled = false;
				}
				if (this.xThere && this.yThere && this.wandering && this.left) {
					goTo(0);
				}
			}	
			//check to see if all remaining lv1Bosses are in position
			with (LazerCatAttack) {
				if (!goToEnabled && linkEnabled) {
					for (var b:int = 0; b < bossVector.length; b++) {
						if ( bossVector[b].xThere && bossVector[b].yThere && bossVector[b].linkEnabled) {
							goGo ++;
							if (goGo == bossCount && !this.linked) {				
								for (var b:int = 0; b < bossVector.length; b++) {
									bossVector[b].link();
									trace("loop calling link()");
									goGo = 0;
								}
								
							}
						}
						else {
							goGo = 0;
						}
					}
				}
			}	
			
			if (canFireNow && fireEnabled) {
				//during link only the last boss on the list will fire
				if (linked && lv1Boss.firePickerList[lv1Boss.firePickerList.length -1] == this) {
					fireBullet();
					lv1Boss.firePickerList.pop();
					if (lv1Boss.firePickerList.length == 0) {
						firePicker(10);
					}
					else {
						//do nothing
					}
				}
				else if (!linked) {
					fireBullet();
				}
				else {
					//do nothing
				}
			}
			// left boss updates the links positions
			if (linked && left || left && bossCount == 1) {
				for (var lP:int = 0; lP < lv1Boss.lv1BossLinks.length; lP++) {
					lv1Boss.lv1BossLinks[lP].y += changeY;
					lv1Boss.lv1BossLinks[lP].x += changeX;
					}
				
				for (var bP:int = 0; bP < LazerCatAttack.bossVector.length; bP ++) {
					//don't reupdate the left one's position because it already updated
					if (!LazerCatAttack.bossVector[bP].left) {
						LazerCatAttack.bossVector[bP].x += changeX;
						LazerCatAttack.bossVector[bP].y += changeY;
					}	
				}
			}
			if (bossCount == 1) {
				for (var i:int = 0; i < lv1Boss.lv1BossDrones.length; i++) {
					lv1Boss.lv1BossDrones[i].x += changeX;
					lv1Boss.lv1BossDrones[i].y += changeY;
				}
			}
		}
		public function functionHandler () {
			trace("functionHandler has been called");
			switch (bossCount) {
				case 3:
					triangulate();
					break;
				case 2:
					lineUp();
					break;
				case 1:
					lastStand();
					break;
			}
		}
		
		//generate random points for the Bosses to goTo
		
		private function fireTimerHandler (e:TimerEvent) {
			if (fireEnabled) {
				fire++;
			}
			if (fire > fireRate * 60) {
				canFireNow = true;
				fire = 0
			}
		}
		
		private function firePicker(length) {
			//code here to set up the Vector
			//only used for bossCount = 3
			var rando:Number = 0.000;
			var listLength:Number = length;
			/*trace(listLength);*/
			var fPL:int = 0;
			for (fPL; fPL < listLength; fPL ++) {
				rando = Math.random();
				/*trace(rando);*/
				if (rando > .6) {
					lv1Boss.firePickerList.unshift(LazerCatAttack.lv1Boss1);
				}
				else if (rando <= .6 && rando > .3) {
					lv1Boss.firePickerList.unshift(LazerCatAttack.lv1Boss2);
				}
				else {
					lv1Boss.firePickerList.unshift(LazerCatAttack.lv1Boss3);
				}
			}
			/*trace(lv1Boss.firePickerList);*/
		}	
		private function fireBullet() {
				var bullet = new lv1BossBullet(/*seeking, thisTarget, */bulletSpeed/*, totalMass, velocity*/);
				bullet.x = this.x;
				bullet.y = this.y;
				lv1Boss.bullet.push(bullet);
				LazerCatAttack.game.addChild(bullet);
				canFireNow = false;
		}
		
		private function goTo (nextPoint) {
			//if called by some function wanting to move boss randomly call with point(0,0)
			//this is jank, the goTo function shouldn't give coordinates
			if ((0 == nextPoint) && !wandering) {
				wandering = true;
				movePoint.unshift(wanderPoint1,wanderPoint2,wanderPoint3,wanderPoint4,wanderPoint5);
				targetPoint = movePoint[0];
				goToEnabled = true;
				xThere = false;
				yThere = false;
			}
			//if triangulate or other link system function gives goTo a destination 
			//immediately clear the movePoint array and go there.
			else if (0 == nextPoint && wandering) {
				targetPoint = movePoint.shift();
				xThere = false;
				yThere = false;
				if (movePoint.length == 0) {
					goToEnabled = false;
				}
			}
			else if (1 == nextPoint) {
				//code for boss1 waypoints
				wandering = true;
				//recent change //build 1
				movePoint.unshift(pointLeft, pointRight, pointLead, finalBossWander1/*, finalBossWander2, finalBossWander3, finalBossWander4, finalBossWander2, finalBossWander1*/);
				targetPoint = movePoint[0];
				goToEnabled = true;
				xThere = false;
				yThere = false;
			}
			else {
				var vectorLength = movePoint.length;
				targetPoint = nextPoint;
				movePoint.splice(0, vectorLength, targetPoint);
				goToEnabled = true;
				xThere = false;
				yThere = false;
			}
			
		}
		
		//only call this if there are three bosses, I dont know what'll happen if this
		//calls a null value or if static var's can even be null....
		//this code is probably unneccessary but whatever..use it dammit.
		//What if two coordinates are equal?
		private function triangulate () {
			trace("triangulating");
			//this determines roles then run goTo your role point
			with (LazerCatAttack) {
				//assign roles in triangle. assign lead then right
				//assign lead
				if (!lead && !right && !left ) {
					if (lv1Boss1.y >= lv1Boss2.y) {
						if (lv1Boss1.y >= lv1Boss3.y) {
							lv1Boss1.lead = true;
						}
						else if (lv1Boss3.y >= lv1Boss2.y) {
							lv1Boss3.lead = true;
						}					
					}
					else if (lv1Boss2.y >= lv1Boss3.y) {
						lv1Boss2.lead = true;
					}
					else {
						lv1Boss3.lead = true;
					}
				}
				
				//assign right (consider re-optimizing this)
						if (lv1Boss1.lead) {
							if (lv1Boss2.x >= lv1Boss3.x) {
								lv1Boss2.right = true;
								lv1Boss3.left = true;
							}	
							else {
								lv1Boss2.left = true;
								lv1Boss3.right = true;
							}
						}	
						else if (lv1Boss2.lead) {
							if (lv1Boss1.x >= lv1Boss3.x) {
								lv1Boss1.right = true;
								lv1Boss3.left = true;
							}	
							else {
								lv1Boss1.left = true;
								lv1Boss3.right = true;
							}
						}		
						else if (lv1Boss3.lead) {
							if (lv1Boss1.x >= lv1Boss2.x) {
								lv1Boss1.right = true;
								lv1Boss2.left = true;
							}	
							else {
								lv1Boss1.left = true;
								lv1Boss2.right = true;
							}
						}
						else {
							trace("triangulate found no lead");
						}
				}
		
			//goTo your Point
			if (this.lead){
				goTo(pointLead);
			}
			else if (this.right) {
				goTo(pointRight);
			}
			else if (this.left) {
				goTo(pointLeft);
			}
		}
		
		private function lineUp () {
			if (!boss1Alive) {
				if (this.bossName == 2) {
					left = true;
				}	
				else {
					right = true;
				}
			}
			else if (!boss2Alive) {
				if (this.bossName == 1) {
					left = true;
				}
				else {
					right = true;
				}
			}
			else {
				if (this.bossName == 1) {
					left = true;
				}
				else {
					right = true;
				}
			}
			//send them to their points
			if (right) {
				goTo(pointRight);
			}
			else {
				goTo(pointLeft);
			}
		}
		private function lastStand () {
			//triangulate-eske function for bossCount =1
			//set left to true plz for the unLink function to work
			left = true;
			goTo(pointLead);
			
		}
		
		private function link () {
			switch (bossCount) {
				case 3:
					//lead shoots to right point math on this is wrong
					//only one needs to set up the firePicker vector
					if (lead) {
						var newLink = new lv1BossLink(this.x + (pointRight.x - pointLead.x) /2,this.y -(pointLead.y - pointRight.y) /2,sideLength - 2*Math.sqrt(((Math.pow(this.height/2,2)) + (Math.pow(this.width/2,2)))), 300);
						lv1Boss.lv1BossLinks.push(newLink);
						trace("link lead");
						LazerCatAttack.game.addChild(newLink);
						invincible = true;
						linked = true;
						xThere = false;
						yThere = false;
						fireEnabled = true;
						firePicker(15);
					}
					//right shoots left
					else if (right) {
						var newLink1 = new lv1BossLink(pointLead.x,this.y,sideLength - this.width,180);
						lv1Boss.lv1BossLinks.push(newLink1);
						trace("link right");
						LazerCatAttack.game.addChild(newLink1);
						invincible = true;
						linked = true;
						xThere = false;
						yThere = false;
						fireEnabled = true;
					}
					//left shoots to front math on this is wrong
					//left will fire goTo and receive points to move to and through loop
					//function will lead the others.Used left because no lead in bosscount = 2
					else if (left) {
						var newLink2 = new lv1BossLink(this.x + (pointRight.x - pointLead.x) /2,this.y + (pointLead.y - pointRight.y) /2,sideLength - 2*Math.sqrt(((Math.pow(this.height/2,2)) + (Math.pow(this.width/2,2)))), 60);
						lv1Boss.lv1BossLinks.push(newLink2);
						trace("link left");
						LazerCatAttack.game.addChild(newLink2);
						invincible = true;
						linked = true;
						xThere = false;
						yThere = false;
						fireEnabled = true;
						goTo(0);
					}
					else {
						trace("problem in link function");
					}
					break;
				case 2:
					if (right) {
						linked = true;
						invincible = true;
						xThere = false;
						yThere = false;
						var newLink5 = new lv1BossLink(pointLead.x,this.y,sideLength - this.width,180);
						lv1Boss.lv1BossLinks.push(newLink5);
						LazerCatAttack.game.addChild(newLink5);
						//no firing
						fireEnabled = false;
					}
					else {
						linked = true;
						invincible = true;
						xThere = false;
						yThere = false;
						//move and lead
						goTo(0);
						//no firing
						fireEnabled = false;
					}
					LazerCatAttack.enemySpawn = true;
					if (Main.difSet == 1) {
						LazerCatAttack.game.difficulty = .6;
					} else if (Main.difSet == 2) {
						LazerCatAttack.game.difficulty = .7;
					} else if (Main.difSet == 3) {
						LazerCatAttack.game.difficulty = .98;
					}
					trace(" case two of Link fired");
					break;
				case 1:
					linked = true;
					invincible = false;
					xThere = false;
					yThere = false;
					//no firing seeking bullets
					fireEnabled = true;
					/*seeking = true;*/
					//move
					//recent change line 568 & 569
					goTo(1);
					if (!dronesSetup) {
						LazerCatAttack.enemySpawn = false;
						//could probably right a for function for this.....
						var bossDrone1 = new DroneShip;
						var bossDrone2 = new DroneShip;
						var bossDrone3 = new DroneShip;
						bossDrone1.freeMovement = false;
						bossDrone2.freeMovement = false;
						bossDrone3.freeMovement = false;
						bossDrone2.x = pointLead.x;
						bossDrone2.y = pointLead.y + bossDrone2.height/2 + this.height/2 + 50;
						bossDrone3.x = pointLead.x + bossDrone3.width + 10;
						bossDrone3.y = bossDrone2.y;
						bossDrone1.x = pointLead.x - bossDrone1.width -10;
						bossDrone1.y = bossDrone2.y;
						bossDrone1.invincible = true;
						bossDrone2.invincible = true;
						bossDrone3.invincible = true;
						lv1Boss.lv1BossDrones.unshift(bossDrone1, bossDrone2, bossDrone3);
						LazerCatAttack.enemyList.push(bossDrone1, bossDrone2, bossDrone3);
						LazerCatAttack.game.addChild(bossDrone1);
						LazerCatAttack.game.addChild(bossDrone2);
						LazerCatAttack.game.addChild(bossDrone3);
						dronesSetup = true;
					}	
					//code array 
					break;
				default:
					trace("Oh my glob bossCount issue at link()");
			}
		}
		
		//works as a behavioral switchboard using lt to synchronize
		public function coolDownHandler (e:TimerEvent) {
			//tells the boss to begin the link process after the unlink time is up
			if (!linked) {
				lt ++;
				if ((unlinkedTime * 60) < lt) {
					linkEnabled = true;
					wandering = false;
					functionHandler();
					trace("CoolDownHandler !linked linkEnabled true");
					lt = 0;
				}
			}
			
			//tells the boss to unlink after link time is up
			else if (linked) {
				lt ++;
				if ((linkedTime *60) < lt) {
					trace("unlink called at cooldownhandler");
					unLink();
					lt = 0;
				}
			}
		}
		
		public function unLink() {
			trace("unLink begun");
			switch (bossCount) {
				case 3:
					if (lead) {
						/*var bl:int = lv1Boss.lv1BossLinks.length - 1;
						for (bl; bl <= lv1Boss.lv1BossLinks.length; bl --) {
							lv1Boss.lv1BossLinks[bl].remove();
							if (bl == 0) {
								bl = 2;
							}
						}*/
						for (var i:int = lv1Boss.lv1BossLinks.length - 1; i >= 0; i --) {
							lv1Boss.lv1BossLinks[i].remove();
						}
						lv1Boss.firePickerList.splice(0,lv1Boss.firePickerList.length);
						linkEnabled = false;
						linked = false;
						invincible = false;
					}
					else if (right) {
						linkEnabled = false;
						linked = false;
						invincible = false;
						fireEnabled = false;
					}
					else {
						linkEnabled = false;
						linked = false;
						invincible = false;
						fireEnabled = false;
					}
					break;
				case 2:
					if (left) {
						lv1Boss.lv1BossLinks[0].remove();
						linkEnabled = false;
						linked = false;
					}
					else if (right) {
						linkEnabled = false;
						linked = false
					}
					else {
						trace("unlink case 2 error");
					}
					break;
				case 1:
					if (left) {
					/*	linkEnabled = false;
						linked = false;*/
						//remove lv1Boss drones from LazerCatAttack.game and vectors
					/*	for (var i:int = 0; i < lv1Boss.lv1BossDrones.length; i++) {
							lv1Boss.lv1BossDrones[i].invincible = false;
							lv1Boss.lv1BossDrones[i].destroyYourself();
							LazerCatAttack.enemyList.splice(LazerCatAttack.enemyList.indexOf(lv1Boss.lv1BossDrones[i]),1);
						}
						lv1Boss.lv1BossDrones.splice(0,lv1Boss.lv1BossDrones.length);*/
					}
					break;
				default:
					trace("Problems in unlink");
			}
			invincible = false;
			linked = false;
			left = false;
			right = false;
			lead = false;
		}
		
		public function remove () {
			if (!invincible) {
				h ++;
			}
			with (LazerCatAttack) {
				//recent change
				//hopefully resolves the restart glitch, restarting will set hitPoints to 0, nothing else does 
				if (hitPoints == 0) {
					for (var bc:int = 0; bc < bossVector.length; bc++) {
						bossVector[bc].bossCount -= 1;
					}
					trace("bossVector length = " + bossVector.length);
					bossVector.splice((bossVector.indexOf(this)), 1);
					gameTimer.removeEventListener(TimerEvent.TIMER, this.loop);
					gameTimer.removeEventListener(TimerEvent.TIMER, this.coolDownHandler);
					gameTimer.removeEventListener(TimerEvent.TIMER, fireTimerHandler);
					LazerCatAttack.game.removeChild(this);
					if (this.bossCount == 0) {
						trace("last boss died vector" + bossVector.length);
						var deathTime = timeIndex;
						//recent change
						for (var i:int = lv1Boss.lv1BossLinks.length - 1; i >=0; i --) {
							lv1Boss.lv1BossLinks[i].remove();
						}
						for (var i:int = lv1Boss.lv1BossDrones.length - 1; i >= 0; i--) {
							if (lv1Boss.lv1BossDrones[i] != null) {
								lv1Boss.lv1BossDrones[i].invincible = false;
								lv1Boss.lv1BossDrones[i].destroyYourself();
								lv1Boss.lv1BossDrones[i].kick();
								/*enemyList.splice(enemyList.indexOf(lv1Boss.lv1BossDrones[i]),1);*/
							}
						}
						lv1Boss.lv1BossDrones.splice(0, lv1Boss.lv1BossDrones.length);
						LazerCatAttack.game.q = 0;
						LazerCatAttack.game.bossFight = false;
					}	
				}else if (h >= hitPoints) {
					//send dead boss name : put this in the for function below
					//one of these bosses should probably become left since left
					//boss controlls movement.
					if (this.bossName == 1) {
						if (boss2Alive) {
							lv1Boss2.boss1Alive = false;
						}
						if (boss3Alive) {
							lv1Boss3.boss1Alive = false;
						}	
					}
					else if (this.bossName == 2) {
						if (boss1Alive) {
							lv1Boss1.boss2Alive = false;	
						}
						if (boss3Alive) {
							lv1Boss3.boss2Alive = false;
						}
					}
					else {
						if (boss1Alive) {
							lv1Boss1.boss3Alive = false;
						}
						if (boss2Alive) {
							lv1Boss2.boss3Alive = false;
						}
					}
					for (var bc:int = 0; bc < bossVector.length; bc++) {
						bossVector[bc].bossCount -= 1;
					}
					/*trace(bossVector.length);*/
					bossVector.splice((bossVector.indexOf(this)), 1);
					//need a start point for level two events so get the time when the last boss died
					if (this.bossCount == 0) {
						trace("last boss died vector" + bossVector.length);
						if (playerKilledMe) {
							if (Main.difSet == 1) {
								Main.so.data.beatL1Casual = true;
							}else if (Main.difSet == 2) {
								Main.so.data.beatL1Normal = true;
							}else if (Main.difSet == 3) {
								Main.so.data.beatL1Hard = true;
							}else {
								trace("lv1Boss is unaware of what difficulty you beat");
							}
							var upgrade = new UpgradeScreen;
							upgrade.x = 250 - upgrade.width/2;
							upgrade.y = 300 - upgrade.height/2;
							LazerCatAttack.game.addChild(upgrade);
							LazerCatAttack.gameTimer.stop();
							var deathTime:int = LazerCatAttack.timeIndex;
							LazerCatAttack.endLv1 = deathTime / 60;
							/*trace(deathTime);
							trace("endLv1 = " + endLv1);
							trace("LazerCatAttack.timeIndex = " + LazerCatAttack.timeIndex);*/
							//bring the player health back up to full
							var hits:int = LazerCatAttack.you.hits;
							LazerCatAttack.you.hits = 0;
							LazerCatAttack.huD.updateHitPoints(-hits);
							
							LazerCatAttack.game.level1 = false;
							LazerCatAttack.level2 = true;
							LazerCatAttack.game.q = 0;
							LazerCatAttack.game.bossFight = false;
							//passive upgrade screen
							LazerCatAttack.game.showPassive = true;
							LazerCatAttack.huD.updateScore(this.points);
							/*var snd:Sound = new EnemyDeathSound;
							Main.sound.playFX(snd); */
						}	
						//recent change
						for (var i:int = lv1Boss.lv1BossLinks.length -1; i >=0; i --) {
							lv1Boss.lv1BossLinks[i].remove();
						}
						//endLv1 is the number of seconds the bossfight lasted [changed that]
						//create upgrade screen and move this stuff to the upgrade continue button
						
						
						//recent change
						for (var i:int = lv1Boss.lv1BossDrones.length - 1; i >= 0; i--) {
							if (lv1Boss.lv1BossDrones[i] != null) {
								lv1Boss.lv1BossDrones[i].invincible = false;
								lv1Boss.lv1BossDrones[i].destroyYourself();
							}
						}
						lv1Boss.lv1BossDrones.splice(0, lv1BossDrones.length);
					}else {
						trace("lv1Boss removes says bosscount ! == 0");
						for (var bc:int = 0; bc < bossVector.length; bc++) {
							bossVector[bc].functionHandler();
						}
					}
					gameTimer.removeEventListener(TimerEvent.TIMER, this.loop);
					gameTimer.removeEventListener(TimerEvent.TIMER, this.coolDownHandler);
					gameTimer.removeEventListener(TimerEvent.TIMER, this.fireTimerHandler);
					LazerCatAttack.game.removeChild(this);
				/*}else if (playerKilledMe && !invincible) {
					var snd:Sound = new HitSound;
					Main.sound.playFX(snd); */
				}
			}
			playerKilledMe = false;
		}	
		
	}
}
