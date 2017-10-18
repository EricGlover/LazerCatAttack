package  {
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.text.TextField;
	import flash.geom.Vector3D;
	import flash.geom.Point;
	
	public class LazerCatAttack extends MovieClip{
		//use this for the timer event frame rate conversion stuffs
		public static var frameSpeed:int = 60;
		public static var width:int = 500;
		public static var height:int = 600;
		
		public static var enemyList:Array = new Array();
		public static var lazerDroneList:Array = new Array();
		//later have particular game instances transfer their object pools after death / restart
		public var dronePool:Vector.<DroneShip> = new Vector.<DroneShip>;
		public var lazerDPool:Vector.<LazerDrones> = new Vector.<LazerDrones>;
		public var rocketDPool:Vector.<RocketDrone> = new Vector.<RocketDrone>;
		/*public var rocketPool:Vector.<Rocket> = new Vector.<Rocket>;*/
		public static var deathBallerzList:Vector.<DeathBallerz> = new Vector.<DeathBallerz>;
		public static var enemySpawn:Boolean = true;
		public var difficulty:Number = .7;
		//1000 milliseconds / 16 = roughly 60 so it will fire 60 times per second
		public static var gameTimer:Timer = new Timer(16,0);
		public static var you:Player;
		
		public static var huD:hud;
		public static var cdBar;
		public var cdHud:AbilityHUD;
		public static var game:LazerCatAttack;
		public var b1:Background;
		public var b2:Background;
		//backup backgrounds....
		/*public var b3:Background;
		public var b4:Background;*/
		public var checkpoint:Checkpoint;
		
		public var pauseMenu:PauseMenu;
		
		//lv1 Boss stuff
		public static var lv1Boss1:lv1Boss;
		public static var lv1Boss2:lv1Boss;
		public static var lv1Boss3:lv1Boss;
		public static var bossVector = new Vector.<lv1Boss>();
		//set this to 45 seconds later Comment out how level transitions are working sometime, jesus man.
		private var start:int = 0;
		public var level1:Boolean = true;
		public static var level2:Boolean = false;
		public var level3:Boolean = false;
		public var devMode = false;
		//chosen player ability used to set the next game after restart
		public var ability1:String = "none";
		public var ability2:String = "none";
		public var passive1:String = "none";
		public var passive2:String = "none";
		public var q:int = 0;
		public var bossFight:Boolean = false;
		private var level1Events:Vector.<int> = new <int>[4,8,20,35,55,65,74,84];
		//lvl 2 has two parts, a friendly beginning allowing you to explore your abilities(events 1- 10)
		//and a 2nd part that has difficulty spikes followed by easier but still challenging sections (events 11 - 20)
		//in which you must go heal yourself before the next spike
		//once you make it to the boss though you can start over there until you quit the game
		//should you be able to start at the second part (call it checkpoint 1)
		//first part is 60 seconds
		//second part is 120 seconds                     [1,2,3,4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]
		private var level2Events:Vector.<int> = new <int>[1,2,8,18,20,46,60,76,94,114,120,128,140,148,156,168,176,186,198,206,214,234,236, 240];
		private var level3Events:Vector.<int> = new <int>[2,28,54,72,92,112,122];
		public var lv1BossEnter:int = level1Events[level1Events.length - 1];
		public var lv2BossEnter:int = level2Events[level2Events.length - 1];
		public var lv3BossEnter:int = level3Events[level3Events.length - 1];
		//endLv1 sets for the time you beat the boss, implemented in lv2Events
		public static var endLv1:int = 0;
		//lv2 boss sets this
		public static var endLv2:int = 0;
		public static var seenLevel2:Boolean = false;
		
		//lazer guys
		private var lazersOn:Boolean = true;
		private var lazerSpawnCount:int = 0;
		private var lazerDroneMod:Number = 1.0;
		//db spawn //how many seconds until possibly spawned
		private var deathBallerzSpawnRate:int = 2;
		private var randomDB:Boolean = true;
		private var dBMod:Number = 1;
		private var dBSpawnCounter:int = 0;
		private var dBCountMax:int = 4;
		//med bots
		private var healthWave:Boolean = false;
		private var medSpawn:Boolean = false;
		private var randomMedBots:Boolean = true;
		public static var medDroneList:Array = new Array();
		private var medSpawnCounter:int = 0;
		private var rMedBotMod:Number = 0.001;
		private var lastMed:int = 0;
		private var medMax:int = 4;
		private var medInterval:Number = .07;
		
		private var number:Number = 0.00;
		
		private var rockets:Boolean = false;
		private var rocketMod:Number = 1;
		
		private var batons:Boolean = false;
		private var randomBatons:Boolean = false;
		private var rBatonMod:Number = 1.00;
		private var batonAmount:int = 1;
		private var lastBaton:int = 0;
		private var batonInterval:Number = 1.2;
		
		/*private var setupPoint:Point = new Point(200, 200);*/
		private  var sPoint1:Point = new Point(200,200);
		private  var sPoint2:Point = new Point(400,150);
		private var sPoint3:Point = new Point(260,50);
		private var sPoint4:Point = new Point(360,50);
		public var setupPoint:Vector.<Point> = new Vector.<Point>(0,false);
		
			// set pause var to on and if on set to off // stop the main game timer and stop this ship
		public static var timeIndex:int = 0;
		public var showUpgrade:Boolean = false;
		public var showUpgrade2:Boolean = false;
		public var showPassive:Boolean = false;
		public var showPassive2:Boolean = false;
		public var spentCasinoGold:int = 0;
		public var giveThemLazers:Boolean = false;
		public var level1Score:int = 0;
		public var level2Score:int = 0;
		
		public var deathTime:int;
		public var victory:Boolean = false;
		
		//difficulty setting stuffs
		public var mode:String = " ";
		
		//extra's
		public var hamburglarMode:Boolean = false;
		private var burger:Burger = null;
		private var hBMod:int = 1;
		private var hTimerCount:int;
		private var hTimerMax:int = 2 * 60;
		
		
		
		public static var debug:Boolean = false;
		
		/*public var subscribe:TextField;*/
		

		public function LazerCatAttack() {
			//notice the lovely jankness of no complete timers so I added it to this container
			/*you.addEventListener(Event_ADDED.TO.STAGE, huD.setupListener)*/
			LazerCatAttack.huD = new hud;
	/*		LazerCatAttack.cdBar = new CooldownBar1;*/
			cdHud = new AbilityHUD;
			b1 = new Background;
			b1.width = 1000;
			b1.height = 900;
			b1.x = -250;
			b1.y = -300;
			b2 = new Background;
			b2.width = 1000;
			b2.height = 900;
			b2.x = -250;
			b2.y = -1200;
			addChild(b1);
			addChild(b2);
			this.addChild(huD);
			/*cdBar.x = 0;
			cdBar.y = 600;
			this.addChild(cdBar);*/
			cdHud.x = 500;
			cdHud.y = 400 + cdHud.height/2;
			addChild(cdHud);
			you = new Player;
			LazerCatAttack.huD.startUp();
			you.x = 250;
			you.y = 400;
			this.addChild(you);
			you.b1 = b1;
			you.b2 = b2
			trace("level 2 length " + level2Events.length);	
			
			
			//testing
			/*var thing:*;*/
			for (var i:uint = 0; i < 20; i++) {
				dronePool[i] = new DroneShip;
				lazerDPool[i] = new LazerDrones;
				LazerDrones.lazerPool[i] = new LazerDroneLazer;
				rocketDPool[i] = new RocketDrone;
				RocketDrone.rocketPool[i] = new Rocket;
				/*thing = dronePool[i];*/
				/*trace("this " + thing + " is in dronePool at index " + i);*/
			}
			for (var i:uint = 0; i < 50; i ++) {
				DroneShip.bulletPool[i] = new DroneShipBullet;
				/*trace(DroneShip.bulletPool[i]);*/
			}
			setupPoint.push(sPoint1,sPoint2,sPoint3,sPoint3,sPoint4);
			gameTimer.addEventListener(TimerEvent.TIMER,init);
			gameTimer.start();
			//timer for the Subscribe gag	
			/*var gagTimer:Timer = new Timer(300,1);
			gagTimer.addEventListener(TimerEvent.TIMER, gagTimerHandler);
			gagTimer.start();*/
			
			/*addEventListener(KeyboardEvent.KEY_DOWN, tabStart);*/
			//listen for tab to focus the keyboard to the player then start the game
			/*function tabStart (e:KeyboardEvent) {
				if (e.keyCode == 9) {
				removeEventListener(KeyboardEvent.KEY_DOWN, tabStart);
				gameTimer.addEventListener(TimerEvent.TIMER,init);
				gameTimer.start();
				}	
			}*/
		}
		//public function screenUnfocus(e:Event) {
		//	gameTimer.stop();
		//	trace("screen is unfocused");
		//}
		//public function screenFocus(e:Event) {
		//	//nothign for now
		//	trace("screen is focused");
		//}
		public function init(e:TimerEvent):void { 
			//added the start value so I can start whereever I want without adjusting all the game 
			//event timers
			b1.move();
			b2.move();
			if (timeIndex == 0) {
				game = this;
				//update the hud
				if (ability1 == "crusher") {
					cdHud.enableCrusher();
					LazerCatAttack.you.enableCrusher();
				}else if (ability1 == "warp") {
					cdHud.enableWarp();
					LazerCatAttack.you.enableWarp();
				}else if (ability1 == "pokeball") {
					cdHud.enableVoid();
				}
				//restart at boss changes
				if (bossFight && level1) {
					//set q runLevel1(q); 
					q = level1Events.length - 1;
					timeIndex = level1Events[q] * 60;
					runLevel1(q);
					trace("running bossFIght level1 LCA part");
					trace("q == " + q);
					trace("timeIndex = " + timeIndex);
				}else if (bossFight && LazerCatAttack.level2) {
					//set q and give lazer and add cat
					q = level2Events.length - 1;
					timeIndex = level2Events[q] * 60;
					runLevel2(q);
					LazerCatAttack.you.lazerEnabled = true;
					cdHud.enableLazer();
					LazerCatAttack.you.addCat();
				}else if (bossFight && level3) {
					//set q
					q = level3Events.length - 1;
					timeIndex = level3Events[q] * 60;
					runLevel3(q);
				}
				/*stage.addEventListener(Event.ACTIVATE, screenFocus);
				stage.addEventListener(Event.DEACTIVATE, screenUnfocus);	*/
				//change the level event timers?
				if (Main.difSet == 1) {
					mode = "Casual";
					LazerDrones.lazerMinWidth = 20;
					LazerDrones.lazerWidth = 100;
					DroneShip.fireMod = 60;
					DroneShip.fInterval = 2;
					DroneShip.speed = 2.2;
					DroneShipBullet.speed = 3;
					lv3Boss.fireCooldownPreset = 3;
					lv3Boss.presetHitPoints = 15;
					Pokeball.lv2BossStunTime = 2.2;
					Pokeball.lv3BossStunTime = 2.5;
					Baton.presetCloseEnough = 20;
					lv2Boss.painsFired = 4;
					lv2Boss.delay = .65;
				}else if (Main.difSet == 2) {
					mode = "Normal";
					LazerDrones.lazerMinWidth = 120;
					LazerDrones.lazerWidth = 50;
					DroneShip.fireMod = 1;
					DroneShip.fInterval = .7;
					DroneShip.speed = 2.5;
					DroneShipBullet.speed = 4.5;
					lv3Boss.fireCooldownPreset = 1.5;
					lv3Boss.presetHitPoints = 30;
					lv2Boss.painsFired = 6;
					lv2Boss.delay = .5;
					Pokeball.lv2BossStunTime = 1.5;
					Pokeball.lv3BossStunTime = 1.9;
					Baton.presetCloseEnough = 35;
				}else if (Main.difSet == 3) {
					mode = "Hard";
					LazerDrones.lazerMinWidth = 50;
					LazerDrones.lazerWidth = 150;
					DroneShip.fireMod = 1;
					DroneShip.fInterval = .5;
					DroneShip.speed = 3;
					DroneShipBullet.speed = 6;
					lv3Boss.fireCooldownPreset = .7;
					lv3Boss.presetHitPoints = 40;
					Pokeball.lv2BossStunTime = 1.45;
					Pokeball.lv3BossStunTime = 1.4;
					Baton.presetCloseEnough = 55;
					lv2Boss.delay = .49;
					lv2Boss.painsFired = 6;
				}
			/*	LazerDrones.lazerMinWidth = 20;
					LazerDrones.lazerWidth = 100;
					DroneShip.fireMod = 60;
					DroneShip.fInterval = 2;
					DroneShip.speed = 1;
					DroneShipBullet.speed = 1;*/
				for (var d:uint = 0; d < 20; d++) {
					dronePool[d].fireMod = DroneShip.fireMod;
					dronePool[d].fInterval = DroneShip.fInterval;
					dronePool[d].speed = DroneShip.speed;
					dronePool[d].vy = dronePool[d].speed;
					lazerDPool[d].lazerWidth = LazerDrones.lazerWidth;
					lazerDPool[d].lazerMinWidth = LazerDrones.lazerMinWidth;
				}
				for (var s:uint = 0; s < 50; s ++) {
					DroneShip.bulletPool[s].velocity.y = DroneShipBullet.speed;
				}
				LazerCatAttack.game = this;
				LazerCatAttack.timeIndex += start *frameSpeed;
				//pass the selected abilities after restart
				trace("this ability = " + ability1);
				you.ability1 = this.ability1;
				you.ability2 = this.ability2;
				//da fuk is this?
				you.passive1 = this.passive1;
				you.passive2 = this.passive2;
				/*if (ability1 != "none") {
					you.ability1 = ability1;
				}*/
				if (showUpgrade) {
					var upgrade = new UpgradeScreen;
					upgrade.x = 250 - upgrade.width/2;
					upgrade.y = 300 - upgrade.height/2;
					LazerCatAttack.game.addChild(upgrade);
					LazerCatAttack.gameTimer.stop();
				}
				var pops = stage.getChildAt(0);
				if (giveThemLazers || level3) {
					you.lazerEnabled = true;
					cdHud.enableLazer();
				}/*else if (pops.giveThemLazers) {
					you.lazerEnabled = true;
				}*/
				//update score from previous level, I don't think I need the if then statement but oh well
				if (LazerCatAttack.level2) {
					trace("score level1" + level1);
					LazerCatAttack.huD.updateScore(level1Score);
				}else if (level3) {
					LazerCatAttack.huD.updateScore(level2Score);
					trace("score level2 = " + level2);
				}
			}else if (timeIndex == 2) {
				if (showPassive) {
					var passive:Casino = new Casino(0);
					passive.x = 250;
					passive.y = 300;
					addChild(passive);
					//transfer over the gold amounts
					LazerCatAttack.gameTimer.stop();
					//now don't show it again after restart button stuff
					showPassive = false;
				}
			}else if (timeIndex == 3) {
				if (showPassive2) {
					//transfer over the gold amounts
					//since this is the second coming of the casino go and change the casinos active passive list to exclude this active passive
					trace("passive 1 = " + passive1);
					switch (passive1) {
						case "Double Fire":
							var passive:Casino = new Casino(1);
							passive.activePassives.splice(0,1);
							break;
						case "Secret":
							var passive:Casino = new Casino(2);
							passive.activePassives.splice(1,1);
							break;
						case "Slow Time Ability":
							var passive:Casino = new Casino(3);
							passive.activePassives.splice(2,1);
							break;
						case "Hit Points ++":
							var passive:Casino = new Casino(4);
							passive.activePassives.splice(3,1);
							break;
						case "Nyan Cats":
							var passive:Casino = new Casino(5);
							passive.activePassives.splice(4,1);
							break;
						case "Sheep 4 The Win":
							var passive:Casino = new Casino(6);
							passive.activePassives.splice(5,1);
							break;
						default:
							var passive:Casino = new Casino(0);
							trace("couldn't find the correct case @ second passiveScreen");
					}
					//you have to redraw the wheel without the passive that you already own
					passive.draw();
					passive.x = 250;
					passive.y = 300;
					addChild(passive);
					LazerCatAttack.gameTimer.stop();
					showPassive2 = false;
				}
			}else {
				
			}
			timeIndex ++;
			//a spawn counter for every second events rework this....
			//these are doing two things, spawning things randomly and spawning at specific intervals
			//but the interval spawn rate is tied to the random eval. rate; which is horribly writing.
			number = timeIndex/60;
			if (number > (dBSpawnCounter+1) *deathBallerzSpawnRate) {
				spawnDB(randomDB);
				/*dBSpawnCounter ++;*/
				dBSpawnCounter = timeIndex/60;
			}
			//have bosses reset q
			if (level1 && !bossFight) {
				if (timeIndex >= level1Events[q] * 60) {
					runLevel1(q);
					q++;
				}
			}else if (LazerCatAttack.level2 && !bossFight) {
				if (timeIndex >= level2Events[q] * 60 + (LazerCatAttack.endLv1 * 60)) {
					runLevel2(q);
					q++;
				}
			}else if (level3 && !bossFight) {
				if (timeIndex >= level3Events[q] * 60 + (LazerCatAttack.endLv2 * 60)) {
					runLevel3(q);
					q++;
				}
			}
			/*trace("timeIndex = " + timeIndex);
			trace("lazercat.timeIndex = " + LazerCatAttack.timeIndex);*/
			//rewrite this so they spawn at specific time intervals
			//lazerSpawnCount allows you to control how many lazers get
			//added
			if (Math.random() < .008 * lazerDroneMod) {
				if (lazersOn && LazerCatAttack.enemySpawn) {
					for (var i = 0; i < lazerSpawnCount; i++){
						spawnLazerDrones(0,0,130);
					}
				}
			}	
			//spawn batons
			if (batons && randomBatons) {
				//random if mod = 1, then 50% of getting one per second
				if (Math.random() < .5 * rBatonMod / 60) {
					for (var i:int = 0; i < batonAmount; i++) {
						spawnBaton();
					}
				}
			}else if (batons && !randomBatons) {
				//not random
				lastBaton ++;
				if (lastBaton >= batonInterval * 60) {
					for (var i:int = 0; i < batonAmount; i++) {
						spawnBaton();
					}
					lastBaton = 0;
				}
			}
			//spawn med bots :trying to make spawns more random
			if (medSpawn && randomMedBots) {
				//random
				lastMed ++;
				/*if (lastMed >= 30) {*/
					if (Math.random() < .5 * rMedBotMod / 60) {
					trace("spawning random medbot");
					spawnMedBot();
				}
			}else if (medSpawn && !randomMedBots) {
				lastMed ++;
				if (lastMed >= medInterval * 60) {
					spawnMedBot();
					lastMed = 0;
				}
			}
			//change the spawn function for variability sake, later
			if (Math.random() < .002 * rocketMod && LazerCatAttack.enemySpawn && rockets) {
				if (rocketDPool.length > 1) {
					var left:RocketDrone = rocketDPool.shift();
					var right:RocketDrone = rocketDPool.shift();
				}else {
					var right:RocketDrone = new RocketDrone;
					var left:RocketDrone = new RocketDrone;
				}
				right.recycle();
				left.recycle();
				left.left = true;
				left.right = false;
				right.right = true;
				right.left = false;
				LazerCatAttack.enemyList.push(left);
				LazerCatAttack.enemyList.push(right);
				left.x = 0 + left.width/2;
				right.x = 500 - right.width/2;
				left.y = /*-20 - left.height;*/ 10;
				right.y = /*-20 - right.height;*/ 10;
				LazerCatAttack.game.addChild(left);
				LazerCatAttack.game.addChild(right);
			}
			if (Math.random() < (.02*difficulty) && LazerCatAttack.enemySpawn) {
				//bringeth a drone from the pool
				if (dronePool.length > 0) {
					var enemy:DroneShip = dronePool.pop();
				}else {
					var enemy:DroneShip = new DroneShip;
				}

				/*var enemy:DroneShip = new DroneShip;*/
				/*enemy.addEventListener(Event.REMOVED_FROM_STAGE, removeEnemy);*/
				LazerCatAttack.enemyList.push(enemy);
				enemy.recycle();
				if (passive1 == "Nyan Cats" || passive2 == "Nyan Cats") {
					enemy.gotoAndStop(9);
				}
				game.addChild(enemy);
			}
			//spawn hamburgers for the hamburglar mode
			if (hamburglarMode) {
				if (hTimerCount <= 0) {
					if (Math.random() < (hBMod * .5)){
						burger = new Burger;
						LazerCatAttack.game.addChild(burger);
						burger = null;
					}
					hTimerCount = hTimerMax;
				}else{
					hTimerCount --;
				}
			}
			if (healthWave) {
				var medDrone = new MedBot;
				medDrone.speed = 3;
				LazerCatAttack.game.addChild(medDrone);
			}
		}
		//consider rewriting the switch statement to increase speed
		private function runLevel1(daEvent) {
			switch (daEvent + 1) {
				case 1:
					if (Main.difSet == 1) {
						lazersOn = false;
						trace("diff == casual");
					}else if (Main.difSet == 2) {
						lazersOn = false;
						trace("diff == normal");
					}else if (Main.difSet == 3) {
						trace("difficulty == hard");
						lazersOn = false;
					}
					if (Main.sound.currentMusic == "lv1Loop") {
						
					}else {
						Main.sound.lv1Music();
					}
					LazerCatAttack.enemySpawn = true;
					trace("started on lv1");
					break;
				case 2:
					trace("event2");
					//consider messing around with LazerDrones.lazerMinWidth = 60;
					///LazerDrones.lazerWidth = 150;
					if (Main.difSet == 1) {
						lazersOn = true;
						lazerDroneMod = 2;
						lazerSpawnCount = 1;
					}else if (Main.difSet == 2) {
						lazersOn = true;
						lazerDroneMod = 2;
						lazerSpawnCount = 1;
					}else if (Main.difSet == 3) {
						lazersOn = true;
						lazerDroneMod = 2;
						lazerSpawnCount = 1;
					}
					break;
				case 3:
					trace("event3");
					if (Main.difSet == 1) {
						lazersOn = true;
						lazerDroneMod = 1.5;
						lazerSpawnCount = 2;
						difficulty = .7;
					}else if (Main.difSet == 2) {
						lazersOn = true;
						lazerDroneMod = 2.5;
						lazerSpawnCount = 1;
						difficulty = .62;
					}else if (Main.difSet == 3) {
						lazersOn = true;
						lazerDroneMod = 1.5;
						lazerSpawnCount = 3;
						difficulty = 1;
					}
					break;
				case 4:
					trace("event 4");
					if (Main.difSet == 1) {
						lazersOn = false;
						lazerSpawnCount = 2;
						rockets = true;
						rocketMod = 1.2;
						difficulty = .5;
					}else if (Main.difSet == 2) {
						lazersOn = false;
						lazerSpawnCount = 1;
						rockets = true;
						rocketMod = 1.2;
						difficulty = .5;
					}else if (Main.difSet == 3) {
						lazersOn = false;
						lazerSpawnCount = 1;
						rockets = true;
						rocketMod = 1.2;
						difficulty = .5;
					}
					testRocketDrones();
					break;
				case 5:
					trace("event 5");
					if (Main.difSet == 1) {
						lazersOn = true;
						lazerDroneMod = 1.3;
						lazerSpawnCount = 1;
						rockets = true;
						rocketMod = 1;
						difficulty = .65;
					}else if (Main.difSet == 2) {
						lazersOn = true;
						lazerDroneMod = 2;
						lazerSpawnCount = 1;
						rockets = true;
						rocketMod = 1;
						difficulty = .6;
					}else if (Main.difSet == 3) {
						lazersOn = false;
						lazerDroneMod = 1.3;
						lazerSpawnCount = 2;
						rockets = true;
						rocketMod = 1;
						difficulty = .65;
					}
					break;
				case 6:
					if (Main.difSet == 1) {
						lazersOn = true;
						lazerDroneMod = 1.3;
						lazerSpawnCount = 2;
						rockets = true;
						rocketMod = 1;
						difficulty = .69;
					}else if (Main.difSet == 2) {
						lazersOn = true;
						lazerDroneMod = 2;
						lazerSpawnCount = 2;
						rockets = true;
						rocketMod = 1;
						difficulty = .69;
					}else if (Main.difSet == 3) {
						lazersOn = true;
						lazerDroneMod = 3;
						lazerSpawnCount = 2;
						rockets = true;
						rocketMod = 1.2;
						difficulty = .98;
					}
					trace("event 6");
					break;
				case 7:
					trace("clearStage plz");
					LazerCatAttack.enemySpawn = false;
					Main.sound.lv1BossMusic();
					//display checkpoint reached graphic
					checkpoint = new Checkpoint;
					checkpoint.x = 250 - checkpoint.width/2;
					checkpoint.y = 300;
					addChild(checkpoint);
					break;
				case 8:
					trace("boss time");
					lv1Boss1 = new lv1Boss("lv1Boss1");
					//edited //tempermental changed lv1Boss y's from -10 to -40
					lv1Boss1.y = -40;
					lv1Boss1.x = 0;
					lv1Boss2 = new lv1Boss("lv1Boss2");
					lv1Boss2.y = -40;
					lv1Boss2.x = 100;
					lv1Boss3 = new lv1Boss("lv1Boss3");
					lv1Boss3.y = -40;
					lv1Boss3.x = 200;
					game.addChild(lv1Boss1);
					game.addChild(lv1Boss2);
					game.addChild(lv1Boss3);
					LazerCatAttack.enemySpawn = false;
					LazerCatAttack.bossVector.push(lv1Boss1,lv1Boss2,lv1Boss3);
					bossFight = true;
					//flash a boss graphic warning, graphics
					break;
				default:
					//nothing
			}
		}
		//or this way with runlevel called by the loop with an index thing and stuff, and just base it
		//off of the timeIndex
		private function runLevel2(daEvent) {
			switch (daEvent + 1) {
				case 1:
					//show Passive stuff
					if (showPassive) {
						var passive:Casino = new Casino(0);
						passive.x = 250;
						passive.y = 300;
						addChild(passive);
						//transfer over the gold amounts
						LazerCatAttack.gameTimer.stop();
						//now don't show it again after restart button stuff
						showPassive = false;
					}						
					//in case you start on level 2
					if (Main.sound.currentMusic == "lv2Loop") {
						
					}else {
						Main.sound.lv2Music();
					}
					level1Score = LazerCatAttack.huD.newScore;
					trace("set level1Score to = " + level1Score);
					trace("level2 event 1");
					break;
				case 2:
					trace("event 2");
					lazerSpawnCount = 0;
					LazerCatAttack.enemySpawn = false;
					difficulty = .6;
					var drone:DroneShip;
					for (var i:int = 0; i < 6; i++) {
						drone = new DroneShip;
						if (passive1 == "Nyan Cats" || passive2 == "Nyan Cats") {
							drone.gotoAndStop(9);
						}
						drone.x = 20 + i*10;
						drone.y = -40 + -1*(i*15);
						LazerCatAttack.game.addChild(drone);
						/*drone.addEventListener(Event.REMOVED_FROM_STAGE, removeEnemy);*/
						LazerCatAttack.enemyList.push(drone);
					}
					spawnLazerDrones(250, -10, 250);
					spawnLazerDrones(500, -10, 250);
					spawnLazerDrones(200, -30, 250);
					spawnLazerDrones(500, -60, 250);
				/*	spawnLazerDrones(200, -60, 130);
					spawnLazerDrones(500, -60, 130);
					spawnLazerDrones(300, -100, 130);
					spawnLazerDrones(430, -100, 130);*/
					var initialVelocity = new Vector3D(0,0,0);
					var testBaller = new DeathBallerz(initialVelocity, 4, setupPoint.shift());
					testBaller.x = 20;
					testBaller.y = -100;
					LazerCatAttack.deathBallerzList.push(testBaller);
					LazerCatAttack.enemyList.push(testBaller);
					game.addChild(testBaller);
					break;
				case 3:
					LazerCatAttack.enemySpawn = true;
					difficulty = .65;
					lazerSpawnCount = 1;
					lazerDroneMod = 2;
					rockets = true;
					rocketMod = .5;
					trace("event 3 occured");
					break;
				case 4:
					//introduce the player to the med bots
					LazerCatAttack.enemySpawn = false;
					healthWave = true;
					medSpawn = true;
					randomMedBots = false;
					dBCountMax = 4;
					medInterval = 7;
					trace("event 4 has occured");
					break;
				case 5:
					difficulty = .6;
					lazerSpawnCount = 0;
					healthWave = false;
					medSpawn = true;
					dBCountMax = 3;
					randomMedBots = true;
					rMedBotMod = .07;
					LazerCatAttack.enemySpawn = true;
					trace("release the cat!");
					var newPoint:Point = new Point(350, 500);
					var datKitty = new Cat(newPoint);
					datKitty.x = -50;
					datKitty.y = 500;
					if (LazerCatAttack.seenLevel2) {
						datKitty.screenTime = 2;
					}
					LazerCatAttack.game.addChild(datKitty);
					trace("event 5 has occured");
					break;
				case 6:
					//fix random med bots
					if (Main.difSet == 1) {
						difficulty = .65;
						lazerSpawnCount = 1;
						lazerDroneMod = 2;
						randomDB = false;
						dBCountMax = 4;
						deathBallerzSpawnRate = 2;
						randomMedBots = false;
						medSpawn = true;
						medInterval = 7.5;
					}else if (Main.difSet == 2) {
						difficulty = 1;
						lazerSpawnCount = 1;
						lazerDroneMod = 2;
						randomDB = false;
						dBCountMax = 4;
						deathBallerzSpawnRate = 3.5;
						randomMedBots = false;
						medSpawn = false;
						medInterval = 8;
					}else if (Main.difSet == 3) {
						difficulty = .87;
						lazerSpawnCount = 1;
						lazerDroneMod = 3;
						randomDB = false;
						dBCountMax = 4;
						deathBallerzSpawnRate = 3.5;
						randomMedBots = false;
						medSpawn = false;
						medInterval = 5;
					}
					trace("event 6 has occured");
					break;
				case 7:
					//code, I should probably have an event here....
					if (Main.difSet == 1) {
						difficulty = .87;
						lazerSpawnCount = 1;
						lazerDroneMod = 3;
						randomDB = false;
						dBCountMax = 4;
						deathBallerzSpawnRate = 3.5;
						randomMedBots = false;
						medSpawn = false;
						medInterval = 5;
						
					}else if (Main.difSet == 2) {
						difficulty = .87;
						lazerSpawnCount = 1;
						lazerDroneMod = 3;
						randomDB = false;
						dBCountMax = 4;
						deathBallerzSpawnRate = 3.5;
						randomMedBots = false;
						medSpawn = false;
						medInterval = 5;
						
					}else if (Main.difSet == 3) {
						difficulty = .7;
						lazerSpawnCount = 1;
						lazerDroneMod = 2.2;
						randomDB = true;
						dBMod = 5;
						dBCountMax = 4;
						deathBallerzSpawnRate = 4;
						randomMedBots = false;
						medSpawn = false;
						medInterval = 5;
						
					}
					trace("event 7 has occured");
					break;
				case 8:
					//code
					if (Main.difSet == 1) {
						difficulty = .62;
						lazerSpawnCount = 2;
						lazerDroneMod = 1.2;
						randomDB = true;
						dBMod = 5;
						dBCountMax = 2;
						deathBallerzSpawnRate = 2;
						randomMedBots = false;
						medSpawn = false;
						medInterval = 5;
						
					}else if (Main.difSet == 2) {
						difficulty = .62;
						lazerSpawnCount = 2;
						lazerDroneMod = 1.2;
						randomDB = true;
						dBMod = 5;
						dBCountMax = 3;
						deathBallerzSpawnRate = 2;
						randomMedBots = false;
						medSpawn = false;
						medInterval = 5;
						
					}else if (Main.difSet == 3) {
						difficulty = .82;
						lazerSpawnCount = 2;
						lazerDroneMod = 1.5;
						randomDB = true;
						dBMod = 5;
						dBCountMax = 3;
						deathBallerzSpawnRate = 2;
						randomMedBots = false;
						medSpawn = false;
						medInterval = 5;
					}
					trace("event 8");
					break;
				case 9:
					if (Main.difSet == 1) {
						difficulty = .52;
						lazerSpawnCount = 2;
						lazerDroneMod = 1.5;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 3;
						deathBallerzSpawnRate = 2;
						randomMedBots = false;
						medSpawn = false;
						medInterval = 5;
						
					}else if (Main.difSet == 2) {
						difficulty = .62;
						lazerSpawnCount = 2;
						lazerDroneMod = 1.5;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 3;
						deathBallerzSpawnRate = 2;
						randomMedBots = false;
						medSpawn = false;
						medInterval = 5;
						
					}else if (Main.difSet == 3) {
						difficulty = .82;
						lazerSpawnCount = 3;
						lazerDroneMod = 1.5;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 3;
						deathBallerzSpawnRate = 4;
						randomMedBots = false;
						medSpawn = false;
						medInterval = 5;
					}
					trace("event 9");
					break;
				case 10:
					if (Main.difSet == 1) {
						difficulty = .4;
						lazerSpawnCount = 1;
						lazerDroneMod = 1;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 2;
						deathBallerzSpawnRate = 1;
						randomMedBots = false;
						medSpawn = true;
						medInterval = 4;
						
					}else if (Main.difSet == 2) {
						difficulty = .45;
						lazerSpawnCount = 1;
						lazerDroneMod = 1.5;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 2;
						deathBallerzSpawnRate = 1;
						randomMedBots = false;
						medSpawn = true;
						medInterval = 4;
					}else if (Main.difSet == 3) {
						difficulty = .6;
						lazerSpawnCount = 2;
						lazerDroneMod = 1.5;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 2;
						deathBallerzSpawnRate = 1;
						randomMedBots = false;
						medSpawn = true;
						medInterval = 4;
					}
					trace("event 10 (really 9 )");
					break;
				case 11:
					if (Main.difSet == 1) {
						difficulty = .52;
						lazerSpawnCount = 1;
						lazerDroneMod = 2;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 3;
						deathBallerzSpawnRate = 1;
						randomMedBots = false;
						medSpawn = false;
						medInterval = 6;
					}else if (Main.difSet == 2) {
						difficulty = .62;
						lazerSpawnCount = 1;
						lazerDroneMod = 2;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 3;
						deathBallerzSpawnRate = 1;
						randomMedBots = false;
						medSpawn = false;
						medInterval = 6;
					}else if (Main.difSet == 3) {
						difficulty = .78;
						lazerSpawnCount = 1;
						lazerDroneMod = 2;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 3;
						deathBallerzSpawnRate = 1;
						randomMedBots = false;
						medSpawn = false;
						medInterval = 6;
					}
					trace("event 11");
					break;
				case 12:
					if (Main.difSet == 1) {
						difficulty = .62;
						lazerSpawnCount = 1;
						lazerDroneMod = 2;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 3;
						deathBallerzSpawnRate = 1;
						randomMedBots = false;
						medSpawn = false;
						medInterval = 6;
					}else if (Main.difSet == 2) {
						difficulty = .72;
						lazerSpawnCount = 1;
						lazerDroneMod = 2;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 3;
						deathBallerzSpawnRate = 1;
						randomMedBots = false;
						medSpawn = false;
						medInterval = 6;
					}else if (Main.difSet == 3) {
						difficulty = .89;
						lazerSpawnCount = 1;
						lazerDroneMod = 2;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 4;
						deathBallerzSpawnRate = 1;
						randomMedBots = false;
						medSpawn = false;
						medInterval = 6;
					}
					trace("event 12");
					break;
				case 13:
					if (Main.difSet == 1) {
						difficulty = .45;
						lazerSpawnCount = 2;
						lazerDroneMod = 1;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 2;
						deathBallerzSpawnRate = 1;
						randomMedBots = false;
						medSpawn = true;
						medInterval = 3;
					}else if (Main.difSet == 2) {
						difficulty = .5;
						lazerSpawnCount = 2;
						lazerDroneMod = 1;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 2;
						deathBallerzSpawnRate = 1;
						randomMedBots = false;
						medSpawn = true;
						medInterval = 3.6;
					}else if (Main.difSet == 3) {
						difficulty = .6;
						lazerSpawnCount = 3;
						lazerDroneMod = 1;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 2;
						deathBallerzSpawnRate = 1;
						randomMedBots = false;
						medSpawn = true;
						medInterval = 4;
					}
					trace("event 13");
					break;
				case 14:
					if (Main.difSet == 1) {
						difficulty = .48;
						lazerSpawnCount = 1;
						lazerDroneMod = 2;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 3;
						deathBallerzSpawnRate = 2;
						randomMedBots = false;
						medSpawn = false;
						medInterval = 6;
						
					}else if (Main.difSet == 2) {
						difficulty = .58;
						lazerSpawnCount = 1;
						lazerDroneMod = 2;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 3;
						deathBallerzSpawnRate = 2;
						randomMedBots = false;
						medSpawn = false;
						medInterval = 6;
					}else if (Main.difSet == 3) {
						difficulty = .78;
						lazerSpawnCount = 1;
						lazerDroneMod = 2;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 3;
						deathBallerzSpawnRate = 1;
						randomMedBots = false;
						medSpawn = false;
						medInterval = 6;
					}
					trace("event 14");
					break;
				case 15:
					if (Main.difSet == 1) {
						difficulty = .52;
						lazerSpawnCount = 1;
						lazerDroneMod = 2;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 4;
						deathBallerzSpawnRate = 1;
						randomMedBots = false;
						medSpawn = true;
						medInterval = 4;
					}else if (Main.difSet == 2) {
						difficulty = .68;
						lazerSpawnCount = 1;
						lazerDroneMod = 2;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 4;
						deathBallerzSpawnRate = 1;
						randomMedBots = false;
						medSpawn = true;
						medInterval = 5;
						
					}else if (Main.difSet == 3) {
						difficulty = .89;
						lazerSpawnCount = 1;
						lazerDroneMod = 2;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 4;
						deathBallerzSpawnRate = 1;
						randomMedBots = false;
						medSpawn = false;
						medInterval = 6;
					}
					trace("event 15");
					break;
				case 16:
					if (Main.difSet == 1) {
						difficulty = .4;
						lazerSpawnCount = 2;
						lazerDroneMod = 1;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 2;
						deathBallerzSpawnRate = 1;
						randomMedBots = false;
						medSpawn = true;
						medInterval = 3;
					}else if (Main.difSet == 2) {
						difficulty = .5;
						lazerSpawnCount = 2;
						lazerDroneMod = 1;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 2;
						deathBallerzSpawnRate = 1;
						randomMedBots = false;
						medSpawn = true;
						medInterval = 4;
					}else if (Main.difSet == 3) {
						difficulty = .6;
						lazerSpawnCount = 3;
						lazerDroneMod = 1;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 2;
						deathBallerzSpawnRate = 1;
						randomMedBots = false;
						medSpawn = true;
						medInterval = 4;
					}
					trace("event 16");
					break;
				case 17:
					if (Main.difSet == 1) {
						difficulty = .58;
						lazerSpawnCount = 1;
						lazerDroneMod = 2;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 3;
						deathBallerzSpawnRate = 2;
						randomMedBots = false;
						medSpawn = true;
						medInterval = 5;
					}else if (Main.difSet == 2) {
						difficulty = .58;
						lazerSpawnCount = 1;
						lazerDroneMod = 2;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 3;
						deathBallerzSpawnRate = 2;
						randomMedBots = false;
						medSpawn = false;
						medInterval = 6;
					}else if (Main.difSet == 3) {
						difficulty = .78;
						lazerSpawnCount = 1;
						lazerDroneMod = 2;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 3;
						deathBallerzSpawnRate = 1;
						randomMedBots = false;
						medSpawn = false;
						medInterval = 6;
					}
					trace("event 17");
					break;
				case 18:
					if (Main.difSet == 1) {
						difficulty = .72;
						lazerSpawnCount = 1;
						lazerDroneMod = 2;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 4;
						deathBallerzSpawnRate = 2;
						randomMedBots = false;
						medSpawn = true;
						medInterval = 6;
					}else if (Main.difSet == 2) {
						difficulty = .82;
						lazerSpawnCount = 1;
						lazerDroneMod = 2;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 4;
						deathBallerzSpawnRate = 2;
						randomMedBots = false;
						medSpawn = false;
						medInterval = 6;
					}else if (Main.difSet == 3) {
						difficulty = .92;
						lazerSpawnCount = 1;
						lazerDroneMod = 2;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 4;
						deathBallerzSpawnRate = 1;
						randomMedBots = false;
						medSpawn = false;
						medInterval = 6;
					}
					trace("event 18");
					break;
				case 19:
					if (Main.difSet == 1) {
						difficulty = .4;
						lazerSpawnCount = 3;
						lazerDroneMod = 1;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 2;
						deathBallerzSpawnRate = 1;
						randomMedBots = false;
						medSpawn = true;
						medInterval = 4;
					}else if (Main.difSet == 2) {
						difficulty = .5;
						lazerSpawnCount = 3;
						lazerDroneMod = 1;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 2;
						deathBallerzSpawnRate = 1;
						randomMedBots = false;
						medSpawn = true;
						medInterval = 4;
					}else if (Main.difSet == 3) {
						difficulty = .6;
						lazerSpawnCount = 3;
						lazerDroneMod = 1;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 2;
						deathBallerzSpawnRate = 1;
						randomMedBots = false;
						medSpawn = true;
						medInterval = 4;
					}
					trace("event 19");
					break;
				case 20:
					if (Main.difSet == 1) {
						difficulty = .58;
						lazerSpawnCount = 1;
						lazerDroneMod = 2;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 3;
						deathBallerzSpawnRate = 2;
						randomMedBots = false;
						medSpawn = false;
						medInterval = 6;
					}else if (Main.difSet == 2) {
						difficulty = .68;
						lazerSpawnCount = 1;
						lazerDroneMod = 2;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 3;
						deathBallerzSpawnRate = 2;
						randomMedBots = false;
						medSpawn = false;
						medInterval = 6;
					}else if (Main.difSet == 3) {
						difficulty = .78;
						lazerSpawnCount = 1;
						lazerDroneMod = 2;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 3;
						deathBallerzSpawnRate = 1;
						randomMedBots = false;
						medSpawn = false;
						medInterval = 6;
					}
					trace("event 20");
					break;
				case 21:
					if (Main.difSet == 1) {
						difficulty = .62;
						lazerSpawnCount = 2;
						lazerDroneMod = 2;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 5;
						deathBallerzSpawnRate = 2;
						randomMedBots = false;
						medSpawn = false;
						medInterval = 6;
					}else if (Main.difSet == 2) {
						difficulty = .72;
						lazerSpawnCount = 2;
						lazerDroneMod = 2;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 5;
						deathBallerzSpawnRate = 1;
						randomMedBots = false;
						medSpawn = false;
						medInterval = 6;
					}else if (Main.difSet == 3) {
						difficulty = .82;
						lazerSpawnCount = 2.4;
						lazerDroneMod = 2;
						randomDB = false;
						dBMod = 5;
						dBCountMax = 5;
						deathBallerzSpawnRate = 1;
						randomMedBots = false;
						medSpawn = false;
						medInterval = 6;
					}
					trace("event 21");
					break;
				case 22:
					//leave screen event
					//same for all difficulty settings
					dBCountMax = 0;
					scatterTheMeak();
					LazerCatAttack.enemySpawn = false;
					randomDB = false;
					healthWave = true;
					deathBallerzSpawnRate = 3.5;
					randomMedBots = true;
					rMedBotMod = .07;
					medSpawn = true;
					medInterval = 4;
					difficulty = .01;
					lazerSpawnCount = 1;
					/*Main.sound.lv2BossMusic();*/
					trace("event 22 has occured");
					break;
				case 23:
					//here wait a second for the healthwave to finish
					healthWave = false;
					Main.sound.lv2BossMusic();
					//display checkpoint reached graphic
					checkpoint = new Checkpoint;
					checkpoint.x = 250 - checkpoint.width/2;
					checkpoint.y = 300;
					addChild(checkpoint);
					trace("event 23 has occured");
					break;
				case 24:
					//have all onscreen enemies leave
					LazerCatAttack.enemySpawn = false;
					healthWave = false;
					randomDB = false;
					deathBallerzSpawnRate = 3.5;
					randomMedBots = true;
					rMedBotMod = .07;
					medSpawn = true;
					medInterval = 4;
					difficulty += .3;
					lazerSpawnCount = 1;
					var boss2 = new lv2Boss();
					LazerCatAttack.enemyList.push(boss2);
					this.addChild(boss2);
					bossFight = true;
					trace("Boss fight has occured");
					break;	
				default:
					//nothing
			}
		}
		private function runLevel3(daEvent) {
			switch (daEvent + 1) {
				case 1:
					trace("level 3");
					if (showPassive2) {
						//transfer over the gold amounts
						//since this is the second coming of the casino go and change the casinos active passive list to exclude this active passive
						trace("passive 1 = " + passive1);
						switch (passive1) {
							case "Double Fire":
								var passive:Casino = new Casino(1);
								passive.activePassives.splice(0,1);
								break;
							case "Secret":
								var passive:Casino = new Casino(2);
								passive.activePassives.splice(1,1);
								break;
							case "Slow Time Ability":
								var passive:Casino = new Casino(3);
								passive.activePassives.splice(2,1);
								break;
							case "Hit Points ++":
								var passive:Casino = new Casino(4);
								passive.activePassives.splice(3,1);
								break;
							case "Nyan Cats":
								var passive:Casino = new Casino(5);
								passive.activePassives.splice(4,1);
								break;
							case "Sheep 4 The Win":
								var passive:Casino = new Casino(6);
								passive.activePassives.splice(5,1);
								break;
							default:
								var passive:Casino = new Casino(0);
								trace("couldn't find the correct case @ second passiveScreen");
						}
						//you have to redraw the wheel without the passive that you already own
						passive.draw();
						passive.x = 250;
						passive.y = 300;
						addChild(passive);
						LazerCatAttack.gameTimer.stop();
						showPassive2 = false;
					}	
					if (Main.sound.currentMusic == "lv3Loop") {
						
					}else {
						Main.sound.lv3Music();
					}
					level2Score = LazerCatAttack.huD.newScore;
					trace("set level2Score to = " + level2Score);
					if (Main.difSet == 1) {
						randomDB = false;
						deathBallerzSpawnRate = 3;
						randomMedBots = true;
						medSpawn = true;
						medInterval = .2;
						rMedBotMod = .08;
						dBMod = 2;
						dBCountMax = 3;
						difficulty = .5;
						lazerSpawnCount = 1;
						lazerDroneMod = 1;
						rockets = true;
						batons = true;
						randomBatons = true;
						batonInterval = 1.2;
						rBatonMod = .09;
						batonAmount = 1;
						lazerDroneMod = 2;
					}else if (Main.difSet == 2) {
						randomDB = false;
						deathBallerzSpawnRate = 3;
						dBMod = 3;
						dBCountMax = 3;
						randomMedBots = true;
						medSpawn = true;
						medInterval = .2;
						rMedBotMod = .08;
						difficulty = .5;
						lazerSpawnCount = 1;
						lazerDroneMod = 2;
						rockets = true;
						batons = true;
						randomBatons = true;
						batonInterval = 1.2;
						rBatonMod = .09;
						batonAmount = 1;
					}else if (Main.difSet == 3) {
						randomDB = false;
						deathBallerzSpawnRate = 3;
						dBMod = 5;
						dBCountMax = 5;
						randomMedBots = true;
						medSpawn = true;
						medInterval = .2;
						rMedBotMod = .08;
						difficulty = .5;
						lazerSpawnCount = 1;
						lazerDroneMod = 2;
						rockets = true;
						batons = true;
						randomBatons = true;
						batonInterval = 1.2;
						rBatonMod = .09;
						batonAmount = 1;
					}
					LazerCatAttack.enemySpawn = true;
					spawnBaton();
					break;
				case 2:
					trace("lv3 Event 2");
					if (Main.difSet == 1) {
						LazerCatAttack.enemySpawn = true;
						randomDB = true;
						deathBallerzSpawnRate = 3.3;
						dBMod = 2;
						dBCountMax = 2;
						randomMedBots = true;
						medSpawn = true;
						medInterval = 1.7;
						rMedBotMod = .08;
						difficulty = .5;
						lazerSpawnCount = 1;
						lazerDroneMod = 2;
						rockets = true;
						batons = true;
						randomBatons = false;
						batonInterval = 9.6;
						rBatonMod = .09;
						batonAmount = 1;
					}else if (Main.difSet == 2) {
						LazerCatAttack.enemySpawn = true;
						randomDB = true;
						deathBallerzSpawnRate = 3.3;
						dBMod = 3;
						dBCountMax = 3;
						randomMedBots = true;
						medSpawn = true;
						medInterval = 1.7;
						rMedBotMod = .08;
						difficulty = .5;
						lazerSpawnCount = 1;
						lazerDroneMod = 2;
						rockets = true;
						batons = true;
						randomBatons = true;
						batonInterval = 1.2;
						rBatonMod = .09;
						batonAmount = 1;
					}else if (Main.difSet == 3) {
						LazerCatAttack.enemySpawn = true;
						randomDB = true;
						deathBallerzSpawnRate = 3.3;
						dBMod = 5;
						dBCountMax = 5;
						randomMedBots = true;
						medSpawn = true;
						medInterval = 1.7;
						rMedBotMod = .08;
						difficulty = .5;
						lazerSpawnCount = 1;
						lazerDroneMod = 2;
						rockets = true;
						batons = true;
						randomBatons = true;
						batonInterval = 1.2;
						rBatonMod = .09;
						batonAmount = 1;
					}
					break;
				case 3:
					trace("lv3 event 3");
					if (Main.difSet == 1) {
						LazerCatAttack.enemySpawn = true;
						randomDB = true;
						deathBallerzSpawnRate = 3.8;
						dBMod = 2;
						dBCountMax = 3;
						randomMedBots = true;
						medInterval = .01;
						medSpawn = true;
						difficulty = .7;
						lazerSpawnCount = 1;
						lazerDroneMod = 4;
						rockets = true;
						rocketMod = 1.2;
						batons = true;
						randomBatons = false;
						batonInterval = 8.0;
						rBatonMod = .09;
						batonAmount = 1;
					}else if (Main.difSet == 2) {
						LazerCatAttack.enemySpawn = true;
						randomDB = true;
						deathBallerzSpawnRate = 3.8;
						dBMod = 3;
						dBCountMax = 3;
						randomMedBots = true;
						medInterval = .01;
						medSpawn = true;
						difficulty = .9;
						lazerSpawnCount = 1;
						lazerDroneMod = 4;
						rockets = true;
						rocketMod = 1.2;
						batons = true;
						randomBatons = false;
						batonInterval = 12;
						rBatonMod = .09;
						batonAmount = 2;
					}else if (Main.difSet == 3) {
						LazerCatAttack.enemySpawn = true;
						randomDB = true;
						deathBallerzSpawnRate = 3.8;
						dBMod = 5;
						dBCountMax = 5;
						randomMedBots = true;
						medInterval = .01;
						medSpawn = true;
						difficulty = 1.2;
						lazerSpawnCount = 1;
						lazerDroneMod = 4;
						rockets = true;
						rocketMod = 1.2;
						batons = true;
						randomBatons = true;
						batonInterval = 1.2;
						rBatonMod = .17;
						batonAmount = 1;
					}
					break;
				case 4:
					trace("lv3 event 4");
					if (Main.difSet == 1) {
						LazerCatAttack.enemySpawn = true;
						randomDB = false;
						deathBallerzSpawnRate = 3.2;
						randomMedBots = true;
						medInterval = .07;
						rMedBotMod = .07;
						medSpawn = true;
						difficulty = .87;
						lazerDroneMod = 1.4;
						lazerSpawnCount = 2;
						rockets = true;
						rocketMod = 1;
						batons = true;
						randomBatons = true;
						batonInterval = 1.2;
						rBatonMod = .1;
						batonAmount = 1;
					}else if (Main.difSet == 2) {
						LazerCatAttack.enemySpawn = true;
						randomDB = false;
						deathBallerzSpawnRate = 3.2;
						randomMedBots = true;
						medInterval = .07;
						rMedBotMod = .07;
						medSpawn = true;
						difficulty = 1;
						lazerDroneMod = 1;
						lazerSpawnCount = 2;
						rockets = true;
						rocketMod = 1.2;
						batons = true;
						randomBatons = true;
						batonInterval = 1.2;
						rBatonMod = .14;
						batonAmount = 1;
					}else if (Main.difSet == 3) {
						LazerCatAttack.enemySpawn = true;
						randomDB = false;
						deathBallerzSpawnRate = 3.2;
						randomMedBots = true;
						medInterval = .07;
						rMedBotMod = .07;
						medSpawn = true;
						difficulty = 1.5;
						lazerDroneMod = 1.7;
						lazerSpawnCount = 3;
						rockets = true;
						rocketMod = 1;
						batons = true;
						randomBatons = true;
						batonInterval = 1.2;
						rBatonMod = .17;
						batonAmount = 2;
					}
					
					break;
				case 5:
					trace("lv3 event 5");
					if (Main.difSet == 1) {
						LazerCatAttack.enemySpawn = true;
						randomDB = false;
						//no DB's
						deathBallerzSpawnRate = 1000;
						difficulty = .9;
						rockets = true;
						rocketMod = .79;
						batons = true;
						randomBatons = true;
						batonInterval = 1.4;
						rBatonMod = .09;
						batonAmount = 1;
						lazerDroneMod = 2;
						lazerSpawnCount = 1;
					}else if (Main.difSet == 2) {
						LazerCatAttack.enemySpawn = true;
						randomDB = false;
						//no DB's
						deathBallerzSpawnRate = 1000;
						difficulty = 1.1;
						rockets = true;
						rocketMod = 1.1;
						batons = true;
						randomBatons = true;
						batonInterval = 1.4;
						rBatonMod = .12;
						batonAmount = 1;
						lazerDroneMod = 3;
						lazerSpawnCount = 2;
					}else if (Main.difSet == 3) {
						LazerCatAttack.enemySpawn = true;
						randomDB = false;
						//no DB's
						deathBallerzSpawnRate = 1000;
						difficulty = 1.5;
						rockets = true;
						rocketMod = 1.1;
						batons = true;
						randomBatons = true;
						batonInterval = 1.4;
						rBatonMod = .15;
						batonAmount = 1;
						lazerDroneMod = 4;
						lazerSpawnCount = 2;
					}
					
					break;
				case 6:
					//tell everyone on screen to fuck off
					LazerCatAttack.enemySpawn = false;
					randomDB = false;
					//no DB's
					scatterTheMeak();
					deathBallerzSpawnRate = 1000;
					difficulty = 0.000001;
					rockets = false;
					rocketMod = 1.1;
					batons = false;
					randomBatons = true;
					batonInterval = 1.4;
					rBatonMod = .09;
					batonAmount = 1;
					Main.sound.lv3BossMusic();
					checkpoint = new Checkpoint;
					checkpoint.x = 250 - checkpoint.width/2;
					checkpoint.y = 300;
					addChild(checkpoint);
					break;
				case 7:
					trace("GLITCH BOSS");
					//have all onscreen enemies leave
					LazerCatAttack.enemySpawn = false;
					randomDB = false;
					deathBallerzSpawnRate = 3.5;
					randomMedBots = false;
					medSpawn = true;
					rMedBotMod = .07;
					medInterval = 4;
					difficulty += .3;
					lazerSpawnCount = 1;
					var boss2 = new lv3Boss(LazerCatAttack.you);
					LazerCatAttack.enemyList.push(boss2);
					this.addChild(boss2);
					bossFight = true;
					break;
				default:
					
			}			
		}
		
		//all these spawning functions are running every frame, that just seems silly
		//for LCAII mayhaps having a class to handle the spawns would be better
		// Spawner class set to one second time interval
		private function spawnLazerDrones (x,y,lazerwidth) {
			if (lazerDPool.length > 0) {
				var asshole:LazerDrones = lazerDPool.pop();
			}else {
				var asshole:LazerDrones = new LazerDrones;
			}
			asshole.y = 0;
			asshole.recycle();
			/*asshole.lazerWidth = lazerwidth;*/
			LazerCatAttack.lazerDroneList.push(asshole);
			LazerCatAttack.game.addChild(asshole);
			//this allows me to specify coordinates or not
			if (x != 0 && y != 0) {
				asshole.x = x;
				asshole.y = y;
			}
		}
		private function spawnBaton() {
			var baton = new Baton();
			//keep x on screen with width// edit later// tweak
			baton.x = Math.random() * 400 + 50;
			baton.y = 0 - 10 - baton.height;
			Baton.batons.push(baton);
			LazerCatAttack.game.addChild(baton);
			/*LazerCatAttack.enemyList.push(baton);*/
		}
		private function testRocketDrones() {
			if (rocketDPool.length > 1) {
				var left:RocketDrone = rocketDPool.pop();
				var right:RocketDrone = rocketDPool.pop();
			}else {
				var right:RocketDrone = new RocketDrone;
				var left:RocketDrone = new RocketDrone;
			}
			right.recycle();
			left.recycle();
			left.left = true;
			right.right = true;
			LazerCatAttack.enemyList.push(left);
			LazerCatAttack.enemyList.push(right);
			left.x = 0 + left.width/2;
			right.x = 500 - right.width/2;
			left.y = /*-20 - left.height;*/ 10;
			right.y = /*-20 - right.height;*/ 10;
			LazerCatAttack.game.addChild(left);
			LazerCatAttack.game.addChild(right);
		}
		//will eventually be the function to make everything on-screen leave
		private function scatterTheMeak() {
			//tell DBs to fuck off
			for (var i:int = 0; i < LazerCatAttack.deathBallerzList.length; i ++ ) {
				LazerCatAttack.deathBallerzList[i].bossComing = true;
			}
		}
		//spawns things randomly and at specific intervals, with max amount = to # of setupPoints
	
		private function spawnDB (random) {
			if (LazerCatAttack.enemySpawn && !level1 && setupPoint.length > 0 && (Math.random() <.1 * dBMod || !random) && LazerCatAttack.deathBallerzList.length < dBCountMax) {
				//decide on where they should spawn and with what velocity
				var initialVelocity = new Vector3D(3,3,0);
				var enemy1:DeathBallerz = new DeathBallerz(initialVelocity, 4, setupPoint.shift());
				enemy1.x = Math.random() * 500;
				enemy1.y = -25;
				LazerCatAttack.deathBallerzList.push(enemy1);
				LazerCatAttack.enemyList.push(enemy1);
				game.addChild(enemy1);
			}else {
				//nothing
			}
		}
		//spawns randomly and at specific intervals
		private function spawnMedBot() {
			if (LazerCatAttack.medDroneList.length <= medMax) {
				var medDrone = new MedBot;
				/*trace("new medDrone");*/
				LazerCatAttack.medDroneList.push(medDrone);
				LazerCatAttack.game.addChild(medDrone);
			}
		}
		
		public function remove() {
			//lazer Drones? , cooldownBar,
			//remove event listeners and timers
			gameTimer.stop();
			if (LazerCatAttack.level2 && LazerCatAttack.timeIndex / LazerCatAttack.frameSpeed > level2Events[3] + endLv1) {
				LazerCatAttack.seenLevel2 = true;
			}
			//save previous level scores on that run through
			removeChild(Main.main.muteButton);
			gameTimer.removeEventListener(TimerEvent.TIMER, init);
			trace("number of Children prior" + numChildren);
			/*LazerCatAttack.cdBar.remove();
			LazerCatAttack.cdBar = null;*/
			cdHud.remove();
			cdHud = null;
			for (var i:int = LazerCatAttack.enemyList.length - 1; i >= 0; i--) {
				if (LazerCatAttack.enemyList[i] != null) {
					if (LazerCatAttack.enemyList[i] is BatonRam) {
						//do nothing I believe the baton will take care of it
					}else if (LazerCatAttack.enemyList[i] is DeathBallerz || LazerCatAttack.enemyList[i] is lv2Boss || LazerCatAttack.enemyList[i] is lv3Boss) {
						LazerCatAttack.enemyList[i].hitPoints = 0;
						LazerCatAttack.enemyList[i].destroyYourself();
					}else if (LazerCatAttack.enemyList[i] is DroneShip) {
						LazerCatAttack.enemyList[i].invincible = false;
						LazerCatAttack.enemyList[i].destroyYourself();
					}/*else if (LazerCatAttack.enemyList[i] is Rocket) {
						LazerCatAttack[i].invincible = false;
						LazerCatAttack[i].hitPoints = 0;
					}*/else if (LazerCatAttack.enemyList[i] is lv3BossPart) {
						LazerCatAttack.enemyList[i].health = 0;
						LazerCatAttack.enemyList[i].destroyYourself();
					}else if (LazerCatAttack.enemyList[i] is batonHit) {
						/*thing.remove();*/
					}else if (LazerCatAttack.enemyList[i] is lv3BossPylon) {
						LazerCatAttack.enemyList[i].health = 0;
						LazerCatAttack.enemyList[i].destroyYourself();
					}else { 
						LazerCatAttack.enemyList[i].destroyYourself();
					}
				}	
			}
			for (var i:int = Baton.batons.length -1; i >= 0; i--) {
				Baton.batons[i].remove();
			}
			//for functions like this should be able to disinculde the stuf != null statements THIS WAS SO FUCKED
			for (var a:int = LazerCatAttack.lazerDroneList.length - 1 ; a >= 0; a--) {
				if (LazerCatAttack.lazerDroneList[a] != null) {
					LazerCatAttack.lazerDroneList[a].invincible = false;
					LazerCatAttack.lazerDroneList[a].destroyYourself();
				}	
			}
			/*trace("lazerdronelist length = " + LazerCatAttack.lazerDroneList.length);*/
			
			for (var lv:int = LazerCatAttack.bossVector.length - 1; lv >= 0; lv--) {
				if (LazerCatAttack.bossVector[lv] != null) {
					LazerCatAttack.bossVector[lv].hitPoints = 0;
					LazerCatAttack.bossVector[lv].invincible = false;
					LazerCatAttack.bossVector[lv].remove();
				}
			}
			LazerCatAttack.huD.remove();
			LazerCatAttack.huD = null;
			for (var i:int = numChildren - 1; i >= 0; i --) {
				
				var thing = getChildAt(i);
				if (thing is DroneShipBullet) {
					thing.removeDroneShipBullet();
				}else if (thing is Bullet) {
					/*thing.removeBullet();*/
					thing.kick();
				}else if (thing is MedBot) {
					thing.remove();
				}else if (thing is lv3BossBullet) {
					thing.remove();
				}else if (thing is Rocket) {
					thing.hitPoints = 0;
					thing.invincible = false;
					thing.playerKilledMe = false;
					thing.destroyYourself();
				}else if (thing is lv1BossBullet) {
					thing.remove();
				}else if (thing is lv2BossBullet) {
					thing.destroyYourself();
				}else if (thing is Cat) {
					thing.hitPoints = 0;
					thing.destroyYourself();
				}else if (thing is CatScreen) {
					LazerCatAttack.game.removeChild(thing);
				}else if (thing is Crusher) {
					thing.remove();
				}else if (thing is DeathScreen) {
					LazerCatAttack.game.removeChild(thing);
				}else if (thing is DroneShip) {
					thing.kick();
				}else if (thing is Background) {
					removeChild(thing);
				}else if (thing is WormHole) {
					thing.remove();
				}else if (thing is Checkpoint) {
					thing.remove();
				}else if (thing is Burger) {
					thing.destroyYourself();
				}else {
					trace("leftover = " + thing);
					/*thing.kick();*/
				}
				thing = null;
			}
			trace("game children = " + numChildren);
			
			//currently the game is added to stage, consider changing this
			timeIndex = 0;
			LazerCatAttack.timeIndex = 0;
			game = null;
			LazerCatAttack.game = null;
			
			stage.removeChild(this);
			
		}
		public function hamburglar() {
			hamburglarMode = true;
			var announcement = new HbMessage();
			announcement.x = 250;
			announcement.y = 300;
			addChild(announcement);
			//testing : rather interested to see if this removes the referent or the reference...?
			announcement = null;
			//pop up an annnouncement that dissipears
			//add hamburglar content: spawn function enable for burgers && hunger bar
			//player side : lowering and rising hunger bar.
			//LCA will create the hunger bar here by calling enableHunger of the ability HUD
			cdHud.enableHunger();
		}
		public function retro() {
			passive1 = "Nyan Cats";
		}
	}	
}

