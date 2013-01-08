package net.sakri.flex.component{
	
	import flash.events.Event;
	
	import mx.controls.TextArea;
	import mx.events.FlexEvent;
		
	public class FlexSimpleTraceBox extends TextArea{
		
		public static const ALERT_EARLY_TRACES:Boolean=false;
		
		private static var _pre_text_area_traces:String="";
		
		public static var text_area:TextArea=null;
		
		public static function setTextArea(ta:TextArea):void{
			text_area=ta;
			/*
			text_area.text="::Init FlexSimpleTraceBox TextArea::\n";
			text_area.text+="**Pre TextArea Traces:\n"+_pre_text_area_traces;
			text_area.text+="**Post TextArea Traces:\n";
			*/
			text_area.text=_pre_text_area_traces;
			_pre_text_area_traces=null;
		}
		
		//FIND A WAY TO DYNAMICALLY EXTRACT CALLING CLASS AND METHOD NAMES?! POSSIBLE?!
		public static function trace(...args):void{

			var stri:String="";
			for each(var arg:Object in args){
				if(arg is String){
					stri+=arg+"\n";
				}else if(arg.toString!=null){
					stri+=arg.toString()+"\n";;
				}
			}
			if(text_area==null){
				_pre_text_area_traces+=stri;
				return;
			}
			text_area.text+=stri;
			text_area.validateNow();
			text_area.verticalScrollPosition=text_area.maxVerticalScrollPosition;
		}
		
		public static function clear():void{
			if(text_area!=null){
				text_area.text="";
			}
		}			
		

		public function FlexSimpleTraceBox(){
			super();
			addEventListener(mx.events.FlexEvent.CREATION_COMPLETE,init);
		}
		
		private function init(e:Event=null):void{
			this.setStyle("fontSize",10);
			FlexSimpleTraceBox.setTextArea(this);
		}
		
	}
}