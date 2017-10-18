package  {
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.geom.Vector3D;
	import flash.geom.Point;
	import flash.media.Sound;
	
	
	public class Baton extends MovieClip {
		//custom hitbox vars
		public var leftHitBox:batonHit;
		public var midHitBox:batonHit;
		public var rightHitBox:batonHit;
		
		private var rightHP:int = 6;
		private var midHP:int = 6;
		private var leftHP:int = 6;
		
		//mode vars
		private var mode:String = "nothing";
		private var lazre1:BatonLazre;
		private var lazre2:BatonLazre;
		private var lazerOn:Boolean = false;
		private var lStartY:int = 60;
		private var lStartX:int = 20;
		//set this to vary based on ship.y
		private var lMaxH:int = 500;
		private var lMaxW:Number = 50;
		private var lazerDistance:int = 200;
		private var lazreTime:Number = 2.3;
		private var expandY:Number;
		private var expandX:Number;
		private var lHCount:int = 0;
		private var roNowTime:int = 50;
		
		private var batonTimer:int = 0;
		private var batonTime:int = 4;
		private var fireCount:int = 0;
		private var fireCooldown:int = 1;
		
		private var rhinoDistance:int = 300;
		private var rhinoOn:Boolean = false;
		private var ram:Boolean = false;
		public var daRam:BatonRam;
		
		//rotation stuff
		private var diff:Number = 0.00;
		private var roTime:Number = .7;
		private var roDirection:int = 1;
		
		//movement vars
		public var position:Vector3D = new Vector3D();
		private var oldX:int = 0;
		private var oldY:int = 0;
		private var changeX:int = 0;
		private var changeY:int = 0;
		public var selectedTarget:*;
		public var target:Vector3D = new Vector3D();
		public var velocity:Vector3D = new Vector3D();
		public var steering:Vector3D = new Vector3D();
		public var desired:Vector3D = new Vector3D();
		public var there:Boolean = false;
		private var maxVelocity:int = 2;
		private var maxForce:Number = 1.5;
		
		private var circleDistance:Number = 10;
		private var circleRadius:Number = 7;
		private var wanderAngle:int = 0;
		private var angleChange:int = 1;
		//used to set there = true when trying to fire things, cause otherwise batons meander around a bit
		//recent change
		private var closeEnough:int = 50; //20
		public static var presetCloseEnough:int = 20;
		
		//caught is for the pokeball
		public var caught:Boolean = false;
		
		//remove vars
		public var playerKilledMe:Boolean = false;
		private var invincible:Boolean = false;
		public var points:int = 5;
		public static var batons:Array = new Array();
		
		public function Baton() {
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
			mouseEnabled = false;
			closeEnough = Baton.presetCloseEnough;
			// custom hit boxes
			leftHitBox = new batonHit;
			leftHitBox.name = "leftHit";
			midHitBox = new batonHit;
			midHitBox.name = "midHit";
			rightHitBox = new batonHit;
			rightHitBox.name = "rightHit";
			leftHitBox.x = - 42.5;
			/*leftHitBox.y = this.y;*/
			leftHitBox.visible = false;
			/*midHitBox.x = this.x;*/
			/*midHitBox.y = this.y;*/
			midHitBox.height = 6;
			midHitBox.width = 60;
			midHitBox.visible = false;
			rightHitBox.x = 42.5;
			/*rightHitBox.y = this.y;*/
			rightHitBox.visible = false;
			addChild(rightHitBox);
			addChild(midHitBox);
			addChild(leftHitBox);
			LazerCatAttack.enemyList.push(leftHitBox);
			LazerCatAttack.enemyList.push(rightHitBox);
			LazerCatAttack.enemyList.push(midHitBox);
			
			//on startup decide to do something
			decide();
			/*mode = "rhino";*/
			/*selectedTarget = LazerCatAttack.you;*/
			/*selectedTarget = wanderPoint();*/
			trace(mode);
		}
		
		public function loop(e:TimerEvent) {
			//three modes
			//how to deal with players when they decide to travel high up on the screen
			//during these modes??
			position.x = this.x;
			position.y = this.y;
			oldX = this.x;
			oldY = this.y;
			switch (mode) {
				case "lazer":
					//decide sets selectedTarget to the player
					/*trace("running lazer");*/
					//movement: seek a point above the player
					//when there , there = true and shoot lazer
					target.x = selectedTarget.x;
					target.y = selectedTarget.y - lazerDistance;
					if (!lazerOn) {
						move();
						//rotate to 0 : this is all fucking weird
						if (rotation == 180 || rotation ==0) {
							//nothing
						}else {
							trace(rotation);
							if (rotation >= 270) {
								roDirection = 1;
								diff = 360 - rotation;
								diff = diff/ roNowTime;
								rotation -= diff;
								roNowTime --;
							}else if (185 > rotation && rotation >= 180 || 175 < rotation && rotation <= 180) {
								roDirection = 0;
								diff = 0;
								rotation = 180;
								roNowTime = 50;
							}else if (rotation >= 90) {
								roDirection = 1;
								diff = 180 - rotation;
								diff = diff/roNowTime;
								rotation -= diff;
								roNowTime --;
							}else if (5 > rotation && rotation >= 0 || -5 < rotation && rotation <= 0) {
								roDirection = 0;
								diff = 0;
								rotation = 0;
								roNowTime = 50;
							}else {
								rotation = 0;
							}
						}	
						
					}else {
						//nothing
					}
					if (there && !lazerOn && (rotation == 0 || rotation == 180)) {
						fireDaLazre();
						there = false;
					}
					break;
				case "baton":
					//consider doing this by waypoints instead
					target.x = selectedTarget.x;
					target.y = selectedTarget.y;
					move();
					//firing
					if (batonTimer == 0) {
						LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, fireHandler);
					}
					rotation += 1.5;
					batonTimer ++;
					if (batonTimer / 60 == batonTime) {
						LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, fireHandler);
						//reset fireHandler stuff?
						decide();
						trace("should be doing a new mode @ baton/batonMode");
					}
					if (there) {
						there = false;
						selectedTarget = wanderPoint();
					}
					//movement : go to a point at the top, rotate
					//then wander within the top of the screen
					
					break;
				case "rhino":
					//goto a point pretty far above player then rapidly 
					//charge the player, when offscreen warp to top 
					target.x = selectedTarget.x;
					target.y = selectedTarget.y - rhinoDistance;
					//determine a wandering rotation
					if (!rhinoOn && !there) {
						rotation += 1;
						move();
					}
					//consider a custom thing for setting there in rhino that's more
					//lenient
					if (there && !rhinoOn) {
						rhinoOn = true;
						/*trace("STAMPEDING RHINO");*/
						//stop in place and spin to  90 degrees
						/*trace("this rotation = " + rotation);*/
						if (rotation <= - 90) {
							roDirection = 1;
							diff = rotation - 180;
							diff = diff/ (roTime * 60);
						}else if (rotation <= 0) {
							roDirection = -1;
							diff = rotation - 270;
							diff = diff/ (roTime * 60);
							rotation -= diff;
						}else if (rotation > 90) {
							roDirection = -1;
							diff = rotation - 90;
							diff = diff/(roTime * 60);
						}else {
							roDirection = 1;
							diff = rotation;
							diff = diff/(roTime * 60);
						}
						/*trace("diff = " + diff);*/
						/*rotation = 90;*/
					}else if (rhinoOn) {
						/*trace("rhinoOn");
						trace("diff = " + diff);*/
						rotation += roDirection * diff;
						if (rotation > 87 && rotation < 93) {
							rotation = 90;
						}
						if (rotation < -87 && rotation > -93) {
							rotation = -90;
						}
						if (rotation == 90 || rotation == 270){
							if (!ram) {
								ram = true;
								daRam = new BatonRam;
								
								daRam.x = this.x;
								daRam.y = this.y + 65 + daRam.height/2;
								LazerCatAttack.game.addChild(daRam);
								LazerCatAttack.enemyList.push(daRam);
							}else {
								daRam.x += changeX;
								daRam.y += changeY;
							}
							diff = 0;
							velocity.x = 0;
							velocity.y = 6;
							position = position.add(velocity);
							if (this.y > 650) {
								//random x
								var rando:int = Math.random() * 500;
								position.x = rando;
								this.y = -30;
								position.y = -30;
								rhinoOn = false;
								daRam.remove();
								daRam = null;
								ram = false;
								decide();
							}
						}
					}
					break;
				default:
					//if nothing then decide to do something
					decide();
					trace("baton mode non-existent, deciding");
			}
			this.x = position.x; 
			this.y = position.y;
			changeX = this.x - oldX;
			changeY = this.y - oldY;
		}
		
		private function seek(target:Vector3D) {
			var force:Vector3D;
			desired = target.subtract(position);
			desired.normalize();
			desired.scaleBy(maxVelocity);
			force = desired.subtract(velocity);
			return force;
		}
		private function move() {
			steering = seek(target);
			truncate(steering, maxForce);
			velocity = velocity.add(steering);
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
			}else if(distance(this, targetPoint) < velocity.length + closeEnough && (mode == "rhino" || mode == "lazer")){
				var direction:Vector3D = new Vector3D();
				direction = target.subtract(position);
				var directionAngle = getAngle(direction);
				directionAngle*= 180/Math.PI;
				var velAngle = getAngle(velocity) * (180/Math.PI);
				if (velAngle > directionAngle - 10 || velAngle < directionAngle + 10) {
					there = true;
				}else {
					position = position.add(velocity);
					there = false;
				}
			}else {
				position = position.add(velocity);
				there = false;
			}
		}
		
		private function truncate(vector:Vector3D, max:Number):void {
			var i:int;
			i = vector.length/max;
			if (i > 1) {
				if (max == 0) {
					trace("error, @baton truncate");
				}else {
					vector.scaleBy(1/i);
				}
			}
		}
		private function wanderPoint() {
			//describe three sections of possible wanderpoints 1,2,3 :left to right
			//random y in top 250 part of screen moved down 44 so he couldn't rotate off top of the screen
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
		private function wander() {
			var wanderForce:Vector3D;
			var circleCenter:Vector3D;
			var displacement:Vector3D;
			circleCenter = velocity.clone();
			circleCenter.normalize();
			//circleDistance?
			circleCenter.scaleBy(circleDistance);
			displacement = new Vector3D(0,1,0);
			displacement.scaleBy(circleRadius);
			setAngle(displacement, wanderAngle);
			wanderAngle += Math.random() * angleChange - angleChange * .5;
			wanderForce = circleCenter.add(displacement);
			wanderForce.normalize();
			maxForce = .5;
			maxVelocity = 1;
			wanderForce.scaleBy(maxForce);
			return wanderForce;
		}
		//don't know if this will be used
		private function getAngle(vector:Vector3D):Number {
			return Math.atan2(vector.y, vector.x);
		}
		private function setAngle(vector:Vector3D, angle:Number):void {
			var length1:Number = vector.length;
			vector.x = Math.cos(angle) * length1;
			vector.y = Math.sin(angle) * length1;
		}
		public function distance(a, b):int {
			return (Math.sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y)));
		}
		
		private function fireDaLazre() {
			//two beams, grow longer and wider, then stop
			trace("firing the Lazre()");
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER,lazreHandler);
			//this is handy but remove it from final build
			/*BatonLazre.height = lStartY;
			BatonLazre.width = lStartX;*/
			//
			lazre1 = new BatonLazre();
			lazre2 = new BatonLazre();
			lazre1.height = lStartY;
			lazre1.width = lStartX;
			lazre2.width = lStartX;
			lazre2.height = lStartY;
			lazre1.x = this.x - 42.5;
			lazre2.x = this.x + 42.5;
			lazre1.y = this.y + 12.5 + lazre1.height/2;
			lazre2.y = this.y + 12.5 + lazre2.height/2;
			LazerCatAttack.game.addChild(lazre1);
			LazerCatAttack.game.addChild(lazre2);
			lazerOn = true;
			expandY = (lMaxH - lazre1.height) / (lazreTime * 30);
			expandX = (lMaxW - lazre1.width) / (lazreTime * 30);
			/*trace("expandY = " + expandY);
			trace("expandX = " + expandX);*/
		}
		public function lazreHandler(e:TimerEvent) {
			//stay relative to the ship
			lHCount ++;
			//the beam lengthens then widens 
			if (lazreTime* 30 >= lHCount) {
				lazre1.height += expandY;
				lazre2.height += expandY;
				lazre1.y += changeY + expandY/2;
				lazre2.y += changeY + expandY/2;
			}else if (lazreTime*60 > lHCount) {
				lazre1.width += expandX;
				lazre2.width += expandX;
				lazre1.x += changeX + expandX/2;
				lazre2.x += changeX - expandX/2;
			}else if (lazreTime* 60 == lHCount) {
				lHCount = 0;
				lazre1.remove();
				lazre2.remove();
				lazre1 = null;
				lazre2 = null;
				LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, lazreHandler);
				lazerOn = false;
				decide();
			}
		}
		
		private function fire() {
			
		}
		private function fireHandler(e:TimerEvent) {
			fireCount ++;
			if (fireCount / 60 == fireCooldown) {
				fire();
				fireCount = 0;
			}
		}
		
		private function decide() {
			var rando:Number = Math.random();
			if (rando >= .66 && mode != "lazer") {
				mode = "lazer";
				selectedTarget = LazerCatAttack.you;
				there = false
				trace("lazer");
			}else if (rando >= .33 && mode != "baton") {
				mode = "baton";
				there = false;
				selectedTarget = wanderPoint();
				batonTimer = 0;
				trace("baton mode");
			}else if (mode != "rhino") {
				mode = "rhino";
				selectedTarget = LazerCatAttack.you;
				there = false;
				trace("rhino mode");
			}else {
				decide();
			}
		}
		public function rightHit() {
			if (!invincible) {
				rightHP--;
				var snd:Sound = new HitSound;
				Main.sound.playFX(snd); 
				if (rightHP <= 0) {
					//EXPLODE MUTHAFUCKA
					remove();
				}
			}
		}
		public function midHit() {
			if (!invincible) {
				midHP --;
				var snd:Sound = new HitSound;
				Main.sound.playFX(snd); 
				if (midHP <= 0) {
					//EXPLODE
					remove();
				}
			}
		}
		public function leftHit() {
			if (!invincible) {
				leftHP --;
				var snd:Sound = new HitSound;
				Main.sound.playFX(snd); 
				if (leftHP <= 0) {
					//explode...less excited lol.
					remove();
				}
			}
		}
		public function onCatch(xDif, yDif) {
			trace("onCatch was called");
			if (!caught) {
				trace("this baton hasn't been caught");
				LazerCatAttack.you.ball.caught.push(this);
				remove();
				this.x = xDif;
				this.y = yDif;
				LazerCatAttack.you.ball.addChild(this);
			}	
			caught = true;
			trace("this baton is now caught");
		}
		public function revive() {
			caught = false;
			//hitBox stuff
			leftHitBox = new batonHit;
			trace("left hit Box" + leftHitBox);
			leftHitBox.name = "leftHit";
			midHitBox = new batonHit;
			midHitBox.name = "midHit";
			rightHitBox = new batonHit;
			rightHitBox.name = "rightHit";
			leftHitBox.x = - 42.5;
			/*leftHitBox.y = this.y;*/
			leftHitBox.visible = false;
			/*midHitBox.x = this.x;*/
			/*midHitBox.y = this.y;*/
			midHitBox.height = 6;
			midHitBox.width = 60;
			midHitBox.visible = false;
			rightHitBox.x = 42.5;
			/*rightHitBox.y = this.y;*/
			rightHitBox.visible = false;
			addChild(rightHitBox);
			addChild(midHitBox);
			addChild(leftHitBox);
			trace("baton.x .y" + this.x + " " + this.y);
			trace("right" + rightHitBox.x + " " + rightHitBox.y);
			LazerCatAttack.enemyList.push(leftHitBox);
			LazerCatAttack.enemyList.push(rightHitBox);
			LazerCatAttack.enemyList.push(midHitBox);
			trace("enemyList index of left = " + LazerCatAttack.enemyList.indexOf(leftHitBox));
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
			Baton.batons.push(this);
			mode = "nothing";
			lStartY = 60;
			lStartX = 20;
			lazreTime = 2.3;
			batonTimer = 0;
			batonTime = 4;
			fireCount = 0;
			fireCooldown = 1;
			roNowTime = 50;
			lHCount = 0;
			expandX = 0;
			expandY = 0;
			ram = false;
			rhinoOn = false;
			diff = 0.00;
			roTime = .7;
			roDirection = 1;
			changeX = 0;
			changeY = 0;
			oldX = 0;
			oldY = 0;
			position.x = this.x;
			position.y = this.y;
			selectedTarget = null;
			target = new Vector3D();
			velocity = new Vector3D();
			steering = new Vector3D();
			desired = new Vector3D();
			there = false;
			wanderAngle = 0;
			angleChange = 1;
			caught = false;
			invincible = false;
			decide();
		}
		public function remove() {
			LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
			Baton.batons.splice(Baton.batons.indexOf(this), 1);
			rightHitBox.invincible = false;
			rightHitBox.remove();
			rightHitBox = null;
			leftHitBox.invincible = false;
			leftHitBox.remove();
			leftHitBox = null;
			midHitBox.invincible = false;
			midHitBox.remove();
			midHitBox = null;
			LazerCatAttack.game.removeChild(this);
			if (daRam != null) {
				daRam.remove();
				daRam = null;
				//reset all of these state dependent variables
				ram = false;
			}
			if (lazre1 != null) {
				lazre1.remove();
				lazre2.remove();
				lazre1 = null;
				lazre2 = null;
				LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, lazreHandler);
			}
			if (playerKilledMe) {
				var snd:Sound = new EnemyDeathSound;
				Main.sound.playFX(snd); 
				LazerCatAttack.huD.updateScore(this.points);
			}
			playerKilledMe = false;
		}
	}
	
}
