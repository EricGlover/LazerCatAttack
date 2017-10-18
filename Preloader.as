package
{
    import flash.display.LoaderInfo;
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.ProgressEvent;
     
    public class Preloader extends MovieClip{
		
        public function Preloader(){
			mouseEnabled = false;
		}
         
        public function setLoaderInfo(ldrInf:LoaderInfo):void{
            ldrInf.addEventListener(ProgressEvent.PROGRESS, onProgress);
            ldrInf.addEventListener(Event.COMPLETE, onComplete);
        }
         
        private function onProgress(e:ProgressEvent):void{
            var percent:int = Math.round(e.bytesLoaded / e.bytesTotal * 100);
            progressBar.width = percent / 100 * progressArea.width;
            percentLoad.text = percent + "%";
        }
         
        private function onComplete(e:Event):void{
            dispatchEvent(e);
        }
    }
}