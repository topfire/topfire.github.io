package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.geom.Transform;
	import flash.geom.ColorTransform;
	import flash.errors.IOError;

	public class Display extends Sprite
	{
		private var displayWidth:int = 700
		private var displayHeight:int = 500
		
		private var xmlURL:String = ''
		private var xmlLoader:URLLoader = new URLLoader()
	
		private var xmlRequest:URLRequest 
		
		private var xml:XML;
		private var display:Sprite;
		private var xmlLength:int;
	
		private var sd:MovieClip
		private var s:TextField;
	
		public function Display()
		{
			super();
			
			var xmlId:String = root.loaderInfo.parameters["color"];
			
						
			if(xmlId ==null) return
			
			xmlURL = xmlId +'.xml'
			
			xmlRequest = new URLRequest(xmlURL)
			//ls_txt.text = xmlURL
			
			stage.frameRate = 12;
			initControl()
			
			display = new Sprite()
			display.x = 0
			display.y = 0
						
			this.addChild(display)
			//display = this;
			xmlLoader.addEventListener(Event.COMPLETE,completeHandle)
			xmlLoader.load(xmlRequest)
			
		}
		private function initControl():void
		{			
			btn_next.addEventListener(MouseEvent.CLICK,btn_NClickHandle)
			function btn_NClickHandle(e:MouseEvent):void
			{
				currentChild++
				if(currentChild > xmlLength-1)
				{
					//currentChild=0;
					return;
				}
				childDisplay.removeLoad()
				addChildDisplay(currentChild)
			}
			
			btn_pre.addEventListener(MouseEvent.CLICK,btn_PClickHandle)
			function btn_PClickHandle(e:MouseEvent):void
			{
				currentChild--
				if(currentChild < 0)
				{
					currentChild = xmlLength-1;
				}
				childDisplay.removeLoad()
				addChildDisplay(currentChild)
			}
		}
		private var childDisplay:ChildDisplay
		private var currentChild:int = 0
		private function completeHandle(e:Event):void
		{
			xml = XML(xmlLoader.data);
			xmlLength = xml.Product.length();
			//trace(xml)
			//trace(xml.Product.title)	
			addChildDisplay(currentChild)			
		}
		private function addChildDisplay(_currentID:int):void
		{			
			//显示背景的颜色 title des
			
			stage.frameRate = xml.Product[currentChild].frameRate
			
			var colorLine:Number = xml.Product[currentChild].bgColor
			var red:uint=colorLine>>16
			var green:uint=colorLine>>8&0xff
			var blue:uint=colorLine&0xff			
			bg_mc.transform.colorTransform=new ColorTransform(0,0,0,1,red,green,blue,255);
			
			//loadPercent_text
			/*trace('id= '+xml.Product[currentChild].@id)
			trace('width= '+xml.Product[currentChild].width)
			trace('height= '+xml.Product[currentChild].height)
			trace('type= '+xml.Product[currentChild].type)			*/
						
			title_text.text = xml.Product[currentChild].title
			//descripe_text.text = xml.Product[currentChild].desc				
			descripe_text.htmlText = xml.Product[currentChild].desc				
			
			//添加显示对象
			childDisplay = new ChildDisplay(xml.Product[currentChild].@id,xml.Product[currentChild].width,xml.Product[currentChild].height,xml.Product[currentChild].type,displayWidth,displayHeight)		
			childDisplay.beginLoad(display,loadPercent_text,mask_mc)
				
		}
	}
}