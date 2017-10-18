package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.Vector3D;
	
	
	public class DroneShipBullet extends MovieClip {
		public var droneBulletSpeed:Number = 6;
		public static var speed:Number = 6;
		public var position:Vector3D = new Vector3D();
		public var velocity:Vector3D = new Vector3D();
		public var lazerHits:int = 0;
		public var points:int = 0;
		public var playerKilledMe:Boolean = false;
		public var justWarped:Boolean = false;
		
		public function DroneShipBullet() {
			/*LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);*/
			/*this.x = x;*/
			//y + half the bullet height
			/*this.y = y + (this.height/2);
			position.x = this.x;
			position.y = this.y;*/
			droneBulletSpeed = DroneShipBullet.speed; 
			velocity.y = droneBulletSpeed;
		}
		public function recycle(x:Number, y:Number) {
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
			this.x = x;
			this.y = y;
			position.x = this.x;
			position.y = this.y;
			lazerHits = 0;
		}
		private function loop (e:TimerEvent):void {
			//move bullets
			position.x = this.x;
			position.y = this.y;
			
			position = position.add(velocity);
			//remove bullets
			if (this.y > 600 + this.height/2) {
				removeDroneShipBullet();
			}	
			if (LazerCatAttack.you != null) {
				//shipSplit
				if (LazerCatAttack.you.shipSplit){
					if(hitTestObject(LazerCatAttack.you.leftHalf)) {
						removeDroneShipBullet();
						LazerCatAttack.you.killPlayer();
					}else if(hitTestObject(LazerCatAttack.you.rightHalf)) {
						removeDroneShipBullet();
						LazerCatAttack.you.killPlayer();
					}
				}else{
					if (hitTestObject(LazerCatAttack.you)) {
						removeDroneShipBullet();
						LazerCatAttack.you.killPlayer();
					}
				}
			}
			if (Cat.daCat != null) {
				if (hitTestObject(Cat.daCat)) {
					Cat.daCat.destroyYourself();
					/*LazerCatAttack.huD.updateScore(this.points);*/
					removeDroneShipBullet();
				} 
			}
			this.x = position.x;
			this.y = position.y;
		}
		public function removeDroneShipBullet ():void {
			LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
			if (playerKilledMe) {
				LazerCatAttack.huD.updateScore(this.points);
			}
			DroneShip.bulletPool.unshift(this);
			DroneShip.bullet.splice(DroneShip.bullet.indexOf(this), 1);
			LazerCatAttack.game.removeChild(this);	
			lazerHits = 0;
			playerKilledMe = false;
		}
		
	}
	
}
