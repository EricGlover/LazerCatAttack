package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.Vector3D;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import flash.media.Sound;
	
	
	public class lv2Boss extends MovieClip {
		//movement
		public var position:Vector3D = new Vector3D();
		private var velocity:Vector3D = new Vector3D();
		private var steering:Vector3D = new Vector3D;
		private var maxVelocity:int = 2;
		private var maxSteering:Number = .08;
		private var target:Vector3D = new Vector3D();
		private var selectedTarget:*;
		private var there:Boolean = false;
		
		private var safeSpot1:Point = new Point(100, 100);
		private var safeSpot2:Point = new Point(250, 500);
		private var safeSpot3:Point = new Point(500, 100);
		
		private var fireTarget:*;
		private var fireVector:Vector3D = new Vector3D;
		public static var bullet:Array = new Array();
		private var player:Player;
		private var fireOn:Boolean = false;
		private var fCount:int = 0;
		private var fCounter:int = 0;
		private var burst:int = 3;
		private var fireInterval:Number = .2;
		private var timesToFire:int = 3;
		private var first:Boolean = true;
		
		private var activeState:int = 0;
		private var brain:Array = new Array();
		private var stateTime:int;
		private var averageStateTime:int = 10;
		private var varyingStateTime:int = 4;
		private var count:int = 0;
		
		//bringeth the pain vars
		private var p:int = 0;
		private var painCooldown:int = 5;
		private var painEnabled:Boolean = true;
		private var leftWarning:TextField;
		private var rightWarning:TextField;
		private var fP:int = 0;
		private var fQ:int = 0;
		private var flashTime:Number = 1.0;
		//set rate and total to the same thing, this is in the screen update units btw
		private var flashRateTotal:int = 10;
		private var flashRate:int = 10;
		public static var painsFired:int = 6;
		private var painsFired:int = 6;
		private var painList:Array = new Array();
		private var delay:Number = .5;
		public static var delay:Number = .5;
		//gives the spots to the pains put on screen
		//change this after changing the player ship graphic height
		private var painY1:int = -160;
		private var painY2:int = -80;
		private var painY4:int = 80;
		private var painY5:int = 160;
		private var painY3:int = 0;
		private var painY1B:int = -40;
		private var painY2B:int = -20;
		private var painY4B:int = 20;
		private var painY5B:int = 40;
		private var painY:Array;
		private var wiggleRoom:int = 5;
		
		//pokeball vars
		public var rIndicator:int = 0;
		public var rCounter = 0;
		//in seconds, consider defining this variable on pokeball
		public var stunTime:Number = 1.5;
		public var stunned:Boolean = false;
		
		//removal
		private var h:int = 0;
		public var hitPoints = 30;
		public var playerKilledMe:Boolean =false;
		public var points:int = 40;
		
		public function lv2Boss() {
			fireTarget = LazerCatAttack.you;
			delay = lv2Boss.delay;
			painsFired = lv2Boss.painsFired;
			stunTime = Pokeball.lv2BossStunTime;
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
			/*brain[0] = decide();*/
			if (Math.random() > .5) {
				brain.push(1,2);
			}else {
				brain.push(2,1);
			}
			mouseEnabled = false;
			stateTime = averageStateTime + varyingStateTime * Math.random();
			selectedTarget = wanderPoint();
			activeState = 1;
			position.x = this.x;
			position.y = this.y;
			player = LazerCatAttack.you;
			//display warnings
			var t:TextFormat = new TextFormat("Silom", 25, 0xFF0000);
			leftWarning = new TextField();
			leftWarning.type = TextFieldType.DYNAMIC;
			leftWarning.selectable = false;
			leftWarning.text = "Incoming!";
			leftWarning.height = 35;
			leftWarning.width = 150;
			leftWarning.background = false;
			leftWarning.x = 0;
			leftWarning.setTextFormat(t);
			rightWarning = new TextField();
			rightWarning.type = TextFieldType.DYNAMIC;
			rightWarning.selectable = false;
			rightWarning.text = "Incoming!";
			rightWarning.height = 35;
			rightWarning.width = 150;
			rightWarning.background = false;
			rightWarning.x = 500 - rightWarning.width;
			rightWarning.setTextFormat(t);
			
			//set up pain array
			painY = new Array(painY1, painY2, painY3, painY4, painY5);
			painY1 += wiggleRoom;
			painY5 -= wiggleRoom;
		}
		
		public function loop(e:TimerEvent) {
			position.x = this.x;
			position.y = this.y;
			//state 1 = bringeth the pain
			//state 2 = attack mode
			//states will be popped when completed whenever the current state is completed it decides the next states length
			if (brain.length < 3) {
				for (var i:int = brain.length; i < 4; i ++) {
					brain.push(decide());
				}
			}
			//testing mode attack 2
			/*brain[0] = 2;*/
			activeState = brain[0];
			switch (activeState) {
				case 1:
					count ++;
					target.x = selectedTarget.x;
					target.y = selectedTarget.y;
					move();
					if (painEnabled) {
						LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, bringethThePain);
					}
					if (there) {
						there = false;
						selectedTarget = wanderPoint();
						/*trace("selectedTarget now = " + selectedTarget.x + selectedTarget.y);*/
					}
					if (count >= stateTime * 60) {
						//decide a new state length 
						var rando:int = 0;
						/*trace("popping current state");*/
						if (Math.random() > .5) {
							rando = -1;
						}else {
							rando = 1;
						}
						stateTime = averageStateTime + (varyingStateTime * Math.random() * rando);
						/*trace("StateTime = " + stateTime);*/
						first = true;
						brain.splice(0,1);
						/*trace("next state is " + brain[0]);*/
						count = 0;
					}
					break;
				case 2:
					//maybe use count instead of first
					count ++;
					target.x = selectedTarget.x;
					target.y = selectedTarget.y;
					//in this mode lv2Boss ceases wandering and starts teleporting and firing
					if (!fireOn) {
						blink();
						fireOn = true;
					}else if (fireOn && first) {
						LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, fireHandler);
						first = false;
					}else{
						//do nothing?
					}
					/*move();*/
					//if (there) {
					//	there = false;
					//	selectedTarget = wanderPoint();
					//	/*trace("selectedTarget now = " + selectedTarget.x + selectedTarget.y);*/
					//}
					if (count >= stateTime * 60) {
						brain.splice(0,1);
						/*trace("next state is " + brain[0]);*/
						/*trace("popping current state");*/
						var rando:int = 0;
						if (Math.random() > .5) {
							rando = -1;
						}else {
							rando = 1;
						}
						first = true;
						stateTime = averageStateTime + (varyingStateTime * Math.random() * rando);
						/*trace("StateTime = " + stateTime);*/
						count = 0;
					}
					break;
				default:
					//nothing
					trace("error @ lv2Boss @loop @activeState");
			}
			if (player.y < this.y && player.x + this.width/2 + 10 > this.x && player.x - this.width/2 - 10 < this.x) {
				//check for need to warp but for now just warp
				selectedTarget = findSafeSpot();
				teleport();
			}
			
		}
		public function move() {
			/*trace(velocity + "velocity now is that");*/
			steering = seek(target);
			/*truncate(steering, maxVelocity);*/
			/*trace("this is the steering force " + steering);*/
			velocity = velocity.add(steering);
			/*trace(velocity + "velocity now is that");*/
			truncate(velocity, maxVelocity);
			//this stops it from back and forth around where you're going
			var targetPoint:Point = new Point(target.x, target.y);
			if (distance(this, targetPoint) < velocity.length) {
				var direction:Vector3D = new Vector3D();
				direction = target.subtract(position);
				var directionAngle = getAngle(direction);
				directionAngle*= 180/Math.PI;
				var velAngle = getAngle(velocity) * (180/Math.PI);
				if (velAngle > directionAngle - 10 || velAngle < directionAngle + 10) {
					position.x = target.x;
					position.y = target.y;
					there = true;
				}else {
					position = position.add(velocity);
					there = false;
				}
			}else {
				position = position.add(velocity);
				there = false;
			}
			this.x = position.x;
			this.y = position.y;
		}
		public function seek(target) {
			var desired:Vector3D = new Vector3D();
			desired = target.subtract(position);
			desired.normalize();
			desired.scaleBy(maxVelocity);
			var force:Vector3D = new Vector3D();
			force = desired.subtract(velocity);
			truncate(force, maxSteering);
			return force
		}
		private function wanderPoint() {
			//describe three sections of possible wanderpoints 1,2,3 :left to right
			//random y in top 250 part of screen moved down 44 so he couldn't rotate off top of the screen
			/*trace("finding a new place to wander to ");*/
			var newY:int = (180 * Math.random()) + 44;
			if (this.x > 400) {
				var section = 3;
				var leftRange:Number = this.x;
				leftRange = leftRange * Math.random();
				var wanderPoint = new Point(leftRange, newY);
			}else if (this.x > 100) {
				var section = 2;
				/*find direction, add 1/3 possibility to change direction later */
				var velAngle = getAngle(velocity);
				velAngle *= 180/Math.PI;
				//if right, else if left
				if (velAngle < 90 || velAngle > 270) {
					var rightRange:Number = 500 - this.x;
					rightRange = (rightRange * Math.random()) + this.x;
					var wanderPoint = new Point(rightRange, newY);
				}else {
					var leftRange:Number = this.x;
					leftRange = leftRange * Math.random();
					var wanderPoint = new Point(leftRange, newY);
				}
			}else {
				var section = 1;
				//total range right then shift it by x value so it's the x coordinate
				var rightRange:Number = 500 - this.x;
				rightRange = (rightRange * Math.random()) + this.x;
				var wanderPoint = new Point(rightRange, newY);
			}
			/*trace("new WanderPoint = " + wanderPoint);*/
			return wanderPoint;
			
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
		public function distance(a, b):int {
			return (Math.sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y)));
		}
		private function getAngle(vector:Vector3D):Number {
			return Math.atan2(vector.y, vector.x);
		}
		private function setAngle(vector:Vector3D, angle:Number):void {
			var length1:Number = vector.length;
			vector.x = Math.cos(angle) * length1;
			vector.y = Math.sin(angle) * length1;
		}
		private function findSafeSpot() {
			//find a point to warp to 
			//test point use one of three points
			//if you're calling this it's because the player's above you so use your x to find a new location.
			var safeList:Array = new Array(safeSpot1, safeSpot2, safeSpot3);
			if (this.x > 350) {
				safeList.splice(2,1);
			}else if (this.x > 150) {
				safeList.splice(1,1)
			}else {
				safeList.splice(0,1);
			}
			var spot = new Point();
			if (Math.random() > .5) {
				spot.x = safeList[1].x;
				spot.y = safeList[1].y;
			}else {
				spot.x = safeList[0].x;
				spot.y = safeList[0].y;
			}
			return spot
		}
		private function teleport() {
			//current uses: teleporting away from aft cannon shots, maybe teleporting to the cat later....
			//selectedTarget already set
			target.x = selectedTarget.x;
			target.y = selectedTarget.y;
			position.x = target.x;
			position.y = target.y;
			this.x = position.x;
			this.y = position.y;
			velocity.x = 1;
			velocity.y = 1;
			there = true;
		}
		private function blink() {
			//teleport to a position on the sides of the screen, that's away from the player
			//make sure this works with potentially teleporting inbetween
			var blinkPoint:Point;
			if (player.x > 250) {
				this.x = Math.random() * 100 + 400 - this.width/2;
			}else {
				this.x = Math.random() * 100 + this.width/2;
			}
			if (player.y > 300) {
				this.y = Math.random() * 100 + this.height/2;
			}else {
				this.y = Math.random() * 100 + 500 - this.height/2;
			}
			position.x = this.x;
			position.y = this.y;
			first = true;
		}
		private function fire() {
			var bullet:lv2BossBullet = new lv2BossBullet(LazerCatAttack.you, this.x, this.y);
			bullet.x = this.x;
			bullet.y = this.y;
			lv2Boss.bullet.push(bullet);
			LazerCatAttack.game.addChild(bullet);
		}
		public function fireHandler (e:TimerEvent) {
			if (fCounter >= fireInterval * LazerCatAttack.frameSpeed) {
				fCounter = 0;
				fCount ++;
			}
			if (fCounter == 0) {
				for (var i:int = 0; i < burst; i++) {
					fire();
					/*trace("firing");*/
				}
			}
			if (fCount >= timesToFire) {
				LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, fireHandler);
				fireOn = false;
				first = true;
				fCount = 0;
			}
			fCounter ++;
			/*trace("fCounter = " + fCounter);
			trace("fireINterval * 60 = " + fireInterval * 60);*/
			////rewrite
			/*fCounter ++;
			if (fCounter >= fireInterval * */
		}
		private function painCooldownHandler(e:TimerEvent) {
			p ++;
			if (p / LazerCatAttack.frameSpeed >= painCooldown) {
				painEnabled = true;
				p = 0;
			}
			//consider adding an expanded pool for this so that he can store up the pain and bringeth it fuller later
		}
		private function bringethThePain(e:TimerEvent) {
			//spawn the pain things
			//flash a text warning on the sides of the screen
			if (fP == 0) {
				rightWarning.y = LazerCatAttack.you.y;
				leftWarning.y = LazerCatAttack.you.y;
			}
			LazerCatAttack.game.addChild(leftWarning);
			LazerCatAttack.game.addChild(rightWarning);
			fP ++;
			fQ ++;
			//flash the warning && increase the flash rate
			if (fQ >= flashRate) {
				fQ = 0;
				leftWarning.visible = (!leftWarning.visible);
				rightWarning.visible = (!rightWarning.visible);
				if (flashRate > 1) {
					flashRate --;
				}
			}			
			if (fP >= flashTime * LazerCatAttack.frameSpeed) {
				//reset the flashRate
				fP = 0;
				flashRate = flashRateTotal;
				var direction:Boolean = true;
				//add the pain things and add them to the pain Array add removedfromStageEvent
				var pain:Pain;
				var delayCounter:int = 0;
				var newDelay:Number = 0.00;
				var pair:int = 1;
				var positions:Array = new Array();
				//expandTime:Number = .5;
				var expandTime:Number = .5;
				delay = .3;
				painsFired = 10;
				
				//set up the way that the things are going to appear on screen
				var rando:Number = Math.random();
				if (rando > .75) {
					positions.unshift(painY2B, painY1B, painY3, painY1);
					delay = .3;
					expandTime = 1;
				}else if (rando > .5) {
					positions.unshift(painY3, painY1, painY5, painY1B, painY4B);
					delay = .3;
					expandTime = 1;
				}else if (rando >.25) {
					positions.unshift(painY4B, painY3, painY1B, painY2, painY1);
					delay = .22;
					expandTime = 1;
				}else {
					positions.unshift(painY2, painY4B, painY3, painY4);
					delay = .3;
					expandTime = 1;
				}
				/*positions.push(painY3);
				positions.push(painY1);
				positions.push(painY5);*/
				//rough if you fuck up but otherwise easy
				/*positions.unshift(painY2B, painY1B, painY3, painY1);*/
				/*positions.unshift(painY4B, painY2B, painY1, painY4B);*/
				/*positions.unshift(painY3, painY1, painY5, painY1B, painY4B);*/
				//consider this with delay = .22
				/*positions.unshift(painY4B, painY3, painY1B, painY2, painY1);*/
				//this fucks you up if you were moving
				/*positions.unshift(painY2, painY4B, painY3, painY4);*/
				painsFired = positions.length * 2;
				for (var i:int = 0; i < painsFired; i ++) {
					if (delayCounter == 2) {
						delayCounter = 0;
						pair ++;
					}
					delayCounter ++;
					newDelay = delay * (pair - 1);
					if (direction) {
						pain = new Pain("left", newDelay);
					}else if (!direction) {
						pain = new Pain("right", newDelay);
					}
					//pain sets it's own x
					pain.y = LazerCatAttack.you.y + positions[pair - 1];
					direction = (!direction);
					pain.addEventListener(Event.REMOVED_FROM_STAGE, removePain);
					painList.push(pain);
					LazerCatAttack.game.addChild(pain);
				}	
				painEnabled = false;
				LazerCatAttack.game.removeChild(leftWarning);
				LazerCatAttack.game.removeChild(rightWarning);
				LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, bringethThePain);
				LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, painCooldownHandler);
			}
			//should this be here, yes, otherwise loop runs more pains
			painEnabled = false;
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, painCooldownHandler);
		}
		public function decide():int {
			//decide what to do
			//if (/*cat exposed*/) {
			//	//attack the cat
			//	/*selectedTarget = cat*/
			//}
			var decision:int = 0;
			var rando:Number = Math.random();
			if (rando > .5) {
				/*activeState = 1;
				trace("Going into pain mode");*/
				decision = 1;
			}else {
				/*activeState = 2;
				trace("Going into attack mdoe");*/
				decision = 2;
			}
			return decision;
		}
		//check the event target stuffs
		public function removePain (e:Event) {
			e.target.removeEventListener(Event.REMOVED_FROM_STAGE, removePain);
			painList.splice(painList.indexOf(e.target), 1); 
			trace("hey, removing pains");
		}
		/*public function removePain(e:) {
			switch (childNumber) {
				case 1:
					pain1 = null;
					break;
				case 2:
					pain2 = null;
					break;
				case 3:
					pain3 = null;
					break;
				case 4: 
					pain4 = null;
					break;
				case 5:
					pain5 = null;
					break;
				case 6:
					pain6 = null;
					break;
				case 7:
					pain7 = null;
					break;
				case 8:
					pain8 = null;
				default:
					trace("pain remove done dern fucked up");
			}
		}*/
		public function onCatch(xDif, yDif) {
			//stun //freeze the pains if there are pains
			//do stun animation and sound
			LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
			if (activeState == 1) {
				/*trace("active state ==1 @onCatch @ lv2Boss");*/
				if (p > 0) {
					/*trace("attempting to remove the painCH");*/
					LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, painCooldownHandler);
					//set the revive indicator
					rIndicator = 1;
				}else if (fP > 0) {
					/*trace("attempting to remove bringethThePain @lv2Boss");*/
					LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, bringethThePain);
					//set the revive indicator
					rIndicator = 2;
				}else {
					//not sure if this works
					/*trace("potential error on the way @lv2Boss @onCatch");*/
					brain.splice(0, brain.length);
					brain[0] = decide();
					rIndicator = 5;
				}
			}else if (activeState == 2) {
				/*trace("active state ==1 @onCatch @ lv2Boss");*/
				LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, fireHandler);
				rIndicator = 3;
			}else {
				/*trace("activeState resolution problem at @onCatch @lv2Boss");*/
			}
			//at all times check for pains b/c state may have just changed will pains are in play
			for (var i:int = 0; i < painList.length; i++) {
				/*trace("attempting to remove da Pains");*/
				LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, painList[i].loop);
			}
			//do damage
			for (var i:int = 0; i < LazerCatAttack.you.ball.damage; i ++) {
				/*trace("dealing the lv2Boss da damages");*/
				if (i -1 == LazerCatAttack.you.ball.damage) {
					destroyYourself();
				}else {
					h++
				}
			}
			/*trace("I've dealt lv2Boss da damages");*/
			//start the stun timer
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, revive);
			//I believe this stun setting is unused....
			stunned = true;
		}
		//stun timer
		public function revive(e:TimerEvent) {
			//stun timer
			rCounter++;
			if (rCounter == 0) {
				//play powering up sound for the stun duration
				trace("running stun timer");
			}
			if (rCounter >= stunTime * 60) {
				//do repowering animation
				trace("player position = " + player.x + " " + player.y);
				LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
				if (activeState == 1) {
					/*trace("active state ==1 @onCatch @ lv2Boss");*/
					if (p > 0) {
						/*trace("attempting to remove the painCH");*/
						LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, painCooldownHandler);
						//set the revive indicator
						rIndicator = 1;
					}else if (fP > 0) {
						/*trace("attempting to remove bringethThePain @lv2Boss");*/
						LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, bringethThePain);
						//set the revive indicator
						rIndicator = 2;
					}else {
						//not sure if this works
						/*trace("potential error on the way @lv2Boss @onCatch");*/
						brain.splice(0, brain.length);
						brain[0] = decide();
						rIndicator = 5;
					}
				}else if (activeState == 2) {
						/*trace("active state ==1 @onCatch @ lv2Boss");*/
						LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, fireHandler);
						rIndicator = 3;
				}else {
					/*trace("activeState resolution problem at @onCatch @lv2Boss");*/
				}
				for (var i:int = 0; i < painList.length; i++) {
					LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, painList[i].loop);
				}
				rCounter = 0;
				LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, revive);
				stunned = false;
				alpha = 1;
				trace("unstunned @ lv2Boss");
				trace("player position = " + player.x + " " + player.y);
			}
		}
		public function destroyYourself() {
			h ++;
			/*trace("OUch, you shot me! @lv2Boss, h = " + h);*/
			if (hitPoints == 0) {
				//restart mode
				LazerCatAttack.enemyList.splice(LazerCatAttack.enemyList.indexOf(this));
				LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
				LazerCatAttack.game.removeChild(this);
				if (stunned) {
					LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, revive);
				}
				for (var i:int = painList.length - 1; i >= 0; i--) {
					painList[i].destroyYourself();
					painList.splice(i,1);
				}
				LazerCatAttack.game.q = 0;
			}else if (h >= hitPoints) {
				LazerCatAttack.enemyList.splice(LazerCatAttack.enemyList.indexOf(this));
				LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
				LazerCatAttack.game.removeChild(this);
				
				//remove bullets
				for (var i:int = lv2Boss.bullet.length-1; i >= 0; i--) {
					lv2Boss.bullet[i].destroyYourself();
				}
				//passive upgrade screen
				LazerCatAttack.game.showPassive2 = true;
				if (playerKilledMe) {
					LazerCatAttack.huD.updateScore(this.points);
					/*var snd:Sound = new EnemyDeathSound;
					Main.sound.playFX(snd); */
				}
				for (var i:int = painList.length - 1; i >= 0; i--) {
					painList[i].destroyYourself();
					painList.splice(i,1);
				}
				if (playerKilledMe) {
					if (Main.difSet == 1) {
						Main.so.data.beatL2Casual = true;
					}else if (Main.difSet == 2) {
						Main.so.data.beatL2Normal = true;
					}else if (Main.difSet == 3) {
						Main.so.data.beatL2Hard = true;
					}
					//bring the player health back up to full
					var hits:int = LazerCatAttack.you.hits;
					LazerCatAttack.you.hits = 0;
					LazerCatAttack.huD.updateHitPoints(-hits);
					
					LazerCatAttack.level2 = false;
					LazerCatAttack.game.q = 0;
					LazerCatAttack.game.bossFight = false;
					LazerCatAttack.game.level3 = true;
					var end = Math.round(LazerCatAttack.timeIndex / 60);
					LazerCatAttack.endLv2 = end + 2;
					if (Cat.daCat != null) {
						Cat.daCat.thankYou();
					}
					player.killCat();
				}	
			/*}else if (playerKilledMe) {
				var snd:Sound = new HitSound;
				Main.sound.playFX(snd); */
			}
			playerKilledMe = false;
		}
	}
	
}
