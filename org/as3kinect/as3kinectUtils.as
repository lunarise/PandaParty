/*
 * 
 * This file is part of the OpenKinect Project. http://www.openkinect.org
 * 
 * Copyright (c) 2010 individual OpenKinect contributors. See the CONTRIB file 
 * for details.
 * 
 * This code is licensed to you under the terms of the Apache License, version 
 * 2.0, or, at your option, the terms of the GNU General Public License, 
 * version 2.0. See the APACHE20 and GPL20 files for the text of the licenses, 
 * or the following URLs:
 * http://www.apache.org/licenses/LICENSE-2.0
 * http://www.gnu.org/licenses/gpl-2.0.txt
 * 
 * If you redistribute this file in source form, modified or unmodified, 
 * you may:
 * 1) Leave this header intact and distribute it under the same terms, 
 * accompanying it with the APACHE20 and GPL20 files, or
 * 2) Delete the Apache 2.0 clause and accompany it with the GPL20 file, or
 * 3) Delete the GPL v2.0 clause and accompany it with the APACHE20 file
 * In all cases you must keep the copyright notice intact and include a copy 
 * of the CONTRIB file.
 * Binary distributions must follow the binary distribution requirements of 
 * either License.
 * 
 */

package org.as3kinect
{
	import org.as3kinect.as3kinect;
	
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.display.DisplayObject;
	
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	import flash.filters.ColorMatrixFilter;
	import flash.events.TouchEvent;
	import flash.utils.ByteArray;
	
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	
	import code.ColorControl;
	import code.SampleColors;
	import code.NoteDetection;
	
	public class as3kinectUtils
	{
		
		public static var quarter:Array = new Array();
		public static var half:Array = new Array();
		public static var whole:Array = new Array();
		
		/*
		 * Draw ARGB from ByteArray to BitmapData object
		 */
		public static function byteArrayToBitmapData(bytes:ByteArray, _canvas:BitmapData):void{
			_canvas.lock();
			_canvas.setPixels(new Rectangle(0,0, as3kinect.IMG_WIDTH, as3kinect.IMG_HEIGHT), bytes);
			_canvas.unlock();
		}

		/*
		 * Process blobs from BitmapData, if _w and _h set they will be returned in that resoluton
		 */		
		public static function getBlobs(r:BitmapData, r2:BitmapData, orig:BitmapData, _w:Number = 0, _h:Number = 0):Array 
		{
			//if _w and _h not specified use as3kinect constants
			if(_w == 0) _w = as3kinect.IMG_WIDTH;
			if(_h == 0) _h = as3kinect.IMG_HEIGHT;
			
			var i:int;
			var blobs:Array = new Array();
		
			//Looking for the blobs
			while (i < as3kinect.MAX_BLOBS)
			{
			    //Look for BLOB_COLOR (white) in the BitmapData and genrate a rectanglo enclosing the Blobs of that color
				var mainRect:Rectangle = r.getColorBoundsRect(as3kinect.BLOB_MASK, as3kinect.BLOB_COLOR);
				
				//No blobs found (stop the show)
			    if (mainRect.isEmpty()) break;
			    var xx:int = mainRect.x;
				//trace(mainRect);

				//Looking in mainRect for a pixel with BLOB_COLOR
			    for (var yy:uint = mainRect.y; yy < mainRect.y + mainRect.height; yy++)
			    {
					
			        if (r.getPixel32(xx, yy) == as3kinect.BLOB_COLOR)
			        {
						//Use floodFill to paint that blob to BLOB_FILL_COLOR (works like paint fill tool)
			            r.floodFill(xx, yy, as3kinect.BLOB_FILL_COLOR);
						//Now our blob is not BLOB_COLOR we get the rect of our recently painted blob (this is our i blob)
			            var blobRect:Rectangle = r.getColorBoundsRect(as3kinect.BLOB_MASK, as3kinect.BLOB_FILL_COLOR,true);
	
						//trace(blobRect);
						//Looking if our blob fits our desired min/max width and height
			            if (blobRect.width > as3kinect.BLOB_MIN_WIDTH 
							&& blobRect.width < as3kinect.BLOB_MAX_WIDTH 
							&& blobRect.height > as3kinect.BLOB_MIN_HEIGHT 
							&& blobRect.height < as3kinect.BLOB_MAX_HEIGHT)
			            {
							//Create the blob object
			                var blob:Object = {};
							//Add a rect to the object
			                blob.rect = blobRect;
							//Convert blob positions to float and then multiply per requested width and height
							blob.rect.x = ((blob.rect.x / as3kinect.IMG_WIDTH) * _w);
							blob.rect.y = ((blob.rect.y / as3kinect.IMG_HEIGHT) * _h);
							blob.rect.width = (blob.rect.width / as3kinect.IMG_WIDTH) * _w;
							blob.rect.height = (blob.rect.height / as3kinect.IMG_HEIGHT) * _h;
							//The point is the center of the rect
							var _x:int = blob.rect.x + (blob.rect.width / 2);
							var _y:int = blob.rect.y + (blob.rect.height / 2);
							//Add a point to the object
							blob.point = new Point(_x, _y);
							
							var bwColor = ColorControl.hexToRGB(r.getPixel32(blob.rect.x + (blob.rect.width/2), blob.rect.y+blob.rect.height-15));
							//trace("red "+bwColor.red + "; green "+bwColor.green+"; blue "+bwColor.blue);
							
							//, NoteDetection.detectNote(new BitmapData().copyPixels(orig,blob.rect))
							blobs.push(new Array(blob,blob.rect));
							
							r.floodFill(xx, yy, as3kinect.BLOB_PROCESSED_COLOR);
			            } else {
						//Finally we paint our blob to a BLOB_PROCESSED_COLOR so we can discard it in the next pass
			           		r.floodFill(xx, yy, 0x00ffff);
						}
			        }
			    }
			    i++;
			}
			
			
			//return blob array to test.as
			return blobs;
		}
		
		
		/*
		 * Process blobs from BitmapData, if _w and _h set they will be returned in that resoluton
		 */		
		public static function getLines(r:BitmapData, r2:BitmapData, _w:Number = 0, _h:Number = 0):Array 
		{
			//if _w and _h not specified use as3kinect constants
			if(_w == 0) _w = as3kinect.IMG_WIDTH;
			if(_h == 0) _h = as3kinect.IMG_HEIGHT;
			
			var i:int;
			var blobs:Array = new Array();
		
			//Looking for the blobs
			while (i < as3kinect.MAX_LINES)
			{
			    //Look for BLOB_COLOR (white) in the BitmapData and genrate a rectanglo enclosing the Blobs of that color
				var mainRect:Rectangle = r.getColorBoundsRect(as3kinect.BLOB_MASK, as3kinect.BLOB_COLOR);
				//No blobs found (stop the show)
			    if (mainRect.isEmpty()) break;
			    var xx:int = mainRect.x;
				//Looking in mainRect for a pixel with BLOB_COLOR
			    for (var yy:uint = mainRect.y; yy < mainRect.y + mainRect.height; yy++)
			    {
					
			        if (r.getPixel32(xx, yy) == as3kinect.BLOB_COLOR)
			        {
						//Use floodFill to paint that blob to BLOB_FILL_COLOR (works like paint fill tool)
			            r.floodFill(xx, yy, as3kinect.BLOB_FILL_COLOR);
						//Now our blob is not BLOB_COLOR we get the rect of our recently painted blob (this is our i blob)
			            var blobRect:Rectangle = r.getColorBoundsRect(as3kinect.BLOB_MASK, as3kinect.BLOB_FILL_COLOR);
						//trace(blobRect);
						//Looking if our blob fits our desired min/max width and height
			            if (blobRect.width > as3kinect.STAFF_MIN_WIDTH 
							&& blobRect.width < as3kinect.STAFF_MAX_WIDTH 
							&& blobRect.height > as3kinect.STAFF_MIN_HEIGHT 
							&& blobRect.height < as3kinect.STAFF_MAX_HEIGHT)
			            {
							//Create the blob object
			                var blob:Object = {};
							//Add a rect to the object
			                blob.rect = blobRect;
							//Convert blob positions to float and then multiply per requested width and height
							blob.rect.x = ((blob.rect.x / as3kinect.IMG_WIDTH) * _w);
							blob.rect.y = ((blob.rect.y / as3kinect.IMG_HEIGHT) * _h);
							blob.rect.width = (blob.rect.width / as3kinect.IMG_WIDTH) * _w;
							blob.rect.height = (blob.rect.height / as3kinect.IMG_HEIGHT) * _h;
							//The point is the center of the rect
							var _x:int = blob.rect.x + (blob.rect.width / 2);
							var _y:int = blob.rect.y + (blob.rect.height / 2);
							//Add a point to the object
							blob.point = new Point(_x, _y);
			                blobs.push(new Array(blob,new Array(blob.rect.x+blob.rect.width/2, blob.rect.bottom)));
			            }
						//Finally we paint our blob to a BLOB_PROCESSED_COLOR so we can discard it in the next pass
			            r.floodFill(xx, yy, 0X6600CC);
			        }
			    }
			    i++;
			}
			
			
			//return blob array to test.as
			return blobs;
		}
		
		//converts argb to rgb based on passed in uint
		public static function argbToRGB(color) {
			return '#'+ ('000000' + (color & 0xFFFFFF).toString(16)).slice(-6);
		}
		
		
	}
}