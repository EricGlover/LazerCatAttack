package  {
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	
	public class AbilityHUD extends MovieClip {
		private var poolTotalH:int;
		private var hungerBarTotalH:int;
		
		public function AbilityHUD() {
			ability1.visible = false;
			charge1.visible = false;
			charge2.visible = false;
			//hungerstuff
			hungerTxt.visible = false;
			theHungerBar.visible = false;
			pool.visible = false;
			lazGuy.gotoAndStop(2);
			poolTotalH = pool.height;
			hungerBarTotalH = theHungerBar.height;
		}
		public function enableLazer() {
			lazGuy.gotoAndStop(1);
		}
		public function enableVoid() {
			ability1.visible = true;
			ability1.text = "Void Prism Empty";
			charge1.visible = false;
			charge2.visible = false;
			pool.visible = false;
		}
		public function enableWarp(){
			ability1.visible = true;
			ability1.text = "Warp Charges";
			charge1.visible = true;
			charge2.visible = true;
			pool.visible = false;
		}
		public function enableCrusher() {
			pool.visible = true;
			ability1.text = "Shield Charge:";
			ability1.visible = true;
			charge1.visible = false;
			charge2.visible = false;
		}
		public function enableHunger() {
			hungerTxt.visible = true;
			theHungerBar.visible = true;
			theHungerBar.height = 0;
		}
		public function updateHunger(hRatio) {
			if (hRatio <= 1) {
				theHungerBar.height = hRatio * hungerBarTotalH;
			}else{
				theHungerBar.height = hungerBarTotalH;
			}
			//insert stuff to change it's color based on height
			//maybe when you get really hungry you slow down or speed up...lawls
			if (hRatio <= .33) {
				theHungerBar.gotoAndStop(1);
			}else if (hRatio <= .66) {
				theHungerBar.gotoAndStop(2);
			}else {
				theHungerBar.gotoAndStop(3);
			}
			trace("hungerUpdate called " + hRatio + " this is hRatio");
		}
		public function updateWarp(charge, timer):void {
			//needs to show warp going up and then changing colors to signify being on
			//also needs to drop bar height to 0 if no charge
			if (charge == 2) {
				charge2.visible = true;
				charge1.visible = true;
			}else if (charge == 1) {
				charge1.visible = true;
				charge2.visible = false;
			}else {
				charge1.visible = false;
				charge2.visible = false;
			}
			/*if (charge > 0) {
				warpCdBar.height = total;
			}
			else if (charge == 0) {
				var heightUnit = total / (LazerCatAttack.you.warpCooldown * 60);
				warpCdBar.height = heightUnit * timer;
			}*/
			
		}
		public function updatePokeball(caught:Boolean) {
			if (caught) {
				ability1.text = "Void Prism Full";
			}else {
				ability1.text = "Void Prism Empty";
			}
		}
		public function updateCrusher(cRatio:Number) {
			pool.height = cRatio * poolTotalH;
		}
		public function updateLazer(canFire:Boolean, timer):void {
			/*if(canFire) {
				lazerCdBar.height = total;
			}
			else {
				var heightUnit = total / (LazerCatAttack.you.lazerCooldown * LazerCatAttack.frameSpeed);
				lazerCdBar.height = heightUnit * timer;
			}*/
			if (canFire) {
				lazGuy.gotoAndStop(1);
			}else {
				lazGuy.gotoAndStop(2);
			}
		}
		
		public function remove() {
			parent.removeChild(this);
		}
	}
}