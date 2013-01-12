package code
{
	import flash.display.BitmapData;
	import code.SampleColors;
	public class NoteDetection
	{

		//Array containing ranges and note types corresponding to the color
		var ranges:Array = new Array();

		//Green - Half Note - half_note
		ranges[0] = new Object();
		ranges[0].Low = 145;
		ranges[0].High = 160;
		ranges[0].Name = "half_note";

		//Green (Alt Values) - Half Note - half_note
		ranges[1] = new Object();
		ranges[1].Low = 57;
		ranges[1].High = 61;
		ranges[1].Name = "half_note";

		//Yellow - Quarter Rest - quarter_rest
		ranges[2] = new Object();
		ranges[2].Low = 35;
		ranges[2].High = 41;
		ranges[2].Name = "quarter_rest";

		//Pink - Whole Rest - whole_rest
		ranges[3] = new Object();
		ranges[3].Low = 325;
		ranges[3].High = 331;
		ranges[3].Name = "whole_rest";

		//Blue - Half Rest - half_rest
		ranges[4] = new Object();
		ranges[4].Low = 235;
		ranges[4].High = 250;
		ranges[4].Name = "half_rest";

		//Red - Quarter Note - quarter_note
		ranges[5] = new Object();
		ranges[5].Low = 349;
		ranges[5].High = 360;
		ranges[5].Name = "quarter_note";

		//Red (Alt Values) - Quarter Note - quarter_note
		ranges[6] = new Object();
		ranges[6].Low = 0;
		ranges[6].High = 4;
		ranges[6].Name = "quarter_note";

		//Orange - Whole Note - whole_note
		ranges[7] = new Object();
		ranges[7].Low = 14;
		ranges[7].High = 18;
		ranges[7].Name = "whole";


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
