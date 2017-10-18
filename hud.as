package  {
	
	import flash.display.*;
	import flash.events.Event;
	import flash.text.*;
	
	
	
	public class hud extends MovieClip {
		public var newScore:int = 0;
		public var newHitPoints:int = 5;
		private var hPUnit:int;
		
		public function hud() {
			score.text = "0";
			hitPoints.text = "5";
			mouseEnabled = false;
			this.x = 0;
			this.y = 0;
		}
		public function startUp() {
			hPUnit = hPBar.width / LazerCatAttack.you.hitPoints;
		}
		public function updateScore(value:int):void {
			newScore += value;
			score.text = String(newScore);
		}
		public function updateHitPoints(value:int):void {
			newHitPoints -= value;
			hitPoints.text = String(newHitPoints);
			/*hPBar.width -= hPUnit;*/
			if (newHitPoints == 1) {
				hPBar.gotoAndStop(3);
				hPBar.width = newHitPoints * hPUnit;
			}else if (newHitPoints <= 3) {
				hPBar.gotoAndStop(2);
				hPBar.width = newHitPoints * hPUnit;
			}else {
				hPBar.width = newHitPoints * hPUnit;
				hPBar.gotoAndStop(1);
			}
		}
		public function remove() {
			LazerCatAttack.game.removeChild(this);
			LazerCatAttack.huD = null;
		}
	}
	
}
