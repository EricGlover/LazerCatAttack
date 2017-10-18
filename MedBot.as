
package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.media.Sound;
	
	public class MedBot extends MovieClip {
		private var hitPointBuff:int = 1;
		public var speed = .6;
		public var justWarped:Boolean = false;
		private var spent:Boolean = false;
		private var cat:Boolean = false;
		
		public function MedBot() {
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
			this.x = Math.random() * 500;
			this.y = -10;
			mouseEnabled = false;
		}
		private function loop(TimerEvent):void {
			this.y += speed;
			//changes the hit's taken from player
			if (LazerCatAttack.you != null) {
				if (hitTestObject(LazerCatAttack.you)) {
					//don't exceed max hitpoints
					if (LazerCatAttack.you.hits > 0) {
						LazerCatAttack.you.hits -= hitPointBuff;
						/*var snd:Sound = new HealingSound;
						Main.sound.playFX(snd);*/
						/*this.x = 0;
						this.y = 0;*/
						/*LazerCatAttack.you.addChild(this);*/
						spent = true;
						//da fuk is this!!!?
						LazerCatAttack.huD.updateHitPoints(-1);	
					}
					if (Cat.daCat != null) {
						if (Cat.daCat.attached && Cat.daCat.h > 0) {
							Cat.daCat.h -= hitPointBuff;
							/*trace("CAT GOT HEALED");*/
						}
					}
					var snd:Sound = new HealingSound;
					Main.sound.playFX(snd);
					remove();
					this.x = 0;
					this.y = 0;
					this.gotoAndPlay(2);
					LazerCatAttack.you.addChild(this);
				}	
			}
			if (Cat.daCat != null && !spent) {
				if (hitTestObject(Cat.daCat) && Cat.daCat.h >= 0) {
					Cat.daCat.h -= hitPointBuff;
					trace("CAT GOT HEALED");
					var snd:Sound = new HealingSound;
					Main.sound.playFX(snd);
					remove();
					cat = true;
					this.x = 0;
					this.y = 0;
					Cat.daCat.addChild(this);
					this.gotoAndPlay(2);
					spent = true;
				}
			}
			if (lv3Boss.bob != null && !spent) {
				if (hitTestObject(lv3Boss.bob)) {
					if (lv3Boss.bob.h > 0) {
						lv3Boss.bob.h -= hitPointBuff;
					}
					spent = true;
					remove();
				}
			}
			if (this.y > 600 && !spent) {
				remove();
			}
		}
		//the pokeball calls this function to heal the ship when medBots are caught
		public function heal() {
			if (LazerCatAttack.you.hits > 0) {
				LazerCatAttack.you.hits -= hitPointBuff;
				//da fuk is this!!!?
				LazerCatAttack.huD.updateHitPoints(-1);	
			}
			if (Cat.daCat != null) {
				if (Cat.daCat.attached && Cat.daCat.h >= 0) {
					Cat.daCat.h -= hitPointBuff;
					/*trace("CAT GOT HEALED");*/
				}
			}
			remove();
			//hud healing animation ???	
			var snd:Sound = new HealingSound;
			Main.sound.playFX(snd);
			this.x = 0;
			this.y = 0;
			LazerCatAttack.you.addChild(this);
			this.gotoAndPlay(2);
		}
		public function kick() {
			if (cat) {
				Cat.daCat.removeChild(this);
			}else {
				LazerCatAttack.you.removeChild(this);
			}
		}
		public function remove() {
			if (currentFrame == 1) {
				LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
				LazerCatAttack.medDroneList.splice(LazerCatAttack.medDroneList.indexOf(this),1);
				if (LazerCatAttack.game.contains(this)) {
					LazerCatAttack.game.removeChild(this);
					/*trace("found med Bot contained in LCA.game");*/
				}else if (parent == null) {
					/*removeChild(this);*/
					trace("medBot @ unknown parentage");
				}else{
					parent.removeChild(this);
					trace("myPops = " + parent);
				}	
			}else {
				LazerCatAttack.you.removeChild(this);
			}
		}
	}
	
}
