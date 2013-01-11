package code {
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import code.ColorControl;
	
	//I apologize, but I had to change some things because I was getting some errors, including a null error.
	
	public class SampleColors {
		
		//I made some changes to the red and orange array because I noticed red was being detected as orange.
		//If these ranges are off, please feel free to correct by copy and pasting from the last SampleColors file
		
		//new Array("color", minRed, minGreen, minBlue, maxRed, maxGreen, maxBlue)
		public static const colors:Array = new Array(	
											new Array("red", 150, 0, 0, 255, 40, 255),
											new Array("green", 0, 40, 0, 90, 255, 90),
											new Array("blue", 0, 0, 150, 170, 200, 255),
											new Array("orange", 200, 150, 0, 255, 225, 40)											
										);
	
		public function SampleColors() {
			//constructor
		}
		
		//Function to determine color by pass rgb
		//This was changed specifically because I was getting a null error before
		public static function determineColor(rgb:Object):String {

			for(var i:int=0 ; i < colors.length; i++ ){
				//Check range
				if( rgb.red >= colors[i][1] && rgb.red <= colors[i][4] &&
				    rgb.blue >= colors[i][2] && rgb.blue <= colors[i][5] &&
					rgb.green >= colors[i][3] && rgb.green <= colors[i][6]
				  ){
					//Return color
					return colors[i][0];
				}
			}

			return "not found";
			
		}
		
		public static function checkIfGrey(rgb:Object):Boolean{
			
			if(rgb.red >= rgb.green - 20 && rgb.red <= rgb.green + 20 && rgb.red >= rgb.blue - 20 && rgb.red <= rgb.blue + 20 && rgb.green >= rgb.blue - 20 && rgb.green <= rgb.blue + 20){
				return true;
			}
			else{
				
				return false;
				
			}
			
		}
		
		
		//Function that checks if non color -> OUTDATED
		public static function checkIfNonColor(rgb:Object){
			
			trace("current checkIfNonColor function is not used");
			//If white or black-> return true or return false
			if((rgb.red < 50 && rgb.green < 50 && rgb.blue < 50) || (rgb.red > 200 && rgb.green > 200 && rgb.blue > 200) || checkIfGrey(rgb))
			{
				return true;
			}
			else
				return false;
		}
		
		//
		public static function getAverageColor(blobBitmapData:BitmapData):Number{
			
			var maxSamples:int = 50; //Maximum number of samples to obtain
			var maxTries:int = 50; //Maximum number of tries to obtain a pixel
			var numOfSamples:int = 0; //Keep track of number of sampled pixels
			var numOfTries:int = 0; //Keep track of number of attempts to get another pixel to sample
			var blobWidth:int = Math.floor(blobBitmapData.width); //Get blob width
			var blobHeight:int = Math.floor(blobBitmapData.height); //Get blob height
			
			var red:int = 0;
			var green:int = 0;
			var blue:int = 0;
			
			while(numOfSamples < maxSamples){
				
				if(numOfTries > 50){
					
					break;
					trace("No color found within 50 tries!");
					
				}
				else{
					var aPixel:Object = ColorControl.hexToRGB(blobBitmapData.getPixel(Math.round(blobWidth * Math.random()),Math.round(blobHeight * Math.random())));
					
					if((aPixel.red == 0 && aPixel.green == 0 && aPixel.blue == 0) == false){
						red += aPixel.red;
						green += aPixel.green;
						blue += aPixel.blue;
						
						numOfTries = 0;     //reset number of tries to get another pixel
						numOfSamples++;
					}
					
					numOfTries++;
					
				}
				
			}
			
			red = red/numOfSamples;
			green = green/numOfSamples;
			blue = blue/numOfSamples;
				
			return ColorControl.getHueValueFromRGB(red, green, blue);
			
		}
	}
}
