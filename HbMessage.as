package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class HbMessage extends MovieClip {
		
		
		public function HbMessage() {
			button.addEventListener(MouseEvent.CLICK, resume);
			button.focusEnabled = false;
		}
		private function resume(e:MouseEvent) {
			this.remove();
			LazerCatAttack.you.pause();
		}
		public function remove() {
			button.removeEventListener(MouseEvent.CLICK, resume);
			//don't recall if this works all the time....
			parent.removeChild(this);
		}
	}
	
}
