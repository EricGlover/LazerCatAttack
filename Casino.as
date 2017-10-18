package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import fl.controls.CheckBox;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.*;
	import fl.controls.TextArea;
	import fl.controls.Button;
	import flash.media.Sound;
	
	public class Casino extends MovieClip {
		private var respins:int = 0;
		private var gold:int = 0;
		public var mod:int = 3;
		private var spentGold:int = 0;
		private var spinCost:int = 20;
		private var startSpin:Boolean = true;
		private var rando:Number;
		private var decel:Number = .01;
		private var wheelFlipped:Boolean = false;
		private var spinning:Boolean = false;
		private var passiveCost:int = 50;
		private var winner:*;
		private var selectedPassive:String;
		private var box:Sprite;
		private var confirm:Button;
		private var respin1:Button;
		//remove the current one later upon the second coming of the casino
		public var activePassives:Array = new Array(1,2,3,4,5,6);
		private var wheel:Sprite;
		private var radius:int = 100;
		private var point:Array;
		private var text1:String = "Double Fire";
		//this seems to fuck up the crusher after restarting on lv3
		private var text2:String = "Secret";
		private var text3:String = "Slow Time Ability";
		private var text4:String = "Hit Points ++";
		private var text5:String = "Nyan Cats";
		private var text6:String = "Sheep 4 The Win";
		private var hitPointBuff:int = 4;
		
		public function Casino(owned) {
			//Sounds: spin, winner
			//I believe gold, pay sound, click sound, can't do sound, and Congrats screen is done
			//display "you broke" if trying to buy something to expensive
			//do the tool tip on the passives?
			//when passive removed strikethrough the label
			mouseEnabled = false;
			upArrow.addEventListener(MouseEvent.CLICK, addRespin);
			downArrow.addEventListener(MouseEvent.CLICK, lessRespin);
			spin.addEventListener(MouseEvent.CLICK, SpinIt);
			/*upArrow.focusEnabled = false;*/
			/*downArrow.focusEnabled = false;*/
			spin.focusEnabled = false;
			passive1Check.label = text1;
			passive2Check.label = text2;
			passive3Check.label = text3;
			passive4Check.label = text4;
			passive5Check.label = text5;
			passive6Check.label = text6;
			passive1Check.focusEnabled = false;
			passive2Check.focusEnabled = false;
			passive3Check.focusEnabled = false;
			passive4Check.focusEnabled = false;
			passive5Check.focusEnabled = false;
			passive6Check.focusEnabled = false;
			passive1Check.width = 250;
			passive2Check.width = 250;
			passive3Check.width = 250;
			passive4Check.width = 250;
			passive5Check.width = 250;
			passive6Check.width = 250;
			//this is my drool-ass way of removing buttons representing choices that have already
			//been won by previous passive casino times, the game will remove the owned from the active list
			if (owned == 1) {
				removeChild(passive1Check);
				passive2Check.addEventListener(MouseEvent.CLICK, p1);
				passive3Check.addEventListener(MouseEvent.CLICK, p1);
				passive4Check.addEventListener(MouseEvent.CLICK, p1);
				passive5Check.addEventListener(MouseEvent.CLICK, p1);
				passive6Check.addEventListener(MouseEvent.CLICK, p1);
			}else if (owned == 2) {
				removeChild(passive2Check);
				passive1Check.addEventListener(MouseEvent.CLICK, p1);
				passive3Check.addEventListener(MouseEvent.CLICK, p1);
				passive4Check.addEventListener(MouseEvent.CLICK, p1);
				passive5Check.addEventListener(MouseEvent.CLICK, p1);
				passive6Check.addEventListener(MouseEvent.CLICK, p1);
			}else if (owned == 3) {
				removeChild(passive3Check);
				passive1Check.addEventListener(MouseEvent.CLICK, p1);
				passive2Check.addEventListener(MouseEvent.CLICK, p1);
				passive4Check.addEventListener(MouseEvent.CLICK, p1);
				passive5Check.addEventListener(MouseEvent.CLICK, p1);
				passive6Check.addEventListener(MouseEvent.CLICK, p1);
			}else if (owned == 4) {
				removeChild(passive4Check);
				passive1Check.addEventListener(MouseEvent.CLICK, p1);
				passive2Check.addEventListener(MouseEvent.CLICK, p1);
				passive3Check.addEventListener(MouseEvent.CLICK, p1);
				passive5Check.addEventListener(MouseEvent.CLICK, p1);
				passive6Check.addEventListener(MouseEvent.CLICK, p1);
			}else if (owned == 5) {
				removeChild(passive5Check);
				passive1Check.addEventListener(MouseEvent.CLICK, p1);
				passive2Check.addEventListener(MouseEvent.CLICK, p1);
				passive3Check.addEventListener(MouseEvent.CLICK, p1);
				passive4Check.addEventListener(MouseEvent.CLICK, p1);
				passive6Check.addEventListener(MouseEvent.CLICK, p1);
			}else if (owned == 6) {
				removeChild(passive6Check);
				passive1Check.addEventListener(MouseEvent.CLICK, p1);
				passive2Check.addEventListener(MouseEvent.CLICK, p1);
				passive3Check.addEventListener(MouseEvent.CLICK, p1);
				passive4Check.addEventListener(MouseEvent.CLICK, p1);
				passive5Check.addEventListener(MouseEvent.CLICK, p1);
			}else {
				passive1Check.addEventListener(MouseEvent.CLICK, p1);
				passive2Check.addEventListener(MouseEvent.CLICK, p1);
				passive3Check.addEventListener(MouseEvent.CLICK, p1);
				passive4Check.addEventListener(MouseEvent.CLICK, p1);
				passive5Check.addEventListener(MouseEvent.CLICK, p1);
				passive6Check.addEventListener(MouseEvent.CLICK, p1);
			}
			point = new Array();
			draw();
			//update gold
			gold = LazerCatAttack.huD.newScore * mod - LazerCatAttack.game.spentCasinoGold;
			yourGold.text = "You have " + gold + " gold.";
		}
		
		public function addRespin (e:MouseEvent) {
			//take their money
			if (gold - spinCost > 0  && !spinning) {
				gold -= spinCost;
				spentGold += spinCost;
				//update gold
				yourGold.text = "You have " + gold + " gold.";
				respins ++;
				respin.text = "RESPINS = " + respins;
				//play buy sound
				var snd:Sound = new PickupCoin;
				Main.sound.playFX(snd);
			}else {
				//can't do that sound
				// display you broke
				var snd:Sound = new CantSelect;
				Main.sound.playFX(snd);
			}
		}
		public function lessRespin (e:MouseEvent) {
			if (respins > 0 && !spinning) {
				//give them money
				gold += spinCost;
				spentGold -= spinCost;
				//update gold
				yourGold.text = "You have " + gold + " gold.";
				respins --;
				respin.text = "RESPINS = " + respins;
				//play buy sound CONSIDER CHANGING THIS SOUND
				var snd:Sound = new PickupCoin;
				Main.sound.playFX(snd);
			}
		}
		public function p1 (e:MouseEvent) {
			//added and removed used to see if you need to redraw the wheel, cause they could click on things and not be able to do them
			var removed:Boolean = false;
			var added:Boolean = false;
			if (!spinning) {
				if (e.target.selected) {
					if (gold - passiveCost > 0) {
						gold -= passiveCost;
						spentGold += passiveCost;
						yourGold.text = "You have " + gold + " gold.";
						removed = true;
						//pay sound
						//play buy sound
						var snd:Sound = new PickupCoin;
						Main.sound.playFX(snd);
					}else {
						e.target.selected = false;
						//can't do that sound
						// display you broke
						var snd:Sound = new CantSelect;
						Main.sound.playFX(snd);
					}
				}else {
					gold += passiveCost;
					spentGold -= passiveCost;
					added = true;
					yourGold.text = "You have " + gold + " gold.";
					//play buy sound
					var snd:Sound = new PickupCoin;
					Main.sound.playFX(snd);
				}
				switch (e.target) {
					case passive1Check:
						if (removed) {
							activePassives.splice(activePassives.indexOf(1),1);
						}else if (added) {
							activePassives.push(1);
						}
						break;
					case passive2Check:
						if (removed) {
							activePassives.splice(activePassives.indexOf(2),1);
						}else if (added) {
							activePassives.push(2);
						}
						break;
					case passive3Check:
						if (removed) {
							activePassives.splice(activePassives.indexOf(3),1);
						}else if (added) {
							activePassives.push(3);
						}
						break;
					case passive4Check:
						if (removed) {
							activePassives.splice(activePassives.indexOf(4),1);
						}else if (added) {
							activePassives.push(4);
						}
						break;
					case passive5Check:
						if (removed) {
							activePassives.splice(activePassives.indexOf(5),1);
						}else if (added) {
							activePassives.push(5);
						}
						break;
					case passive6Check:
						if (removed) {
							activePassives.splice(activePassives.indexOf(6),1);
						}else if (added) {
							activePassives.push(6);
						}
						break;
					default:
						//nothing
				}
				if (added || removed) {
					//redraw
					draw();
				}
			}else{
				e.target.selected = (!e.target.selected);
				//play can't do that sound
				var snd:Sound = new CantSelect;
				Main.sound.playFX(snd);
			}			
		}
		public function draw() {
			//draw the wheel at the beginning
			if (wheel == null) {
				var sections:int = activePassives.length;
				//in degrees
				var angle:Number = 360 / sections;
				//draw the wheel
				wheel = new Sprite;
				wheel.x = -137.3;
				wheel.y = .45;
				addChild(wheel);
				wheel.graphics.beginFill(0x0099FF,1);
				wheel.graphics.drawCircle(0, 0, radius);
				wheel.graphics.endFill();
			}else {
				wheel.graphics.clear();
				wheel.graphics.beginFill(0x0099FF,1);
				wheel.graphics.drawCircle(0, 0, radius);
				wheel.graphics.endFill();
				//and clear the texts
				for (var i:int = wheel.numChildren - 1; i >= 0; i --) {
					wheel.removeChild(wheel.getChildAt(i));
				}
			}
			findPoints();
			//add lines to separate the sections
			wheel.graphics.lineStyle(2, 0xFF0000,1);
			for (var i:int = 0; i < point.length; i++) {
				wheel.graphics.moveTo(0,0);
				wheel.graphics.lineTo(point[i].x, point[i].y);
				wheel.graphics.moveTo(0,0);
			}
			//add text in the correct spots at the appropriate angles
		}
		public function findPoints() {
			point.splice(0, point.length);
			var sections:int = activePassives.length;
			var angle:Number = 360 / sections;
			//convert to radians for the trig functions
			angle *= Math.PI/180;
			/*var needed:int = sections - 1;*/
			var newAngle = 0;
			var format1:TextFormat = new TextFormat("Silom", 8, 0x000000);
			for (var i:int = 0; i < sections; i++) {
				//use angle
				//find point
				var newX:int = radius * Math.cos(newAngle);
				var newY:int = (radius * Math.sin(newAngle)) * -1;
				//add point
				var newPoint:Point = new Point(newX, newY);
				point.push(newPoint);
				var textAngle = newAngle + angle/2;
				newX = (radius - 20) * Math.cos(textAngle);
				newY = ((radius - 20) * Math.sin(textAngle)) * -1;
				var text:TextField = new TextField;
				text.height = 8;
			/*	text.background = true;
				text.backgroundColor = 0xFFFFFF;*/
				text.textColor = 0x000000;
				text.autoSize = TextFieldAutoSize.LEFT;
				text.embedFonts = true;
				text.width = 100;
				text.defaultTextFormat = format1;
				text.x = newX;
				text.y = newY;
				switch (activePassives[i]) {
					case 1:
						text.text = text1;
						break;
					case 2:
						text.text = text2;
						break;
					case 3:
						text.text = text3;
						break;
					case 4:
						text.text = text4;
						break;
					case 5:
						text.text = text5;
						break;
					case 6:
						text.text = text6;
						break;
					default:
						//nothing
				}
				text.x -= text.width/2;
				text.y -= text.height/2;
				wheel.addChild(text);
				//change angle
				newAngle += angle;
				//if angle > 180 then it becomes negative...
			}
		}
		public function SpinIt (e:MouseEvent) {
			if (startSpin) {
				startSpin = false;
				addEventListener(Event.ENTER_FRAME, loop);
				rando = Math.abs((Math.random() * 100));
				spinning = true;
				//play spin sound 
				//code
			}else {
				//play can't do that sound
				var snd:Sound = new CantSelect;
				Main.sound.playFX(snd);
			}
		}
		public function loop(e:Event) {
			//this is for the spinning wheel
			wheel.rotation += rando;
			/*wheel.rotation = 2;*/
			rando *= 1 - decel;
			//flip text
			//var lastCheck = wheelFlipped;
			//if (wheel.rotation < 0) {
			//	wheelFlipped = true;
			//	/*trace("running rotation > 180");*/
			//	if (wheelFlipped != lastCheck) {
			//		for (var i:int = 0; i < wheel.numChildren; i++) {
			//			//flip text and adjust x and y
			//			trace("children rotation previous = " + wheel.getChildAt(i).rotation);
			//			wheel.getChildAt(i).rotation = 180;
			//			trace("children rotation now = " + wheel.getChildAt(i).rotation);
			//		}
			//	}
			//}else {
			//	wheelFlipped = false;
			//	if (wheelFlipped != lastCheck) {
			//		for (var i:int = 0; i < wheel.numChildren; i++) {
			//			//flip text and adjust x and y
			//			trace("children rotation previous = " + wheel.getChildAt(i).rotation);
			//			wheel.getChildAt(i).rotation = 0;
			//			trace("children rotation now = " + wheel.getChildAt(i).rotation);
			//		}
			//	}
			//}
			
			/*decel *= (1.2/60);*/
			if (rando < .06) {
				spinning = false;
				removeEventListener(Event.ENTER_FRAME, loop);
				//declare the winning selection
				rando = 0;
				var ro = wheel.rotation;
				//convert - ro's to a positive angle and fuck you actionscript
				if (ro < 0) {
					ro = Math.abs(ro);
					ro = 180 - ro;
					ro += 180;
				}
				var sections:int = activePassives.length;
				var angle = 360 / sections;
				//find the angle that is greater than ro
				var newAngle = 0;
				var index:int;
				for (var i:int = 0; i <= activePassives.length; i ++) {
					if (ro < newAngle) {
						//set passive
						index = i - 1;
						winner = activePassives[index];
						declareWinner(winner);
						break;
					}else if(i == activePassives.length) {
						//it's the last section
						index = i;
						winner = activePassives[index];
						declareWinner(winner);
					}					
					newAngle += angle;
				}
			}
		}
		public function declareWinner(winner) {
			box = new Sprite;
			box.graphics.beginFill(0xFFFFFF, 1);
			box.graphics.drawRect(0, 0, 250, 250);
			box.graphics.endFill();
			box.x = -box.width/2;
			box.y = -box.height/2;
			addChild(box);
			var win:TextField = new TextField();
			var format1:TextFormat = new TextFormat("Silom", 12, 0x000000);
			win.defaultTextFormat = format1;
			if (winner == 1) {
				win.text = "You've won " + text1;
				selectedPassive = text1;
			}else if (winner == 2) {
				win.text = "You've won " + text2;
				selectedPassive = text2;
			}else if (winner == 3) {
				win.text = "You've won " + text3 + ".Just Press CAPSLOCK to activate";
				win.wordWrap = true;
				selectedPassive = text3;
			}else if (winner == 4) {
				win.text = "You've won " + text4;
				selectedPassive = text4;
			}else if (winner == 5) {
				win.text = "You've won " + text5;
				selectedPassive = text5;
			}else if (winner == 6) {
				win.text = "You've won " + text6;
				selectedPassive = text6;
			}
			win.width = 200;
			win.x = box.height/2 - win.width/2;
			win.y = box.width/2 - win.height/2;
			box.addChild(win);
			confirm = new Button;
			confirm.y = box.height/2 + 100;
			confirm.x = box.width/2 - 60 - confirm.width/2;
			confirm.label = "accept";
			confirm.focusEnabled = false;
			confirm.addEventListener(MouseEvent.CLICK, confirmation);
			box.addChild(confirm);
			if (respins > 0 ) {
				respin1 = new Button;
				respin1.y = confirm.y;
				respin1.x = box.width/2 + 20;
				respin1.label = "respin";
				/*respin1.focusEnabled = false;*/
				respin1.addEventListener(MouseEvent.CLICK, respinPlz);
				box.addChild(respin1);
			}
			//play winner sound
			//code
		}
		public function confirmation(e:MouseEvent) {
			//remove the casino
			if (respin1 != null) {
				respin1.removeEventListener(MouseEvent.CLICK, respinPlz);
			}
			confirm.removeEventListener(MouseEvent.CLICK, confirmation);
			for (var i:int = box.numChildren - 1; i >= 0; i --) {
				box.removeChild(box.getChildAt(i));
			}
			confirm = null;
			respin1 = null;
			removeChild(box);
			box = null;
			//testing
			/*selectedPassive = "Secret";*/
			if (selectedPassive == "Hit Points ++") {
				LazerCatAttack.you.hitPoints += hitPointBuff;
				LazerCatAttack.huD.updateHitPoints(-hitPointBuff);
			}else if (selectedPassive == "Secret") {
				/*var extraMan:Player = new Player;
				extraMan.x = 50;
				extraMan.y = LazerCatAttack.you.y;
				LazerCatAttack.game.addChild(extraMan);*/
				//this seems to fuck up the crusher after restarting on lv3
				LazerCatAttack.you.width += 7;
				LazerCatAttack.you.height += 7;
			}
			//take selected passive and send it to the right people to initiate it
			LazerCatAttack.game.removeChild(this);
			if (LazerCatAttack.game.passive1 == "none") {
				LazerCatAttack.game.passive1 = selectedPassive;
				if (selectedPassive == "Slow Time Ability") {
					LazerCatAttack.you.passive1 = "Slow Time Ability";
				}else if (selectedPassive == "Double Fire") {
					LazerCatAttack.you.passive1 = "Double Fire";
				}else if (selectedPassive == "Sheep 4 The Win") {
					LazerCatAttack.you.passive1 = "Sheep 4 The Win";
				}
				trace("found no game passive1 @ Casino");
			}else {
				if (selectedPassive == "Slow Time Ability") {
					LazerCatAttack.you.passive2 = "Slow Time Ability";
				}else if (selectedPassive == "Double Fire") {
					LazerCatAttack.you.passive2 = "Double Fire";
				}else if (selectedPassive == "Sheep 4 The Win") {
					LazerCatAttack.you.passive2 = "Sheep 4 The Win";
				}
				LazerCatAttack.game.passive2 = selectedPassive;
				trace("set Game passive2 to be " + selectedPassive);
			}
			LazerCatAttack.game.spentCasinoGold = spentGold;
			LazerCatAttack.gameTimer.start();
		}
		public function respinPlz (e:MouseEvent) {
			//remove the box
			respin1.removeEventListener(MouseEvent.CLICK, respinPlz);
			confirm.removeEventListener(MouseEvent.CLICK, confirmation);
			for (var i:int = box.numChildren - 1; i >= 0; i --) {
				box.removeChild(box.getChildAt(i));
			}
			confirm = null;
			respin1 = null;
			removeChild(box);
			box = null;
			//change the number of respins
			respins --;
			respin.text = "RESPINS = " + respins;
			//start the spinning of the wheel
			addEventListener(Event.ENTER_FRAME, loop);
			rando = Math.abs((Math.random() * 100));
			spinning = true;
		}
	}
	
}
