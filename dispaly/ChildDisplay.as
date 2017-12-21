package {
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import flash.system.System;
	import com.jumpeye.Events.FLASHEFFEvents;

	public class ChildDisplay extends MovieClip {
		private var displayWidth:int;
		private var displayHeight:int;
		private var url:String;
		private var disWidth:Number;
		private var disHeight:Number;
		private var type:String;
		private var xmlChildRequest:URLRequest;
		private var xmlChildLoader:Loader = new Loader();
		private var display:Sprite;
		private var isInLoading:Boolean = true;

		public function ChildDisplay(_url:String,_width:Number,_height:Number,_type:String,_displayWidth:int,_displayHeight:int) {
			super();
			url = _url;
			disWidth = _width;
			disHeight = _height;
			type = _type;
			displayWidth = _displayWidth;
			displayHeight = _displayHeight;
		}
		private var loadPercent:TextField;
		public function beginLoad(_display:Sprite,_loadPercent:TextField,mask_mc:MovieClip):void {
			isInLoading = true;
			display = _display;
			loadPercent = _loadPercent;
			xmlChildRequest = new URLRequest(url);
			xmlChildLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,childCompleteHandle);
			xmlChildLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,progressHandle);
			xmlChildLoader.load(xmlChildRequest);
			display.mask = mask_mc;

		}
		private function progressHandle(e:ProgressEvent):void {
			loadPercent.text = e.bytesLoaded+' / '+e.bytesTotal;
		}
		private var lsBitmap:Bitmap;
		private var lsMovieClip:MovieClip = new MovieClip();
		private function childCompleteHandle(e:Event):void {
			isInLoading = false;
			loadPercent.text = '';
			trace('typeof '+ typeof(xmlChildLoader.content ));
			switch (type) {
				case 'bmp' :
					lsBitmap = xmlChildLoader.content as Bitmap;
					lsBitmap.width = disWidth;
					lsBitmap.height = disHeight;
					lsBitmap.x=0;
					lsBitmap.y=0;
					
					lsMovieClip.addChild(lsBitmap);

					break;
				case 'swf' :
					var swf_1 = e.target.loader.content;
					trace('displayWidth  '+displayWidth+' '+disWidth);
					trace('displayHeight '+displayHeight+' '+disHeight);
					//swf_1.x = (displayWidth - disWidth)/2
					//swf_1.y = (displayHeight - disHeight)/2
					swf_1.x =0;
					swf_1.y =0;
					
					lsMovieClip.addChild(swf_1);
					
					break;
				default :

					break;
			}
			//display.addChild(lsMovieClip)
			//增加水波纹
			var cls = getDefinitionByName ("com.jumpeye.flashEff.symbol.desertIllusion.FESDesertIllusion") as Class;
			var myPattern = new cls();

			var myEffect:FlashEff = new FlashEff();
			myEffect.showTransitionName ="com.jumpeye.flashEff.symbol.desertIllusion.FESDesertIllusion";
			myPattern.tweenDuration = 2;
			myPattern.waveSize = 500;
			myEffect.showTransition = myPattern;
			display.addChild(lsMovieClip);
			display.addChild(myEffect);
			myEffect.target =lsMovieClip;
			myEffect.addEventListener(FLASHEFFEvents.TRANSITION_END,completeHandle);
			function completeHandle(e:FLASHEFFEvents):void {
				trace('end');
				//myEffect.removeEffect()
				myEffect.removeAll();
			}
			
		}
		public function removeLoad():void {
			if(isInLoading){
				xmlChildLoader.close();
			}
			while (display.numChildren>0) {
				display.removeChild(display.getChildAt(0));
			}
			
		}
	}
}