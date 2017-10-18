package  {
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.display.Sprite;
	import flash.geom.Vector3D;
	import flash.geom.Point;
	import flash.media.Sound;
	
	
	public class Pokeball extends MovieClip {
		//if it has stuff in it, maybe player should have this 
		public var full:Boolean = false;
		public var toss:Boolean = true;
		public var catching:Boolean = false;
		public var retrieve:Boolean = false;
		public var ballBlocked:Boolean = false;
		
		public var caught:Array = new Array();
		
		//playtesting boomerang mode
		/*public var boomerang:Boolean = false;*/
		
		//movement vars
		public var position:Vector3D = new Vector3D();
		public var velocity:Vector3D = new Vector3D();
		private var target:Vector3D = new Vector3D();
		private var steering:Vector3D = new Vector3D();
		public var maxVelocity:int = 12;
		private var maxSteering:Number = 4;
		public var selectedTarget:*;
		public var speed:Number = 4.3; //3.7
		private var radius:int = 65;
		public var color:int = 0;
		public var circle:Sprite;
		
		public var caughtTotal:int = 0;
		//boss vars
		public var damage:int = 2;
		public static var lv2BossStunTime:Number = 1.5;
		public static var lv3BossStunTime:Number = 2.1;
		
		//debug 
		public var debug:Boolean = false;
		
		public function Pokeball() {
			/*LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);*/
			if (LazerCatAttack.debug) {
				debug = true;
			}
			this.graphics.beginFill(0xFF0000, .3);
			this.graphics.drawCircle(0,0, radius);
			this.graphics.endFill();
			color = 0;
			position.x = this.x;
			position.y = this.y;
			mouseEnabled = false;
		}
		
		public function loop(e:TimerEvent) {
			//modes: toss full / toss empty; catching / releasing (catching when full); retrieval
			position.x = this.x;
			position.y = this.y;
			target.x = selectedTarget.x;
			target.y = selectedTarget.y;
			if (toss && !full) {
				var oldColor:int = color;
				//change so you use the velocity vector
				/*velocity.y = -speed;*/
				var changeColor:Boolean = false;
				color = 0;
				var foe:*;
				for (var i:int = 0; i < LazerCatAttack.enemyList.length; i ++) {
					foe = LazerCatAttack.enemyList[i];
					if (foe is batonHit) {
						//check the batons separately
						if (hitTestObject(foe.myPops)) {
							color = 1;
							break;
						}else {
							color = 0;
						}
					}else {
						if (distance(foe, this) <= radius) {
							/*trace("catchable " + foe + " enemy");*/
							color = 1;
							break;
						}else {
							color = 0;
						}
					}	
				}
				//this makes the indicator render only sometimes....
					var bot:MedBot;
				/*for (var i:int = 0; i < LazerCatAttack.medDroneList.length; i ++) {
					bot = LazerCatAttack.medDroneList[i];
					if (distance(bot, this) <= radius) {
						color = 1;
						break;
					}else {
						color = 0;
					}
				}*/
				var laz:LazerDrones;
				//don't call onCatch twice so if you already caught something just move on to the next one
				var lazCaught:Boolean = false;
				// if color is 1 then you don't need to check for anything else because indicator will be green
				if (color != 1) {
					for (var i:int = 0; i < LazerCatAttack.lazerDroneList.length; i ++) {
						laz = LazerCatAttack.lazerDroneList[i];
						if (distance(laz,this) <= radius) {
							color = 1;
							break;
						}
						//how to do this because distance doesn't really cut it
						//check the right and left lazer beam point
						if (laz.lazer != null && !lazCaught) {
							if (laz.righty) {
								var right:Point = new Point (laz.x + laz.width/2 + laz.lazer.width, laz.y);
								var left:Point = new Point(laz.x + laz.width/2, laz.y);
							}else {
								var right:Point = new Point (laz.x - laz.width/2, laz.y);
								var left:Point = new Point(laz.x - laz.lazer.width, laz.y);
							}
							if (distance(right,this) <= radius || distance(left,this) <= radius) {
								color = 1;
								break;
							}
						}
						lazCaught = false;
					}
				}	
				//0 is red, 1 is green; if change them then redraw the other
				if (oldColor != color) {
					if (color == 0) {
						graphics.clear();
						graphics.beginFill(0xFF0000, .3);
						graphics.drawCircle(0, 0, radius);
						graphics.endFill();
					}else if (color == 1) {
						this.graphics.clear();
						graphics.beginFill(0x33FF00, .3);
						graphics.drawCircle(0, 0, radius);
						graphics.endFill();
					}
				}
			}else if (toss && full) {
				/*velocity.y = -speed;*/
				/*velocity.x = 0;*/
			}else if (retrieve) {
				/*if (boomerang) {*/
					//for (var i:int = 0; i < LazerCatAttack.enemyList.length; i++) {
					//	if (LazerCatAttack.enemyList[i] != null) {
					//		if (hitTestObject(LazerCatAttack.enemyList[i])) {
					//			if (LazerCatAttack.enemyList[i] is BatonRam) {
					//				/*trace("found a baton");*/
					//				//graphical animation
					//				break;
					//			}
					//			LazerCatAttack.enemyList[i].playerKilledMe = true;
					//			LazerCatAttack.enemyList[i].destroyYourself();
					//		}
					//	}	
					//}
					//for (var a:int = 0; a < LazerCatAttack.lazerDroneList.length; a++) {
					//	if (LazerCatAttack.lazerDroneList[a] != null) {
					//		if (hitTestObject(LazerCatAttack.lazerDroneList[a])) {
					//			LazerCatAttack.lazerDroneList[a].playerKilledMe = true;
					//			LazerCatAttack.lazerDroneList[a].destroyYourself();
					//		}
					//	}	
					//}
				/*}*/
				steering = seek(target);
				velocity = velocity.add(steering);
				if (LazerCatAttack.you != null) {
					if (hitTestObject(LazerCatAttack.you)) {
						retrieve = false;
						silenceThySelf();
					}
				}
			}			
			truncate(velocity, maxVelocity);
			var newPos:Vector3D = new Vector3D();
			newPos = position.add(velocity);
			var direction:Number;
			//splitting these up allows for it to still travel up if hitting the left wall.
			if (newPos.x + this.width/2 < 500 && newPos.x - this.width/2 > 0){
				position.x = position.x + velocity.x;
			}else {
				if (newPos.x + this.width/2 > 500 && velocity.x < 0) {
					position.x = position.x + velocity.x;
				}else if (newPos.x - this.width/2 < 0 && velocity.x > 0) {
					position.x = position.x + velocity.x;
				}
			}
			if (newPos.y + this.height/2 < 600 && newPos.y - this.height/2 > 0) {
				position.y = position.y + velocity.y;
			}else {
				if (newPos.y - this.height/2 < 0 && velocity.y > 0) {
					position.y = position.y + velocity.y;
				}else if (newPos.y + this.height/2 > 600 && velocity.y < 0) {
					position.y = position.y + velocity.y;
				}
			}
			
			this.x = position.x;
			this.y = position.y;
		}
		private function getAngle(vector:Vector3D):Number {
			return Math.atan2(vector.y, vector.x);
		}
		public function seek(target) {
			var desired:Vector3D = new Vector3D();
			desired = target.subtract(position);
			desired.normalize();
			desired.scaleBy(maxVelocity);
			var force:Vector3D = new Vector3D();
			force = desired.subtract(velocity);
			truncate(force, maxSteering);
			return force
		}
		private function truncate(vector:Vector3D, max:Number):void {
			var i:int;
			i = vector.length/max;
			if (i > 1) {
				if (max == 0) {
					trace("error, @ lv2 boss truncate");
				}else{
					vector.scaleBy(1/i);	
				}
			}
		}
		public function silenceThySelf() {
			//if you caught something then 
			if (caught.length > 0) {
				full = true;
				LazerCatAttack.game.cdHud.updatePokeball(true);
			}else if (caught.length == 0) {
				full = false;
				LazerCatAttack.game.cdHud.updatePokeball(false);
			}
			gotoAndStop(1);
			var foe:*;
			for (var i:int = 0; i < caught.length; i++) {
				foe = caught[i];
				gotoAndStop(2);
				if (foe is Cat) {
					caught.splice(caught.indexOf(foe), 1);
					removeChild(foe);
					LazerCatAttack.you.addCat();
					break;
				}
			}
			LazerCatAttack.you.haveBall = true;
			retrieve = false;
			velocity.y = 0;
			velocity.x = 0;
			toss = true;
			ballBlocked = false;
			LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
			LazerCatAttack.game.removeChild(this);
		}
		public function retoss() {
			LazerCatAttack.gameTimer.addEventListener(TimerEvent.TIMER, loop);
			full = true;
			toss = true;
			/*release = true;*/
			/*this.x = LazerCatAttack.you.x;
			this.y = LazerCatAttack.you.y;*/
			alpha = 1;
			LazerCatAttack.game.addChild(this);
		}
		public function distance(a, b):int {
			return (Math.sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y)));
		}
		public function gottaCatchemAll() {
			//check for batonRams first to see if it will ball block that shit
			gotoAndStop(2);
			var snd:Sound = new PokeballSound;
			Main.sound.playFX(snd);
			var baton:Baton;
			var p1:Point;
			var p2:Point;
			for (var i:int = 0; i < Baton.batons.length; i++) {
				if (debug) {
					/*trace("I'm finding batons, that may block shit @pokeball");*/
				}
				baton = Baton.batons[i];
				if (baton.daRam == null) {
					
				}else {
					//check two points
					p1 = new Point(baton.daRam.x - baton.daRam.width/2, baton.daRam.y);
					p2 = new Point(baton.daRam.x + baton.daRam.width/2, baton.daRam.y);
					if (distance(this, p1) <= radius || distance(this,p2) <= radius) {
						//check yourself pokeball
						//do the ball block animation
						ballBlocked = true;
						retrieve = true;
						toss = false;
						velocity.y = 0;
						this.alpha = .4;
						graphics.clear();
						if (debug) {
							/*trace("Ball blocked @pokeball");*/
						}
						break;
					}
				}
			}
			if (!ballBlocked) {
				var xDif:int;
				var yDif:int;
				var foe:*;
				for (var i:int = LazerCatAttack.enemyList.length - 1; i >= 0; i--) {
					foe = LazerCatAttack.enemyList[i];
					if (foe != null){
						if (foe is batonHit) {
							/*trace("found foe that is batonhit");*/
							if (hitTestObject(foe.myPops)){
								/*trace("hitTest with batonHit is true");*/
								xDif = foe.myPops.x - this.x;
								yDif = foe.myPops.y - this.y;
								foe.onCatch(xDif,yDif);
							}
						}else if (distance(foe, this) <= radius) {
							/*trace("in distance foe section");*/
							/*trace("foe = " + foe);*/
							//maybe it'd be better to have all the other classes have a foe.caught() function, so this wouldn't be so bogged down
							//all the enemies that just die put here with the rocketDrone
							/*if (foe is RocketDrone) {
								
							}else {
								caught.push(foe);
							}*/
							
							//caught needs to be used on db before destroyYourself() so it won't erase it's groupie array
							//if (foe is DroneShip) {
							//	foe.caught = true;
							//	/*trace("caught droneships");*/
							//}else if (foe is DeathBallerz) {
							//	foe.caught = true;
							//}
							//da fuck does xDif and yDif do?????
							xDif = foe.x - this.x;
							yDif = foe.y - this.y;
							/*foe.hitPoints = 0;
							foe.destroyYourself();*/
							/*addChild(foe);*/
							//changed this because of weirdness with the baton/ batonHit things
							/*foe.x = xDif;
							foe.y = yDif;*/
							foe.alpha = .5;
							foe.onCatch(xDif,yDif);
							/*trace("caught " + foe);*/
							//lists and arrays
							//or maybe just have them destroythemselves but maintain a reference to them in a list or something
							//and then maybe add them to the pokeball later...x and y stuff????!!!!
						}
					}	
				}
				//check for med Bots, have them heal the ship and remove themselves
				var bot:MedBot;
				for (var i:int = LazerCatAttack.medDroneList.length - 1; i >= 0; i --) {
					if (debug) {
						trace("Running for loop for medBots @pokeball");
					}
					bot = LazerCatAttack.medDroneList[i];
					if (distance(bot,this) <= radius) {
						bot.heal();
						caughtTotal++;
					}
				}
				var lazCaught:Boolean = false;
				var laz:LazerDrones;
				for (var i:int = 0; i < LazerCatAttack.lazerDroneList.length; i ++) {
					if (debug) {
						trace("Checking lazerDrone @ for @pokeball");
					}
					laz = LazerCatAttack.lazerDroneList[i];
					if (distance(laz,this) <= radius) {
						laz.onCatch();
						caughtTotal++;
						lazCaught = true;
						if (debug) {
							trace("catching laz @pokeball");
						}
					}
					//how to do this because distance doesn't really cut it
					//check the right and left lazer beam point
					if (laz.lazer != null && !lazCaught) {
						if (debug) {
							trace("Checking laz.lazer @pokeball");
						}
						if (laz.righty) {
							var right:Point = new Point (laz.x + laz.width/2 + laz.lazer.width, laz.y);
							var left:Point = new Point(laz.x + laz.width/2, laz.y);
						}else {
							var right:Point = new Point (laz.x - laz.width/2, laz.y);
							var left:Point = new Point(laz.x - laz.lazer.width, laz.y);
						}
						if (distance(right,this) <= radius || distance(left,this) <= radius) {
							laz.onCatch();
							if (debug) {
								trace("Laz.lazer @distance < radius @pokeball");
							}
						}
					}
					lazCaught = false;
				}
				//cat is not catchable on the player ship
				if (Cat.daCat != null) {
					if (debug) {
						trace("Checking cat @pokeball");
					}
					if (distance(this, Cat.daCat) <= radius && !Cat.daCat.attached) {
						var cat = Cat.daCat;
						caught.push(cat);
						var xDif = cat.x - this.x;
						var yDif = cat.y - this.y;
						cat.hitPoints = 0;
						cat.destroyYourself();
						addChild(cat);
						cat.x = xDif;
						cat.y = yDif;
						cat.alpha = .5;
						trace("caught " + cat);
						caughtTotal ++;
					}
				}
				//check for rockets to destroy
				var rockette:Rocket;
				for (var i:int = RocketDrone.rockets.length - 1; i >= 0; i--) {
					if (debug) {
						trace("checking rockets @for @pokeball");
					}
					rockette = RocketDrone.rockets[i];
					if (distance(this, rockette) <= radius) {
						rockette.onCatch();
					}
				}
				//destroy all bullets
				for (var i:int = DroneShip.bullet.length - 1; i >= 0; i --) {
					if (distance(this, DroneShip.bullet[i]) <= radius) {
						DroneShip.bullet[i].removeDroneShipBullet();
						caughtTotal ++;
					}
				}
				if (lv3Boss.bob != null) {
					for (var i:int = lv3Boss.bob.bobsBurgers.length - 1; i >= 0 ; i --) {
						if (distance(this,lv3Boss.bob.bobsBurgers[i]) <= radius) {
							lv3Boss.bob.bobsBurgers[i].remove();
							caughtTotal ++;
						}
					}
				}
				for (var i:int = lv2Boss.bullet.length -1; i >= 0 ; i --) {
					if (distance(this, lv2Boss.bullet[i]) <= radius) {
						lv2Boss.bullet[i].destroyYourself();
						caughtTotal ++;
					}
				}
				//run through droneShips and find the ones that were groupies of DBS that weren't caught
				//or does the DB do this? DB DOES THIS!
				//run through the caught list and deal with the groupies
				for (var i:int = 0; i < caught.length; i++) {
					foe = caught[i];
					if (i == 0) {
						LazerCatAttack.game.cdHud.updatePokeball(true);
					}
					if (foe is DeathBallerz) {
						for (var a:int = foe.groupies.length -1; a >= 0 ; a --) {
							if (foe.groupies[a].caught) {
								//nothing
							}else if (!foe.groupies[a].caught) {
								xDif = foe.groupies[a].x - foe.groupies[a].x;
								yDif = foe.groupies[a].y - this.y;
								foe.groupies[a].alpha = .5;
								foe.groupies[a].onCatch(xDif,yDif);
							}
						}
					}
				}
				//do the flash of light animation
				retrieve = true;
				toss = false;
				velocity.y = 0;
				this.alpha = .4;
				caughtTotal += caught.length;
				graphics.clear();
			}	
		}
		public function releaseBeasts() {
			if (caught.length > 0) {
				gotoAndStop(2);
				var snd:Sound = new PokeballSound;
				Main.sound.playFX(snd);
				var foe:*;
				var xDif:int;
				var yDif:int;
				for (var i:int = caught.length - 1; i >= 0; i --) {
					foe = caught[i];
					xDif = foe.x;
					yDif = foe.y;
					if (LazerCatAttack.you.ball.contains(this)){
						removeChild(foe);
					}else {
						trace("da fuck is this!!!");
						foe.destroyYourself();
					}
					foe.alpha = 1;
					foe.x = this.x + xDif;
					foe.y = this.y + yDif;
					LazerCatAttack.game.addChild(foe);
					foe.revive();
					caught.splice(i, 1);
				}
			}	
			LazerCatAttack.game.cdHud.updatePokeball(false);
			toss = false;
			retrieve = true;
			full = false;
			gotoAndStop(1);
		}
		public function destroyYourself() {
			//recent change
			if (toss) {
				LazerCatAttack.gameTimer.removeEventListener(TimerEvent.TIMER, loop);
			}
			caught.splice(0, caught.length);
			if (LazerCatAttack.game.contains(this)) {
				LazerCatAttack.game.removeChild(this);
			}
			selectedTarget = null;
		}
	}
	
}
