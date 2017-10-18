package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import fl.controls.Button;
	import flash.events.Event;
	import flash.net.SharedObject;
	
	public class DeathScreen extends MovieClip {
		private var score:int;
		private var finalS:int;
		private var newHighScore:Boolean;
		private var scoreMod:int;
		private var casualMod:int = 1;
		private var normalMod:int = 2;
		private var hardMod:Number = 4.56738;
		private var counter:int = 0;
		private var caughtTotal:int;
		private var timesWarped:int;
		private var thingsWrecked:int;
		private var lazersFired:int;
		private var so:SharedObject;
		private var currentLevel:int;
		private var mainButton:Button = new Button;
		private var restartButton:Button = new Button;
		private var victory:Boolean = false;
		private var tip1:String = "Pro Tip: Get hit less.";
		private var tip2:String = "Pro Tip: Don't forget to spam your abilities.";
		private var tip3:String = "Pro Tip: The Void Prisms can pick up MedBots for you.";
		private var tip4:String = "Pro Tip: Live on the edge: hovering around the top half of the screen makes optimal use of the Aft Cannon.";
		private var tip5:String = "Pro Tip: All the abilities combo really well with the aft-cannon.";
		private var tip6:String = "Pro Tip: Warp past enemies and you're aft-cannon will destroy them.";
		private var tip7:String = "Pro Tip: The Void Prism destroys the Lazer Drones (those pesky falling red bars).";
		private var tip8:String = "Pro Tip: If you send me all your monies I'll setup warp to be activate upon saying, 'Engage'";
		private var tipList:Vector.<String> = new <String>[tip1,tip2,tip3,tip4,tip5,tip6,tip7,tip8];
		private var level2AbilityTranslation:String;
		private var level3AbilityTranslation:String;
		
		public function DeathScreen() {
			so = Main.so;
			if (so.data.level2Ability == "pokeball") {
				level2AbilityTranslation == "Void Prism";
			}else if (so.data.level2Ability == "crusher") {
				level2AbilityTranslation == "Ramming Shields"
			}else if (so.data.level2Ability == "warp") {
				level2AbilityTranslation == "Warp";
			}else {
				level2AbilityTranslation == "nothing but your wits";
			}
			if (so.data.level3Ability == "pokeball") {
				level3AbilityTranslation == "Void Prism";
			}else if (so.data.level3Ability == "crusher") {
				level3AbilityTranslation == "Ramming Shields"
			}else if (so.data.level3Ability == "warp") {
				level3AbilityTranslation == "Warp";
			}else {
				level3AbilityTranslation == "nothing but your wits";
			}
			if (LazerCatAttack.game.level3) {
				currentLevel = 3;
			}else if (LazerCatAttack.level2) {
				currentLevel = 2;
			}else if (LazerCatAttack.game.level1) {
				currentLevel = 1;
			}
			if (LazerCatAttack.game.victory) {
				levelProgressText.text = "Victory";
				victory = true;
				trace("deathScreen sees victory");
			}
			score = LazerCatAttack.huD.newScore;
			yourScoreTxt.text = score.toString();
			difficultyTxt.text = LazerCatAttack.game.mode;
			caughtTotal = LazerCatAttack.you.caughtTotal;
			timesWarped = LazerCatAttack.you.timesWarped;
			thingsWrecked = LazerCatAttack.you.thingsWrecked;
			lazersFired = LazerCatAttack.you.lazersFired;
			//consider adding bullets fired and accuracy stats...
			switch (LazerCatAttack.game.mode) {
				case "Causal":
					scoreMod = casualMod;
					break;
				case "Normal":
					scoreMod = normalMod;
					break;
				case "Hard":
					scoreMod = hardMod;
					break;
				case "Beta Tester":
					scoreMod = 87;
					break;
				default:
					scoreMod = 1;
			}
			finalS = scoreMod * score;
			finalScoreTxt.text = finalS.toString();
			ratingTxt.text = rater();
			proTip.text = tip();
			lazerStat.text = "Lazers Fired = " + lazersFired.toString();
			highScoreFunk();
			switch (LazerCatAttack.you.ability1) {
				case "crusher":
					abilityStat.text = "Ability Stat: Enemies Rammed = " + thingsWrecked.toString();
					break;
				case "pokeball":
					abilityStat.text = "Ability Stat: Enemies Caught = " + caughtTotal.toString();
					break;
				case "warp":
					abilityStat.text = "Ability Stat: You warped " + timesWarped.toString() + " times.";
					break;
				default:
					abilityStat.text = "Ability Stat: On level 2 you will get some kick-ass abilities.";
			}
			aftStatTxt.text = "Aft-Cannon Shots Fired = " + Player.aftShotsFired.toString();
			addEventListener(Event.ADDED_TO_STAGE, startUp);
		}
		private function highScoreFunk() {
			switch (currentLevel) {
				case 1:
					if (finalS > so.data.level1HighScore) {
						so.data.level1HighScore = finalS;
						so.data.level1Ability = LazerCatAttack.you.ability1;
						so.data.level1Difficulty = LazerCatAttack.game.mode;
						newHighScore = true;
					}
					highScoreStat.htmlText = "<U>HighScore on Level 1 </U><BR> " + so.data.level1HighScore.toString() + "<BR> Achieved on " + so.data.level1Difficulty;
					break;
				case 2:
					if (finalS > so.data.level2HighScore) {
						so.data.level2HighScore = finalS;
						so.data.level2Ability = LazerCatAttack.game.ability1;
						so.data.level2Difficulty = LazerCatAttack.game.mode;
						newHighScore = true;
					}
					highScoreStat.htmlText = "<U>HighScore on Level 2 </U><BR> " + so.data.level2HighScore.toString() + "<BR> Using " + level2AbilityTranslation + "<BR> Achieved on " + so.data.level2Difficulty;
					break;
				case 3:
					if (finalS > so.data.level3HighScore) {
						so.data.level3HighScore = finalS;
						so.data.level3Ability = LazerCatAttack.you.ability1;
						so.data.level3Difficulty = LazerCatAttack.game.mode;
						newHighScore = true;
					}
					highScoreStat.htmlText = "<U>HighScore on Level 3 </U><BR> " + so.data.level3HighScore.toString() + "<BR> Using " + level3AbilityTranslation + "<BR> Achieved on " + so.data.level3Difficulty;
					break;
				default:
					
			}
			so.flush();
			/*so.data.level1HighScore = int1;
			so.data.level1Ability = string1;
			so.data.level2HighScore = int1;
			so.data.level2Ability = string1;
			so.data.level3HighScore = int1;
			so.data.level3HighScore = string1;*/
		}
		private function tip() {
			var rando:int = Math.random() * tipList.length;
			return tipList[rando];
		}
		private function rater () {
			var finalScore:int = scoreMod * score;
			trace("final Score = " + finalScore);
			if (finalScore > 130) {
				return "Picard";
			}else if (finalScore > 110) {
				return "Riker";
			}else if (finalScore > 90) {
				return "Captain";
			}else if (finalScore > 70) {
				return "1st Officier";
			}else if (finalScore > 50) {
				return "Scoundrel";
			}else if (finalScore > 20) {
				return "Solidly Drunk Pilot";
			}else {
				return "Incredibly Bad";
			}
		}
		public function startUp (e:Event) {
			//restart button
			trace("running startUP upon death");
			restartButton.label = "Die Again?";
			if (victory) {
				restartButton.label = "Win Again?";
			}
			restartButton.focusEnabled = false;
			restartButton.x = 5;
			restartButton.y = -50;
			restartButton.alpha = 1;
			restartButton.addEventListener(MouseEvent.CLICK, Main.main.restart);
			mainButton.x = restartButton.x - restartButton.width - 10;
			mainButton.y = - 50;
			mainButton.label = "Menu";
			mainButton.addEventListener(MouseEvent.CLICK, Main.main.backToMain);
			mainButton.focusEnabled = false;
			addChild(mainButton);
			addChild(restartButton);
			counter ++;
			if (counter > 0 ) {
				removeEventListener(Event.ADDED_TO_STAGE, startUp);
			}
		}
		public function remove() {
			mainButton.removeEventListener(MouseEvent.CLICK, Main.main.backToMain);
			restartButton.removeEventListener(MouseEvent.CLICK, Main.main.restart);
			removeChild(mainButton);
			removeChild(restartButton);
			lvlProgress.remove();
			parent.removeChild(this);
		}
	}
	
}
