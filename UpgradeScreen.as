package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.Mouse;
	import flash.text.TextField;
	import flash.display.Shape;
	import flash.text.*;
	import flash.media.Sound;
	
	public class UpgradeScreen extends MovieClip {
		public var tip:TextField = new TextField;
		private var style:TextFormat = new TextFormat("Silom", 12, 0x000000);
		
		public function UpgradeScreen() {
			warpCheck.addEventListener(MouseEvent.CLICK, enableWarp);
			getWreckedCheck.addEventListener(MouseEvent.CLICK, enableCrusher);
			pokeballCheck.addEventListener(MouseEvent.CLICK, enablePokeball);
			continueButton.addEventListener(MouseEvent.CLICK, continueClick);
			warpCheck.focusEnabled = false;
			getWreckedCheck.focusEnabled = false;
			pokeballCheck.focusEnabled = false;
			continueButton.focusEnabled = false;
			/*mouseEnabled = false;*/
			warpCheck.addEventListener(MouseEvent.ROLL_OVER, warpTip);
			getWreckedCheck.addEventListener(MouseEvent.ROLL_OVER, getWreckedTip);
			pokeballCheck.addEventListener(MouseEvent.ROLL_OVER, ballTip);
			tip.visible = false;
			/*stage.addChild(tip);*/
			addEventListener(Event.ENTER_FRAME, startUp);
			tip.setTextFormat(style);
			/*tip.addChild(txt);*/
		}
		public function startUp(e:Event) {
			/*stage.addEventListener(MouseEvent.MOUSE_MOVE, move);*/
			removeEventListener(Event.ENTER_FRAME, startUp);
			addChild(tip);
			trace("startup ran");
		}
		public function tipText(tx:String) {
			tip.text = tx;
			tip.wordWrap = true;
			tip.background = true;
			tip.backgroundColor = 0xFFFFFF;
			tip.height = 60;
			tip.width = 200;
		}	
		public function move (e:MouseEvent) {
			tip.x = e.stageX + 15 - this.x;
			tip.y = e.stageY - 10 - this.y - tip.height;
			/*trace("mouseMoved");
			trace("mouse.stagex " + e.stageX);
			trace("mouse.localx " + e.localX);
			trace("warpCheck.x " + warpCheck.x);
			trace("this.x " + this.x);*/
		}
		public function warpTip (e:MouseEvent) {
			warpCheck.addEventListener(MouseEvent.ROLL_OUT, warpOut);
			tip.visible = true;
			tipText("Activate to warp in the direction you were moving. With a extremely low cooldown, it's easy to use and good for aggresive and defensive pilots.");
			tip.x = e.stageX + 15 - this.x;
			tip.y = e.stageY - 20 - this.y - tip.height;
			trace("mouseOver warp");
			stage.addEventListener(MouseEvent.MOUSE_MOVE, move);
		}
		public function getWreckedTip (e:MouseEvent) {
			getWreckedCheck.addEventListener(MouseEvent.ROLL_OUT, wreckOut);
			tip.visible = true;
			tipText("Hold button to gain a shield that destroys most enemies. Shield slowly fades away, release it when not being used to conserve it's power reserves.");
			tip.x = e.stageX + 5 - this.x;
			tip.y = e.stageY - 10 - this.y - tip.height;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, move);
		}
		public function ballTip (e:MouseEvent) {
			pokeballCheck.addEventListener(MouseEvent.ROLL_OUT, ballOut);
			tip.visible = true;
			tipText("Hold button to throw a void prism in the direction you're moving, release button to capture/kill enemies. If you captured enemies you must throw the prism again and release them before you can capture/kill more.");
			tip.x = e.stageX + 5 - this.x;
			tip.y = e.stageY - 10 - this.y - tip.height;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, move);
		}
		public function warpOut(e:MouseEvent) {
			/*warpCheck.addEventListener(MouseEvent.ROLL_OUT, warpOut);*/
			tip.visible = false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, move);
		}
		public function wreckOut (e:MouseEvent) {
			/*getWreckedCheck.addEventListener(MouseEvent.ROLL_OUT, wreckOut);*/
			tip.visible = false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, move);
		}
		public function ballOut (e:MouseEvent) {
			/*pokeballCheck.addEventListener(MouseEvent.ROLL_OUT, ballOut);*/
			tip.visible = false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, move);
		}
		public function continueClick (e:MouseEvent) {
			//enable these on your ship
			if (getWreckedCheck.selected) {
				LazerCatAttack.you.enableCrusher();
			}else if (pokeballCheck.selected) {
				LazerCatAttack.you.enablePokeball();
			}else if (warpCheck.selected) {
				LazerCatAttack.you.enableWarp();
			}
			this.remove();
			var snd:Sound = new MechSound;
			Main.sound.playFX(snd);
			LazerCatAttack.gameTimer.start();
		}
		public function enableWarp(e:MouseEvent) {
			LazerCatAttack.you.ability1 = "warp";
			LazerCatAttack.game.cdHud.enableWarp();
			if (getWreckedCheck.selected) {
				getWreckedCheck.selected = false;
			}
			if (pokeballCheck.selected) {
				pokeballCheck.selected = false;
			}
		}
		public function enableCrusher(e:MouseEvent) {
			LazerCatAttack.you.ability1 = "crusher";
			LazerCatAttack.game.cdHud.enableCrusher();
			if (warpCheck.selected) {
				warpCheck.selected = false;
			}
			if (pokeballCheck.selected) {
				pokeballCheck.selected = false;
			}
		}
		public function enablePokeball(e:MouseEvent) {
			LazerCatAttack.you.ability1 = "pokeball";
			LazerCatAttack.game.cdHud.enableVoid();
			if (getWreckedCheck.selected) {
				getWreckedCheck.selected = false;
			}
			if (warpCheck.selected) {
				warpCheck.selected = false;
			}
		}
		public function remove() {
			warpCheck.removeEventListener(MouseEvent.CLICK, enableWarp);
			getWreckedCheck.removeEventListener(MouseEvent.CLICK, enableCrusher);
			pokeballCheck.removeEventListener(MouseEvent.CLICK, enablePokeball);
			continueButton.removeEventListener(MouseEvent.CLICK, continueClick);
			warpCheck.removeEventListener(MouseEvent.ROLL_OVER, warpTip);
			getWreckedCheck.removeEventListener(MouseEvent.ROLL_OVER, getWreckedTip);
			pokeballCheck.removeEventListener(MouseEvent.ROLL_OVER, ballTip);
			parent.removeChild(this);
			/*tip.remove();*/
			/*stage.removeEventListener(MouseEvent.MOUSE_MOVE, move);*/
		}
	}
	
}
