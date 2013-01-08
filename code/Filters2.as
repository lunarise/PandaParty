package code {
	import flash.display.MovieClip;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	
	//class created from Patrick's bitmap examples
	//good matrix refrence - http://chargedweb.com/labs/2010/04/30/fast_brightness_contrast_saturation/
	public class Filters extends MovieClip{
		
		//public static const rc:Number = 1/3, gc:Number = 1/3, bc:Number = 1/3;
		public static const rLum:Number = 0.2225, gLum:Number = 0.7169, bLum:Number = 0.0606;
		public static const threshold = 150; //10
			
		public function Filters() {
		}

		public static function applyBWFilterToBitmapData(sourceBitmapData:BitmapData):BitmapData{
			var bwBitmapData:BitmapData = sourceBitmapData.clone(); //cloned source
			//bwBitmapData = applyBrightnessFilter(bwBitmapData);
			var matrix:Array = [rLum * 256, gLum * 256, bLum * 256, 0, -256 * threshold,
								rLum * 256, gLum * 256, bLum * 256, 0, -256 * threshold,
								rLum * 256, gLum * 256, bLum * 256, 0, -256 * threshold,
								0,          0,          0,          1, 0                ]; 
			var bw_filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			
			bwBitmapData.applyFilter(bwBitmapData, bwBitmapData.rect, new Point(0,0), bw_filter); //apply filter to cloned bitmap data
			applyContrastFilterToBitmapData(bwBitmapData);
			bwBitmapData = invertBWBitmapData(bwBitmapData);
			
			return bwBitmapData; //return cloned bitmapdata
		}
		
		public static function applyBWFilterBitmapData(sourceBitmapData:BitmapData):BitmapData{
			var threshold:Number = 50;
			var bwBitmapData:BitmapData = sourceBitmapData.clone(); //cloned source
			//bwBitmapData = applyBrightnessFilter(bwBitmapData);
			var matrix:Array = [rLum * 256, gLum * 256, bLum * 256, 0, -256 * threshold,
								rLum * 256, gLum * 256, bLum * 256, 0, -256 * threshold,
								rLum * 256, gLum * 256, bLum * 256, 0, -256 * threshold,
								0,          0,          0,          1, 0                ]; 
			var bw_filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			
			bwBitmapData.applyFilter(bwBitmapData, bwBitmapData.rect, new Point(0,0), bw_filter); //apply filter to cloned bitmap data
			applyContrastFilterToBitmapData(bwBitmapData);
			bwBitmapData = invertBWBitmapData(bwBitmapData);
			
			return bwBitmapData; //return cloned bitmapdata
		}
		
		public static function invertBWBitmapData(sourceBitmapData:BitmapData):BitmapData {
			var invertedBitmapData:BitmapData = sourceBitmapData.clone(); //cloned source
			
			var bd:BitmapData;
			var invertTransform:ColorTransform = new ColorTransform(-1,-1,-1,1,255,255,255,0)
			invertedBitmapData.colorTransform(invertedBitmapData.rect, invertTransform);
			return invertedBitmapData;
		}
		
		public static function applyContrastFilterToBitmapData(sourceBitmapData:BitmapData,severity:Number=101):BitmapData{
			
			var contrastBitmapData:BitmapData = sourceBitmapData.clone();		//cloned source	
			var s: Number = severity;
            var o : Number = 128 * (1 - s);
            var m:Array = new Array();
            m = m.concat([s, 0, 0, 0, o]);  // red
            m = m.concat([0, s, 0, 0, o]);  // green
            m = m.concat([0, 0, s, 0, o]);  // blue
            m = m.concat([0, 0, 0, 1, 0]);  // alpha
			
			var contrast_filter:ColorMatrixFilter=new ColorMatrixFilter(m);	//filter
			contrastBitmapData.applyFilter(contrastBitmapData, contrastBitmapData.rect, new Point(0,0), contrast_filter); //apply filter to cloned bitmapdata
			
			return contrastBitmapData; //return cloned bitmap data
			
		}
		
		public static function applyBrightnessFilter(sourceBitmapData:BitmapData) {
			var colorBitmapData:BitmapData = sourceBitmapData.clone();		//cloned source	
			var value = 70;
            var m:Array = new Array();
            m = m.concat([1, 0, 0, 0, value]);  // red
            m = m.concat([0, 1, 0, 0, value]);  // green
            m = m.concat([0, 0, 1, 0, value]);  // blue
            m = m.concat([0, 0, 0, 1, 0]);      // alpha
            var brightness_filter = new ColorMatrixFilter(m);
			colorBitmapData.applyFilter(colorBitmapData, colorBitmapData.rect, new Point(0,0), brightness_filter); //apply filter to cloned bitmapdata
			
			return colorBitmapData;
		}
		//apply color filter;
		public static function applyColorFilterToBitmapData(sourceBitmapData:BitmapData):BitmapData{
			
			var colorBitmapData:BitmapData = sourceBitmapData.clone();		//cloned source	
	
            var v:Number = 120;
            var i:Number = (1 - v);
            var r:Number = (i * rLum);
            var g:Number = (i * gLum);
            var b:Number = (i * bLum);
			
            var m:Array = new Array();
            m = m.concat([(r + v), g, b, 0, 0]);    // red
            m = m.concat([r, (g + v), b, 0, 0]);    // green
            m = m.concat([r, g, (b + v), 0, 0]);    // blue
            m = m.concat([0, 0, 0, 1, 0]);          // alpha
   
			var color_filter:ColorMatrixFilter=new ColorMatrixFilter(m);	//filter
			
			colorBitmapData = applyBrightnessFilter(colorBitmapData);
			//colorBitmapData = applyContrastFilterToBitmapData(colorBitmapData,2);
			colorBitmapData.applyFilter(colorBitmapData, colorBitmapData.rect, new Point(0,0), color_filter); //apply filter to cloned bitmapdata
			
			return colorBitmapData; //return cloned bitmap data
			
		}
		
		public static function applyHighContColorFilterToBitmapData(sourceBitmapData:BitmapData):BitmapData{
			
			var colorBitmapData:BitmapData = sourceBitmapData.clone();		//cloned source	
			var s: Number = 211; //211 108
            var o : Number = 108 * (1 - s);
            var m:Array = new Array();
            m = m.concat([s*100, 0, 0, 0, o]);  // red
            m = m.concat([0, s, 130, 0, o]);  // green
            m = m.concat([90, 0, s, 0, o]);  // blue
            m = m.concat([0, 0, 0, 1, o]);  // alpha
			
			var color_filter:ColorMatrixFilter=new ColorMatrixFilter(m);	//filter
			
			colorBitmapData.applyFilter(colorBitmapData, colorBitmapData.rect, new Point(0,0), color_filter); //apply filter to cloned bitmapdata
			
			return colorBitmapData; //return cloned bitmap data
			
		}
		
		public static function applyHCColorFilterToBitmapData(sourceBitmapData:BitmapData):BitmapData{
				
			var colorBitmapData:BitmapData = sourceBitmapData.clone();		//cloned source	
	/*
			var matrix:Array = new Array();
			matrix=matrix.concat([1.5,0,0,0,1]);// red
			matrix=matrix.concat([0,1.5,0,0,10]);// green
			matrix=matrix.concat([0,0,1.5,0,0]);// blue
			matrix=matrix.concat([0,0,0,1,0]);// alpha
			
			var matrix:Array = new Array();
            matrix = matrix.concat([1,0,0,0,0]);
            matrix = matrix.concat([0,1,0,0,0]);
            matrix = matrix.concat([0,0,1,0,0]);
            matrix = matrix.concat([0,0,0,1,0]);
			*/
			var r:Number=0.212671;
	var g:Number=0.715160;
	var b:Number=0.12169;
 
	var matrix:Array = [r, g, b, 0, 0,
                                      r, g, b, 0, 0,
                                      r, g, b, 0, 0,
                                      0, 0, 0, 1, 0];
									  
			
			var color_filter:ColorMatrixFilter=new ColorMatrixFilter(matrix);	//filter
			
			colorBitmapData = applyHighContColorFilterToBitmapData(colorBitmapData);
			//colorBitmapData.applyFilter(colorBitmapData, colorBitmapData.rect, new Point(0,0), color_filter); //apply filter to cloned bitmapdata
			
			colorBitmapData = invertBWBitmapData(colorBitmapData);
			var colorToReplace:uint = 0x00ffff;
			var newColor:uint = 0x000000ff;
			var maskToUse:uint = 0x0000ffff;
			
			var colorTwoToReplace:uint = 0x363636;
			
			var rect:Rectangle = new Rectangle(0,0,colorBitmapData.width,colorBitmapData.height);
			var p:Point = new Point(0,0);
			colorBitmapData.threshold(colorBitmapData, rect, p, "==", colorToReplace, newColor, maskToUse, true);
			//colorBitmapData.threshold(colorBitmapData, rect, p, "==", colorTwoToReplace, newColor, maskToUse, true);
		
			return colorBitmapData; //return cloned bitmap data
			
		}
		
		
	}
	
}
