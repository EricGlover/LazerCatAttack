
package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import fl.events.SliderEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	public class OptionsScreen extends MovieClip {
		public var created:Boolean = false;
		public var fx:SoundChannel;
		public static var fxVal:Number;
		public static var musicVal:Number;
		//class notes, thumbdrag is dispatched even when the position hasn't changed.
		//change is only dispatched when slider is released LIVE DRAGGING ENABLES THAT
		//music shouldn't create a new song everytime
		public function OptionsScreen() {
			musicSlider.addEventListener(SliderEvent.CHANGE, musicSlide );
			musicSlider.addEventListener(SliderEvent.THUMB_PRESS, musicSlide);
			/*musicSlider.addEventListener(SliderEvent.THUMB_RELEASE, musicSlide);*/
			musicSlider.addEventListener(SliderEvent.THUMB_DRAG, musicSlide);
			fxSlider.addEventListener(SliderEvent.CHANGE,  fxSlide);
			/*fxSlider.addEventListener(SliderEvent.THUMB_RELEASE, fxSlide);*/
			fxSlider.addEventListener(SliderEvent.THUMB_DRAG, fxSlide);
			fxSlider.addEventListener(SliderEvent.THUMB_PRESS, fxSlide);
			musicSlider.focusEnabled = false;
			fxSlider.focusEnabled = false;
			OptionsScreen.fxVal = Main.sound.fxVol * 100;
			OptionsScreen.musicVal = Main.sound.mVol * 100;
			/*musicSlider.value = OptionsScreen.musicVal;
			fxSlider.value = OptionsScreen.fxVal;*/
		}
		public function fxSlide(e:SliderEvent) {
			/*trace("IMMMA DOIN THINGS");*/
			mouseEnabled = false;
			//change the fx setting DO THE MEOW INSTEAD
			if (e.type == "thumbPress") {
				var snd:Sound = new MissileFX();
				fx = snd.play(0, 1000, Main.sound.fxSound)
			}else if (e.type == "change" ) {
				fx.stop();
				fx = null;
			}else if (e.type == "thumbDrag"){
				var fxVol:Number = fxSlider.value / 100;
				Main.sound.setFx(fxVol);
				var testVol:SoundTransform = new SoundTransform(fxVol);
				fx.soundTransform = testVol;
			}
		}
		public function musicSlide(e:SliderEvent) {
			//change the music vol setting
			//what if music != null ?
			//consider saving previous postion of music
			/*trace("IMMMA DOIN THINGS TOO");*/
			if (e.type == "thumbPress") {
				if (Main.sound.channel1 == null) {
					var snd:Sound = new ChibiNinja();
					Main.sound.channel1 = snd.play(0,0);
					created = true;
				}else if (Main.sound.channel1 != null) {
					
				}
			}else if (e.type == "change") {
				//change mVol and stop music
				if (created) {
					Main.sound.channel1.stop();
					Main.sound.channel1 = null;
				}else {
					created = false;
				}
			}else if (e.type == "thumbDrag") {
				//change mVol every so often
				/*trace("slider position = " + musicSlider.value);*/
				var newVol:Number = musicSlider.value / 100;
				Main.sound.setMusicVol(newVol);
			}
			/*trace("e.type = " + e.type);*/
		}
		public function remove() {
			musicSlider.removeEventListener(SliderEvent.CHANGE, musicSlide );
			musicSlider.removeEventListener(SliderEvent.THUMB_PRESS, musicSlide);
			/*musicSlider.addEventListener(SliderEvent.THUMB_RELEASE, musicSlide);*/
			musicSlider.removeEventListener(SliderEvent.THUMB_DRAG, musicSlide);
			fxSlider.removeEventListener(SliderEvent.CHANGE,  fxSlide);
			/*fxSlider.addEventListener(SliderEvent.THUMB_RELEASE, fxSlide);*/
			fxSlider.removeEventListener(SliderEvent.THUMB_DRAG, fxSlide);
			fxSlider.removeEventListener(SliderEvent.THUMB_PRESS, fxSlide);
		}
	}
	
}
