package  {
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	
	
	public class Pain extends MovieClip {
		private var startWidth:int = 10;
		private var endWidth:int = 240;
		public var expandTime:Number = .5;
		public var expandWidth:Number;
		public var expandMod:Number;
		private var count:int = 0;
		private var delayCounter:int = 0;
		private var delayCount:Number;
		public var testHeight:int = 25;
		//side is the direction it will be moving, 1 = left, -1 = right
		private var side:int = 0;
		private var damage:int = 1;
		private var hitEnabled:Boolean = true;
		//this is weird
		private var meVar:int = 0;
		
		//this move from outside the screen instead of expanding, this way it doesn't look so silly
		public function Pain(direction:String, delay:Number) {
			this.height = testHeight;
			mouseEnabled = false;
			if (direction == "left") {
				this.rotation = 180;
				this.name = "left";
				this.x = 0 - this.width/2;
				side = 1;
			}else {
				this.name = "right";
				this.x = 500 + this.width/2;
				side = -1;
			}
			delayCount = delay;
			expandWidth = (endWidth)/ (expandTime * LazerCatAttack.frameSpeed);
			/*trace("expand width = " + expandWidth);*/
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
			expandMod = expandWidth * .1;
			expandWidth *= .38;
		}
		public function loop(e:TimerEvent) {
			delayCounter ++;
			if (delayCount * LazerCatAttack.frameSpeed <= delayCounter) {
				count ++;
				//figure out a way to get the expandWidth to accelerate nicely
				expandWidth += expandMod / 2.5; 
				if (side > 0) {
					this.x += expandWidth;
				}else if (side < 0) {
					this.x -= expandWidth;
				}
				if (count > expandTime * 60) {
					destroyYourself();
				}
				if (this.name == "left") {
					if (this.x >= 250 - this.width/2) {
						destroyYourself();
					}
				}else if (this.name == "right") {
					if (this.x <= 250 + this.width/2) {
						destroyYourself();
					}	
				}
				//consider making it hurt the lv2Boss or destroy other things, maybe lv2BossBullets?
				if (LazerCatAttack.you != null) {
					if (hitTestObject(LazerCatAttack.you)) {
					//consider changing the hitEnabled stuff to damage per second or something
						if (hitEnabled) {
							for (var i:int = 0; i < damage; i ++) {
								LazerCatAttack.you.killPlayer();
							}	
							hitEnabled = false;
						}
					//move the player
						if (this.name == "left") {
							LazerCatAttack.you.x = this.x + this.width/2 + LazerCatAttack.you.width/2;
						}else {
							LazerCatAttack.you.x = this.x - this.width/2 - LazerCatAttack.you.width/2;
						}
					}
				}	
				//}if (hitTestObject(LazerCatAttack.you)) {
				//	//consider changing the hitEnabled stuff to damage per second or something
				//	if (hitEnabled) {
				//		for (var i:int = 0; i < damage; i ++) {
				//			LazerCatAttack.you.killPlayer();
				//		}	
				//		hitEnabled = false;
				//	}
				//	//move the player
				//	if (this.name == "left") {
				//		LazerCatAttack.you.x = this.x + this.width/2 + LazerCatAttack.you.width/2;
				//	}else {
				//		LazerCatAttack.you.x = this.x - this.width/2 - LazerCatAttack.you.width/2;
				//	}
				//}
			}
		}	
		//lv2 boss will remove you from the pain array
		public function destroyYourself() {
			LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
			if (LazerCatAttack.game.contains(this)){
				LazerCatAttack.game.removeChild(this);
			}
		}
	}
	
}
