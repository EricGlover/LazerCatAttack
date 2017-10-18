package  {
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.geom.*;
	import flash.media.Sound;
	
	
	public class DeathBallerz extends MovieClip {
		public var h:int = 0;
		public var hitPoints = 3;
		public var presetHitPoints = 3;
		public var lazerHits:int = 0;
		public var points = 3;
		public var playerKilledMe:Boolean = false;
		private var target = new Vector3D();
		private var selectedTarget:*;
		private var mass:int = .5; //changed this from 0 !!
		private	var desired	 = new Vector3D(0, 0, 0); 
		private var steering = new Vector3D(0, 0, 0); 
		public var position = new Vector3D();
		public var positionPoint:Point = new Point();
		private var velocity = new Vector3D();
		private var maxForce:int = 2;
		private var maxVelocity:int = 2.7;
		private var changeX:Number = 0;
		private var changeY:Number = 0;
		private var brain:Array = new Array();
		public var groupies:Array = new Array();
		public var bossComing:Boolean = false;
		
		//drone width and height
		private var droneW:int = DroneShip.width;
		private var droneH:int = DroneShip.height;

		//Death Ballerz current height and width
		private var dBW:int = 27;
		private var dBH:int = 20;
		
		//groupie points
		private var point1:Point = new Point(dBW/2 - dBW/5 + droneW/2, droneH/2 + 10);
		private var point2:Point = new Point(dBW/5 - dBW/2 - droneW/2, point1.y);
		private var point3:Point = new Point(point1.x + droneW/2, droneH/4 + 10);
		private var point4:Point = new Point(point2.x - droneW/2, point3.y);
		private var point5:Point = new Point(0, droneH/2 + 30);
		/*private var point1:Point = new Point(10,10);
		private var point2:Point = new Point(-10,-10);
		private var point3:Point = new Point(20, 5);
		private var point4:Point = new Point(-20,-5);
		private var point5:Point = new Point(0,15);*/
		private var totalGroupies:int = 5;
		private var lastGroup:int = 0;
		private var activeState:int = 0;
		private var circling:Boolean = false;
		private var circlingRadiusMod:int = 5;
		private var retreatDist:int = 150;
		private var corner:Boolean = false;
		
		//the radius of the imaginary circle around them that other deathballerz will avoid.
		public var radius:int = 10;
		private var detectRadius:int = 120;
		private var ahead = new Vector3D();
		private var ahead2 = new Vector3D();
		private var visionRange:int = 20;
		private var maxAvoidForce:int = 2;
		/*private var setupPoint:Point = new Point(150,150);*/
		private var setupPoint:Point;
		private var setupComplete:Boolean = false;
		private var fireTime:int = 0;
		private var fireCooldown:int = 2 * LazerCatAttack.frameSpeed;
		private var fireEnabled:Boolean = false;
		
		//testing pokeball
		public var caught:Boolean = false;
		
		//currently the vectors here are crazy man
		
		//DeathBallerz will have ~4 states: setup, attack, fly away, reposition
		//setup, start by going to the stagePoint given to them then 
		//circle around while gather "groupies" in array
		//when full go to attack (seek, while avoiding collisions)
		//then if close to player fly away (seek nearest screen corner, while avoiding)
		//then reappear at the top at random x and attack, rise and repeat.
		
		public function DeathBallerz(velocity, totalMass, setupP) {
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, fireCooldownHandler);
			position.setTo(this.x, this.y, 0);
			positionPoint.setTo(this.x,this.y);
			this.velocity = velocity;
			mass = totalMass;
			this.setupPoint = setupP;
			selectedTarget = this.setupPoint;
			target.setTo(selectedTarget.x, selectedTarget.y, 0);
			mouseEnabled = false;
			/*brain.push(0);*/
			brain[0] = 0;
		}
		
		public function loop (e:TimerEvent) {
			//decide behavior 0 attack, 1 fly away, 2 reposition
			activeState = brain[0];
			switch (activeState) {
				case 0:
					//do nothing
					//recent change, don't know if this works....
					if (!bossComing) {
						detectGroupies();
						if (!circling) {
							checkCircling();
						}
					}else if (bossComing) {
						brain[0] = 2;
					}	
					controlGroupies(changeX, changeY);
					break;
				case 1:
					//attack sequence
					circling = false;
					this.maxVelocity = 2;
					if (!setupComplete) {
						detectGroupies();
					}
					if (distance(this, LazerCatAttack.you) < retreatDist) {
						brain[0] = 2;
					}
					else if (distance(this, LazerCatAttack.you) > retreatDist) {
						selectedTarget = LazerCatAttack.you;
					}
					controlGroupies(changeX, changeY);
					//start firing
					fireEnabled = true;
					break;
				case 2:
					//fly off in style : check for closest corner
					if (!setupComplete) {
						detectGroupies();
					}
					if (!corner) {
						pickCorner();
						controlGroupies(changeX, changeY);
					}
					else if (corner) {
						if (this.y > LazerCatAttack.height || this.y < 0 || this.x < 0 || this.x > LazerCatAttack.width) {
							if (!bossComing) {
								brain[0] = 1;
								//update changeX changeY
								oldX = this.x;
								oldY = this.y;
								this.x = -40;
								this.y = -40;
								var newX = this.x;
								var newY = this.y;
								changeX += newX - oldX;
								changeY += newY - oldY;
								corner = false;
								controlGroupies(changeX, changeY);
							}else if (bossComing) {
								hitPoints = 0;
								destroyYourself();
							}
						}else {
							controlGroupies(changeX, changeY);
						}
					}
					break;
				case 3:
					selectedTarget = LazerCatAttack.you;
					controlGroupies(changeX, changeY);
					break;
				default:
					//nothing
			}
			//MOVEMENT
			
			//update the target vector
			position.x = this.x;
			position.y = this.y;
			var oldX:Number = this.x;
			var oldY:Number = this.y;
			
			//if you want to have groupies being added during attack mode then change detectGroupies 
			//to have the groupies seek the correct position instead of just moving analogous to the DB
			/*detectGroupies();*/
			target.setTo(selectedTarget.x, selectedTarget.y, 0);
			steering = seek(target);
			if (circling) {
				var circleSteering= new Vector3D();
				var circlingRadius = velocity.length / circlingRadiusMod; 
				var angle2 = Math.atan2(velocity.y, velocity.x) + Math.PI/2;
				var newVecY = Math.sin(angle2) * circlingRadius;
				var newVecX = Math.cos(angle2) * circlingRadius;
				circleSteering.setTo(newVecX, newVecY, 0);
				steering = circleSteering;
			}
			truncate(steering, maxForce);
			steering.scaleBy(1 / mass);
			velocity = velocity.add(steering);
			truncate(velocity, maxVelocity);
			position = position.add(velocity);
			

			this.x = position.x;
			this.y = position.y;
			positionPoint.x = this.x;
			positionPoint.y = this.y;
			changeX = this.x - oldX;
			changeY = this.y - oldY;
			if (setupComplete && groupies.length < totalGroupies) {
				setupComplete = false;
				for (var i:int = 0; i< groupies.length; i++) {
					groupies[i].inPosition = false;
					groupies[i].xThere = false;
					groupies[i].yThere = false;
					lastGroup = groupies.length;
				}
			}
			//handle Groupies
			if(!setupComplete){
				if (groupies.length < lastGroup) {
					for (var i = 0; i < groupies.length; i++) {
						groupies[i].xThere = false;
						groupies[i].yThere = false;
						groupies[i].inPosition = false;
					}
				}
				var newPoint:Point = new Point;
				for (var i = 0; i < groupies.length; i++) {
					if (!groupies[i].inPosition) {
						switch (i) {
							case 0:
								newPoint = positionPoint.add(point1);
								break;
							case 1:
								newPoint = positionPoint.add(point2);
								break;
							case 2:
								newPoint = positionPoint.add(point3);
								break;
							case 3:
								newPoint = positionPoint.add(point4);
								break;
							case 4:
								newPoint = positionPoint.add(point5);
								break;
							default:
								//nothing
						}
						groupies[i].goTo(newPoint);
						newPoint.setTo(0,0);
					}/*else if (groupies[i].inPosition) {
						groupies[i].x += this.changeX;
						groupies[i].y += this.changeY;
					}*/
				}
				lastGroup = groupies.length;
				if (detectFormation()){
					setupComplete = true;
					//add in this setup Point to the list
					//set for attack mode
					if (brain[0] == 0) {
						brain[0] = 1;
						LazerCatAttack.game.setupPoint.unshift(this.setupPoint);
						setupPoint = null;
					}
				}
			}	
		}
		//fire function
		private function fire(shots) {
			
		}
		
		private function fireCooldownHandler (e:TimerEvent) {
			if (!fireEnabled) {
				fireTime ++;
				if (fireTime == fireCooldown) {
					fireEnabled = true;
					fireTime = 0;
				}
			}
		}
		
		
		//problems with this in collision avoidance
		private function distance(a, b):int {
			return (Math.sqrt((a.x - b.x) * (a.x - b.x)  + (a.y - b.y) * (a.y - b.y)));
		}
 
		private function lineIntersectsCircle(ahead:Vector3D, ahead2:Vector3D, obstacle):Boolean {
			// check that this return is written correctly (do I need parentheses?)
			return distance(obstacle, ahead) <= obstacle.radius || distance(obstacle, ahead2) <= obstacle.radius;
			/*trace("lineIntersectsCircle ran");*/
		}		
		//read and implement page 241 for vector.length = 0
		public function truncate(vector: Vector3D, max: Number):void {
			var i:Number;
			i = max / vector.length;
			/*trace(vector);
			trace(max);*/
			if ( i < 1) {
				vector.scaleBy(i);
				/*trace("vector after scaleby = " + vector);*/
			}	
		}
		
		private function seek(target:Vector3D):Vector3D {
			var force:Vector3D;
			
			desired = target.subtract(position);
			desired.normalize();
			desired.scaleBy(maxVelocity);
			force = desired.subtract(velocity);
			return force;
		}
		
		private function pickCorner() {
			var theCorner:Number = Math.random();
			if(theCorner > .5) {
				selectedTarget = new Point(-30, -50);
			}
			else {
				selectedTarget = new Point(stage.width + 50, -50);
			}
			corner = true;
		}
		
		private function checkCircling() {
			//if near setupPoint then start circling
			if ((setupPoint.x + 10 >= this.x && setupPoint.x - 10 <=  this.x) && (setupPoint.y + 10 >= this.y && setupPoint.y - 10 <= this.y)) {
				circling = true;
			}
		}
		
		private function detectGroupies() {
			//if drone within certain radius pass them coordinates to goTo
			if (groupies.length < totalGroupies) {
				for (var i:int = 0; i < LazerCatAttack.enemyList.length; i++) {
					var drone:* = LazerCatAttack.enemyList[i];
					if (drone is DroneShip) {
						if (distance(this, drone) < detectRadius && !drone.groupie) {
							groupies.push(drone);
							drone.groupie = true;
							drone.dB = this;
							var groupieNumber:int = groupies.indexOf(drone);
							drone.freeMovement = false;
						}
					}
					else {
						//nothing
					}
				}
			}
		}
		
		private function detectFormation():Boolean {
			var posCheck:int = 0;
			for (var i = 0; i < groupies.length; i++) {
				if (groupies[i].inPosition) {
					posCheck ++;
				}
			}
			if (posCheck === totalGroupies) {
				return true;
			}
			else {
				return false;
			}
		}
		
		private function controlGroupies (x,y) {
			//recent change for the pokeball
			if (!caught) {
				for (var i:int = groupies.length -1; i >= 0; i-- ) {
					//if (groupies[i].caught) {
					//	//remove
					//	groupies[i].freeMovement = true;
					//	groupies.splice(i, 1);
					//}else {
					if (groupies[i].inPosition){		
						groupies[i].x += x;
						groupies[i].y += y;
					}	
					/*}*/
				}	
			}
		}
		public function revive() {
			hitPoints = presetHitPoints;
			h --;
			LazerCatAttack.deathBallerzList.push(this);
			LazerCatAttack.enemyList.push(this);
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, fireCooldownHandler);
			position.x = this.x;
			position.y = this.y;
			//setup or not stuff???
			trace("groupies.length " + groupies.length);
			if (groupies.length == 0) {
				brain[0] = 0;
				setupPoint = LazerCatAttack.game.setupPoint.shift();
				selectedTarget = this.setupPoint;
				target.setTo(selectedTarget.x, selectedTarget.y, 0);
				circling = false;
			}
			caught = false;
		}
		public function onCatch(xDif, yDif) {
			hitPoints = 0;
			caught = true;
			LazerCatAttack.you.ball.caught.push(this);
			this.x = xDif;
			this.y = yDif;
			destroyYourself();
			LazerCatAttack.you.ball.addChild(this);
		}
		public function destroyYourself() {
			h++;
			//recent change 
			if (h >= hitPoints) {
				/*if (!caught) {*/
					for (var i:int = groupies.length -1; i >= 0; i--) {
						groupies[i].freeMovement = true;
						groupies[i].groupie = false;
						groupies[i].xThere = false;
						groupies[i].yThere = false;
						groupies[i].inPosition = false;
						groupies.splice(i, 1);
					}
				//}
				if (playerKilledMe) {
					LazerCatAttack.huD.updateScore(this.points);
					/*var snd:Sound = new EnemyDeathSound;
					Main.sound.playFX(snd);*/
				}
				if (setupPoint != null) {
					LazerCatAttack.game.setupPoint.push(this.setupPoint);
				}
				LazerCatAttack.deathBallerzList.splice(LazerCatAttack.deathBallerzList.indexOf(this), 1);
				LazerCatAttack.enemyList.splice(LazerCatAttack.enemyList.indexOf(this),1);
				LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
				LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, fireCooldownHandler);
				LazerCatAttack.game.removeChild(this);
			}else if (playerKilledMe){
				//only play hit sounds when player hits you
				/*var snd:Sound = new HitSound;
				Main.sound.playFX(snd);*/
			}
			playerKilledMe = false;
		}
	}
}
