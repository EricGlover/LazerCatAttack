package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import fl.controls.Button;
	import flash.events.*;
	
	public class PauseMenu extends MovieClip {
		private var backButton;
		private var instructions:Instructions;
		private var optionsScreen:OptionsScreen;
		private var instructOn:Boolean = false;
		private var optionsOn:Boolean = false;
		
		public function PauseMenu() {
			resumeButton.addEventListener(MouseEvent.CLICK, resume);
			instructionsButton.addEventListener(MouseEvent.CLICK, inGameInstructions);
			optionsButton.addEventListener(MouseEvent.CLICK, inGameOptions);
			mainButton.addEventListener(MouseEvent.CLICK, inGameToMain);
			instructions = new Instructions;
			instructions.x = -250;
			instructions.y = -300;
			backButton = new Button;
			backButton.x = - 250;
			backButton.y = -300;
			backButton.label = "Back";
			backButton.addEventListener(MouseEvent.CLICK, backToPause);
			resumeButton.focusEnabled = false;
			instructionsButton.focusEnabled = false;
			optionsButton.focusEnabled = false;
			backButton.focusEnabled = false;
			mainButton.focusEnabled = false;
		}
		public function resume(e:MouseEvent) {
			LazerCatAttack.gameTimer.start();
			//Player.playerTimer.addEventListener(TimerEvent.TIMER, LazerCatAttack.you.warpCooldownHandler);
			Player.playerTimer.addEventListener(TimerEvent.TIMER, LazerCatAttack.you.refresh);
			Player.playerTimer.start();
			LazerCatAttack.you.fireTimer.start();
			//Player.playerTimer.addEventListener(TimerEvent.TIMER, LazerCatAttack.you.crusherCooldown);
			/*if (lv3Boss.bob != null) {
				if (lv3Boss.bob.glitchTimer != null) {
					lv3Boss.bob.glitchTimer.start();
				}	
			}	*/
			LazerCatAttack.you.pauseGame = false;
			destroyYourself();
		}
		public function inGameToMain(e:MouseEvent) {
			LazerCatAttack.gameTimer.start();
			//Player.playerTimer.addEventListener(TimerEvent.TIMER, LazerCatAttack.you.warpCooldownHandler);
			Player.playerTimer.addEventListener(TimerEvent.TIMER, LazerCatAttack.you.refresh);
			Player.playerTimer.start();
			LazerCatAttack.you.fireTimer.start();
			//Player.playerTimer.addEventListener(TimerEvent.TIMER, LazerCatAttack.you.crusherCooldown);
			/*if (lv3Boss.bob != null) {
				if (lv3Boss.bob.glitchTimer != null) {
					lv3Boss.bob.glitchTimer.start();
				}	
			}	*/
			/*LazerCatAttack.you.pauseGame = false;*/
			destroyYourself();
			LazerCatAttack.you.hitPoints = 0;
			LazerCatAttack.you.killPlayer();
		}
		public function inGameInstructions (e:MouseEvent) {
			addChild(instructions);
			addChild(backButton);
			instructOn = true;
		}
		public function inGameOptions(e:MouseEvent) {
			optionsScreen = new OptionsScreen;
			addChild(optionsScreen);
			addChild(backButton);
			optionsOn = true;
		}
		public function backToPause(e:MouseEvent) {
			/*if (this.contains(optionsScreen)) {
				removeChild(optionsScreen);
				optionsScreen.remove();
			}else if (this.contains(instructions)) {
				removeChild(instructions);
			}
			removeChild(backButton);*/
			if (optionsOn) {
				removeChild(optionsScreen);
				optionsScreen.remove();
				optionsOn = false;
			}else if (instructOn) {
				removeChild(instructions);
				instructOn = false;
			}
			removeChild(backButton);
		}
		public function destroyYourself() {
			/*LazerCatAttack.game.removeChild(this);*/
			parent.removeChild(this);
			instructions = null;
			resumeButton.removeEventListener(MouseEvent.CLICK, resume);
			instructionsButton.removeEventListener(MouseEvent.CLICK, inGameInstructions);
			optionsButton.removeEventListener(MouseEvent.CLICK, inGameOptions);
			mainButton.removeEventListener(MouseEvent.CLICK, inGameToMain);
			backButton.removeEventListener(MouseEvent.CLICK, backToPause);
			backButton = null;
		}
	}
	
}
