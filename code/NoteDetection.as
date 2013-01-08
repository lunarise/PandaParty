package code
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
	
	import flash.display.PixelSnapping;

	import Tone;
	import flashx.textLayout.formats.Float;

	public class NoteDetection extends MovieClip
	{
		private var doc:Document;
		private var _notes			:Array;
		private var _blob_array		:Array;
		
		//holds quarter, half, whole notes 
		private var quarter:Array = new Array();
		private var half:Array = new Array();
		private var whole:Array = new Array();

		private var _canvas_video_feed	:BitmapData;
		
		private var _bw_bmp		:Bitmap; //holds bw feed
		private var _color_bmp		:Bitmap; //holds color feed
		
		private var _min_depth_dragging	:Boolean = false;
		private var _max_depth_dragging	:Boolean = false;
		private var _motor_dragging		:Boolean = false;
		private var _threshold_dragging	:Boolean = false;
		private var _blobs_on			:Boolean = false;
		private var _wb_filter_on		:Boolean = false;
		
		private var _threshold_value	:int = 50;
		
		private var _tone	:Tone;
		private var _as3w	:as3kinectWrapper;
		
		
		const rc:Number = 1/3, gc:Number = 1/3, bc:Number = 1/3;
		public function NoteDetection(noteLocations:Array,aDoc:Document)
		{
			doc = aDoc;
			_notes = new Array();
			_notes = noteLocations;
	
			//Instantiating the wrapper library
			_as3w = new as3kinectWrapper();
			
			//Add as3kinectWrapper events (depth, video and acceleration data)
			_as3w.addEventListener(as3kinectWrapperEvent.ON_VIDEO, got_video);
			_as3w.addEventListener(as3kinectWrapperEvent.ON_ACCELEROMETER, got_motor_data);

			//video feed (BITMAP)
			_canvas_video_feed = _as3w.video.bitmap;
			
			//initialize bitmap obj
			_bw_bmp = new Bitmap();
			_color_bmp = new Bitmap();
			
			//create bitmapdata based on video feed with filters
			_color_bmp.bitmapData = Filters.applyColorFilterToBitmapData(_canvas_video_feed);  //apply filter to bitmap we want in color.
			_bw_bmp.bitmapData = Filters.applyBWFilterToBitmapData(_canvas_video_feed); 			 //apply filter to bitmap we want to be black and white.
		
			//add to screen
			doc.addChild(_bw_bmp);
			//rgb_cam.addChild(_color_bmp);
			
			//blobs should be on from the get go
			_blobs_on = true;
			
			//On every frame call the update method
			doc.addEventListener(Event.ENTER_FRAME, update);
		}
		
		
		//UPDATE METHOD (This is called each frame)
		private function update(event:Event){
			_as3w.video.getBuffer();
			_as3w.motor.getData();
		}
		
		
		
		//GOT VIDEO METHOD
		private function got_video(event:as3kinectWrapperEvent):void{
			/*//Convert Received ByteArray into BitmapData
			trace(event.data);
			
			//as3kinectUtils.byteArrayToBitmapData(event.data, _canvas_video_feed);

			_color_bmp.bitmapData = Filters.applyColorFilterToBitmapData(_canvas_video_feed);  //apply filter to bitmap we want in color.
			_bw_bmp.bitmapData = Filters.applyBWFilterToBitmapData(_canvas_video_feed); 			 //apply filter to bitmap we want to be black and white.
			
			//if looking for blobs
			if(_blobs_on) { 
				//Process Blobs from image
				_blob_array = as3kinectUtils.getBlobs(_bw_bmp.bitmapData,_color_bmp.bitmapData);
				
				//where are the specific types of blobs?
				quarter = as3kinectUtils.quarter;
				half = as3kinectUtils.half;
				whole = as3kinectUtils.whole;
			}
			
			//update text at the bottom
			updateText();*/
		}
		
		//how many whole/half/quarter notes are there?
		private function updateText() {
			//overall blobs
			doc.blobCountText.text = "There are "+_blob_array.length+" blobs";
			
			
			//print all quarter notes & their positions
			doc.quarterText.text = quarter.length.toString();
			
			var quarterPos:String = "";
			if(quarter.length >= 1) {
				for(var q=0; q < quarter.length; q++) {
					quarterPos += "x: "+quarter[q][0]+"\ny: "+quarter[q][1]+"\n\n";
				}
			}
			doc.quarterPosition.text = quarterPos;
			
			//print all half notes & their positions
			doc.halfText.text = half.length.toString();
			var halfPos:String = "";
			if(half.length >= 1) {
				for(var h=0; h < half.length; h++) {
					halfPos += "x: "+half[h][0]+"\ny: "+half[h][1]+"\n\n";
				}
			}
			doc.halfPosition.text = halfPos;
			
			//print all whole notes & their positions
			doc.wholeText.text = whole.length.toString();
			
			var wholePos:String = "";
			if(whole.length >= 1) {
				for(var w=0; w < whole.length; w++) {
					wholePos += "x: "+whole[w][0]+"\ny: "+whole[w][1]+"\n\n";
				}
			}
			doc.wholePosition.text = wholePos;
		}

		//GOT MOTOR DATA (Accelerometer info) - keeping if needed later
		function got_motor_data(event:as3kinectWrapperEvent):void
		{
			var object:motorData = event.data;
		}
	}
}