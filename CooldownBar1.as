package  {
	
	import flash.display.MovieClip;
	
	
	public class CooldownBar1 extends MovieClip {
		//total bar heights
		private var total:int = 22;

		public function CooldownBar1() {
			mouseEnabled = false;
		}
		
		public function updateWarp(charge, timer):void {
			//needs to show warp going up and then changing colors to signify being on
			//also needs to drop bar height to 0 if no charge
			if (charge > 0) {
				warpCdBar.height = total;
			}
			else if (charge == 0) {
				var heightUnit = total / (LazerCatAttack.you.warpCooldown * 60);
				warpCdBar.height = heightUnit * timer;
			}
			
		}
		public function updateLazer(canFire, timer):void {
			if(canFire) {
				lazerCdBar.height = total;
			}
			else {
				var heightUnit = total / (LazerCatAttack.you.lazerCooldown * LazerCatAttack.frameSpeed);
				lazerCdBar.height = heightUnit * timer;
			}
		}
		public function updateInv():void {
			//code
		}
		public function remove(){
			LazerCatAttack.game.removeChild(this);
			LazerCatAttack.cdBar = null;
		}
	}
}
