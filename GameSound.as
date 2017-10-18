package  {
	import flash.media.SoundMixer;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	
	public class GameSound {
		//is this necessary with the array, I believe the array is necessary for fade outs
		private var music1:Sound;
		public var channel1:SoundChannel;
		private var channel2:SoundChannel;
		private var gameMixer:SoundMixer = new SoundMixer;
		private var fx:Vector.<SoundChannel>;
		//if the loops seem annoyingly repetive just use the music array to fade in different segements
		//from different songs.
		private var music:Vector.<SoundChannel>;
		//public for glitch sounds
		public var glitch:Vector.<SoundChannel>;
		public var fxSound:SoundTransform = new SoundTransform(.35);
		//made public for the glitch sound part of the boss
		public var fxVol:Number = .35;
		public var mVol:Number = .4;
		private var oldMVol:Number;
		private var oldFXVol:Number;
		public var currentMusic:String = "none";
		private var musicSet = false;
		private var fadeTime:int = 5;
		private var fadeVolChange:Number = 0;
		private var inVol:Number = 0.001;
		private var outVol:Number = 0;
		private var doIn:Boolean = true;
		private var doOut:Boolean = true;
		private var fadeIn:SoundChannel;
		private var fadeOut:SoundChannel;
		private var fadeCount:int = 0;
		private var fading:Boolean = false;
		
		//fade 5 before stop
		//Times 1000 cause sound.play takes milliseconds
		//recently changed numbers to ints in these vars
		//chibi ninja
		private var lv1LoopStart:int = 0;
		private var lv1LoopStop:int = 118;
		//station intense part
		private var lv1BossMusicStart:int = 120;
		private var lv1BossMusicStop:int = 220;
		//Until I sleep
		private var lv2LoopStart:int = 0;
		private var lv2LoopStop:int = 235; //3:55
		//Blown Away 0 - 3:00
		private var lv2BossMusicStart:int = 0;
		private var lv2BossMusicStop:int = 180;
		//okiiroba station
		private var lv3LoopStart:int = 0;
		private var lv3LoopStop:int = 117;
		//OkiiroboNav. Intense
		private var lv3BossMusicStart:int = 120;
		private var lv3BossMusicStop:int = 220;
		
		private var count:int = 0;
		
		public function GameSound() {
			// constructor code
			//need I have anything in here?
			fx = new <SoundChannel>[];
			/*music = new Array();*/
		}
		public function setMusicVol(number) {
			var newMVol:SoundTransform = new SoundTransform(number);
			mVol = number;
			/*for (var i:int = 0; i < music.length; i++ ) {
				music[i].SoundTransform = newMVol;
			}*/
			if (channel1 != null) {
				channel1.soundTransform = newMVol;
			}else if (channel2 != null) {
				channel2.soundTransform = newMVol;
			}
		}
		//set's the fx vol, should probably also change all active fx vol as well
		public function setFx(number) {
			var newFX:SoundTransform = new SoundTransform(number);
			fxVol = number;
			fxSound = newFX;
			for (var i:int = 0; i < fx.length; i++) {
				fx[i].soundTransform = newFX;
			}
		}
		//removes fx from the active fx array
		public function completedFX(e:Event) {
			/*e.removeEventListener(Event.SOUND_COMPLETE, completedFX);*/
			//figure that out later
			fx.splice(fx.indexOf(e),1);
		}
		public function mute(e:MouseEvent) {
			//find all sound channels that aren't fx and pause them
			//or not? Maybe just attached sound transform objects to all sounds where volume = 0;
			//also unmute if button not toggeld.....ugh
			if (e.target.selected) {
				oldMVol = mVol;
				oldFXVol = fxVol;
				setFx(0);
				setMusicVol(0);
			}else if (!e.target.selected) {
				fxVol = oldFXVol;
				mVol = oldMVol;
				setFx(fxVol);
				setMusicVol(mVol);
			}	
			/*e.target.tabEnabled = false;*/
		}
		//these functions are called when the game loses and regains system focus
		public function pauseMusic() {
			oldMVol = mVol;
			oldFXVol = fxVol;
			setFx(0);
			setMusicVol(0);
			/*channel1.stop();
			channel2.stop();*/
		}
		public function unPauseMusic() {
			fxVol = oldFXVol;
			mVol = oldMVol;
			setFx(fxVol);
			setMusicVol(mVol);
			/*channel1.
			channel2.start();*/
		}
		public function musicTimer(e:TimerEvent) {
			//this waits until music has been playing for so long and then orchestrates the switch out of music
			//should count be the actual time or the music progress?
			//channel.progress return a Number in milliseconds
			/*trace("musicTimer is running");
			trace("count = " + count);
			trace("position = " + channel1.position);*/
			//set all your own counts so that I can use count = 0 for transitions
			if (channel1.position >= count) {
				//execute fade in and fade out
				trace("currentMusic = " + currentMusic);
				switch (currentMusic) {
					case "lv1Loop" :
						trace("ran the musicTimer lv1Loop section");
						//change the channels here
						//channel 2 is the exclusive fade out channel so that the loop timer will work
						//set channel 1 to two, then start channel 1
						var time:int = lv1LoopStop;
						count = time * 1000;
						var transitionSpot:Number = channel1.position;
						//might not work with this
						channel1.stop();
						if (music1 is OkiiroboNavigationSystem) {
							var sameSound:Sound = new OkiiroboNavigationSystem();
						}else if (music1 is UntilSleep) {
							var sameSound:Sound = new UntilSleep();
						}else if (music1 is ChibiNinja) {
							var sameSound:Sound = new ChibiNinja();
						}else if (music1 is BlownAway) {
							var sameSound:Sound = new BlownAway();
						}
						//mVol is the Number setting of the current vol for music transformation blah
						var newMVol:SoundTransform = new SoundTransform(mVol);
						channel2 = sameSound.play(transitionSpot, 0, newMVol);
						music1 = new ChibiNinja();
						var vol:SoundTransform = new SoundTransform(inVol);
						var start:Number = lv1LoopStart * 1000;
						channel1 = music1.play(start, 0, vol);
						fadeOut = channel2;
						fadeIn = channel1;
						doOut = true;
						doIn = true;
						fadeVolChange = mVol/(fadeTime * LazerCatAttack.frameSpeed);
						fadeTime = 5;
						Main.main.mainTimer.addEventListener(TimerEvent.TIMER, fade);
						outVol = mVol;
						inVol = .001;
						fading = true;
						break;
					case "lv1BossMusic" :
						trace("lv1BossMusic running");
						var time:int = lv1BossMusicStop;
						count = time * 1000;
						var transitionSpot:Number = channel1.position;
						channel1.stop();
						if (music1 is OkiiroboNavigationSystem) {
							var sameSound:Sound = new OkiiroboNavigationSystem();
						}else if (music1 is UntilSleep) {
							var sameSound:Sound = new UntilSleep();
						}else if (music1 is ChibiNinja) {
							var sameSound:Sound = new ChibiNinja();
						}else if (music1 is BlownAway) {
							var sameSound:Sound = new BlownAway();
						}
						//mVol is the Number setting of the current vol for music transformation blah
						var newMVol:SoundTransform = new SoundTransform(mVol);
						channel2 = sameSound.play(transitionSpot, 0, newMVol);
						var vol:SoundTransform = new SoundTransform(inVol);
						music1 = new OkiiroboNavigationSystem();
						var start:Number = lv1BossMusicStart * 1000;
						channel1 = music1.play(start, 0, vol);
						trace("channel1 position = " + channel1.position);
						fadeOut = channel2;
						fadeIn = channel1;
						//what da fuk will fix this glitch????
						fadeCount = 0;
						doOut = true;
						doIn = true;
						fadeVolChange = mVol/(fadeTime * LazerCatAttack.frameSpeed);
						fadeTime = 7;
						Main.main.mainTimer.addEventListener(TimerEvent.TIMER, fade);
						outVol = mVol;
						inVol = .001;
						fading = true;
						break;
					case "lv2Loop" :
						var time:int = lv2LoopStop;
						count = time * 1000;
						var transitionSpot:Number = channel1.position;
						//might not work with this
						channel1.stop();
						if (music1 is OkiiroboNavigationSystem) {
							var sameSound:Sound = new OkiiroboNavigationSystem();
						}else if (music1 is UntilSleep) {
							var sameSound:Sound = new UntilSleep();
						}else if (music1 is ChibiNinja) {
							var sameSound:Sound = new ChibiNinja();
						}else if (music1 is BlownAway) {
							var sameSound:Sound = new BlownAway();
						}
						//mVol is the Number setting of the current vol for music transformation blah
						var newMVol:SoundTransform = new SoundTransform(mVol);
						channel2 = sameSound.play(transitionSpot, 0, newMVol);
						music1 = new UntilSleep();
						var vol:SoundTransform = new SoundTransform(inVol);
						channel1 = music1.play(lv2LoopStart * 1000, 0, vol);
						fadeOut = channel2;
						fadeIn = channel1;
						doOut = true;
						doIn = true;
						fadeVolChange = mVol/(fadeTime * LazerCatAttack.frameSpeed);
						fadeTime = 5;
						Main.main.mainTimer.addEventListener(TimerEvent.TIMER, fade);
						outVol = mVol;
						inVol = .001;
						fading = true;
						break;
					case "lv2BossMusic":
						var time:int = lv2BossMusicStop;
						count = time * 1000;
						var transitionSpot:Number = channel1.position;
						//might not work with this
						channel1.stop();
						if (music1 is OkiiroboNavigationSystem) {
							var sameSound:Sound = new OkiiroboNavigationSystem();
						}else if (music1 is UntilSleep) {
							var sameSound:Sound = new UntilSleep();
						}else if (music1 is ChibiNinja) {
							var sameSound:Sound = new ChibiNinja();
						}else if (music1 is BlownAway) {
							var sameSound:Sound = new BlownAway();
						}
						//mVol is the Number setting of the current vol for music transformation blah
						var newMVol:SoundTransform = new SoundTransform(mVol);
						channel2 = sameSound.play(transitionSpot, 0, newMVol);
						music1 = new BlownAway();
						var vol:SoundTransform = new SoundTransform(inVol);
						channel1 = music1.play(lv2BossMusicStart * 1000, 0, vol);
						fadeOut = channel2;
						fadeIn = channel1;
						doOut = true;
						doIn = true;
						fadeVolChange = mVol/(fadeTime * LazerCatAttack.frameSpeed);
						Main.main.mainTimer.addEventListener(TimerEvent.TIMER, fade);
						outVol = mVol;
						inVol = .001;
						fading = true;
						break;
					case "lv3Loop":
						var time:int = lv3LoopStop;
						count = time * 1000;
						var transitionSpot:Number = channel1.position;
						//might not work with this
						channel1.stop();
						if (music1 is OkiiroboNavigationSystem) {
							var sameSound:Sound = new OkiiroboNavigationSystem();
						}else if (music1 is UntilSleep) {
							var sameSound:Sound = new UntilSleep();
						}else if (music1 is ChibiNinja) {
							var sameSound:Sound = new ChibiNinja();
						}else if (music1 is BlownAway) {
							var sameSound:Sound = new BlownAway();
						}
						//mVol is the Number setting of the current vol for music transformation blah
						var newMVol:SoundTransform = new SoundTransform(mVol);
						channel2 = sameSound.play(transitionSpot, 0, newMVol);
						music1 = new OkiiroboNavigationSystem();
						var vol:SoundTransform = new SoundTransform(inVol);
						channel1 = music1.play(lv3LoopStart * 1000, 0, vol);
						fadeOut = channel2;
						fadeIn = channel1;
						doOut = true;
						doIn = true;
						fadeVolChange = mVol/(fadeTime * LazerCatAttack.frameSpeed);
						Main.main.mainTimer.addEventListener(TimerEvent.TIMER, fade);
						outVol = mVol;
						inVol = .001;
						fading = true;
						break;
					case "lv3BossMusic":
						var time:int = lv3BossMusicStop;
						count = time * 1000;
						var transitionSpot:Number = channel1.position;
						//might not work with this
						channel1.stop();
						if (music1 is OkiiroboNavigationSystem) {
							var sameSound:Sound = new OkiiroboNavigationSystem();
						}else if (music1 is UntilSleep) {
							var sameSound:Sound = new UntilSleep();
						}else if (music1 is ChibiNinja) {
							var sameSound:Sound = new ChibiNinja();
						}else if (music1 is BlownAway) {
							var sameSound:Sound = new BlownAway();
						}
						//mVol is the Number setting of the current vol for music transformation blah
						var newMVol:SoundTransform = new SoundTransform(mVol);
						channel2 = sameSound.play(transitionSpot, 0, newMVol);
						music1 = new OkiiroboNavigationSystem();
						var vol:SoundTransform = new SoundTransform(inVol);
						channel1 = music1.play(lv3BossMusicStart * 1000, 0, vol);
						fadeOut = channel2;
						fadeIn = channel1;
						doOut = true;
						doIn = true;
						fadeVolChange = mVol/(fadeTime * LazerCatAttack.frameSpeed);
						Main.main.mainTimer.addEventListener(TimerEvent.TIMER, fade);
						outVol = mVol;
						inVol = .001;
						fading = true;
						break;
					case "Menu":
						/*var time:int = */
						//trace("Menu sound is running");
						//var time:int = lv3BossMusicStop;
						//count = time * 1000;
						//var transitionSpot:Number = channel1.position;
						////might not work with this
						//channel1.stop();
						//if (music1 is OkiiroboNavigationSystem) {
						//	var sameSound:Sound = new OkiiroboNavigationSystem();
						//}else if (music1 is UntilSleep) {
						//	var sameSound:Sound = new UntilSleep();
						//}else if (music1 is ChibiNinja) {
						//	var sameSound:Sound = new ChibiNinja();
						//}else if (music1 is BlownAway) {
						//	var sameSound:Sound = new BlownAway();
						//}
						////mVol is the Number setting of the current vol for music transformation blah
						//var newMVol:SoundTransform = new SoundTransform(mVol);
						//channel2 = sameSound.play(transitionSpot, 0, newMVol);
						///*music1 = new OkiiroboNavigationSystem();*/
						//var vol:SoundTransform = new SoundTransform(inVol);
						///*channel1 = music1.play(lv3BossMusicStart * 1000, 0, vol);*/
						//fadeOut = channel2;
						///*fadeIn = channel1;*/
						//doOut = true;
						///*doIn = true;*/
						//doIn = false;
						//fadeVolChange = mVol/(fadeTime * LazerCatAttack.frameSpeed);
						//Main.main.mainTimer.addEventListener(TimerEvent.TIMER, fade);
						//outVol = mVol;
						//inVol = .001;
						channel1.stop();
						channel1 = null;
						Main.main.mainTimer.removeEventListener(TimerEvent.TIMER, musicTimer);
						if (fading) {
							Main.main.mainTimer.removeEventListener(TimerEvent.TIMER, fade);
						}
						musicSet = false;
						break;
					default:
						trace("musicTimer fucked up");
				}
			}

			/*trace("music position = " + channel1.position);*/
			/*Main.main.mainTimer.removeEventListener(TimerEvent.TIMER, musicTimer);*/
		}
		public function fade(e:TimerEvent) {
			//set channel 2 to channel 1 when fade is completed
			//figure out how to set inVol and outVol
			//vars needed to be set fadeOut, fadeIn, doOut, doIn, && it handles inVol/Volin; outVol/VolOut
			//if you reset volume during a fade this will fuck up the fade...... but then reset
			/*fadeVolChange = mVol/(fadeTime * LazerCatAttack.frameSpeed);*/
			fadeCount++;
			//probably change how the fadeVolChange works....
			//fade in
			if (doIn) {
				inVol += fadeVolChange;
				var increasedVol:SoundTransform = new SoundTransform(inVol);
				channel1.soundTransform = increasedVol;
			}else{ 
				channel1.stop();
			}	
			//fade out
			if (doOut) {
				outVol -= fadeVolChange;
				var decreasedVol:SoundTransform = new SoundTransform(outVol);
				channel2.soundTransform = decreasedVol;
			}else {
				//should it do this???
				channel2.stop();
			}
			if (fadeCount >= fadeTime * LazerCatAttack.frameSpeed) {
				var finalVol:SoundTransform = new SoundTransform(mVol);
				channel1.soundTransform = finalVol;
				channel2.stop();
				Main.main.mainTimer.removeEventListener(TimerEvent.TIMER, fade);
				fading = false;
				fadeCount = 0;
			}
		}
		
		public function lv1Music() {
			
			/*music.push(channel1);*/
			/*channel1.addEventListener(Event.SOUND_COMPLETE, completedMusic);*/
			/*setMTimer(lv1LoopStop);*/
			//make sure that only the first game entry point does this
			if (!musicSet) {
				Main.main.mainTimer.addEventListener(TimerEvent.TIMER, musicTimer);
				musicSet = true;
				var time:int = lv1LoopStop;
				count = time * 1000;
				music1 = new ChibiNinja();
				var newMVol:SoundTransform = new SoundTransform(mVol);
				channel1 = music1.play(lv1LoopStart, 0, newMVol);
			}else {
				count = 0;
			}
			
			//set the music Timer vars, convert time from seconds based to milliseconds
			currentMusic = "lv1Loop";
		}
		public function lv1BossMusic() {
			currentMusic = "lv1BossMusic";
			count = 0;
			
		}
		public function lv2Music() {
			//how to determine if starting on lv2 or if music is not already running
			if (!musicSet) {
				Main.main.mainTimer.addEventListener(TimerEvent.TIMER, musicTimer);
				musicSet = true;
				var time:int = lv2LoopStop;
				count = time * 1000;
				music1 = new UntilSleep();
				var newMVol:SoundTransform = new SoundTransform(mVol);
				channel1 = music1.play(lv2LoopStart, 0, newMVol);
			}else{
				count = 0;
			}
			currentMusic = "lv2Loop";
		}
		public function lv2BossMusic() {
			currentMusic = "lv2BossMusic";
			count = 0;
		}
		public function lv3Music() {
			if (!musicSet) {
				Main.main.mainTimer.addEventListener(TimerEvent.TIMER, musicTimer);
				musicSet = true;
				var time:int = lv3LoopStop;
				count = time * 1000;
				music1 = new OkiiroboNavigationSystem();
				var newMVol:SoundTransform = new SoundTransform(mVol);
				channel1 = music1.play(lv3LoopStart, 0, newMVol);
			}else{
				count = 0;
			}
			currentMusic = "lv3Loop";
		}
		public function lv3BossMusic() {
			currentMusic = "lv3BossMusic";
			count = 0;
		}
		//glitch boss will call this then will call lv3GlitchSoundReset to reset the sounds.
		public function lv3GlitchSound() {
			//don't know how to work the resetting of the sound really
			channel1.stop();
			channel2.stop();
			glitch = new <SoundChannel>[];
		}
		public function lv3GlitchSoundReset() {
			trace("@gameSound, glitchSound reset called");
			for (var i:int = glitch.length - 1; i >= 0; i --) {
				//should I declare the datatype? potential problems there
				var channel:SoundChannel = glitch[i];
				channel.stop();
				glitch.pop();
			}
			//not a perfect reset because just calling the musicTimer will cause the non-playing old music on
			//music channel 1 to start playing again and then fading out immediately
			//consider reworking
			currentMusic = "lv3BossMusic";
			count = 0;
		}
		public function backToMain() {
			currentMusic = "Menu";
			count = 0;
		}
		//perhaps it would be better for everything to just pass the sound to this class...
		public function playFX(snd:Sound) {
			fxSound = new SoundTransform(fxVol);
			var fx1:SoundChannel = snd.play(0,0, fxSound);
			fx1.addEventListener(Event.SOUND_COMPLETE, completedFX);
			fx.push(fx1);
			//when complete you should delete this 
		}
		
	}
	
}
