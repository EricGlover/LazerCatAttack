package  {
	import flash.display.*;
	import flash.events.*;
	import flash.ui.Mouse;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import fl.controls.Button;
	import flash.utils.Timer;
	import flash.net.SharedObject;
	
	public class Main extends MovieClip{
		/*var preloader:Preloader;*/
		public var game;
		public static var so:SharedObject;
		public var backButton// = new Button;
		public static var start:Boolean = false;
		public var instructions; //= new Instructions;
		public var credits; //= new CreditsScreen;
		public var options;// new OptionsScreen;
		public var muteButton;// = new Button;
		public var casual:Button;// = new Button;
		public var normal:Button; // = new Button;
		public var hard:Button;// = new Button;
		//1 = casual, 2 = normal, 3 = hard
		public static var difSet:int = 3;
		public static var fake;
		public static var main:Main;
		public static var sound;//:GameSound = new GameSound();
		public var level1:Boolean = true;
		public var level2:Boolean = false;
		public var level3:Boolean = false;
		private var locks:Boolean = true;
		public var giveThemLazers:Boolean = false;
		private var ratio:Number;
		private var percent:int;
		private var firstTime:Boolean = true;
		public var mainTimer:Timer;
		
		
		//Notes : Main is the main class of the game
		//All the menu's functionality are done in code
		//Preloader : Main class sets up events to load and initMain
				//Load controls the bar
				//initMain
		
		public function Main() {
			//start the preloader
			//register button listeners
			/*preloader = new Preloader
			preloader.addEventListener(Event.COMPLETE, onPreloaderComplete);
            preloader.setLoaderInfo(loaderInfo);*/
			/*startButton.addEventListener(MouseEvent.CLICK, playGame, false, 0, true);
			instructionsButton.addEventListener(MouseEvent.CLICK, instructionScreen, false, 0, true);
			creditsButton.addEventListener(MouseEvent.CLICK, creditsScreen, false, 0, true);
			optionsButton.addEventListener(MouseEvent.CLICK, optionsScreen, false, 0, true);
			lv1Button.addEventListener(MouseEvent.CLICK, runLevel1, false, 0, true);
			lv2Button.addEventListener(MouseEvent.CLICK, runLevel2);
			lv3Button.addEventListener(MouseEvent.CLICK, runLevel3);*/
			//mute
		/*	muteButton.addEventListener(MouseEvent.CLICK, Main.sound.mute);
			backButton.label = "Back";
			Main.main = this;*/
			//do stuff later for the preloader
			//This sends progress to load, and completion event to initMain
			this.loaderInfo.addEventListener(Event.INIT, initMain);
			this.loaderInfo.addEventListener(ProgressEvent.PROGRESS, load);
        }
		private function load(e:ProgressEvent) {
			/*trace("load running");*/
			ratio = e.bytesLoaded/ e.bytesTotal;
			/*trace("ratio = " + ratio);*/
			/*cover.width = (1 - ratio) * 400;*/
			percent = ratio * 100;
			if (firstTime) {
				/*var button:Button = new Button;
				addChild(button);*/
				firstTime = false;
				/*trace(stage.numChildren);
				trace(stage.getChildAt(0));
				trace("my children" + numChildren);*/
			}
			/*stage.loadText.text = "Loading... " + percent.toString() + "% Complete";*/
			
			//loadBar.width = ratio * 190;*/
			
		}
		private function initMain(e:Event) {
			loaderInfo.removeEventListener(Event.INIT, initMain);
			/*stop();*/
			/*gotoAndPlay(3);*/
			addEventListener(Event.ENTER_FRAME, theSecondComing);
		}
		
		private function theSecondComing(e:Event) {
			/*trace("currentFrame is " + currentFrame);*/
			/*trace("secondcoming called");
			trace("current Frame" + currentFrame);*/
			if (currentFrame < 3) {
				loadText.text = "Loading";
				ratio = this.loaderInfo.bytesLoaded/ this.loaderInfo.bytesTotal;
				percent = ratio * 100;
				loadText.text = "Loading... " + percent.toString() + "% Complete";
			}
			if (this.loaderInfo.bytesLoaded == this.loaderInfo.bytesTotal && currentFrame == 3) {
				/*trace("loaded");*/
				/*trace("what is start button " + startButton);*/
				this.mouseEnabled = false;
				so = SharedObject.getLocal("LCAdata");
				/*trace("so.data.talk before writing = " + so.data.talk);*/
				//write something that sets the values that you'll need in the game but only does it the 
				//first time
				if (!so.data.stale) {
					trace("so.data.stale so I'm writing new values");
					/*var but:Button = new Button;
					but.x = 300;
					but.y = 500;
					but.label = "SO Fresh";
					addChild(but);*/
					so.data.stale = true;
					var b1a:Boolean = false;
					var b1b:Boolean = false;
					var b1c:Boolean = false;
					var b2a:Boolean = false;
					var b2b:Boolean = false;
					var b2c:Boolean = false;
					var b3a:Boolean = false;
					var b3b:Boolean = false;
					var b3c:Boolean = false;
					var string1:String = "none";
					var int1:int = 0;
					so.data.beatL1Casual = b1a;
					so.data.beatL1Normal = b1b;
					so.data.beatL1Hard = b1c;
					so.data.beatL2Casual = b2a;
					so.data.beatL2Normal = b2b;
					so.data.beatL2Hard = b2c;
					so.data.beatL3Casual = b3a;
					so.data.beatL3Normal = b3b;
					so.data.beatL3Hard = b3c;
					so.data.level1HighScore = int1;
					so.data.level1Ability = string1;
					so.data.level1Difficulty = string1;
					so.data.level2HighScore = int1;
					so.data.level2Ability = string1;
					so.data.level2Difficulty = string1;
					so.data.level3HighScore = int1;
					so.data.level3Ability = string1;
					so.data.level3Difficulty = string1;
					so.flush();
				}else if (so.data.stale){
					/*trace("so data is weird");
					var L:Boolean = false;
					var st:String = "Fuck You Man";
					so.data.L1Complete = L;
					so.data.talk = st;
					so.flush();*/
					/*var but:Button = new Button;
					but.x = 100;
					but.y = 500;
					but.label = "SO Stale";
					addChild(but);*/
				}
				//menu setup
				//sound setup
				//create other menu screen class instances
				//lockSetter() control the button lock functionality
				startButton.addEventListener(MouseEvent.CLICK, playGame, false, 0, true);
				instructionsButton.addEventListener(MouseEvent.CLICK, instructionScreen, false, 0, true);
				creditsButton.addEventListener(MouseEvent.CLICK, creditsScreen, false, 0, true);
				optionsButton.addEventListener(MouseEvent.CLICK, optionsScreen, false, 0, true);
				lv1Button.addEventListener(MouseEvent.CLICK, runLevel1, false, 0, true);
				lockSetter();
				/*lv2Button.addEventListener(MouseEvent.CLICK, runLevel2);
				lv3Button.addEventListener(MouseEvent.CLICK, runLevel3);*/
				lv1Button.selected = true;
				instructions = new Instructions;
				credits = new CreditsScreen;
				mainTimer = new Timer(16,0);
				mainTimer.start();
				sound is GameSound;
				sound = new GameSound();
				options = new OptionsScreen;
				muteButton = new Button;
				muteButton.width = 50;
				muteButton.height = 20;
				muteButton.x = 500 - muteButton.width;
				muteButton.y = 0;
				muteButton.toggle = true;
				muteButton.tabEnabled = false;
				muteButton.focusEnabled = false;
				muteButton.label = "Mute";
				casual = new Button;
				normal = new Button;
				hard = new Button;
				muteButton.addEventListener(MouseEvent.CLICK, Main.sound.mute);
				backButton = new Button;
				backButton.label = "Back";
				backButton.x = 0;
				backButton.y = 0;
				Main.main = this;
				removeEventListener(Event.ENTER_FRAME, theSecondComing);
				/*addEventListener(Event.ACTIVATE, fuck);
				addEventListener(Event.DEACTIVATE, fucked);*/
			}	
		}
		/*public function fuck(e:Event) {
			trace("game focused");
		}
		public function fucked(e:Event) {
			trace("game unfocused");
		}*/
		public function backToMain(e:MouseEvent) {
			var snd:Sound = new ClickS;
			Main.sound.playFX(snd);
			/*if (mainTimer == null) {
				mainTimer = new Timer(16);
				mainTimer.start();
			}*/
			Main.sound.backToMain();
			/*gotoAndStop(3);*/
			gotoAndStop(3);
			trace("backToMain ran");
			// remove deathScreen
			var myPops = e.target.parent;
			myPops is DeathScreen;
			myPops.remove();
			LazerCatAttack.endLv1 = 0;
			LazerCatAttack.endLv2 = 0;
			/*e.target.removeEventListener(TimerEvent.TIMER, Main.main.restart);
			var fuckingButton = e.target;
			fuckingButton is Button; 
			var myPops = fuckingButton.parent;
			myPops.removeChild(fuckingButton);*/
			if (LazerCatAttack.game.victory) {
				LazerCatAttack.you.hitPoints = 0;
				LazerCatAttack.you.killPlayer();
			}
			game.remove();
			game = null;
			trace("stage's children = ");
			for (var i:int = 0; i < stage.numChildren; i++) {
				trace(stage.getChildAt(i));
			}
			startButton.addEventListener(MouseEvent.CLICK, playGame, false, 0, true);
			instructionsButton.addEventListener(MouseEvent.CLICK, instructionScreen, false, 0, true);
			creditsButton.addEventListener(MouseEvent.CLICK, creditsScreen, false, 0, true);
			optionsButton.addEventListener(MouseEvent.CLICK, optionsScreen, false, 0, true);
			lv1Button.addEventListener(MouseEvent.CLICK, runLevel1, false, 0, true);
			/*lv2Button.addEventListener(MouseEvent.CLICK, runLevel2);
			lv3Button.addEventListener(MouseEvent.CLICK, runLevel3);*/
			stage.addEventListener(Event.ACTIVATE, activation);
			stage.addEventListener(Event.DEACTIVATE, unActive);
			lockSetter();
			addChild(startButton);
			addChild(instructionsButton);
			addChild(creditsButton);
			addChild(optionsButton);
			addChild(lv1Button);
			addChild(lv2Button);
			addChild(lv3Button);
			addChild(level2Lock);
			addChild(level3Lock);
		}
		//activation and unActive handle screen focus shifts
		private function activation(e:Event) {
			trace("system refocused");
		}
		private function unActive(e:Event) {
			trace("system unfocused");
		}
		private function playGame (e:MouseEvent) {
			trace("trying to run playGame");
			trace("Shared Object . Level 1 Complete = " + so.data.L1Complete);
			trace("shared object.talk plz ..." + so.data.talk);
			
			/*if (so.data.L1Complete) {
				var but:Button = new Button;
				but.x = 300;
				but.y = 500;
				but.label = "SHARED OBJECT RUNNING";
				addChild(but);
			}*/
			casual.toggle = true;
			normal.toggle = true;
			hard.toggle = true;
			casual.x = 100 - casual.width/2;
			normal.x = 250 - normal.width/2;
			hard.x = 400 - hard.width/2;
			casual.y = 300;
			normal.y = 300;
			hard.y = 300;
			casual.addEventListener(MouseEvent.CLICK, runCasual);
			normal.addEventListener(MouseEvent.CLICK, runNormal);
			hard.addEventListener(MouseEvent.CLICK, runHard);
			casual.label = "Casual";
			normal.label = "Normal";
			hard.label = "Hard";
			var snd:Sound = new ClickS;
			Main.sound.playFX(snd);
			lv1Button.removeEventListener(MouseEvent.CLICK, runLevel1);
			if (lv2Button.visible) {
				lv2Button.removeEventListener(MouseEvent.CLICK, runLevel2);
			}
			if (lv3Button.visible) {
				lv3Button.removeEventListener(MouseEvent.CLICK, runLevel3);
			}
			backButton.addEventListener(MouseEvent.CLICK, toMain);
			addChild(backButton);
			addChild(casual);
			addChild(normal);
			addChild(hard);
			removeChild(startButton);
			removeChild(instructionsButton);
			removeChild(creditsButton);
			removeChild(optionsButton);
			removeChild(lv1Button);
			removeChild(lv2Button);
			removeChild(lv3Button);
			removeChild(level2Lock);
			removeChild(level3Lock);
			lv1Button.selected = false;
			lv2Button.selected = false;
			lv3Button.selected = false;
			/*gotoAndStop(4);*/
		}
			//runCasual, runNormal, and runHard handle setting up the game to the selected level
			//and to the selected difficulty
		private function runCasual(e:MouseEvent) {
			Main.difSet = 1;
			var snd:Sound = new ClickS;
			Main.sound.playFX(snd);
			backButton.removeEventListener(MouseEvent.CLICK, toMain);
			removeChild(backButton);
			start = true;
			game = new LazerCatAttack;
			game.mode = "Casual";
			/*muteButton.width = 50;
			muteButton.height = 20;
			muteButton.x = 500 - muteButton.width;
			muteButton.y = 0;
			muteButton.toggle = true;
			muteButton.tabEnabled = false;
			muteButton.focusEnabled = false;
			muteButton.label = "Mute";*/
			game.addChild(muteButton);
			if (level1) {
				game.level1 = true;
				LazerCatAttack.level2 = false;
				game.level3 = false;
				giveThemLazers = false;
				Main.sound.lv1Music();
			}else if (level2) {
				game.showUpgrade = true;
				game.showPassive = true;
				giveThemLazers = false;
				game.level1 = false;
				LazerCatAttack.level2 = true;
				game.level3 = false;
				Main.sound.lv2Music();
			}else if (level3) {
				game.giveThemLazers = true;
				giveThemLazers = true;
				game.showUpgrade = true;
				game.showUpgrade2 = true;
				game.showPassive = true;
				game.showPassive2 = true;
				game.level1 = false;
				LazerCatAttack.level2 = false;
				game.level3 = true;
				Main.sound.lv3Music();
			}
			removeChild(casual);
			removeChild(normal);
			removeChild(hard);
			casual.selected = false;
			normal.selected = false;
			hard.selected = false;
			casual.removeEventListener(MouseEvent.CLICK, runCasual);
			normal.removeEventListener(MouseEvent.CLICK, runNormal);
			hard.removeEventListener(MouseEvent.CLICK, runHard);
			gotoAndStop(4);
			stage.addChild(game);
		}
		private function runNormal (e:MouseEvent) {
			Main.difSet = 2;
			var snd:Sound = new ClickS;
			Main.sound.playFX(snd);
			backButton.removeEventListener(MouseEvent.CLICK, toMain);
			removeChild(backButton);
			start = true;
			game = new LazerCatAttack;
			game.mode = "Normal";
			/*muteButton.width = 50;
			muteButton.height = 20;
			muteButton.x = 500 - muteButton.width;
			muteButton.y = 0;
			muteButton.toggle = true;
			muteButton.tabEnabled = false;
			muteButton.label = "Mute";*/
			game.addChild(muteButton);
			if (level1) {
				game.level1 = true;
				LazerCatAttack.level2 = false;
				game.level3 = false;
				Main.sound.lv1Music();
			}else if (level2) {
				game.showUpgrade = true;
				game.showPassive = true;
				game.level1 = false;
				LazerCatAttack.level2 = true;
				game.level3 = false;
				Main.sound.lv2Music();
			}else if (level3) {
				game.giveThemLazers = true;
				giveThemLazers = true;
				game.showUpgrade = true;
				game.showUpgrade2 = true;
				game.showPassive = true;
				game.showPassive2 = true;
				game.level1 = false;
				LazerCatAttack.level2 = false;
				game.level3 = true;
				Main.sound.lv3Music();
			}
			removeChild(casual);
			removeChild(normal);
			removeChild(hard);
			casual.selected = false;
			normal.selected = false;
			hard.selected = false;
			casual.removeEventListener(MouseEvent.CLICK, runCasual);
			normal.removeEventListener(MouseEvent.CLICK, runNormal);
			hard.removeEventListener(MouseEvent.CLICK, runHard);
			gotoAndStop(4);
			stage.addChild(game);
		}
		private function runHard (e:MouseEvent) {
			Main.difSet = 3;
			var snd:Sound = new ClickS;
			Main.sound.playFX(snd);
			backButton.removeEventListener(MouseEvent.CLICK, toMain);
			removeChild(backButton);
			start = true;
			game = new LazerCatAttack;
			game.mode = "Hard";
			/*muteButton.width = 50;
			muteButton.height = 20;
			muteButton.x = 500 - muteButton.width;
			muteButton.y = 0;
			muteButton.toggle = true;
			muteButton.tabEnabled = false;
			muteButton.label = "Mute";*/
			game.addChild(muteButton);
			if (level1) {
				game.level1 = true;
				LazerCatAttack.level2 = false;
				game.level3 = false;
				Main.sound.lv1Music();
			}else if (level2) {
				game.showUpgrade = true;
				game.showPassive = true;
				game.level1 = false;
				LazerCatAttack.level2 = true;
				game.level3 = false;
				Main.sound.lv2Music();
			}else if (level3) {
				game.giveThemLazers = true;
				giveThemLazers = true;
				game.showUpgrade = true;
				game.showUpgrade2 = true;
				game.showPassive = true;
				game.showPassive2 = true;
				game.level1 = false;
				LazerCatAttack.level2 = false;
				game.level3 = true;
				Main.sound.lv3Music();
			}
			removeChild(casual);
			removeChild(normal);
			removeChild(hard);
			casual.selected = false;
			normal.selected = false;
			hard.selected = false;
			casual.removeEventListener(MouseEvent.CLICK, runCasual);
			normal.removeEventListener(MouseEvent.CLICK, runNormal);
			hard.removeEventListener(MouseEvent.CLICK, runHard);
			gotoAndStop(4);
			stage.addChild(game);
		}
		private function runLevel1 (e:MouseEvent) {
			level1 = true;
			var snd:Sound = new ClickS;
			Main.sound.playFX(snd);
			level2 = false;
			level3 = false;
			/*lv1Button.selected = true;*/
			lv2Button.selected = false;
			lv3Button.selected = false;
		}
		private function runLevel2 (e:MouseEvent) {
			level1 = false;
			var snd:Sound = new ClickS;
			Main.sound.playFX(snd);
			level2 = true;
			level3 = false;
			lv1Button.selected = false;
			/*lv2Button.selected = true;*/
			lv3Button.selected = false;
		}
		private function runLevel3 (e:MouseEvent) {
			var snd:Sound = new ClickS;
			Main.sound.playFX(snd);
			level1 = false;
			level2 = false;
			level3 = true;
			lv1Button.selected = false;
			lv2Button.selected = false;
			/*lv3Button.selected = true;*/
		}
		private function instructionScreen (e:MouseEvent) {
			removeChild(startButton);
			removeChild(instructionsButton);
			removeChild(creditsButton);
			removeChild(optionsButton);
			removeChild(lv1Button);
			removeChild(lv2Button);
			removeChild(lv3Button);
			removeChild(level2Lock);
			removeChild(level3Lock);
			addChild(instructions);
			var snd:Sound = new ClickS;
			Main.sound.playFX(snd);
			backButton.addEventListener(MouseEvent.CLICK, back, false, 0, true);
			addChild(backButton);
		}
		private function optionsScreen (e:MouseEvent) {
			removeChild(startButton);
			removeChild(instructionsButton);
			removeChild(creditsButton);
			removeChild(optionsButton);
			removeChild(lv1Button);
			removeChild(lv2Button);
			removeChild(lv3Button);
			removeChild(level2Lock);
			removeChild(level3Lock);
			options.x = 250;
			options.y = 300;
			addChild(options);
			var snd:Sound = new ClickS;
			Main.sound.playFX(snd);
			backButton.addEventListener(MouseEvent.CLICK, back, false, 0, true);
			addChild(backButton);
		}
        private function creditsScreen (e:MouseEvent) {
			removeChild(startButton);
			removeChild(instructionsButton);
			removeChild(creditsButton);
			removeChild(optionsButton);	
			removeChild(lv1Button);
			removeChild(lv2Button);
			removeChild(lv3Button);
			removeChild(level2Lock);
			removeChild(level3Lock);
			addChild(credits);
			var snd:Sound = new ClickS;
			Main.sound.playFX(snd);
			backButton.addEventListener(MouseEvent.CLICK, back, false, 0, true);
			addChild(backButton);
			//add credits text
		}		
		private function back (e:MouseEvent) {
			removeChild(backButton);
			if (this.contains(instructions)) {
				removeChild(instructions);
			}else if (this.contains(credits)) {
				removeChild(credits);
			}else if (this.contains(options)) {
				removeChild(options);
				options.remove();
			}
			backButton.removeEventListener(MouseEvent.CLICK, back);
			addChild(startButton);
			var snd:Sound = new ClickS;
			Main.sound.playFX(snd);
			addChild(instructionsButton);
			addChild(creditsButton);
			addChild(optionsButton);
			addChild(lv1Button);
			addChild(lv2Button);
			addChild(lv3Button);
			addChild(level2Lock);
			addChild(level3Lock);
		}
		private function toMain(e:MouseEvent) {
			removeChild(backButton);
			removeChild(casual);
			removeChild(normal);
			removeChild(hard);
			addChild(lv1Button);
			addChild(lv2Button);
			addChild(lv3Button);
			addChild(level2Lock);
			addChild(level3Lock);
			addChild(instructionsButton);
			addChild(creditsButton);
			addChild(optionsButton);
			addChild(startButton);
			lockSetter();
			lv1Button.addEventListener(MouseEvent.CLICK, runLevel1);
			/*lv2Button.addEventListener(MouseEvent.CLICK, runLevel2);
			lv3Button.addEventListener(MouseEvent.CLICK, runLevel3);*/
			backButton.removeEventListener(MouseEvent.CLICK, toMain);
			casual.removeEventListener(MouseEvent.CLICK, runCasual);
			normal.removeEventListener(MouseEvent.CLICK, runNormal);
			hard.removeEventListener(MouseEvent.CLICK, runHard);
			startButton.addEventListener(MouseEvent.CLICK, playGame, false, 0, true);
			instructionsButton.addEventListener(MouseEvent.CLICK, instructionScreen, false, 0, true);
			creditsButton.addEventListener(MouseEvent.CLICK, creditsScreen, false, 0, true);
			optionsButton.addEventListener(MouseEvent.CLICK, optionsScreen, false, 0, true);
		}
		public function restart(e:MouseEvent) {
			trace("I've been told to restart this shind-dig");
			//remove button
			/*e.target.removeEventListener(TimerEvent.TIMER, Main.main.restart);
			var fuckingButton = e.target;
			fuckingButton is Button; 
			var myPops = fuckingButton.parent;
			myPops.removeChild(fuckingButton);*/
			var myPops = e.target.parent;
			myPops is DeathScreen;
			myPops.remove();
			LazerCatAttack.endLv1 = 0;
			LazerCatAttack.endLv2 = 0;
			if (LazerCatAttack.game.victory) {
				LazerCatAttack.you.hitPoints = 0;
				LazerCatAttack.you.killPlayer();
			}
			var bossTime:Boolean = game.bossFight;
			var ability1:String = game.ability1;
			var ability2:String = game.ability2;
			var passive1:String = game.passive1;
			var passive2:String = game.passive2;
			var snd:Sound = new ClickS;
			Main.sound.playFX(snd);
			var level:int = 0;
			if (game.level1) {
				level = 1;
			}else if (LazerCatAttack.level2) {
				level = 2;
			}else if (game.level3) {
				level = 3;
			}else {
				
			}
			var lv1Score:int = game.level1Score;
			var lv2Score:int = game.level2Score;
			trace("main sees level1score as = " + lv1Score);
			trace("main sees level2Score as = " + lv2Score);
			game.remove();
			game = null;
			game = new LazerCatAttack;
			game.addChild(muteButton);
			game.level1Score = lv1Score;
			game.level2Score = lv2Score;
			trace("main says ability1 = " + ability1);
			game.ability1 = ability1;
			game.ability2 = ability2;
			game.passive1 = passive1;
			game.passive2 = passive2;
			game.bossFight = bossTime;
			trace("game.ability1 = " + game.ability1);
			trace("game.passive1 = " + game.passive1);
			trace("game.passive2 = " + game.passive2);
			if (level == 3) {
				game.level3 = true;
				game.level1 = false;
				LazerCatAttack.level2 = false;
			}else if (level == 2) {
				game.level3 = false;
				game.level1 = false;
				LazerCatAttack.level2 = true;
			}else if (level == 1) {
				game.level3 = false;
				game.level1 = true;
				LazerCatAttack.level2 = false;
			}
			stage.addChild(game);
			trace("stage's children = ");
			for (var i:int = 0; i < stage.numChildren; i++) {
				trace(stage.getChildAt(i));
			}
		}
		private function lockSetter() {
			if (locks) {
				if (so.data.beatL1Casual || so.data.beatL1Normal || so.data.beatL1Hard) {
					lv2Button.addEventListener(MouseEvent.CLICK, runLevel2);
					lv2Button.visible = true;
					level2Lock.visible = false;
					trace("lockSetter says that you've beat level 1 before");
				}else {
					lv2Button.visible = false;
					level2Lock.visible = true;
				}
				if (so.data.beatL2Casual || so.data.beatL2Normal || so.data.beatL2Hard) {
					lv3Button.addEventListener(MouseEvent.CLICK, runLevel3);
					lv3Button.visible = true;
					level3Lock.visible = false;
					trace("lockSetter says that you've beat level 2 before");
				}else {
					lv3Button.visible = false;
					level3Lock.visible = true;
				}
			}else {
				lv2Button.addEventListener(MouseEvent.CLICK, runLevel2);
				lv3Button.addEventListener(MouseEvent.CLICK, runLevel3);
				level2Lock.visible = false;
				level3Lock.visible = false;
			}
		}
       /* private function onPreloaderComplete(e:Event):void {
            gotoAndStop(5);
        }*/

	}
	
}
