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
		
		public static const rc:Number = .5, gc:Number = .5, bc:Number = .5;
		public static const rLum:Number = 0.2225, gLum:Number = 0.7169, bLum:Number = 0.0606;
		public static const threshold = 150; //10
		public static var bwMatrix:Array = new Array();
			bwMatrix = bwMatrix.concat([0.5,0.5,0.5,0,0]);// red
			bwMatrix = bwMatrix.concat([0.5,0.5,0.5,0,0]);// green
			bwMatrix = bwMatrix.concat([0.5,0.5,0.5,0,0]);// blue
			bwMatrix = bwMatrix.concat([0,0,0,1,0]);// alpha
			

		public static const cmf:ColorMatrixFilter = new ColorMatrixFilter([rc, gc, bc, 0, 0, rc, gc, bc, 0, 0, rc, gc, bc, 0, 0, 0, 0, 0, 1, 0]);
			
		public function Filters() {
		}
		
		public static function applyBlobDetectFiltersViaContrast(bmp:BitmapData):BitmapData {
			var img_bmp:BitmapData = bmp.clone(); //cloned source
			//img_bmp = applyBrightnessFilter(img_bmp,69);
			img_bmp = applyContrastFilterToBitmapData(img_bmp,10);
			img_bmp = applyBWFilterToBitmapData(img_bmp);
			
			var pt:Point = new Point(0, 0);
			var rect:Rectangle = new Rectangle(0, 0,img_bmp.width,img_bmp.height);

			//img_bmp.threshold(img_bmp, rect, pt, "==", 0xff000000, 0xffffffff, 0xffffffff,true);
			//img_bmp.threshold(img_bmp, rect, pt, "<", 0xff709090, 0xffffffff, 0xffffffff,true);
			//img_bmp = applyBrightnessFilter(img_bmp);
			//preserve reds; modify to green
			//img_bmp.threshold(img_bmp, rect, pt,">", 0xff10101f,0xff00ff00,0xffffff,true);
			//img_bmp.threshold(img_bmp, rect, pt,"<", 0xff2020ff,0xff00ff00,0xffffff,true);
			//img_bmp.threshold(img_bmp, rect, pt,"<", 0xffff5f5f,0xff00ff00,0xffffff,true);
			
			var threshold:uint =  0x604545; //0xf4f4f4 Dark Grey -->0x000030
			var color:uint = 0xffffffff; //Replacement color (white)
			var maskColor:uint = 0xffffff; //What channels to affect (0xffffff is the default).
			
			/* START FOR KEEPING BLUE,GREEN
			ar pt:Point = new Point(0, 0);
			var rect:Rectangle = new Rectangle(0, 0,img_bmp.width,img_bmp.height);
			var threshold:uint =  0xFFA08080; //Dark Grey  //f4f4f4
			var color:uint = 0xffffff00; //Replacement color (white)
			var maskColor:uint = 0xFFFF0000; //What channels to affect (this is the default).
			*/
			
			
		//	img_bmp = applyDarknessFilter(img_bmp);
			//img_bmp = applyBWFilterToBitmapData(img_bmp);
			//img_bmp = invertBWBitmapData(img_bmp);
			//img_bmp.threshold(img_bmp, rect, pt,"<", threshold, color, maskColor,true);
			
			//img_bmp.threshold(img_bmp, rect, pt,"<",0x6E4545, 0xffffff, 0xff000000, true);
			//img_bmp =  applyLightColorFilterToBitmapData(img_bmp);
			//img_bmp.threshold(img_bmp, rect, pt,"==", threshold, color, maskColor,false);
			//img_bmp.threshold(img_bmp, rect, pt, "==", 0xffffff00, 0x000000, 0x000000);
			//img_bmp = applyBrightnessFilter(img_bmp);
			//img_bmp = applyBWFilterToBitmapData(img_bmp);
			//img_bmp = invertBWBitmapData(img_bmp);
			//img_bmp =  applyHighContrastColorFilterToBitmapData(img_bmp);
			//img_bmp.threshold(img_bmp, rect, pt,"!=", 0x00000000, 0xffffffff, maskColor,true);
			
			
			
			return img_bmp;
		}
		
				//apply color filter;
		public static function applyLightColorFilterToBitmapData(sourceBitmapData:BitmapData):BitmapData{
			
			var colorBitmapData:BitmapData = sourceBitmapData.clone();		//cloned source	
			colorBitmapData = applyBrightnessFilter(colorBitmapData,29);
			colorBitmapData = applyContrastFilterToBitmapData(colorBitmapData,6);
            var v:Number = 10;
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
			
			//colorBitmapData = applyBrightnessFilter(colorBitmapData);
			//colorBitmapData = applyContrastFilterToBitmapData(colorBitmapData,2);
			//colorBitmapData.applyFilter(colorBitmapData, colorBitmapData.rect, new Point(0,0), color_filter); //apply filter to cloned bitmapdata
			
			return colorBitmapData; //return cloned bitmap data
			
		}
		
		
		public static function applyBlobDetectFilters(bmp:BitmapData):BitmapData {
			var img_bmp:BitmapData = bmp.clone(); //cloned source
			img_bmp =  applyHighContrastColorFilterToBitmapData(img_bmp);
			
			var pt:Point = new Point(0, 0);
			var rect:Rectangle = new Rectangle(0, 0,img_bmp.width,img_bmp.height);
			var threshold:uint =  0xf4f4f4; //Dark Grey
			var color:uint = 0xffffff00; //Replacement color (white)
			var maskColor:uint = 0xffffff; //What channels to affect (this is the default).
			
			/* START FOR KEEPING BLUE,GREEN
			ar pt:Point = new Point(0, 0);
			var rect:Rectangle = new Rectangle(0, 0,img_bmp.width,img_bmp.height);
			var threshold:uint =  0xFFA08080; //Dark Grey  //f4f4f4
			var color:uint = 0xffffff00; //Replacement color (white)
			var maskColor:uint = 0xFFFF0000; //What channels to affect (this is the default).
			*/
			
		//	img_bmp = applyDarknessFilter(img_bmp);
			//img_bmp = applyBWFilterToBitmapData(img_bmp);
			//img_bmp = invertBWBitmapData(img_bmp);
			img_bmp.threshold(img_bmp, rect, pt,"<", threshold, color, maskColor,true);
			//img_bmp.threshold(img_bmp, rect, pt,"==", threshold, color, maskColor,false);
			//img_bmp.threshold(img_bmp, rect, pt, "==", 0xffffff00, 0x000000, 0x000000);
			img_bmp = applyBrightnessFilter(img_bmp);
			img_bmp = applyBWFilterToBitmapData(img_bmp);
			img_bmp = invertBWBitmapData(img_bmp);
			img_bmp =  applyHighContrastColorFilterToBitmapData(img_bmp);
			img_bmp.threshold(img_bmp, rect, pt,"!=", 0x00000000, 0xffffffff, maskColor,true);
			return img_bmp;
		}

		
		
		public static function applyBWFilterToBitmapData(sourceBitmapData:BitmapData):BitmapData{
			var bwBitmapData:BitmapData = sourceBitmapData.clone(); //cloned source
			bwBitmapData.applyFilter(bwBitmapData, bwBitmapData.rect, new Point(0,0), cmf); //apply filter to cloned bitmap data
			return bwBitmapData;
		}
		
		public static function invertBWBitmapData(sourceBitmapData:BitmapData):BitmapData {
			var invertedBitmapData:BitmapData = sourceBitmapData.clone(); //cloned source
			var invertTransform:ColorTransform = new ColorTransform(-1,-1,-1,1,255,255,255,0)
			invertedBitmapData.colorTransform(invertedBitmapData.rect, invertTransform);
			return invertedBitmapData;
		}
		
		public static function applyStaffFilterToBitmapData(sourceBitmapData:BitmapData):BitmapData{
			var bwBitmapData:BitmapData = sourceBitmapData.clone(); //cloned source

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
		
		
		public static function applyHighContrastColorFilterToBitmapData(sourceBitmapData:BitmapData,severity:Number=101):BitmapData{
			
			var contrastBitmapData:BitmapData = sourceBitmapData.clone();		//cloned source	
			var s: Number = 1.2;
            var o : Number = 0;
            var m:Array = new Array();
            m = m.concat([s, 0, 0, 0, o]);  // red
            m = m.concat([0, s, 0, 0, o]);  // green
            m = m.concat([0, 0, s, 0, o]);  // blue
            m = m.concat([0, 0, 0, 1, 0]);  // alpha
			
			var contrast_filter:ColorMatrixFilter=new ColorMatrixFilter(m);	//filter
			contrastBitmapData.applyFilter(contrastBitmapData, contrastBitmapData.rect, new Point(0,0), contrast_filter); //apply filter to cloned bitmapdata
			
			//contrastBitmapData = applyContrastFilterTwoToBitmapData(contrastBitmapData);
			return contrastBitmapData; //return cloned bitmap data
			
		}
		
		public static function applyContrastFilterTwoToBitmapData(sourceBitmapData:BitmapData,severity:Number=101):BitmapData{
			
			var contrastBitmapData:BitmapData = sourceBitmapData.clone();		//cloned source	
			var s: Number = 0;
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
		
		public static function applyDarknessFilter(sourceBitmapData:BitmapData) {
			var colorBitmapData:BitmapData = sourceBitmapData.clone();		//cloned source	
			var value = -80;
            var m:Array = new Array();
            m = m.concat([1, 0, 0, 0, value]);  // red
            m = m.concat([0, 1, 0, 0, value]);  // green
            m = m.concat([0, 0, 1, 0, value]);  // blue
            m = m.concat([0, 0, 0, 1, 0]);      // alpha
            var brightness_filter = new ColorMatrixFilter(m);
			colorBitmapData.applyFilter(colorBitmapData, colorBitmapData.rect, new Point(0,0), brightness_filter); //apply filter to cloned bitmapdata
			
			return colorBitmapData;
		}
		
		public static function applyBrightnessFilter(sourceBitmapData:BitmapData,value:int=5) {
			var colorBitmapData:BitmapData = sourceBitmapData.clone();		//cloned source	

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
			colorBitmapData = applyContrastFilterToBitmapData(colorBitmapData,2);
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
			var colorToReplace:uint = 0x112331;
			var newColor:uint = 0xffffff;
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
