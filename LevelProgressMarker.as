package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import fl.controls.progressBarClasses.IndeterminateBar;
	import flash.display.Sprite;
	import flash.display.Shape;
	
	
	public class LevelProgressMarker extends MovieClip {
		//the furthest that you've made it on these respective levels
		public static var furthest1:int;
		public static var furthest2:int;
		public static var furthest3:int;
		public var lv1Time:int;
		public var lv2Time:int;
		public var lv3Time:int;
		public var currentLevel:int;
		public var oldBest:int;
		public var oldX:int;
		public var thisX:int;
		private var markH:int = 18;
		private var markW:int = 18;
		/*public var mark:Shape;*/
		public var deathTime:int;
		public var deathSpot:Number;
		public var youProgressed:Boolean = false;
		public var maidenVoyage:Boolean = false;
		private var bossFight:Boolean = false;
		private var myPops;
		private var counter:int = 0;
		//mark function vars
		private var left:int;
		private var right:int;
		private var top:int;
		private var bottom:int;
		//spot function var
		private var xSpot:Number;
		private var time:int;
		
		public function LevelProgressMarker() {
			lv1Time = LazerCatAttack.game.lv1BossEnter * 60;
			lv2Time = LazerCatAttack.game.lv2BossEnter * 60;
			lv3Time = LazerCatAttack.game.lv3BossEnter * 60;
			bossFight = LazerCatAttack.game.bossFight;
			mouseEnabled = false;
			//set deathTime
			deathTime = LazerCatAttack.game.deathTime;
			myPops = parent;
			myPops is DeathScreen;
			/*trace("deathTime is in seconds = " + deathTime/60);*/
			if (LazerCatAttack.game.level1) {
				/*trace("it is indeed lvl 1");*/
				currentLevel = 1; 
				if (deathTime > LevelProgressMarker.furthest1) {
					//if it's their first run through
					if (LevelProgressMarker.furthest1 != 0) {
						youProgressed = true;
						oldBest = LevelProgressMarker.furthest1;
					}else {
						maidenVoyage = true;
						/*trace("set maidenVoyage to true");*/
					}
					LevelProgressMarker.furthest1 = deathTime;					
				}
			}else if (LazerCatAttack.level2) {
				currentLevel = 2;
				if (deathTime > LevelProgressMarker.furthest2) {
					if (LevelProgressMarker.furthest2 != 0) {
						youProgressed = true;
						oldBest = LevelProgressMarker.furthest2;
					}else {
						maidenVoyage = true;
					}
					LevelProgressMarker.furthest2 = deathTime;
				}
			}else if (LazerCatAttack.game.level3) {
				currentLevel = 3;
				if (deathTime > LevelProgressMarker.furthest3) {
					if (LevelProgressMarker.furthest3 != 0) {
						youProgressed = true;
						oldBest = LevelProgressMarker.furthest3;
					}else {
						maidenVoyage = true;
					}
					LevelProgressMarker.furthest3 = deathTime;					
				}
			}else {
				trace("some shit is seriously fuckedd @ levelProgressMarker");
			}
			addEventListener(Event.ADDED_TO_STAGE, loop);
		}
		//need a function to draw an X where you died and the furthest spot that you've made it to 
		//and write text describing what they mean below it 
		public function loop(e:Event) {
			//here call the draw function and such
			if (youProgressed) {
				//display some sort of lovely text....
				//draw both X's but change the texts......
				//use oldBest
				if (!bossFight) {
					oldX = toX(oldBest, findLvlTime(currentLevel));
					thisX = toX(deathTime, findLvlTime(currentLevel));
				}else {
					thisX = this.width;
					if (oldX >= thisX) {
						oldX = this.width;
					}
				}
				myPops.thisRunTxt.x = this.x + thisX - myPops.thisRunTxt.width/2;
				myPops.bestRunTxt.x = this.x + oldX - myPops.thisRunTxt.width/2;
				myPops.bestRunTxt.text = "Previous Best";
				myPops.bestRunTxt.textColor = 0xFF0000;
				myPops.thisRunTxt.textColor = 0x0000FF;
				myPops.bestRunTxt.width += 25;
				xDraw(oldX, 0xFF0000);
				xDraw(thisX, 0x0000FF);
				//do a hitTest to insure that the texts don't overlap
				//possible error here
				/*parent.bestRunTxt.x = oldX;*/
				/*parent.thisRunTxt.x = thisX;*/
			}else if (maidenVoyage) {
				//display one X but no lovely text......
				/*bestRunTxt.visible = false;*/
				if (bossFight) {
					thisX = this.width;
				}else {
					thisX = toX(deathTime, findLvlTime(currentLevel));
				}
				
				/*trace("thisX = " + thisX);*/
				/*myPops.arrangeTxt(1,thisX);*/
				myPops.bestRunTxt.visible = false;
				myPops.thisRunTxt.x = this.x + thisX - myPops.thisRunTxt.width/2;
				myPops.thisRunTxt.textColor = 0xFF0000;
				xDraw(thisX, 0xFF0000);
				//potential error
				/*parent.thisRunTxt.x = thisX;*/
			}else { 
				//draw two X's and display suiting texts
				if (bossFight) {
					thisX = this.width;
					if (oldX >= thisX) {
						oldX = thisX;
					}
				}else {
					oldX = toX(oldBest, findLvlTime(currentLevel));
					thisX = toX(deathTime, findLvlTime(currentLevel));
				}
				
				myPops.thisRunTxt.x = this.x + thisX - myPops.thisRunTxt.width/2;
				myPops.bestRunTxt.x = this.x + oldX - myPops.thisRunTxt.width/2;
				myPops.bestRunTxt.textColor = 0xFF0000;
				myPops.thisRunTxt.textColor = 0x0000FF;
				xDraw(thisX, 0x0000FF);
				xDraw(oldX, 0xFF0000);
			}
			//add something here to make sure that the two texts don't overlap.
			var best = myPops.bestRunTxt;
			var thisRun = myPops.thisRunTxt;
			if (best.x + best.width/2 > thisRun.x - thisRun.width/2) {
				best.y += thisRun.height/2 + 2;
				thisRun.y -= thisRun.height/2 - 2; 
			}else if (best.x - best.width/2 < thisRun.x + thisRun.width/2) {
				best.y += thisRun.height/2 + 2;
				thisRun.y -= thisRun.height/2 - 2;
			}
			counter ++;
			if (counter > 0) {
				removeEventListener(Event.ADDED_TO_STAGE, loop);
			}
		}
		public function xDraw(xMark:int, color:*) {
			/*trace("drawing some X");*/
			if (xMark > this.width) {
				xMark = this.width;
			}
			left = xMark - markW/2;
			right = xMark + markW/2;
			top = -markH/2;
			bottom = markH/2;
			var mark:Shape = new Shape;
			/*mark.graphics.lineStyle(2, 0xFF0000);*/
			mark.graphics.lineStyle(2, color);
			mark.graphics.moveTo(left, bottom);
			mark.graphics.lineTo(right, top);
			mark.graphics.moveTo(left, top);
			mark.graphics.lineTo(right, bottom);
			addChild(mark);
		}
		public function findLvlTime(level):int {
			if (level == 1) {
				time = lv1Time;
			}else if (level == 2) {
				time = lv2Time;
			}else if (level == 3) {
				time = lv3Time;
			}
			return time;
		}
		public function toX(dTime, lTime):Number {
			xSpot = (dTime / lTime) * this.width;
			/*trace("dTime / lTime = " + (dTime/lTime));
			trace("this width = " + this.width);
			trace("xSpot is " + xSpot);*/
			return xSpot;
		}
		//idk if this is needed later
		public function remove() {
			graphics.clear();
			//idk if this works
			for (var i:int = numChildren -1; i >= 0; i--) {
				removeChild(getChildAt(i));
			}
			parent.removeChild(this);
		}
	}
	
}
