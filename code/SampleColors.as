package code {
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	public class SampleColors {
		import code.ColorControl;
		
		
		//each sub array defines a color, min/max rgb vals for detecting that color, and what type of note it represents
		public static const colors:Array = new Array(
										   new Array(
													 "blue",
													 new Array(0,0,150),
													 new Array(170,200,255),
													 "quarter"
													 ),
											new Array(
													 "orange",
													 new Array(150,0,0),
													 new Array(255,40,40)
													 ),
											new Array(
													 "red",
													 new Array(150,0,150),
													 new Array(255,40,255),
													 "half"
													 ),
										   new Array(
													 "green",
													 new Array(0,40,0),
													 new Array(90,255,90),
													 "whole"
											),
											new Array(
													  "black",
													  new Array(0,0,0),
													  new Array(37,37,37),
													  "line"
											));
		

	
		public function SampleColors() {
			//constructor
		}
		
		/*
		public static function getRandomColors(blobRect:Rectangle,bmp:BitmapData) {
			trace(blobRect);
			var randomX:int = Math.random()*bmp.width;
			//var randomY:int = ;
			trace(randomX);
		}*/
		
		//Does color satisfy our vals?
		//param - array of rgb
		public static function determineColor(rgb:Object):String {
			var found:Boolean = false;
			var color:String = "none";
			var note:String = "none";
			
			//cycle through array of colors at the top, determine if passed in RGB channel is between our min/max vals - if it is, stop the show!
			for(var i:int = 0; i < colors.length; i++) {
				if((rgb.red >= colors[i][1][0] && rgb.green >= colors[i][1][1] && rgb.blue >= colors[i][1][2]) &&
				   (rgb.red <= colors[i][2][0] && rgb.green <= colors[i][2][1] && rgb.blue <= colors[i][2][2])) 
				{
					found = true;
					
					if(found) {
						color = colors[i][0]; // store color in case I want it later (right now I don't)
						note = colors[i][3]; //what note is this color representing?
						break;
					}
				} 
			}
		
			return note; // return what kind of note this is. returns color name OR "none"
			
		}
	}
	
}
