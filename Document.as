package 
{
	import flash.display.MovieClip;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.geom.ColorTransform;
	
	import flash.utils.ByteArray;
	
	//as3kinect (OpenKinect) libraries
	import org.as3kinect.as3kinect;
	import org.as3kinect.as3kinectWrapper;
	import org.as3kinect.as3kinectUtils;
	import org.as3kinect.events.as3kinectWrapperEvent;
	import org.as3kinect.objects.motorData;
	
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.TouchEvent;
	
	
	import code.Filters;
	import code.NoteDetection;
	import code.Lessons;
	
	import flash.display.PixelSnapping;
	
	import flashx.textLayout.formats.Float;
	import code.Staff;
	import code.LessonOne;

	public class Document extends MovieClip
	{
		//bottom up
		private var _notearr:Array = new Array(
											 new Array("low e"),
											 new Array("low f"),
											 new Array("g"),
											 new Array("a"),
											 new Array("b"),
											 new Array("c"),
											 new Array("d"),
											 new Array("high e"),
											 new Array("high f"));
		private var _staff: Array = new Array(
											  new Array("low e"),
											  new Array("g"),
											  new Array("b"),
											  new Array("d"),
											  new Array("high f"));
		
		//dummy staff for testing purposes. real staff is stored above once calculated
		private var temp_staff: Array = new Array(
											  new Array("f", new Array(60,100)),
											  new Array("d", new Array(60,200)),
											  new Array("b", new Array(60,300)),
											  new Array("g", new Array(60,400)),
											  new Array("e", new Array(60,500)));
											  
		private var _line_spacing :int = 0;
		private var _staff_array	:Array;
		
		private var _bw_bmp		:Bitmap; //holds bw feed
		private var _noblack_bmp		:Bitmap; //holds bw feed
		private var _color_bmp		:Bitmap; //holds color feed
		
		private var _blob_array:Array = new Array();
		private var _canvas_video_feed	:BitmapData;
		
		private var _staff_bw_bmp		:Bitmap; //holds bw feed
		private var _staff_color_bmp		:Bitmap; //holds color feed
		private var _blobs_on			:Boolean = false;
		private var _wb_filter_on		:Boolean = false;
		
		private var _threshold_value	:int = 50;
		private var _as3w	:as3kinectWrapper;
		
		private var quarter:Array = new Array();
		private var half:Array = new Array();
		private var whole:Array = new Array();
		
		const rc:Number = 1/3, gc:Number = 1/3, bc:Number = 1/3;
		public function Document()
		{
			this.stop();
			this.gotoAndStop("Lesson");
			var lesson:Lessons = new LessonOne(this);
			
			//Instantiating the wrapper library
			_as3w = new as3kinectWrapper();
			_notearr.reverse();
			
			//Add as3kinectWrapper events (depth, video and acceleration data)
			_as3w.addEventListener(as3kinectWrapperEvent.ON_VIDEO, detectStaff);
			

			//video feed (BITMAP)
			_canvas_video_feed = _as3w.video.bitmap;
			
			//initialize bitmap obj
			_staff_color_bmp = new Bitmap();
			_staff_bw_bmp = new Bitmap();
			
			//create bitmapdata based on video feed with filters
			_staff_color_bmp.bitmapData = Filters.applyColorFilterToBitmapData(_canvas_video_feed);  //apply filter to bitmap we want in color.
			_staff_bw_bmp.bitmapData = Filters.applyBWFilterToBitmapData(_canvas_video_feed); 			 //apply filter to bitmap we want to be black and white.
			_staff_bw_bmp.bitmapData = Filters.invertBWBitmapData(_staff_bw_bmp.bitmapData);
			//blobs should be on from the get go
			_blobs_on = true;
			
			//_staff_bw_bmp.x += _staff_bw_bmp.width;
			this.addChild(_staff_bw_bmp);
			//On every frame call the update method
			this.addEventListener(Event.ENTER_FRAME, update);
			
			
		}
		
		
		//UPDATE METHOD (This is called each frame)
		private function update(event:Event){
			_as3w.video.getBuffer();
		}
		
		//first thing's first - find out where the lines on the staff are
		private function detectStaff(event:as3kinectWrapperEvent):void{

			as3kinectUtils.byteArrayToBitmapData(event.data, _canvas_video_feed);
			var tempStaff:Array = _staff.reverse();
			_staff.reverse();
			
			_staff_bw_bmp.bitmapData = Filters.applyStaffFilterToBitmapData(_canvas_video_feed); 			 //apply filter to bitmap we want to be black and white.
			
			//look for blobs
			if(_blobs_on) { 
				//Process Blobs from image
				_staff_array = as3kinectUtils.getLines(_staff_bw_bmp.bitmapData,_staff_color_bmp.bitmapData);
				
				//are there 5 blobs? we have our staff, yay
				if(_staff_array.length === 5) {
					trace('All lines found. Begin Lesson 1.');
					for(var i=0; i < _staff_array.length; i++) {
						tempStaff[i].push(new Array(_staff_array[i][1][0], _staff_array[i][1][1]));
					}
					
					_staff_array = new Array();
					_staff_array = tempStaff;
					
					this.removeEventListener(Event.ENTER_FRAME, update);
					
					findNoteCoords();
				}
				
			}

			//update text at the bottom
			//blobCountText.text = "There are "+_blob_array.length+" blobs";
		}
		
		private function findNoteCoords() {
			_staff_array.reverse();
			
			//if second line's y - first line's y is greater than 0, create line spacing
			if(_staff_array[1][1][1] - _staff_array[0][1][1] > 0)
				_line_spacing =  (_staff_array[1][1][1] - _staff_array[0][1][1])/2;
			
			//k holds current line in staff array (indexes 0-4; notes egbdf)
			var k:int=0;
			
			//for each note in the note array (all possible notes on staff including notes between lines), compare to staff array (holds blob vals for staff lines egbdf)
			for(var i:int=0; i < _notearr.length; i++) {
				//if note's letter is same as staff's letter, we don't need to calculate positions (already have from blob detection)
				if(_notearr[i][0] === _staff_array[k][0]) {
					_notearr[i].push(new Array(_staff_array[k][1][0],_staff_array[k][1][1]));
					k++;
				} else {
					if(k-1 >= 0)
						_notearr[i].push(new Array(_staff_array[0][1][0],_staff_array[k-1][1][1]+_line_spacing));
				}
			
				//trace("note "+_notearr[i][0]+" is at "+_notearr[i][1][0]+","+_notearr[i][1][1]);
			}
			
			//this.addChild(_staff_bw_bmp);
			_as3w.removeEventListener(as3kinectWrapperEvent.ON_VIDEO, detectStaff);
			
			//temp_staff.reverse();
			//gotoAndStop("Play");
			noteDetection();
			
			trace(_notearr);
			
			/*
			for(var j=0; j < _staff.length; j++) {
				//trace("line "+_staff[j][0]);
				trace("line "+_staff[j][0]+" is at "+_staff[j][1][0]+","+_staff[j][1][1]);
			}*/
		}
		
		private function noteDetection()
		{
			
			
			//Instantiating the wrapper library
			//Add as3kinectWrapper events (depth, video and acceleration data)
			_as3w.addEventListener(as3kinectWrapperEvent.ON_VIDEO, searchForNotes);
			//_as3w.addEventListener(as3kinectWrapperEvent.ON_ACCELEROMETER, got_motor_data);

			//video feed (BITMAP)
			_canvas_video_feed = _as3w.video.bitmap;
			
			//initialize bitmap obj
			_bw_bmp = new Bitmap();
			_color_bmp = new Bitmap();
			
			//create bitmapdata based on video feed with filters
			_color_bmp.bitmapData = Filters.applyColorFilterToBitmapData(_canvas_video_feed);  //apply filter to bitmap we want in color.
			_bw_bmp.bitmapData = Filters.applyBlobDetectFilters(_canvas_video_feed); 			 //apply filter to bitmap we want to be black and white.
			//_noblack_bmp.bitmapData = Filters.applyBWFilterToBitmapData(_canvas_video_feed); 			 //apply filter to bitmap we want to be black and white.
		
		
			//add to screen
			this.addChild(_bw_bmp);
			_color_bmp.x = _bw_bmp.width;
			//this.addChild(_color_bmp);
			
			//blobs should be on from the get go
			_blobs_on = true;
			
			//On every frame call the update method
			this.addEventListener(Event.ENTER_FRAME, update);

		}
		
		
		
		//GOT VIDEO METHOD
		private function searchForNotes(event:as3kinectWrapperEvent):void{
			//Convert Received ByteArray into BitmapData
			//trace(event.data);
			
			as3kinectUtils.byteArrayToBitmapData(event.data, _canvas_video_feed);

			_color_bmp.bitmapData = Filters.applyColorFilterToBitmapData(_canvas_video_feed);  //apply filter to bitmap we want in color.
			_bw_bmp.bitmapData = Filters.applyBlobDetectFilters(_canvas_video_feed); 			 //apply filter to bitmap we want to be black and white.
			//_noblack_bmp.bitmapData = Filters.applyBWFilterToBitmapData(_canvas_video_feed); 			 //apply filter to bitmap we want to be black and white.
			
			
			//if looking for blobs
			if(_blobs_on) { 
				//Process Blobs from image
				_blob_array = as3kinectUtils.getBlobs(_bw_bmp.bitmapData,_color_bmp.bitmapData,_canvas_video_feed);
				trace(_blob_array.length+ " notes detected.");
			}
			
			if(_blob_array.length > 0) {
				storeNotesOnStaff();
			}
		}
		
		private function storeNotesOnStaff() {
			var buffer:int = 10;
			for(var i:int=0; i < _blob_array.length; i++) {
				for(var j:int = 0; j < _notearr.length; j++) {
					if((_blob_array[i][1].y + (_blob_array[i][1].height/2) > _notearr[j][1][1]) && (_blob_array[i][1].y - (_blob_array[i][1].height/2) < _notearr[j+1][1][1])) {
						trace(" 2 this note's y is at "+_blob_array[i][1].y+" and is between notes "+_notearr[j]+" and "+_notearr[j+1]);
						_blob_array[i].push(_notearr[j][0]);
						break;
					} else {
						trace("not in valid range. wat");
					}
					
					trace("i:"+i+", j:"+j);
				}
			}
		}
	
		
		private function checkNextLine(buffer:int, currentBlob:int=0, currentLine:int=0):Boolean {
			if((_blob_array[currentBlob][1].y - buffer >= _notearr[currentLine][1][1]) && (_blob_array[currentBlob][1].y - buffer <= _notearr[currentLine+1][1][1]))  {
				return false;
			} else {
				return true;
			}
		}
		
	}
}