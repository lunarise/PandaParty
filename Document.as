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

	import Tone;
	import flashx.textLayout.formats.Float;
	import code.Staff;
	import code.LessonOne;

	public class Document extends MovieClip
	{
		//bottom up
		private var _notearr:Array = new Array(
											 new Array("e"),
											 new Array("f"),
											 new Array("g"),
											 new Array("a"),
											 new Array("b"),
											 new Array("c"),
											 new Array("d"),
											 new Array("e"),
											 new Array("f"));
		private var _staff: Array = new Array(
											  new Array("e"),
											  new Array("g"),
											  new Array("b"),
											  new Array("d"),
											  new Array("f"));
											
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
		
		private var _tone	:Tone;
		private var _as3w	:as3kinectWrapper;
		
		private var quarter:Array = new Array();
		private var half:Array = new Array();
		private var whole:Array = new Array();
		
		const rc:Number = 1/3, gc:Number = 1/3, bc:Number = 1/3;
		public function Document()
		{
			this.stop();
			//Instantiating the wrapper library
			_as3w = new as3kinectWrapper();
			_notearr.reverse();
			
			//findNoteCoords(); 
			//Add as3kinectWrapper events (depth, video and acceleration data)
			_as3w.addEventListener(as3kinectWrapperEvent.ON_VIDEO, get_video);
			

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
			
			_staff_bw_bmp.x += _staff_bw_bmp.width;
			this.addChild(_staff_bw_bmp);
			//On every frame call the update method
			this.addEventListener(Event.ENTER_FRAME, update);
			
		}
		
		
		//UPDATE METHOD (This is called each frame)
		private function update(event:Event){
			_as3w.video.getBuffer();
		}
		
		//GOT VIDEO METHOD
		private function get_video(event:as3kinectWrapperEvent):void{
			//Convert Received ByteArray into BitmapData
			as3kinectUtils.byteArrayToBitmapData(event.data, _canvas_video_feed);
			var tempStaff:Array = _staff.reverse();
			_staff.reverse();
			
			_staff_bw_bmp.bitmapData = Filters.applyStaffFilterToBitmapData(_canvas_video_feed); 			 //apply filter to bitmap we want to be black and white.
			
			//if looking for blobs
			if(_blobs_on) { 
				//Process Blobs from image
				_staff_array = as3kinectUtils.getLines(_staff_bw_bmp.bitmapData,_staff_color_bmp.bitmapData);
				if(_staff_array.length === 5) {
					for(var i=0; i < _staff_array.length; i++) {
						//_staff[2+i+i%2].push("x: "+_staff_array[i][0]+"\ny: "+_staff_array[i][1]);
						//trace("blob "+i+", x: "+_staff_array[i][1][0]+"\ny: "+_staff_array[i][1][1]);
						tempStaff[i].push(new Array(_staff_array[i][1][0], _staff_array[i][1][1]));
					}
					
					_staff = new Array();
					_staff = tempStaff;
					
					
					//this.removeEventListener(Event.ENTER_FRAME, update);
					
					findNoteCoords();
				}
				
			}

			//update text at the bottom
			//updateText();
		}
		
		private function findNoteCoords() {
			
			
			//temp_staff.reverse();
			if(temp_staff[1][1][1] - temp_staff[0][1][1] > 0)
				_line_spacing =  (temp_staff[1][1][1] - temp_staff[0][1][1])/2;
			
			//trace(temp_staff[1][1][1] - temp_staff[0][1][1]);
			var k:int=0;
			for(var i:int=0; i < _notearr.length; i++) {
				if(_notearr[i][0] === temp_staff[k][0]) {
					//trace(k+" "+temp_staff[k][1][0]+ " "+temp_staff[k][1][0]);
					_notearr[i].push(new Array(temp_staff[k][1][0],temp_staff[k][1][1]));
					k++;
				} else {
					if(k-1 >= 0)
						_notearr[i].push(new Array(temp_staff[0][1][0],temp_staff[k-1][1][1]+_line_spacing));
					//trace(k+" "+temp_staff[k][1][0]+ " "+temp_staff[k][1][0]);
				}
				
				trace("note "+_notearr[i][0]+" is at "+_notearr[i][1][0]+","+_notearr[i][1][1]);
			}
			
			//this.addChild(_staff_bw_bmp);
			_as3w.removeEventListener(as3kinectWrapperEvent.ON_VIDEO, get_video);
			
			//temp_staff.reverse();
			gotoAndStop("Play");
			noteDetection();
			
			
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
			_as3w.addEventListener(as3kinectWrapperEvent.ON_VIDEO, got_video);
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
			this.addChild(_color_bmp);
			
			//blobs should be on from the get go
			_blobs_on = true;
			
			//On every frame call the update method
			this.addEventListener(Event.ENTER_FRAME, update);
			
			
			var lesson:Lessons = new LessonOne(this);
		}
		
		
		
		//GOT VIDEO METHOD
		private function got_video(event:as3kinectWrapperEvent):void{
			//Convert Received ByteArray into BitmapData
			//trace(event.data);
			
			as3kinectUtils.byteArrayToBitmapData(event.data, _canvas_video_feed);

			_color_bmp.bitmapData = Filters.applyColorFilterToBitmapData(_canvas_video_feed);  //apply filter to bitmap we want in color.
			_bw_bmp.bitmapData = Filters.applyBlobDetectFilters(_canvas_video_feed); 			 //apply filter to bitmap we want to be black and white.
			//_noblack_bmp.bitmapData = Filters.applyBWFilterToBitmapData(_canvas_video_feed); 			 //apply filter to bitmap we want to be black and white.
			
			
			//if looking for blobs
			if(_blobs_on) { 
				//Process Blobs from image
				_blob_array = as3kinectUtils.getBlobs(_bw_bmp.bitmapData,_color_bmp.bitmapData);
				
				//where are the specific types of blobs?
				
				quarter = as3kinectUtils.quarter;
				half = as3kinectUtils.half;
				whole = as3kinectUtils.whole;
			}
			
			if(_blob_array.length > 0) {
				storeNotesOnStaff();
			}
			
			//update text at the bottom
			updateText();
		}
		
		private function storeNotesOnStaff() {
			//trace('blob y'+_blob_array[0][1].y);
			
			var buffer:int = 10;
			var line:int = 0;
			/*
			for(var i:int = 0; i < _blob_array.length; i++) {
				 trace("this note's y is at "+_blob_array[i][1].y);
				 
				if((_blob_array[i][1].y < _notearr[0][1][1])) {
					_blob_array[i].push(_notearr[0][0]);
					line = 0; // reset line for next blob search
				}
				//if the note is greater than this line, next line!
				else if((_blob_array[i][1].y < temp_staff[line][1][1])) {
					//if(line+1 
					trace(_blob_array[i][1].y-25);
				   if(_blob_array[i][1].y < temp_staff[line+1][1][1] && (_blob_array[i][1].y-25 > _notearr[line])) {
					   trace('hello');
					   trace("this note's y is at "+_blob_array[i][1].y+" and is between notes "+_notearr[i]+" and "+_notearr[line+1]);
					   _blob_array[i].push(_notearr[line][0]);
					   line=0;
				   } else {
					   line++;
				   }
				} else {
					line++;
					//trace(line);
				}
				   
			*/
			
			
			
			
			loopLines();
			//trace(_blob_array[0][2] +" at "+ _blob_array[0][1].y);
		}
		
		private function loopLines(line:int=0) {
			var buffer:int = 10;
			
			/*
			
			for(var i:int = 0; i < _blob_array.length; i++) {
				//is this the first line?
				//trace('1');
				trace(i);
				if(_blob_array[i][1].y-buffer > _notearr[line][1][1]) {
					var bloby = _blob_array[i][1].y - buffer;
					trace("1 this note's y is at "+bloby+" and is between notes "+_notearr[line][1][1]+" and "+_notearr[line+1][1][1]);
					if((_blob_array[i][1].y-buffer > _notearr[line][1][1]) && (_blob_array[i][1].y-buffer < _notearr[line+1][1][1])) {
						trace(" 2 this note's y is at "+_blob_array[i][1].y+" and is between notes "+_notearr[i]+" and "+_notearr[line]);
						
					} else {
						if((_blob_array[i][1].y-buffer < _notearr[line][1][1]) && (_blob_array[i][1].y-buffer < _notearr[line+1][1][1])) {
							
						}
						line++;
						loopLines(line++);
						trace(line);
					}
				} else {
					_blob_array[i].push(_notearr[0][1][1]);
					line = 0;
					trace('f (top)'+_blob_array[0][1].y);
				}
			}
			
			
			var nextLine:Boolean = checkNextLine(buffer,i,line);
				if(nextLine) {
					line++;
					trace('checking next' + line);
				} else {
					trace(" 2 this note's y is at "+_blob_array[i][1].y+" and is between notes "+_notearr[i]+" and "+_notearr[line]);
				}
				*/
			for(var i:int=0; i < _blob_array.length; i++) {
				for(var j:int = 0; j < _notearr.length; j++) {
					if((_blob_array[i][1].y > _notearr[j][1][1]) && (_blob_array[i][1].y < _notearr[j+1][1][1])) {
						trace(" 2 this note's y is at "+_blob_array[i][1].y+" and is between notes "+_notearr[j]+" and "+_notearr[j+1]);
						_blob_array[i].push(_notearr[j][0]);
					} 
				}
				
				trace(_blob_array[i]);

			}
		}
		
		private function checkNextLine(buffer:int, currentBlob:int=0, currentLine:int=0):Boolean {
			if((_blob_array[currentBlob][1].y - buffer >= _notearr[currentLine][1][1]) && (_blob_array[currentBlob][1].y - buffer <= _notearr[currentLine+1][1][1]))  {
				return false;
			} else {
				return true;
			}
		}
		
		//how many whole/half/quarter notes are there?
		private function updateText() {
			//overall blobs
			blobCountText.text = "There are "+_blob_array.length+" blobs";
			
			
			//print all quarter notes & their positions
			quarterText.text = quarter.length.toString();
			
			var quarterPos:String = "";
			if(quarter.length >= 1) {
				for(var q=0; q < quarter.length; q++) {
					quarterPos += "x: "+quarter[q][0]+"\ny: "+quarter[q][1]+"\n\n";
				}
			}
			quarterPosition.text = quarterPos;
			
			//print all half notes & their positions
			halfText.text = half.length.toString();
			var halfPos:String = "";
			if(half.length >= 1) {
				for(var h=0; h < half.length; h++) {
					halfPos += "x: "+half[h][0]+"\ny: "+half[h][1]+"\n\n";
				}
			}
			halfPosition.text = halfPos;
			
			//print all whole notes & their positions
			wholeText.text = whole.length.toString();
			
			var wholePos:String = "";
			if(whole.length >= 1) {
				for(var w=0; w < whole.length; w++) {
					wholePos += "x: "+whole[w][0]+"\ny: "+whole[w][1]+"\n\n";
				}
			}
			wholePosition.text = wholePos;
		}
	}
}