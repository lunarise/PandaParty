package code {
	import flash.display.*;
	
	public class Staff extends MovieClip {
		private var staff: Array = new Array(
											  new Array("high f"),
											  new Array("d"),
											  new Array("b"),
											  new Array("g"),
											  new Array("low e"));
											  
		
		private var existingNotes:Array = new Array();
		
		public function Staff(doc:Document,emphasis:String="none") {
			drawLines(doc,emphasis);
		}
		
		//draw all lines for staff on scripsi stage
		private function drawLines(doc:Document,emphasis:String="none") {
			var wholeStaff:Shape = new Shape(); 
			var sHeight:int = doc.staffArea.height;
			var sWidth:int = doc.staffArea.width;
			var lineSpace:int = doc.staffArea.height/6
			
			//for every staff line in array, draw a line that spans from staffArea movieclip x to its width
			for(var i:int=1; i <= staff.length; i++) {
				if(emphasis=="none" || emphasis !== staff[i-1][0] ) {
					wholeStaff.graphics.lineStyle(2, 0x000000, 1);
				} else {/*
					if(emphasis === staff[i-1][0])
						wholeStaff.graphics.lineStyle(5, 0x000000, 1);*/
				}
			
				wholeStaff.graphics.moveTo(doc.staffArea.x, doc.staffArea.y+(lineSpace * i)); 
				wholeStaff.graphics.lineTo(doc.staffArea.x + doc.staffArea.width, doc.staffArea.y+(lineSpace * i));
				doc.addChild(wholeStaff);
				
				staff[i-1].push(new Array(doc.staffArea.x,doc.staffArea.y+(lineSpace * i)));
			}
		}
		
		//add notes to digital stage
		public function addNote(doc:Document,note:String="e",type:String="quarter") {
			if(type == "")
				type = "quarter";
			var lineSpace:int = doc.staffArea.height/6
			var theNote:MusicNote = new MusicNote(doc,staff,lineSpace,note,type);
			doc.addChild(theNote);
			existingNotes.push(theNote);
		}
		
		
		//clean staff - Called in LessonOne -> First function called in checkStaff, taking in document reference
		public function cleanStaff(doc:Document){
			
			for(var i:int = 0; i < existingNotes.length; i++){

				doc.removeChild(existingNotes[i]);
				existingNotes[i] = null;
				
			}
		
		}

	}
	
}
