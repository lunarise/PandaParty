package  code {
	import flash.events.*;
	import flash.net.*;
	import code.Staff;
	import code.SoundPlayer;
	
	public class LessonOne extends Lessons {
		private var answer:String;
		private var myDoc:Document;
		private var soundPlayer:SoundPlayer;
		//how long is each individual part?
		private var partOneLen:int = 0;
		private var partTwoLen:int = 0;
		
		//trackers
		private var currentPart:int = 0; //part 1 or 2? 0=1, 1=2 (must be this way to access xml)
		private var currentQuestion:int = 0; //question # out of total parts (for use in progress bar)
		
		//
		public var didPlaceNote:Boolean = false;
		//what have I asked?
		private var answerArray:Array = new Array();
		public var lessonFinished:Boolean = false;
		private var staff:Staff;
		
		public function LessonOne(theDoc:Document) {
			lesson = 0;
			myDoc = theDoc;
			currentQuestion = answerArray.length;
			currentPart = 0;
		}
		
		//start setting xml vars
		override public function getXML():void {
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, loadXML);
			xmlLoader.load(new URLRequest("code/xml/lessons.xml"));
		}
		
		//load xml in. set some vars so we know when to switch from p1 to p2 later.
		//call getLesson now that we have our xml and vars all set.
		override public function loadXML(e:Event):void {
			lessonXML = new XML(e.target.data);
			partOneLen =  lessonXML.question.section[0].answers.answer.length();
			partTwoLen =  lessonXML.question.section[1].answers.answer.length();
			getLesson();
		}
		
		//load lesson data! depends which part we're on.
		override public function getLesson():void {
			
			//relace _  in XMl with random letter/note type/etc!
			var charToReplace:RegExp = /_/;  
			
			//generate instructions and note.
			var instructions:String = lessonXML.question.section[currentPart].directions.text();
			var note:String = getQuestion();
			myDoc.lessonInstructions.text =  instructions.replace(charToReplace,note.toUpperCase());
			
			trace(note + "; "+instructions.replace(charToReplace,note.toUpperCase()));
			
			//listen for the events. did they do it?
			myDoc.addEventListener(Event.ENTER_FRAME,checkStaff);
			staff = new Staff(myDoc,note);
			staff.addNote(myDoc,note,"quarter_note");
		}
		
		//calls itself until it gets a question the user hasn't already answered
		private function getQuestion():String {
			didPlaceNote = false;
			
			var noteID:int = randomizeQuestion(); // array key for found note in xml
			var note:String = lessonXML.question.section[currentPart].answers.answer.text()[noteID];
			
			//if there's answers in answerArray, we have already asked the user some questions. gotta ask new ones
			if(answerArray.length > 0) {
				//keeps track of how many notes we've checked are not the note.
				var notTheNote:int = 0;

				//if all answers in the array are not the note, then we can ask this question
				while(notTheNote !== answerArray.length) {
					
					//loop through all answers in array
					for(var i:int=0; i < answerArray.length; i++) {
						
						//if note is not at this array position, we can now check the next position
						if(note !== answerArray[i]) {
							//trace(note+" is not "+answerArray[i]);
							notTheNote++;
							
							//with this incrementation, have we met our requirement? if so we're done, stop this for loop
							if(notTheNote === answerArray.length)
								break;
						
						//otherwise, this note is in the array. we can't ask about this note. generate a new one. 
						//most importantly, set notTheNote var back to 0 because we have to check from index 0 in the next loop again
						} else {
							//trace(note+" is "+answerArray[i]+", regenerating");
							noteID = randomizeQuestion();
							note = lessonXML.question.section[currentPart].answers.answer.text()[randomizeQuestion()];
							//trace("now looking for "+note);
							notTheNote = 0;
						}
					}
					

				}
			} 
			
			storeOldQuestions(note);
			//trace("now on question "+currentQuestion);
			//trace("part #"+currentPart);

			
			return note;
		}

		override public function randomizeQuestion():int {
			return Math.floor(Math.random() * lessonXML.question.section[currentPart].answers.answer.length());
		}
		
		//mark this question as asked. set currentQuestion if needed, etc.
		private function storeOldQuestions(question:String) {
			answer = question;
			answerArray.push(question);
			currentQuestion++;
			//removeStaff();
			

			if(currentQuestion === partOneLen+1) 
				currentPart = 1;
			
			if(currentQuestion > (partOneLen + partTwoLen)) 
				lessonFinished = true;
		}
		
		private function checkStaff(e:Event) {
			if(myDoc._blob_array.length > 0) {
				trace(myDoc._blob_array[0]);
				
				if(myDoc._blob_array[0][2]) {
					if(myDoc._blob_array[0][2] === answer) {
						trace("correct!");
						showFeedback(true);
						getQuestion();
					} else {
						showRespond(false);
						trace("false!");
					}
				} else {
					trace("letter doesn't exist quite yet");
				}
			}
		}
		
		private function showFeedback(correct:Boolean) {
			if(correct) {
				soundPlayer = new SoundPlayer();
				soundPlayer.playTone(answer);
			} else {
				//add incorrect sound here?
			}
		}

	}
	
}
