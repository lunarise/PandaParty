package code {
	
	import flash.display.*;
	
	public class MusicNote extends MovieClip {
		
		//all possible staff letters
		private var fullStaff:Array = new Array(
											 new Array("low e"),
											 new Array("low f"),
											 new Array("g"),
											 new Array("a"),
											 new Array("b"),
											 new Array("c"),
											 new Array("d"),
											 new Array("high e"),
											 new Array("high f"));
											 
		private var staffLines:Array = new Array();
		private var lineSpacing:int = 0;
		private var note:String = "";
		private var noteType:String = "";
		private var doc:Document;
											
		public function MusicNote(theDoc:Document,staff:Array,linespacing:int,theNote:String,type:String="quarter")  {
			this.stop();
			//this will reflect its type (whole/quarter/half) - default is quarter if none specified
			this.gotoAndStop(type);
			this.alpha = 0;
			doc = theDoc;
			note = theNote;
			noteType = type;
			staffLines = staff;
			lineSpacing = linespacing;
			determineAllNotePositions();
			
			
		}
		
		private function determineAllNotePositions() {
			fullStaff.reverse();
			//k holds current line in staff array (indexes 0-4; notes egbdf)
			var k:int=0;
			
			//for each note in the note array (all possible notes on staff including notes between lines), compare to staff array (holds blob vals for staff lines egbdf)
			for(var i:int=0; i < staffLines.length; i++) {
				//if note's letter is same as staff's letter, we don't need to calculate positions (already have from blob detection)
				//trace(note);
				
				if(staffLines[i][0] === note) {
					//fullStaff[i].push(new Array(staffLines[k][1][0],staffLines[k][1][1]));
					this.x = doc.staffArea.x + 150;
					this.y = staffLines[i][1][1];
					 //trace("showing note 1 - "+note+" at "+i);
					 break;
				} else {
					//trace(note);
					//if((i+1) < fullStaff.length) {
					//if(fullStaff[i+1][0] === note) {
					//trace(fullStaff[i * 2 + 1][0] + " is being checked");
					if(fullStaff[i * 2 + 1][0] == note) {
						//trace(i * 2 + 1 + "is the fullstaff index");
						//trace("showing note 2 - "+fullStaff[i+1][0]+" at "+i);
						this.x = doc.staffArea.x + 150;
						this.y = staffLines[Math.ceil((i * 2 + 1) / 2)][1][1] - lineSpacing / 2;
						//trace(staffLines[i][1][1]);
						break;
					} 
				}
			}
			
		}

	}
	
}
