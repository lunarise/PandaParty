package net.sakri.flash.component{
	
	import flash.system.System;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	public class SimpleStatsView extends Sprite{

		protected var _fps:int;		
		public function get fps():int{
			return _fps;
		}
		
		protected var _memory:String;
		public function get memory():String{
			return _memory;
		}
		
		protected var _last_frame_time:int;
		protected var _current_frame_time:int;
		
		protected var _fps_field:TextField;
		protected var _memory_field:TextField;
		
		public function SimpleStatsView(){
			super();
			init();
		}
		
		public function init():void{
			addEventListener(Event.ENTER_FRAME, tick,false,0,true);
			opaqueBackground = 0;
			
			var format:TextFormat = new TextFormat("Arial", 12, 0xFFFFFF, false, false, false);
			
			var fps_label:TextField = new TextField();
			fps_label.selectable=false;
			fps_label.autoSize = TextFieldAutoSize.LEFT;
			fps_label.defaultTextFormat = format;
			fps_label.text="FPS:";
			addChild(fps_label);
			
			_fps_field = new TextField();
			_fps_field.selectable=false;
			_fps_field.x=fps_label.width+3;
			_fps_field.width=100;
			_fps_field.defaultTextFormat = format;
			addChild(_fps_field);
			
			var memory_label:TextField = new TextField();
			memory_label.selectable=false;
			memory_label.autoSize = TextFieldAutoSize.LEFT;
			memory_label.defaultTextFormat = format;
			memory_label.text="Mem:";
			addChild(memory_label);
			
			_memory_field = new TextField();
			_memory_field.selectable=false;
			_memory_field.x=memory_label.width+3;
			_memory_field.autoSize = TextFieldAutoSize.LEFT;
			_memory_field.defaultTextFormat = format;
			addChild(_memory_field);	
			
			_memory_field.y=memory_label.y=20;
			_fps_field.height=fps_label.height=_memory_field.height=memory_label.height=20;
		}

		protected function tick(event:Event):void{
			_current_frame_time = getTimer();
			_fps = 1000/(_current_frame_time - _last_frame_time);
			_last_frame_time = _current_frame_time;
			_memory=(System.totalMemory/1024/1024).toFixed(2);
			update();
		}
		
		protected function update():void{
			_fps_field.text = String(_fps);	
			_memory_field.text = _memory+ "MB";	
		}
		
		public function destroy():void{
			removeEventListener(Event.ENTER_FRAME, tick);
		}
		
	}
}