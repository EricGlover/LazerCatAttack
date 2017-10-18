package  {
	import flash.events.*;
	import flash.display.*;
	import flash.utils.*;
	import fl.controls.Button;
	import flash.geom.*;
	import flash.media.Sound;
	import flash.display.Shape;
	
	public class Player extends MovieClip{
		 //new var key:String;
		//your ship's speed, with a velocity stuff for friction degrading movement
		var youSpeed:Number = .4;
		public var changeX:Number = 0.00;
		public var changeY:Number = 0.00;
		private var oldX:Number;
		private var oldY:Number;
		public var vx:Number = 0;
		public var vy:Number = 0;
		var friction:uint = .93;
		public var maxSpeed = 4;
		//warp variables
		//have no clue if warpEnabled is necessary after the implementation of ability1 stuff
		public var warpEnabled:Boolean = true;
		private var maxWarp:int = 195; //was 180
		/*private var warpTick:Boolean = false;
		private var newStartUpTime:int = 0;*/
		private var warpCharge:int = 0;
		private var wTimer:int = 0;
		public var warpCooldown:int = 1;
		public var timesWarped:int;
		//in time ticks
		/*private var warpStartUpTime:int = 6;*/

		//pokeball vars
		public var pokeballEnabled:Boolean = true;
		public var pokeballFull:Boolean = false;
		public var ball:Pokeball = new Pokeball();
		public var haveBall:Boolean = true;
		public var mCounter:int = 0;
		public var caughtTotal:int = 0;
		//mess around with this 
		public var pLag:int = 7;
		private var move:Array = new Array();
		
		//lazer
		public var lazerEnabled:Boolean = false;
		private var canFireL:Boolean = true;
		public var lc:int = 0;
		public var lazerCooldown:int = 4;
		public var lazersFired:int;
		
		//invincibility powerup (?) / programming tool
		private var deathCount:int = 0;
		private var dead:Boolean = false;
		public var invincible:Boolean = false;
		private var invincibleEnabled:Boolean = true;
		private var iTimer:int = 0;
		//cooldown and length in seconds
		private var invincibilityCooldown:int = 10;
		private var invincibilityLength:int = 3;
		public var hitPoints:int = 5; //testing should be 5
		public var hits:int = 0;
		//keeps track of game pauses
		public var pauseGame:Boolean = false;
		public static var timeIndex:int = 0;
		public var flicker:int = 0;
		public var flickerTimer:int = 0;
		public var flickerTime:Number = .3;
		
		
		private var canFire:Boolean = true;
		public static var aftShotsFired:int = 0;
		private var fire:Boolean = false;
		public static var playerBullets:Array = new Array();
		public static var bulletPool:Vector.<Bullet> = new Vector.<Bullet>;
		public var fireTimer:Timer;
		public var bulletSpeed:Number = 12;
		//permaFire // Overcharge vars
		private var permaFire:Boolean = false;
		public var oneRight:int = 0;
		public var oneLeft:int = 0;
		public var oneBelow:int = 0;
		public var oneAbove:int = 0;
		
		//dimensional rift
		private var dCounter:int = 0;
		private var alphaShiftTime:int = 1;
		private var totalAlphaShift:Number = .5;
		private var dimensionalTime:int = 4;
		
		//slowTime shit
		private var slowMod:Number = 3;
		private var slowTick:Number = 1.15;
		private var slowCount:int = 0;
		private var maxDelayT:Number = 80;
		private var slowTimeAmount:Number = 3 * 60;
		private var normalTime = true;
		
		//Boomerang
		public var boomerangEnabled:Boolean = true;
		private var canFireB:Boolean = true;
		private var bc:int = 0;
		private var boomerangCooldown:int = 3;
		public var boomerangsThrown:int;
		private var boomerang:Boomerang;
		
		//hunger mode
		public var hungerMode:Boolean = false;
		private var eCounter:int;
		private var currentEnergy:int;
		private var totalEnergy:int = 300;
		private var hRatio:Number;
		private var nutValue:int = 50;
		//hunger increase per second
		//private var energyUse:int = 6;
		private var tickSpeed:int = 20;
		
		public var controlFuckery:Boolean = false;
		//setting for cheat codes to enable extra modes : "//" pauses the game and pull up the prompt
		//code = "//hamburglar" I believe
		public var extraContent:Boolean = true;
		private var hBCode:Array = [191,191,72,65,77,66,85,82,71,76,65,82];
		private var retroCode:Array = [191,191,82,69,84,82,79]; // = "//retro" (?)
		public var up:Boolean = false
		public var down:Boolean = false;
		public var left:Boolean = false;
		public var right:Boolean = false;
		public var up1:int = 87;
		public var up2:int = 38;
		public var down1:int = 83;
		public var down2:int = 40;
		public var left1:int = 65;
		public var left2:int = 37;
		public var right1:int = 68;
		public var right2:int = 39;
		public var ability1:String = "none";
		public var ability2:String = "none";
		public var passive1:String = "none";
		public var passive2:String = "none";
		
		public  var b1:Background;
		public  var b2:Background;
		
		public var crushMasta:Crusher;
		public var crushCount:int = 60;
		private var refreshRate:int = 1;
		private var refreshCount:int = 0;
		private var refreshAmount:int = 2;
		/*private var alphaChanger:Number = 1/(crushPool/ 60);*/
		//in seconds remember to update minCrush and crush count if changing crushPool
		public static var crushPool:int = 2;
		private var minCrush:int = 10;
		public var thingsWrecked:int;

		public var leftHalf:Sprite;
		public var rightHalf:Sprite;
		public var shipSplit:Boolean;
		private var splitSpeed:int = 1;
		private var shiftDown:Boolean;
		
		public static var playerTimer:Timer = new Timer(16,0);
	
		public function Player() {
			addEventListener(Event.ADDED_TO_STAGE, startUp);
			this.tabEnabled = false;
			this.mouseEnabled = false;
			this.focusRect = false;
			//register this to the gameTimer for less timers
			fireTimer = new Timer(270,0);
			/*currently this timer is firing off events every 300 milliseconds....
			you should probably rework this.*/
			fireTimer.start();
			fireTimer.addEventListener(TimerEvent.TIMER, fireTimerHandler);
			playerTimer.addEventListener(TimerEvent.TIMER, refresh);
			playerTimer.start();
			/*playerTimer.addEventListener(TimerEvent.TIMER, crusherCooldown);*/
			/*playerTimer.addEventListener(TimerEvent.TIMER, warpCooldownHandler);*/
			addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			Player.aftShotsFired = 0;
			if (ability1 == "pokeball") {
				ball = new Pokeball;
			}
			for (var i:uint = 0; i < 20; i++ ) {
				Player.bulletPool[i] = new Bullet;
			}
		}
		public function startUp(e:Event) {
			/*stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);*/
			removeEventListener(Event.ADDED_TO_STAGE, startUp);
			stage.focus = this;
			addEventListener(Event.ACTIVATE, refocus);
			addEventListener(Event.DEACTIVATE, unfocus);
			addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, attentionPlease);
			/*trace("ran startup blahadkfhasldk");*/
			//set up a warning like press any button to start and use unpause and change LCA.game to not starting immediately
		}
		public function attentionPlease (e:FocusEvent) {
			/*trace("they tried to stop paying attention to me, " + e.relatedObject + " did it.");*/
			/*stage.focus = this;*/
			e.preventDefault();
			stage.focus = this;
		}	
		public function refocus(e:Event) {
			trace("player detects attempt to refocus");
			stage.focus = this;
			if (pauseGame) {
				Main.sound.unPauseMusic();
			}	
		}
		public function unfocus(e:Event) {
			trace("player detects system lost focus");
			if (!pauseGame) {
				pause();
				Main.sound.pauseMusic();
			}	
		}
		public function keyDownHandler(e:KeyboardEvent) {
				//consider a switch function here
				//controlFuckery changes the kecodes
				//the unlock HB and Retro are secret modes
				//create a list of used characters
				//16 = shift (right or left)
				if (e.keyCode == hBCode[0]) {
					unlockHB();
				}else if (e.keyCode == retroCode[0]) {
					unlockRetro();
				}else if (e.keyCode == up1 || e.keyCode == up2) {
						up = true;	
						move.unshift("up");
				}else if (e.keyCode == down1 ||e.keyCode == down2) {
						down = true;	
						move.unshift("down");
				}else if (e.keyCode == left1 ||e.keyCode == left2) {
						left = true;
						move.unshift("left");
				}else if (e.keyCode == right1 ||e.keyCode == right2) {
						right = true;
						move.unshift("right");
				}else if (e.keyCode == 32) {
					fireBullet();
					fire = true;
				}else if (e.keyCode == 27 || e.keyCode == 80 /*&& !pauseMenu*/) {
					// pause menu
					pause();
				}else if (e.keyCode == 74 || e.keyCode == 49) {
					//boomerang
					if (boomerangEnabled && canFireB) {
						fireBoomerang();
					}
				}else if (e.keyCode == 75 || e.keyCode == 88 || e.keyCode == 50) {
					if (ability1 == "warp") {
						if (warpCharge > 0 && warpEnabled) {
							/*warpOn(0);*/
							warpOn("warp");
						}
					}else if (ability1 == "crusher") {
						deployCrusher();
					}else if (ability1 == "pokeball") {
						if (haveBall) {
							throwBall();
						}
					}else {
						/*trace("keydown binding problem");*/
					}					
				}else if (e.keyCode == 76 || e.keyCode == 51) {
					if (lazerEnabled && canFireL) {
						fireLazer();
					}
				}else if ((passive1 == "Slow Time Ability" || passive2 == "Slow Time Ability") && e.keyCode == 20 && normalTime) {
					Player.playerTimer.addEventListener(TimerEvent.TIMER, slowTime);
					/*trace("Attempting to slow time");*/
					normalTime = false;
				}else if (e.keyCode == 16){
					//activate ship partition
					//stage.focus = this;
					//export this to a function
					shiftDown = true;
					//now if shift is down @ refresh then it calls shipSplitter()
					/*if (!this.visible) {
						leftHalf = new Ship_left_half;
						rightHalf = new Ship_right_half;
						leftHalf.x = this.x;
						leftHalf.y = this.y;
						rightHalf.x = this.y;
						rightHalf.y = this.y;
						LazerCatAttack.game.addChild(leftHalf);
						LazerCatAttack.game.addChild(rightHalf);
					}else{
						LazerCatAttack.game.removeChild(leftHalf);
						LazerCatAttack.game.removeChild(rightHalf);
						leftHalf = null;
						rightHalf = null;
					}*/
				}
				//trace("key entered = " + e.keyCode);
			}	
		public function keyUpHandler(e:KeyboardEvent) {
				if (e.keyCode == up1 || e.keyCode == up2) {
					up = false;
				}else if (e.keyCode == down2 || e.keyCode == down1) {
					down = false;
				}else if (e.keyCode == left1 || e.keyCode == left2) {
					left = false;
				}else if (e.keyCode == right1 || e.keyCode == right2) {
					right = false;
				}else if (e.keyCode == 75 || e.keyCode == 50) {
					if (ability1 == "crusher") {
						if (crushMasta == null) {
							//testing
							/*deployCrusher();*/
							/*crushMasta.remove();*/
						}else {
							crushMasta.remove();
						}
					}else if (ability1 == "pokeball") {
						/*trace("pokeball not implemented");*/
						if (!ball.full) {
							ball.gottaCatchemAll();
						}else if (ball.full) {
							ball.releaseBeasts();
						}
					}			
				}else if (e.keyCode == 16){
					shiftDown = false;
				}
				if (e.keyCode == 32) {
					fire = false;
				}
		}
		private function shipSplitter(){
			///current problems: hitbox : the player ship while invisible is still hitbox tested
			// laser beam needs to be added
			// the main firing gun needs to doubled and added to both ships
			// the spawn points for the ship halfs aren't operational
			// the ability needs to be gradual
			//the re-uniting part is handled with the movement
			if (!shipSplit) {
				leftHalf = new Ship_left_half;
				rightHalf = new Ship_right_half;
				leftHalf.x = this.x -  1;
				leftHalf.y = this.y;
				rightHalf.x = this.x + 1;
				rightHalf.y = this.y;
				LazerCatAttack.game.addChild(leftHalf);
				LazerCatAttack.game.addChild(rightHalf);
				shipSplit = true;
				this.visible = false;
				stage.focus = this;
				trace("ship is split");
			}else{
				//leftHalf.x += splitSpeed;
				//rightHalf.x -= splitSpeed;
				//run this when they connect again
				if (leftHalf.x >= rightHalf.x){
					trace("ship is unsplit");
					LazerCatAttack.game.removeChild(leftHalf);
					LazerCatAttack.game.removeChild(rightHalf);
					leftHalf = null;
					rightHalf = null;
					shipSplit = false;
					this.visible = true;
				}
			}
		}
		private function slowTime(e:TimerEvent) {
			//lv3Boss timer //main timer // player timer
			/*trace("running slow time");*/
			/*if (slowCount == 0) {
				LazerCatAttack.gameTimer.delay = 16 * 4;
				trace("gameTimer set to " + LazerCatAttack.gameTimer.delay);
			}*/
			slowCount++;
			if (LazerCatAttack.gameTimer.delay < maxDelayT) {
				LazerCatAttack.gameTimer.delay = 16 * slowTick;
			}
			
			if (slowCount > slowTimeAmount) {
				Player.playerTimer.removeEventListener(TimerEvent.TIMER, slowTime);
				restoreTime();
				slowCount = 0;
			}
		}
		private function restoreTime() {
			/*trace("running time restore");*/
			LazerCatAttack.gameTimer.delay = 16;
			normalTime = true;
		}
		public function enablePokeball() {
			ability1 = "pokeball";
		}	
		private function throwBall() {
			ball.x = this.x;
			ball.y = this.y - 30;
			/*ball.boomerang = false;*/
			ball.retrieve = false;
			/*if (pokeballFull) {
				ball.full = true;
			}else {
				
			}*/
			if (ball.full) {
				//consider changing this to the last inputs within 1/10 of a second
				var velocity:Vector3D = new Vector3D(vx,vy,0);
				velocity.normalize();
				velocity.scaleBy(ball.speed);
				if (velocity.x != 0 || velocity.y != 0) {
					ball.velocity.x = velocity.x;
					ball.velocity.y = velocity.y;
				}else {
					ball.velocity.y = - ball.speed;
				}				
				
				ball.retoss();
			}else {
				ball.color = 3;
				ball.selectedTarget = this;
				//consider changing this to the last inputs within 1/10 of a second
				var velocity:Vector3D = new Vector3D(vx,vy,0);
				velocity.normalize();
				velocity.scaleBy(ball.speed);
				if (velocity.x != 0 || velocity.y != 0) {
					ball.velocity.x = velocity.x;
					ball.velocity.y = velocity.y;
				}else {
					ball.velocity.y = - ball.speed;
				}				
				
				LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, ball.loop);
				LazerCatAttack.game.addChild(ball);
			}
			haveBall = false;
			
		}
		public function enableCrusher() {
			playerTimer.addEventListener(TimerEvent.TIMER, crusherCooldown);
			ability1 = "crusher";
		}	
		private function deployCrusher () {
			if (crushMasta == null && crushCount > minCrush) {
				crushMasta = new Crusher();
				crushMasta.x = this.x;
				crushMasta.y = this.y;
				LazerCatAttack.game.addChild(crushMasta);
			}/*else if (crushCount > minCrush) {
				
			}*/
		}
		public function crusherCooldown(e:TimerEvent) {
			//if not null then lower pool, if null then refresh CHANGE THE REFRESH RATE
			//crush count starts high
			if (crushMasta != null) {
				crushCount --;
				LazerCatAttack.game.cdHud.updateCrusher(crushCount/ (crushPool * LazerCatAttack.frameSpeed));
				if (crushMasta.alpha > .1) {
					crushMasta.alpha = crushCount / (crushPool * LazerCatAttack.frameSpeed);
				}
				/*trace("crushCount = " + crushCount);*/
				if (crushCount <= 0) {
					crushMasta.remove();
					/*trace("removing dr. crusher");*/
				}
			}else if (crushMasta == null && crushCount < crushPool * LazerCatAttack.frameSpeed) {
				refreshCount++;
				/*trace("cRatio = " + (crushCount/ (crushPool * LazerCatAttack.frameSpeed)));*/
				LazerCatAttack.game.cdHud.updateCrusher(crushCount/ (crushPool * LazerCatAttack.frameSpeed));
				if (refreshCount == refreshRate) {
					crushCount += refreshAmount;
					refreshCount = 0;
				}
			}			
		}
		private function fireBullet ():void {
			//testing
			/*passive1 = "Sheep 4 The Win";*/
			//change bullet speed to half as much when sheep 4 the win.
			//also redo the sheep art for this new size and turn off anti-alising
			if (canFire) {
				if (Player.bulletPool.length > 1 ) {
					var bullet2;
					if (passive1 == "Double Fire" || passive2 == "Double Fire"){
						bullet2 = Player.bulletPool.shift();
					}
					/*var bullet = Player.bulletPool.pop();*/
					/*bullet.gotoAndPlay(10);*/
					var bullet = Player.bulletPool.shift();
					/*var bullet2;*/
					if (bullet != null) {
						/*bullet.gotoAndPlay(10);*/
					}	
				}else {
					var bullet = new Bullet();
					if (passive1 == "Double Fire" || passive2 == "Double Fire") {
						bullet2 = new Bullet();
					}
				}
				if (bullet2 != null) {
					if (passive1 == "Sheep 4 The Win" || passive2 == "Sheep 4 The Win") {
						bullet.gotoAndStop(10);
						bullet2.gotoAndStop(10);
						bullet.sheep = true;
						bullet2.sheep = true;
					}
					bullet.recycle(this.x - this.width/2 + 2, this.y - this.height/2, bulletSpeed);
					LazerCatAttack.game.addChild(bullet);
					Player.playerBullets.push(bullet);
					bullet2.recycle(this.x + this.width/2 - 2, this.y - this.height/2, bulletSpeed);
					LazerCatAttack.game.addChild(bullet2);
					Player.playerBullets.push(bullet2);
				}else {
					if (passive1 == "Sheep 4 The Win" || passive2 == "Sheep 4 The Win") {
						bullet.gotoAndStop(10);
						bullet.sheep = true;
					}
					bullet.recycle(this.x, this.y - this.height/2, bulletSpeed);
					LazerCatAttack.game.addChild(bullet);
					Player.playerBullets.push(bullet);
				}
				canFire = false;
				var snd:Sound = new MissileFX;
				Main.sound.playFX(snd);
			}	
			//}else if (permaFire) {
			//	/*var bullet = new Bullet(this.x, this.y - this.height/2, bulletSpeed);
			//	LazerCatAttack.game.addChild(bullet);
			//	Player.playerBullets.push(bullet);*/
			//}
			//delete the else if sometime
			
		}	
		private function fireLazer() {
			if (!dead) {
				var lazer = new PlayerLazer;
				lazersFired ++;
				lazer.x = this.x;
				lazer.y = this.y - 415 - this.height/2;
				trace("firing da lazer");
				LazerCatAttack.game.addChild(lazer);
				Player.playerTimer.addEventListener(TimerEvent.TIMER, lazerCooldownHandler);
				canFireL = false;
				LazerCatAttack.game.cdHud.updateLazer(this.canFireL, 0);
				var snd:Sound = new LazerSound;
				Main.sound.playFX(snd);
			}	
		}
		private function lazerCooldownHandler(e:TimerEvent):void {
			this.lc++;
			/*LazerCatAttack.game.cdHud.updateLazer(this.canFireL, this.lc);*/
			if (lc == lazerCooldown * LazerCatAttack.frameSpeed) {
				canFireL = true;
				lc = 0;
				LazerCatAttack.game.cdHud.updateLazer(this.canFireL, this.lc);
				Player.playerTimer.removeEventListener(TimerEvent.TIMER, lazerCooldownHandler);
			}
			
		}
		
		private function fireBoomerang() {
			if (!dead) {
				//var iVel = new Vector3D();
				boomerang = new Boomerang(this.vx, this.vy);
				boomerangsThrown ++;
				boomerang.x = this.x;
				boomerang.y = this.y - this.height/2;
				LazerCatAttack.game.addChild(boomerang);
				Player.playerTimer.addEventListener(TimerEvent.TIMER, boomerangCooldownHandler);
				canFireB = false;
				//update the hud
				//make a sound
			}
		}
		private function boomerangCooldownHandler(e:TimerEvent) {
			bc++;
			if(bc >= boomerangCooldown * LazerCatAttack.frameSpeed) {
				canFireB = true;
				//update hud
				Player.playerTimer.removeEventListener(TimerEvent.TIMER, boomerangCooldownHandler);
			}
		}
		public function boomerangDied(){
			boomerang = null;
			//do I need other things?
		}
		public function boomerangCaught() {
			//idk what should go here
		}
		public function fireTimerHandler(e:TimerEvent):void {
			canFire = true;
		}
		//aft cannon fires backward
		private function fireAftCannon () {
			if (LazerCatAttack.you != null) {
				if (Player.bulletPool.length > 0 ) {
					var bullet = Player.bulletPool.pop();
				}else {
					var bullet = new Bullet();
					trace("making a new bullet");
				}
				bullet.recycle(this.x,this.y +this.height/2, bulletSpeed * -1);
				Player.playerBullets.push(bullet);
				LazerCatAttack.game.addChild(bullet);
				var snd:Sound = new MissileFX;
				Main.sound.playFX(snd);
				Player.aftShotsFired ++;
			}
		}
		
		public function pause () {
			if (!pauseGame) {
				LazerCatAttack.gameTimer.stop();
				/*playerTimer.removeEventListener(TimerEvent.TIMER, warpCooldownHandler);*/
				playerTimer.removeEventListener(TimerEvent.TIMER, refresh);
				playerTimer.stop();
				/*playerTimer.removeEventListener(TimerEvent.TIMER, crusherCooldown);*/
				fireTimer.stop();
				/*if (lv3Boss.bob != null) {
					if (lv3Boss.bob.glitchTimer != null) {
						lv3Boss.bob.glitchTimer.stop();
					}	
				}	*/			
				pauseGame = true;
				LazerCatAttack.game.pauseMenu = new PauseMenu;
				LazerCatAttack.game.pauseMenu.x = 250;
				LazerCatAttack.game.pauseMenu.y = 300;
				LazerCatAttack.game.addChild(LazerCatAttack.game.pauseMenu);
			}else {
				LazerCatAttack.game.pauseMenu.destroyYourself();
				LazerCatAttack.gameTimer.start();
				/*playerTimer.addEventListener(TimerEvent.TIMER, warpCooldownHandler);*/
				playerTimer.addEventListener(TimerEvent.TIMER, refresh);
				playerTimer.start();
				fireTimer.start();
				/*playerTimer.addEventListener(TimerEvent.TIMER, crusherCooldown);*/
				/*if (lv3Boss.bob != null) {
					if (lv3Boss.bob.glitchTimer != null) {
						lv3Boss.bob.glitchTimer.start();
					}	
				}	*/
				pauseGame = false;
			}
		}
		
		// show movement and do movement	
		public function refresh (e:TimerEvent):void {
			//maybe this should use the player timer?
			timeIndex ++;
			if (fire) {
				fireBullet();
			}
			oldX = this.x;
			oldY = this.y;
			/*if (newStartUpTime > 0 && newStartUpTime + warpStartUpTime <= Player.timeIndex) {
				warpOn("warp");
			}*/
			
				if (up) {
					vy = -maxSpeed;
				}else if (down) {
					vy = maxSpeed;
				}else if (up && down) {
					vy = 0;
				}else {
					vy = 0;
				}
				if (right) {
					/*vx += youSpeed;*/
					vx = maxSpeed;
				}else if (left) {
					/*vx -= youSpeed;*/
					vx = -maxSpeed;
				}else if (right && left) {
					vx = 0;
				}else {
					vx = 0;
				}
				this.rotation = vx * 2;
				this.x += vx;
				this.y += vy;
				if (shiftDown) {
					shipSplitter();
				}
				if (shipSplit) {
					leftHalf.x += vx;
					leftHalf.y += vy;
					rightHalf.x += vx;
					rightHalf.y += vy;
					leftHalf.rotation = vx * 1.3;
					rightHalf.rotation = vx * 1.3;
					if(shiftDown){
						leftHalf.x -= splitSpeed;
						rightHalf.x += splitSpeed;
						//trace("ship separating");
					}else {
						leftHalf.x += splitSpeed;
						rightHalf.x -= splitSpeed;
						if (leftHalf.x >= rightHalf.x){
							shipSplitter();
						}
					}
				}
				/*changeX = this.x - oldX;
				changeY = this.y - oldY;
				b1.parallax(changeX,changeY);
				b2.parallax(changeX,changeY);*/
			
			// no running offscreen
			if (this.x < 0 + this.width/2) {
				this.x = 0 + this.width/2;
			}
			//stage weigth = 500 stage.width wasn't working?
			if (this.x > 500 - this.width/2) {
				this.x = 500 - this.width/2;
			}
			if (this.y < 0 + this.height/2) {
				this.y = 0 + this.height/2;
			}
			//same as weigth comment
			if (this.y > 600 - this.height/2) {
				this.y = 600 - this.height/2;
			}
			changeX = this.x - oldX;
			changeY = this.y - oldY;
			b1.parallax(changeX,changeY);
			b2.parallax(changeX,changeY);
			
			//aft cannon consider trying to implement a with statement from page 302
			for (var i:int; i < Baton.batons.length; i ++) {
				var baton = Baton.batons[i];
				if (this.y < baton.y && baton.x + baton.width/2 > this.x && baton.x - baton.width/2 < this.x) {
					fireAftCannon();
				}
			}
			for (var i:int; i < LazerCatAttack.enemyList.length; i++) {
				if (this.y < LazerCatAttack.enemyList[i].y && (LazerCatAttack.enemyList[i].x + 10) > this.x && ((LazerCatAttack.enemyList[i].x - 10) < this.x)) {
					fireAftCannon();
				}
			}
			for (var lv:int = 0; lv < LazerCatAttack.bossVector.length; lv++) {
				if (this.y < LazerCatAttack.bossVector[lv].y && (LazerCatAttack.bossVector[lv].x +10) > this.x && ((LazerCatAttack.bossVector[lv].x -10) < this.x)) {
					fireAftCannon();
				}
			}
			for (var i:int = 0; i < Baton.batons.length; i++) {
				if (this.y < Baton.batons[i].y && (Baton.batons[i].x + Baton.batons[i].width/2) > this.x && (Baton.batons[i].x - Baton.batons[i].width/2) < this.x){
					fireAftCannon();
				}
			}
			//this is a pokeball thing, so you don't necessarily have to hit up at the exact time you
			//hit the pokeball button
			mCounter ++;
			if (mCounter >= pLag) {
				//check this may not work
				/*move.splice(2,(move.length - 2));*/
				//technically there's a slight chance of you not being able to benefit from this 
				//due to inopportune timing, because each individual command is not remembered for
				//1/10 of a second //consider changing this
				move.splice(0,move.length);
				mCounter = 0;
			}
		}	
		
		
		//I'm not sure if this can go on the cat, try later, now is crunch time
		public function addCat() {
			trace("ADD CAT CALLED");
			if (Cat.daCat != null) {
				Cat.daCat.hitPoints = 0;
				Cat.daCat.invincible = false;
				Cat.daCat.testing = false;
				Cat.daCat.destroyYourself();
			}	
			// I'll even make him move to you after he's  off the ship
			var cat = new Cat(this);
			cat.attached = true;
			cat.firstTime = false;
			addChild(cat);
			trace("catting hopping abroad");
		}
		//called by lv2Boss when defeated, this removes the cat from your ship
		public function killCat() {
			Cat.daCat.hitPoints = 0;
			Cat.daCat.destroyYourself();
		}
		public function justHit(e:TimerEvent) {
			//flicker, invincible for one or so seconds
			flicker ++;
			flickerTimer ++;
			if (flicker == 1) {
				this.alpha = .28;
			} else if (flicker == 2) {
				flicker = 0;
				this.alpha = 1;
			}
			if (flickerTimer >= flickerTime * 60) {
				LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, justHit);
				flickerTimer = 0;
				flicker = 0;
				invincible = false;
			}
		}
		private function getAngle(vector:Vector3D):Number {
			return Math.atan2(vector.y, vector.x);
		}
		//fully implement this later to load a frame that is the game start maybe?
		public function killPlayer () {
			if (!invincible) {
				invincible = true;
				var snd:Sound = new PlayerHurt();
				Main.sound.playFX(snd);
				LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, justHit);
				hits++;
				LazerCatAttack.huD.updateHitPoints(1);
				
				if (hits >= hitPoints) {
					//remove lazer?, crusher, and such
					var snd:Sound = new DeathSound();
					//handle shipSplit Case  <------
					Main.sound.playFX(snd);
					LazerCatAttack.gameTimer.stop();
					invincible = false;
					dead = true;
					b1 = null;
					b2 = null;
					pauseGame = true;
					LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, justHit);
					removeEventListener(FocusEvent.FOCUS_OUT, attentionPlease);
					/*removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, preventFocus);*/
					//pass the deathTime to the levelProgressMarker in the most obscure way
					if (LazerCatAttack.game.level1) {
						LazerCatAttack.game.deathTime = LazerCatAttack.timeIndex;
					}else if (LazerCatAttack.level2) {
						LazerCatAttack.game.deathTime = LazerCatAttack.timeIndex - (LazerCatAttack.endLv1);
					}else if (LazerCatAttack.game.level3) {
						LazerCatAttack.game.deathTime = LazerCatAttack.timeIndex - (LazerCatAttack.endLv2);
					}
					Player.playerTimer.stop();
					/*Player.playerTimer.removeEventListener(TimerEvent.TIMER, crusherCooldown);*/
					Player.playerTimer.removeEventListener(TimerEvent.TIMER, refresh);
					fireTimer.stop();
					fireTimer.removeEventListener(TimerEvent.TIMER, fireTimerHandler);
					fireTimer = null;
					//remove fireTimer events
					/*stage.removeEventListener(TimerEvent.TIMER, keyUpHandler);
					stage.removeEventListener(TimerEvent.TIMER, keyDownHandler);*/
					removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
					removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
					stage.focus = null;
					this.tabEnabled = false;
					if (!normalTime) {
						Player.playerTimer.removeEventListener(TimerEvent.TIMER, slowTime);
					}
					if (!canFireL) {
						Player.playerTimer.removeEventListener(TimerEvent.TIMER, lazerCooldownHandler);
					}
					if (ability1 == "warp") {
						Player.playerTimer.removeEventListener(TimerEvent.TIMER, warpCooldownHandler);
					}else if (ability1 == "crusher") {
						Player.playerTimer.removeEventListener(TimerEvent.TIMER, crusherCooldown);
					}	
					//pass ability to game
					LazerCatAttack.game.ability1 = this.ability1;
					LazerCatAttack.game.ability2 = this.ability2;
					if (ball != null) {
						caughtTotal = ball.caughtTotal
						ball.destroyYourself();
						ball = null;
					}
					if (crushMasta != null) {
						crushMasta.remove();
						crushMasta = null;
					}
					if (Cat.daCat != null && Cat.daCat.attached && !dead) {
						Cat.daCat.hitPoints = 0;
						Cat.daCat.destroyYourself();
					}
					// #Hunger
					if (hungerMode) {
						LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, metabolism);
					}
					/*if (ability1 == "crusher") {
						crushMasta.remove();
						crushMasta = null;
					}*/
					//deathScreen
					if (!LazerCatAttack.game.victory){
						var deathScreen = new DeathScreen;
						deathScreen.x = 250;
						deathScreen.y = 300;
						LazerCatAttack.game.addChild(deathScreen);
					}	
					LazerCatAttack.game.removeChild(this);
					LazerCatAttack.you = null;
				}else {
					//nothing
				}
				//if cat is onboard then toss it off
				if (Cat.daCat != null && Cat.daCat.attached && !dead) {
					//get the velocity angle and send it in the opposite direction
					var velocity:Vector3D = new Vector3D(vx,vy,0);
					var angle:Number = getAngle(velocity);
					angle *= 180/Math.PI;
					if (angle > 0 ) {
						angle *= -1;
						angle += 90;
					}else if (angle <= 0) {
						angle *= -1;
						angle += 90;
					}
					Cat.daCat.unattach(angle);
				}
			}else { 
				//nothing//
				deathCount ++;
				/*trace("You've died " + deathCount + " times");*/
			}
		}
		
		public function enableWarp() {
			playerTimer.addEventListener(TimerEvent.TIMER, warpCooldownHandler);
			ability1 = "warp";
		}
		public function warpCooldownHandler (e:TimerEvent) {
			//whenever warp is used call this and it will charge warpEnabled up to 2 and stop
			if (wTimer < warpCooldown * 60) {
				wTimer++;
				/*LazerCatAttack.game.cdHud.updateWarp(this.warpCharge, this.wTimer);*/
			}else if (wTimer == warpCooldown * 60) {
				if (warpCharge == 0) {
					/*LazerCatAttack.game.cdHud.updateWarp(this.warpCharge, this.wTimer);*/
				}else {
					//nothing;
				}
				warpCharge ++;
				LazerCatAttack.game.cdHud.updateWarp(this.warpCharge, this.wTimer);
				wTimer = 0;
				trace("warpCharge = " + warpCharge);
			}
			if (warpCharge == 2) {
				playerTimer.removeEventListener(TimerEvent.TIMER, warpCooldownHandler);
				/*trace("that thing that I assumed would never run, totally ran");*/
			}
		}
		private function warpOn(thing) {
			if (thing === "warp" && (up || down || left || right)) {
				var doubleUp:Boolean;
				/*trace("you have warped");*/
				if (int(up) + int(down) + int(left) + int(right) > 1) {
					maxWarp = maxWarp/2;
					doubleUp = true;
				}
				if (up) {
					this.y -= maxWarp;
				}
				if (down) {
					this.y += maxWarp;
				}
				if (left) {
					this.x -= maxWarp;
				}
				if (right) {
					this.x += maxWarp;
				}
				//if you're not going anywhere don't warp
				/*else {
					warpTick = false;
				}*/
				warpOff();
				if (doubleUp) {
					maxWarp = maxWarp *2;
				}
				timesWarped ++;
				doubleUp = false;
				/*trace(warpCharge);*/
				var snd:Sound = new WarpSound;
				Main.sound.playFX(snd);
			}
			/*else {
				warpTick = true;
				newStartUpTime = Player.timeIndex;
			}	*/
		}
		private function warpOff() {
			maxSpeed = 4;
			youSpeed = .4;
			/*warpTick = false;*/
			/*newStartUpTime = 0;*/
			if (warpCharge == 2) {
				playerTimer.addEventListener(TimerEvent.TIMER, warpCooldownHandler);	
			}	
			warpCharge --;
			LazerCatAttack.game.cdHud.updateWarp(this.warpCharge, this.wTimer);
			if (warpCharge == 0) {
				/*LazerCatAttack.game.cdHud.updateWarp(this.warpCharge, 0);*/
				trace("this warpCharge = " + this.warpCharge);
				trace(this.wTimer);
			}
		}
		private function metabolism(e:TimerEvent) {
			if (eCounter >= tickSpeed) {
				//currentEnergy -= energyUse;
				//hRatio needs to be the hunger ratio not the energy ratio
				hRatio = 1 - (currentEnergy / totalEnergy);
				if (hRatio >= 1) {
					//you have starved
					invincible = false;
					hitPoints = 0;
					killPlayer();
				}	
				LazerCatAttack.game.cdHud.updateHunger(hRatio);
				eCounter = 0;
			}else {
				eCounter ++;
			}
		}
		public function eat() {
			currentEnergy += nutValue;
			LazerCatAttack.game.cdHud.updateHunger(hRatio);
		}
		private function enableHunger() {
			hungerMode = true;
			currentEnergy = totalEnergy;
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, metabolism);
		}	
		private function unlockHB() {
			if (hBCode.length > 1 ) {
				if (hBCode.length == 12 && !pauseGame) {
					pause();
				}
				hBCode.shift();
				trace("hamburglar code being recieved.....");
			}else {
				/*LazerCatAttack.game.hamburglarMode = true;*/
				hBCode.pop();
				hBCode.push(191,191,72,65,77,66,85,82,71,76,65,82);
				LazerCatAttack.game.hamburglar();
				enableHunger();
				trace("burgularing");
			}	
		}
		//currently something about this isn't working
		private function unlockRetro() {
			if (retroCode.length > 1 ) {
				if (retroCode.length == 12 && !pauseGame) {
					pause();
				}
				retroCode.shift();
			}else{
				retroCode.pop();
				retroCode.push(191,191,82,69,84,82,79);
				passive1 = "Nyan Cats";
				LazerCatAttack.game.retro();
			}
		}
	}
}