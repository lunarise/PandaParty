package code
{
	import flash.display.BitmapData;
	import code.SampleColors;
	public class NoteDetection
	{

		//Array containing ranges and note types corresponding to the color
		var ranges:Array = new Array();

		//Green
		ranges[0] = new Object();
		ranges[0].Low = 145;
		ranges[0].High = 160;
		ranges[0].Name = "quarter";

		//Green (Alt Values)
		ranges[1] = new Object();
		ranges[1].Low = 57;
		ranges[1].High = 61;
		ranges[1].Name = "quarter";

		//Yellow
		ranges[2] = new Object();
		ranges[2].Low = 35;
		ranges[2].High = 41;
		ranges[2].Name = "rest";

		//Pink
		ranges[3] = new Object();
		ranges[3].Low = 325;
		ranges[3].High = 331;
		ranges[3].Name = "upsidedown_hat";

		//Blue
		ranges[4] = new Object();
		ranges[4].Low = 235;
		ranges[4].High = 250;
		ranges[4].Name = "hat";

		//Red
		ranges[5] = new Object();
		ranges[5].Low = 349;
		ranges[5].High = 360;
		ranges[5].Name = "whole";

		//Red (Alt Values)
		ranges[6] = new Object();
		ranges[6].Low = 0;
		ranges[6].High = 4;
		ranges[6].Name = "whole";

		//Orange
		ranges[7] = new Object();
		ranges[7].Low = 14;
		ranges[7].High = 18;
		ranges[7].Name = "half";


		public function NoteDetection()
		{


		}

		//Function to detect note
		public static function detectNote(bitmapData:BitmapData)
		{

			var hueVal:int = Math.round(SampleColors.getAverageColor(bitmapData));

			for (var i:int = 0; i < ranges.length; i++)
			{


				if (hueVal >= ranges[i].Low && hueVal <= ranges[i].High)
				{

					return ranges[i].Name;

				}
			}

		}
	}
}