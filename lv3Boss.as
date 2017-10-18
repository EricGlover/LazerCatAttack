package  {
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.geom.Vector3D;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.text.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	
	public class lv3Boss extends MovieClip {
		//movement
		public var position:Vector3D = new Vector3D();
		public var velocity:Vector3D = new Vector3D();
		private var steering:Vector3D = new Vector3D();
		private var desired:Vector3D = new Vector3D();
		/*private var ahead:Vector3D = new Vector3D();
		private var ahead2:Vector3D = new Vector3D();*/
		private var avoidDistance:int = 80;
		private var avoidForce:int = 3;
		private var avoidConstant:int = 2;
		//goto behavior
		private var there:Boolean = false;
		
		//wander behavior
		private var circleDistance:int = 10;
		private var circleRadius:int = 5;
		private var angleChange:int = 1;
		private var wanderAngle:Number;
		
		//fleePoints
		private var topLeft:Point = new Point(125, -50);
		private var topRight:Point = new Point(375, -50);
		private var rightTop:Point = new Point(650, 150);
		private var rightBottom:Point = new Point(650, 450);
		private var bottomRight:Point = new Point(375, 650);
		private var bottomLeft:Point = new Point(125, 650);
		private var leftBottom:Point = new Point(-50, 450);
		private var leftTop:Point = new Point(-50, 150);
		private var nextPoint:Point;
		private var retreatRange:int = 100;
		private var flyOff:Boolean = false;
		
		private var target:Vector3D = new Vector3D();
		private var selectedTarget:*;
		private var mass = 1;
		private var maxForce = 2;
		private var maxVelocity = 2.5; 
		//firing
		private var fireCooldown:Number = 1.5;
		public static var fireCooldownPreset:Number = 1.5;
		private var fireTimer:int = 0;
		private var fireReady:int = 6;
		private var fireRecharge:int = 1;
		private var maxCharge:int = 6;
		public var bobsBurgers:Array;
		//true = right
		private var fireDirection:Boolean = true;
		private var swipe:Boolean = true;
		//removal
		public var h:int = 0;
		public var hitPoints:int = 50;
		public static var presetHitPoints:int = 50;
		public var invincible:Boolean = false;
		public var lazerHits:int = 0;
		public var firstPoints:int = 100;
		public var finalPoints:int = 100;
		//bullets and such make this true
		public var playerKilledMe:Boolean = false;
		
		//pylon variables
		public var pylonP1:Point = new Point(400,100);
		public var pylonP2:Point = new Point(250,100);
		public var pylonP3:Point = new Point(100,100);
		public static var totalPylons:int = 3;
		public static var pylonPoints:Array = new Array();
		//tried changing this from fixed length array to not fixed at start
		public static var pylons:Array = new Array();
		public var defendMe:* ;				
		public var blockingDistance:int = 100;
		
		public static var parts:Array = new Array();
		private var partSpeed:int = 4;
		private var partTimer:int = 0;
		private var spawnPartRate:int = 1;
	
		//decision making variables
		private var brain:Array = new Array();
		private var activeState:int;
		private var mindChange:Boolean = false;
		private var oldState:int;
		private var lingerTime:int;
		private var lingerCounter:int;
		private var antiFirst:Boolean = true;
		private var state4Time:int = 120;
		private var state1Time:int = 120;
		private var attackTime:int = 240;
		private var beginningSteps:int = 2;
		public static var bob:lv3Boss;
		private var decisionLag:int = 180;
		private var decisionTimer:int = 0;
		private var moarLastMod:int;
		private var defendLastMod:int;
		private var attackLastMod:int;
		private var medLastMod:int;
		private var selectedDrone:MedBot;
		
		/*private var chatCounter:int = 0;
		private var displayTime:int = 0;*/
		
		//pokeball vars
		private var rCounter:int = 0;
		private var stunTime:Number = 2.1;
		
		/*notes:
		1.
		replace all if (fireReady > 3) stuff with firePattern(), then fire() and in fire 
		have an if (fireReady > shotCount) and have firePattern() setting shotCount.
		2.
		Change decide to provide a list of actions to do and then make decide() run maybe once
		a second at max.
		3.
		Read potential change notes to findTargetPoint()
		4.
		Read change notes for decide().defend
		5.
		currently lv3Boss will sometimes try to addPylons to full locations
		6. 
		Check everything that searches the lv3Boss.pylons array to make sure they're doing it correctly now
		7. 
		if running lazer cat spawn glitch at the beginning and the player goes behind the boss, then it crashes
		8.
		recent changes have //recent change annotations and build 1 changes have //build 1
		*/
		
		
		/* inserting new stuff into this game b/c it will never sell so why not man*/
		/* HAMBURGULAR MODE GOING IN! */
		
		
		
		
		public function lv3Boss(myTarget) {
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
			selectedTarget = LazerCatAttack.you;
			stunTime = Pokeball.lv3BossStunTime;
			mouseEnabled = false;
			bobsBurgers = new Array();
			/*this.target.setTo(selectedTarget.x, selectedTarget.y, 0);*/
			this.x = 200;
			this.y = 200;
			position.setTo(this.x, this.y, 0);
			/*brain[0] = 10;
			activeState = 10;*/
			/*brain[0] = 10;*/
			wanderAngle = 0;
			//keep it only to one lv2 boss or the pylon array fucks up
			lv3Boss.pylonPoints.push(pylonP1, pylonP2, pylonP3);
			lv3Boss.bob = this;
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, fireHandler);
			fireCooldown = lv3Boss.fireCooldownPreset;
			hitPoints = lv3Boss.presetHitPoints;
			//set up the random glitches
			//for (var a:int = 0; a < glitchList.length; a++) {
			//	var num:int = Math.random() * totalGlitches;
			//	var found:Boolean = false;
			//	for (var z:int = 0; z < glitchList.length; z++) {
			//		if (glitchList[z] == num) {
			//			found = true;
			//		}
			//	}
			//	if (!found){
			//		glitchList[a] = num;
			//	}else if (found) {
			//		//make the function repeat until it finds non-repeating numbers
			//		a --;
			//	}
			//}
			/*glitchList[0] = 2;
			glitchList[1] = 0;
			glitchList[2] = 3;*/
			/*trace("here's your fancy smancy glitchList " + glitchList);*/
		}

		private function loop(e:TimerEvent) {
			//decide what to do      THIS IS /// CAUSE I'M TESTING ONE STATE
			if (activeState != 10) {
				//change this so it only decides what to do every so often
				if (brain.length == 0) {
					decide();
					trace("deciding");
				}else if(decisionTimer > decisionLag && brain.length < 3){
					decide();
					trace("deciding");
					decisionTimer = 0;
				}else if(decisionTimer > decisionLag) {
					decisionTimer = 0;
				}else{
					decisionTimer ++;
				}	
			}
			//the second else if above might be fucked
			
			//movement stuffs
			position.x = this.x;
			position.y = this.y;
			
			//if there's no new state in the list don't use it
			//if (brain[0] == undefined) {
			//	//do nothing
			//}else {
			
				activeState = brain[0];
				if (oldState != activeState) {
					mindChange = true;
					if (activeState == 4) {
						selectedTarget = selectedDrone;
					}else if (activeState == 0) {
						selectedTarget = LazerCatAttack.you;
					/*}else if (activeState == 2) {
						selectedTarget = selectedPylon;*/
					}/*else if (activeState == 1) {
						
					}*/
				}else {
					mindChange = false;
				}
				oldState = activeState;
				/*trace(activeState);*/
			/*}	*/
			switch (activeState) {
				// 0 = attack, 1 = wander, 2= add Pylon, 3 = defend, 4= grab health 10 = beginning Stage
				case 10:
					if (beginningSteps == 2) {
						selectedTarget = pylonP1;
						if (this.x == pylonP1.x && this.y == pylonP1.y) {
							there = true;
						}
						if (there) {
							there = false;
							addPylon();
							//recent change perhaps use undefined
							if (lv3Boss.pylons[0] != null){
								defendMe = lv3Boss.pylons[0];
							}
							beginningSteps -= 1;
						}
					}
					else if(beginningSteps == 1){
						findTargetPoint(defendMe);
						target.setTo(selectedTarget.x, selectedTarget.y, 0);
						steering = seek(target);
						//fire
						if (fireReady >= 3) {
							fire(3, fireDirection, LazerCatAttack.you) 
							fireDirection = !fireDirection;
						}
						//stop defending complete pylons
						if (defendMe.complete) {
							beginningSteps -= 1;
						}
					}
					else if(beginningSteps == 0) {
						decide();
					}
					target.setTo(selectedTarget.x, selectedTarget.y, 0);
					steering = seek(target);
					break;
				case 0:
					//tactics: Wander and do some cool fire Patterns, charge with lame firing and maybe a side fire
					target.setTo(selectedTarget.x, selectedTarget.y, 0);
					/*trace("ActiveState = " + activeState);*/
					if (mindChange) {
						maxVelocity = 5;
						maxForce = .1;
						LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, antiLinger);
					}
					//when the two ships are close AND headed towards one another, fly off	
					if (distance(this,selectedTarget) > retreatRange) {
						steering = seek(target);
					}else if (!flyOff) {
						var direction:Vector3D = new Vector3D();
						direction = target.subtract(position);
						var directionAngle = getAngle(direction);
						directionAngle *= 180/Math.PI;
						var velAngle = getAngle(velocity) * (180/Math.PI);
						if (velAngle < directionAngle + 20 || velAngle > directionAngle - 20){
							flyOff = true;
					//separate the game screen into quadrants and then choose one of the two sides
					//to dramatically fly off to  in the quadrant that the player is in, then reappear
					//on the opposite side
							var quadrant:int = 0;
							if (target.x >=250 && target.y >= 300) {
								quadrant = 4;
								if (Math.random() > .5) {
									selectedTarget = bottomRight;
									nextPoint = topRight;
								}else {
									selectedTarget = rightBottom;
									nextPoint = leftBottom;
								}
							}else if (target.x <= 250 && target.y >= 300) {
								quadrant = 3;
								if (Math.random() > .5) {
									selectedTarget = leftBottom;
									nextPoint = rightBottom;
								}else {
									selectedTarget = bottomLeft;
									nextPoint = topLeft;
								}
							}else if (target.x >= 250 && target.y <= 300) {
								quadrant = 2;
								if(Math.random() > .5) {
									selectedTarget = rightTop;
									nextPoint = leftTop;
								}else {
									selectedTarget = topRight;
									nextPoint = bottomLeft;
								}
							}else {
								quadrant = 1;
								if (Math.random() >.5) {
									selectedTarget = topLeft;
									nextPoint = bottomLeft;
								}else{
									selectedTarget = leftTop;
									nextPoint = rightTop;
								}
							}
						}
						target.setTo(selectedTarget.x, selectedTarget.y, 0);
						steering = seek(target);
					}else if (flyOff) {
						/*maxVelocity *= 3;*/
						//build 1
						/*trace("teleportin in!");*/
						if (position.x == target.x && position.y == target.y) {
							there = true;
						}
						if (there) {
							this.x = nextPoint.x;
							this.y = nextPoint.y;
							position.x = this.x;
							position.y = this.y;
							there = false;
							maxVelocity = 2.5;
							maxForce = 2;
							flyOff = false;
							selectedTarget = LazerCatAttack.you;
							/*brain.shift();*/
						}
					}
					
					if (fireReady > 0) {
						//consider outsourcing this to a fire pattern function for variance sake
						//firePattern();
						fire(3, fireDirection, LazerCatAttack.you) 
						fireDirection = !fireDirection;
					}else {
						//nothing;
					}
					//erase this later
					target.setTo(selectedTarget.x, selectedTarget.y, 0);
					steering = seek(target);
					break;
				case 1:
					steering = wander();
					/*trace("ActiveState = " + activeState);*/
					if (fireReady >= 3) {
						//consider outsourcing this to a fire pattern function for variance sake
						//firePattern();
						fire(3, fireDirection, LazerCatAttack.you) 
						fireDirection = !fireDirection;
					}else {
						//nothing;
					}
					if (mindChange) {
						LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, antiLinger);
					}
					break;
				case 2:
					//setup a pylon and defend it to introduce the boss fight design
					//find an empty pylon spot
					//move to it
					//when there add it
					//select a target space for the new pylon
					/*trace("ActiveState = " + activeState);*/
					var emptySpotArray:Array = new Array(1,2,3);
					//find a non-taken number of pylon / pylon spot by having existing pylons
					//remove their number from emptySpotArray
					for (var i:int = 0; i < lv3Boss.totalPylons; i++) {
						if (lv3Boss.pylons[i] == undefined) {
							//do nothing
						}else {
							/*emptySpotArray.splice((lv3Boss.pylons[i].number -1),1);*/
							//recent change
							emptySpotArray[lv3Boss.pylons[i].number -1] = null;
						}
					}
					//then assign the first non-null value in emptySpotArray to nonNull
					//and use it (since it's the open spot) to assign that pylon spot # to selectedTarget
					var nonNull:int = 0;
					nonNull = emptySpotArray[0];
					for (var i:int = 0; i < lv3Boss.totalPylons; i ++) {
						if (emptySpotArray[i] != null) {
							nonNull = emptySpotArray[i];
						}
						if (nonNull != 0) {
							break;
						}
					}
						
					if (nonNull == 0) {
						//build 1
						/*trace("decision making error, decided to add a new pylon when there are no spots available.");*/
						//for the moment just decide to do something new here change this when decisions pop
						//pop change needed
						/*decide();*/
					}else {
						switch (nonNull) {
							case 1:
								selectedTarget = pylonP1;
								break;
							case 2:
								selectedTarget = pylonP2;
								break;
							case 3:
								selectedTarget = pylonP3;
								break;
							default:
								//nothing
						}
					}
					target.setTo(selectedTarget.x, selectedTarget.y, 0);
					steering = seek(target);
					//when there add a pylon
					if (position.x == target.x && position.y == target.y) {
						there = true;
						//build 1
						/*trace("trying to addPylon, set there to true, see " + there);*/
					}
					if (there) {
						//build 1
						/*trace("I'm in position to add pylon");*/
						/*if (addPylon() == undefined) {
							trace("oh fuck @lv3Boss.loop.if(there)");
						}*/
						addPylon();
						there = false;
						//ideally pop off brain[0] and next time you'll do brain [1]
						/*decide();*/
						brain.shift();
					}
					
					//fire
					if (fireReady >= 3 ) {
						//consider outsourcing this to a fire pattern function for variance sake
						//firePattern();
						fire(3, fireDirection, LazerCatAttack.you) 
						fireDirection = !fireDirection;
					}
					break;
				case 3:
					//defense: tactics: 1.distraction 2. blocking
					//seek point between player and pylon
					//find something to defend if you have nothing already
					/*trace("ActiveState = " + activeState);*/
					if (defendMe == null) {
						var testDefend = findDefendMe();
						if (testDefend == null) {
							/*decide();*/
							brain.shift();
							trace("Line 421 Boss 3 troubles with testDefend, idk bro");
						}else {
							//here instead of finding something new to defend you may consider redeciding
							//b/c your pylon most likely has died
							defendMe = testDefend;
						}
					}
					findTargetPoint(defendMe);
					target.setTo(selectedTarget.x, selectedTarget.y, 0);
					steering = seek(target);
					if (fireReady >= 3) {
						//consider outsourcing this to a fire pattern function for variance sake
						//firePattern();
						fire(3, fireDirection, LazerCatAttack.you) 
						fireDirection = !fireDirection;
					}
					//stop defending complete pylons
					if (defendMe.complete) {
						//currently nothing here to make decide consider not blocking for completed pylons
						//I'm considering allowing completed pylons to be defended
						/*decide();*/
						brain.shift();
					}
					break;
				case 4:
					target.setTo(selectedTarget.x, selectedTarget.y, 0);
					steering = seek(target);
					/*trace("ActiveState = " + activeState);*/
					if (mindChange) {
						LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, antiLinger);
					}
					break;
				default:
					//nothing?
			}
			
			//movement
			/*if (selectedTarget != LazerCatAttack.you) {*/
				/*steering = steering.add(collisionAvoidance());*/
		/*	}*/
			truncate(steering, maxForce);
			steering.scaleBy(1/mass);
			velocity = velocity.add(steering);
			truncate(velocity, maxVelocity);
			//keep lv3Boss on screen and make it stop at destination points
			/*var newPosition:Vector3D = new Vector3D();
			newPosition = position.add(velocity);*/
			
			/*if (newPosition.x > 0 && newPosition.y > 0 && newPosition.x < 500 && newPosition.y < 600 || flyOff) {*/
				if (distance(this, selectedTarget) < velocity.length) {
					var direction:Vector3D = new Vector3D();
					direction = target.subtract(position);
					var directionAngle = getAngle(direction);
					directionAngle *= 180/Math.PI;
					var velAngle = getAngle(velocity) * (180/Math.PI);
					if (velAngle > directionAngle - 10 || velAngle < directionAngle + 10){
						//this commented line glitches the boss
						/*if (warpGlitch) {
							this.position = target;
						}else{*/
							this.position.x = target.x;
							this.position.y = target.y;
						//}	
					}
				} else{
					position = position.add(velocity);
				}
			/*}*/
			this.x = position.x; 
			this.y = position.y;
			
			//spawn drone parts
			partTimer ++;
			if (partTimer > spawnPartRate * LazerCatAttack.frameSpeed) {
				spawnPart();
				partTimer = 0;
			}
			
		}
		public function antiLinger (e:TimerEvent) {
			if (antiFirst && activeState == 4) {
				lingerTime = state4Time;
			}else if (antiFirst && activeState == 1) {
				lingerTime = state1Time;
			}else if (antiFirst && activeState == 0) {
				lingerTime = attackTime;
			}
			if (lingerCounter > lingerTime) {
				brain.shift();
				mindChange = true;
				lingerCounter = 0;
				antiFirst = true;
				LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, antiLinger);
			}else {
				lingerCounter ++;
				antiFirst = false;
			}
		}
		public function decide() {
			//assign decision values to potential behaviors
			defendLastMod = 1;
			attackLastMod = 1;
			medLastMod = 1;
			moarLastMod = 1;
			if (oldState == 0) {
				attackLastMod = 0;
			}else if (oldState == 3){
				defendLastMod = 0;
			}else if (oldState == 2) {
				moarLastMod = 0;
			}else if (oldState == 4){
				medLastMod = 0;
			}
			//attack
			var currentPlayerH:int = LazerCatAttack.you.hitPoints - LazerCatAttack.you.hits;
			var bloodThirsty:int = 7;
			var killingBlowValue:int = bloodThirsty * (1 - (currentPlayerH/ LazerCatAttack.you.hitPoints));
			//find some other behavior here
			var preference:int = 3;
			/*var angerLevel:int = */
			var attack = (killingBlowValue + preference) * attackLastMod;
			
			//defend
			//consider adding in <dont block completed pylons behavior>
			var defendValue:int = 5;
			var lowestHealth:int = 4;
			var lowHPylon:lv3BossPylon;
			var newPHealth:int = 0;
			/*var defendThis:* = undefined;*/
			for (var i:int = 0; i < lv3Boss.totalPylons; i ++) {
				if (lv3Boss.pylons[i] == undefined) {
					/*trace("brain defend for function problem");*/
					break;
				}
				//this is the function findDefendMe, might use this code later for distance stuff in 
				//decisions
				//var newDefend:lv3BossPylon;
				///*var defendDist*/
				//if (lv3Boss.pylons[i].complete == false) {
				//	newDefend = this;
				//	if (defendThis == undefined) {
				//		defendThis = newDefend;
				//	}else if (distance(this, newDefend) < distance(this,defendThis)){
				//		defendThis = newDefend;
				//	}
				//}
				var newPHealth:int = lv3Boss.pylons[i].health;
				if (newPHealth < lowestHealth) {
					lowestHealth = newPHealth;
					lowHPylon = lv3Boss.pylons[i];
				}
			}
			var currentH:int = lv3BossPylon.totalHealth - lowestHealth;
			if (newPHealth == 0) {
				currentH = 0;
			}
			var defend:Number = defendValue * (currentH / lv3BossPylon.totalHealth) * defendLastMod;
			
			//addPylons
			var moarPylonsValue:int = 5;
			var pylonCount:int = 0;
			var pylonNumber:int = 0;
			//this array will be used to find the remaining pylon number locations
			var pylonNumberArray:Array = new Array(1,2,3);
			for (var i:int = 0; i < lv3Boss.totalPylons; i++) {
				if (lv3Boss.pylons[i] == undefined) {
					//nothing
				}else{
					pylonCount ++; //problem with using splice
					/*pylonNumberArray.splice((lv3Boss.pylons[i].number - 1), 1);*/
					pylonNumberArray[lv3Boss.pylons[i].number - 1] = null;
				}
			}
			var moarPylons:Number = moarPylonsValue * (lv3Boss.totalPylons - pylonCount) * moarLastMod;
			
			//getMed decision value
			var health:int = this.hitPoints - this.h;
			var healthRatio:Number = health/this.hitPoints;
			var survivalNeed:Number = 5;
			var closest:int = 10000;
			var closestDrone:MedBot;
			for (var i:int = 0; i < LazerCatAttack.medDroneList.length; i++) {
				//find the closest drone
				if (LazerCatAttack.medDroneList[i] == undefined) {
					trace("get outta that medDroneList, I've got a funny feeling about it");
					break;
				}
				var newD:int = distance(this, LazerCatAttack.medDroneList[i]);
				if (newD < closest) {
					closest = newD;
					closestDrone = LazerCatAttack.medDroneList[i];
				}
			}
			if (closest > 9999) {
				survivalNeed = 0;
			}
			var getMed = (1- healthRatio) * survivalNeed * medLastMod; 
			
			
			//add a way to decide if the need is immediate
			//build 1
			/*trace("attack = " + attack + "defend = " + defend + "moarPylons = " + moarPylons + "getMed = " + getMed);*/
			switch (Math.max(attack,defend,moarPylons,getMed)) {
				case attack:
					//build 1
					/*trace("attacking");*/
					/*if (Math.random > .5) {
						brain.push(1);
					}else {
						brain.push(0);
					}*/
					/*brain[0] = 0;*/
					brain.push(0);
					/*selectedTarget = LazerCatAttack.you;*/
					break;
				case defend:
					//currently this is redudant but both decide() and activeState find things to defend
					//actually no b/c pylon might die
					/*defendMe = findDefendMe();*/
					defendMe = lowHPylon;
					/*trace("defending");*/
					/*brain[0] = 3;*/
					brain.push(3);
					//lowHPylon
					break;
				case moarPylons:
					switch (pylonNumberArray[0]) {
						case 1:
							selectedTarget = pylonP1;
							break;
						case 2:
							selectedTarget = pylonP2;
							break;
						case 3:
							selectedTarget = pylonP2;
							break;
						default:
							trace("lv3Boss.decide moar pylons problem switch problem...maybe");
					}
					/*trace("adding Pylons");*/
					/*brain[0] = 2;*/
					brain.push(2);
					break;
				case getMed:
					/*trace("getting Medical supplies");*/
					//should the boss attempt to lay in an intercept course where target = the calculated 
					//intercept point or should it just seek the med bot....
					//consider using the distance to the medDrone as a factor in deciding to go to it
					
					/*selectedTarget = closestDrone;
					target.setTo(selectedTarget.x, selectedTarget.y,0);*/
					selectedDrone = closestDrone;
					/*brain[0] = 4;*/
					brain.push(4);
					break;
				default:
					//nothing
			}
		}
		
		public function seek(target:Vector3D):Vector3D {
			var force:Vector3D;
			desired = target.subtract(position);
			desired.normalize();
			desired.scaleBy(maxVelocity);
			force = desired.subtract(velocity);
			return force;
		}
		
		//find the target point between the pylon and the player
		private function findTargetPoint(pylon:lv3BossPylon) {
			if (pylon == null) {
				//do nothing
			}else{
				var pylonVec = new Vector3D(pylon.x, pylon.y, 0);
				var blockingVec:Vector3D = new Vector3D();
				with (LazerCatAttack) {
					var playerVec = new Vector3D(you.x, you.y, 0);
				}
				blockingVec = playerVec.subtract(pylonVec); 
				truncate(blockingVec, blockingDistance);
				blockingVec = blockingVec.add(pylonVec);
				//consider just setting the target vector to the blocking vector
				var defPoint = new Point(blockingVec.x, blockingVec.y);
				selectedTarget = defPoint;
			}	
		}
		private function wander() {
			var wanderForce:Vector3D;
			var circleCenter:Vector3D;
			var displacement:Vector3D;
			circleCenter = velocity.clone();
			circleCenter.normalize();
			circleCenter.scaleBy(circleDistance);
			displacement = new Vector3D(0,1);
			displacement.scaleBy(circleRadius);
			setAngle(displacement, wanderAngle);
			//consider customizing wanderAngle, currently gradually changes the wander force
			wanderAngle += Math.random() * angleChange - angleChange * .5;
			wanderForce = circleCenter.add(displacement);
			wanderForce.normalize();
			//slow the flash fucker down a bit in wander plz
			maxForce = .5;
			maxVelocity = 1;
			wanderForce.scaleBy(maxForce);
			return wanderForce;
		}
		public function getAngle(vector :Vector3D) :Number {
			return Math.atan2(vector.y, vector.x);
		}
		//set angle in degrees or radians??
		private function setAngle(vector:Vector3D, angle:Number):void {
			var length1:Number = vector.length;
			vector.x = Math.cos(angle) * length1;
			vector.y = Math.sin(angle) * length1;
		}
		public function truncate(vector:Vector3D, max:Number):void {
			var i:int;
			i = vector.length/max;
			if (i > 1) {
				if (max == 0) {
					trace("error, @ lv2 boss truncate");
				}else{
					vector.scaleBy(1/i);	
				}
			}
		}
		//problems with this in collision avoidance
		public function distance(a, b):int {
			return (Math.sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y)));
		}
		
		//has a pool of shoots ready, needs to choose the direction and when to fire
		private function fire(shots, direction, myTarget) {
			//code for the initial velocity of the bullets
			//change swipe and stuff
			for (var i:int = 1; i <= shots; i ++) {
				//currently the init velocity of the bullets allows for a patterned spray
				//fire left =1 , fire right = 2
				var initialVelocity:Vector3D = new Vector3D();
				var bullet:lv3BossBullet;
				if (direction == false) {
					/*initialVelocity.setTo(-10000 + (i*3), 4500*-i, 0);*/
					//change swipe
					initialVelocity = setInitVel(i, -1, swipe);
					bullet = new lv3BossBullet(initialVelocity, myTarget/*, swipe*/);
					bullet.x = this.x - this.width/2;
					bullet.y = this.y - this.height/2;
				}else if (direction == true) {
					/*initialVelocity.setTo(10000 - (i*3), 4500*-i, 0);*/
					//swipe is placeholder
					initialVelocity = setInitVel(i, 1, swipe);
					bullet = new lv3BossBullet(initialVelocity, myTarget/*, swipe*/);
					bullet.x = this.x + this.width/2;
					bullet.y = this.y - this.height/2;
				}
				LazerCatAttack.game.addChild(bullet);
				lv3Boss.bob.bobsBurgers.push(bullet);
				/*LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, fireHandler);*/
				fireReady -= shots;
			}	
		}
		private function setInitVel(order:int, direction, attackAngle):Vector3D {
			//based on the distance between player and boss and the number of bullets that have just been fired
			/*var back
			if (attackAngle == swipe) {
				back = 10000;
			}else if (attackAngle == focus) {
				back = 10000;
			}*/
			var valueY:Number = 300 - ((order -1) * 10000);
			var valueX:Number = (1000 + (order* 7 * direction)) * direction;
			var actualY:Number = Math.abs(this.y - LazerCatAttack.you.y);
			var actualX:Number = Math.abs(this.x - LazerCatAttack.you.x);
			var idealY:Number = 200.00;
			var idealX:Number = 1;
			valueY = (actualY/idealY) * valueY;
			valueX = (actualX/idealX) * valueX;
			
			var initVelocity:Vector3D = new Vector3D(valueX, valueY, 0);
			return initVelocity;
		}
		private function firePattern() {
			//fire bullets in coolio patterns man.
			//Attack vectors: 1. Swide Swipe 2. Focus
			//frequency of firing 1.Steady 2. Burst
			//Snipe, non-arching, basically goTo a point then launch really quickly at player (one targeting velocity);
			//Side Vars: Quick Alternating, changes sides between each shot 2. Norm Alt, all fire left then all fire right or what have you
			//will set a list of different firing behavior for each time a new thing is decided
			//if attack mode will decide between attack style firing patterns 
		}
		private function fireHandler(e:TimerEvent) {
			//simple for now
			fireTimer ++;
			if (fireReady == maxCharge) {
				/*LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, fireHandler);*/
				//do nothing
			}else if (fireTimer >= fireCooldown * 60) {
				if (fireReady + fireRecharge <= maxCharge) {
					fireReady += maxCharge;
				}else {
					fireReady = maxCharge;
				}
				fireTimer = 0;
			}
		}
		
	
		private function addPylon():lv3BossPylon {
			var pylonNumber:int = 0;
			switch (selectedTarget) {
				case pylonP1:
					pylonNumber  = 1;
					break;
				case pylonP2:
					pylonNumber = 2;
					break;
				case pylonP3:
					pylonNumber = 3;
					break;
				default:
					trace("lv3Boss.addPylon.switch problem");
			}
			var pylon:lv3BossPylon;
			var doublinDown:Boolean = false;
			for (var i:int =0; i < lv3Boss.pylons.length; i++) {
				/*trace(pylonNumber + " is pylonNumber");*/
				if (lv3Boss.pylons[i] == undefined) {
					//build 1
					/*trace("this should not be running, why is this pylon == undefined?");*/
				}
				else if (pylonNumber == lv3Boss.pylons[i].number) {
					doublinDown = true;
					//build 1
					/*trace("attempting to add a pylon on top of another");*/
				}
			}
			if (!doublinDown) {
				pylon = new lv3BossPylon();
				pylon.x = target.x;
				pylon.y = target.y;
				pylon.number = pylonNumber;
				trace(pylon.number + "assigned pylon #");
				pylon.position.setTo(pylon.x, pylon.y, 0);
				lv3Boss.pylons.unshift(pylon);
				LazerCatAttack.game.addChild(pylon);
				LazerCatAttack.enemyList.push(pylon);
				trace("Pylon = " + pylon);
				
			}else {
				//don't add the pylon and return undefined
			}	
			return pylon;
		}
		
		private function spawnPart() {
			//currently parts can run into the wrong pylons
			for (var i:int = 0; i< lv3Boss.pylons.length; i++) {
				if (lv3Boss.pylons[i] == undefined || lv3Boss.pylons[i].complete == true) {
					//do nothing
				}else {
					var vel:Vector3D = lv3Boss.pylons[i].position.subtract(this.position);
					truncate(vel, partSpeed);
					var part:lv3BossPart = new lv3BossPart(vel);
					part.x = this.x;
					part.y = this.y;
					LazerCatAttack.enemyList.push(part);
					lv3Boss.parts.push(part);
					LazerCatAttack.game.addChild(part);
				}
			
				
			}
		}
		public function findDefendMe():lv3BossPylon {
			var defendThis:lv3BossPylon = null;
			for (var i:int = 0; i < lv3Boss.pylons.length; i ++) {
				if (lv3Boss.pylons[i] == undefined) {
					/*break;*/
				}else {
					var newDefend:lv3BossPylon = null;
					/*if (lv3Boss.pylons[i].complete == false) {*/
						newDefend = lv3Boss.pylons[i];
					/*}	*/
					if (defendThis == null) {
						defendThis = newDefend;
					}else if (distance(this, newDefend) < distance(this, defendThis)){
						defendThis = newDefend;
					}
				}	
			}
			return defendThis;
		}
		public function onCatch(xDif, yDif) {
			//stun if and only if the boss isn't currently glitching out
			/*if (reviveCounter == 0) {*/
				LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, revive);
				/*if (glitch) {
					glitchTimer.stop();
				}*/
				LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, fireHandler);
				LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
				//do stun animation
				//do damage
				for (var i:int = 0; i < LazerCatAttack.you.ball.damage; i ++) {
					/*trace("dealing the lv2Boss da damages");*/
					if (i -1 == LazerCatAttack.you.ball.damage) {
						destroyYourself();
					}else {
						h++;
					}
				}
			//}	
		}
		public function revive(e:TimerEvent) {
			rCounter ++;
			if (rCounter >= stunTime *60) {
				//unstun
				LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, fireHandler);
				LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
				LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, revive);
				alpha = 1;
				/*if (glitch) {
					glitchTimer.start();
				}*/
				rCounter = 0;
			}
		}
	
		//I'm running this through the enemies list so that must be the function name.
		public function destroyYourself() {
			if (!invincible) {
				h++
			}	
			if (hitPoints <= h) {
					//build 2 add in remove all pylons
					if (Main.difSet == 1) {
						Main.so.data.beatL3Casual = true;
					}else if (Main.difSet == 2) {
						Main.so.data.beatL3Normal = true;
					}else if (Main.difSet == 3) {
						Main.so.data.beatL3Hard = true;
					}
					LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
					LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, fireHandler);
					if (lingerCounter > 0) {
						LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, antiLinger);
					}
				//	//do you need to stop the timer or remove it or something?
					/*glitchTimer.removeEventListener(TimerEvent.TIMER, glitchHandler);*/
					for (var i:int = lv3Boss.pylons.length - 1; i >= 0; i --) {
						lv3Boss.pylons[i].health = 0;
						lv3Boss.pylons[i].destroyYourself();
					}
					for (var i:int = lv3Boss.bob.bobsBurgers.length - 1; i >= 0; i --) {
						lv3Boss.bob.bobsBurgers[i].remove();
					}
					lv3Boss.bob = null;
					LazerCatAttack.game.removeChild(this);
					LazerCatAttack.enemyList.splice(LazerCatAttack.enemyList.indexOf(this),1);
					if (playerKilledMe) {
						LazerCatAttack.huD.updateScore(this.finalPoints);
						LazerCatAttack.gameTimer.stop();
						LazerCatAttack.game.victory = true;
						LazerCatAttack.game.bossFight = false;
						LazerCatAttack.game.q = 0;
						LazerCatAttack.game.deathTime = LazerCatAttack.timeIndex - (LazerCatAttack.endLv2);
						var deathScreen = new DeathScreen;
						deathScreen.x = 250;
						deathScreen.y = 300;
						LazerCatAttack.game.addChild(deathScreen);
						/*var snd:Sound = new EnemyDeathSound;
						Main.sound.playFX(snd); */
					}
					/*LazerCatAttack.endLv3 = LazerCatAttack.timeIndex;
					LazerCatAttack.game.level3 = true;*/
				//}	
			/*}else if (playerKilledMe) {
				var snd:Sound = new HitSound;
				Main.sound.playFX(snd); */
			}
			playerKilledMe = false;
		}
	}
}