package  code {
	import flash.events.*;
	import flash.net.*;
	import code.Staff;
	import code.SoundPlayer;
	import code.MusicNote;
	import code.Feedback;
	import flash.utils.Timer;
	
	public class LessonOne extends Lessons {
		private var answer:String;
		private var myDoc:Document;
		
		//how long is each individual part?
		private var partOneLen:int = 0;
		private var partTwoLen:int = 0;
		
		//trackers
		private var currentPart:int = 0; //part 1 or 2? 0=1, 1=2 (must be this way to access xml)
		private var currentQuestion:int = 0; //question # out of total parts (for use in progress bar)
		private var numWrong:int = 0;
		//
		public var didPlaceNote:Boolean = false;
		//what have I asked?
		private var answerArray:Array = new Array();
		public var lessonFinished:Boolean = false;
		private var staff:Staff;
		private var soundPlayer:SoundPlayer; 
		private var timer:Timer;
		private var feedback:Feedback;
		
		private var correctFeedback = false;
		
		public function LessonOne(theDoc:Document) {
			lesson = 0;
			myDoc = theDoc;
			currentQuestion = answerArray.length;
			currentPart = 0;
			myDoc.addEventListener(Event.ENTER_FRAME,checkStaff);
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
			//
			staff = new Staff(myDoc,note);
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
			trace("here's the current part "+currentPart);

			if(currentQuestion === partOneLen+1) 
				currentPart = 1;
			
			if(currentQuestion > (partOneLen + partTwoLen))  {
				lessonFinished = true;
				myDoc.removeEventListener(Event.ENTER_FRAME,checkStaff);
			}
		}
		
		private function checkStaff(e:Event) {
			
			//clean staff
			staff.cleanStaff(myDoc);
			
			//if answer, user has placed note
			if(answer) {
				//double check, make sure there's really a note there. oh god  i hope there is.
				if(myDoc._blob_array.length > 0) {
					trace("this blob is a "+myDoc._blob_array[0]);
					
					//ok let's just double check. is that letter there?
					if(myDoc._blob_array[0][3]) {
						myDoc.removeEventListener(Event.ENTER_FRAME,checkStaff);
						timer = new Timer(1000,4);
						timer.start();
						
						staff.addNote(myDoc,myDoc._blob_array[0][3],myDoc._blob_array[0][2]);
						
						if(myDoc._blob_array[0][3] == answer) {
							feedback = new Feedback('Right');
							soundPlayer = new SoundPlayer();
							soundPlayer.playTone(answer);
							staff.addNote(myDoc,myDoc._blob_array[0][3],myDoc._blob_array[0][2]);
						} else {
							feedback = new Feedback('Wrong');
							trace("false!");
						}
						
						myDoc.addChild(feedback);
						timer.addEventListener(TimerEvent.TIMER_COMPLETE,removeFeedback);
					}
				} else {
					
				}
			}
		}
		
		private function removeFeedback(e:TimerEvent) {
			myDoc.staffArea.removeChild(staff);
			myDoc.removeChild(feedback);
			
			trace(feedback);
			staff = new Staff(myDoc);
			trace("4 seconds later");
			if(correctFeedback) {
				getLesson();
				
			} else {
				if(numWrong < 3) {
					numWrong++;
				} else {
					
				}
				
			}
		
			//myDoc.feedback.alpha = 0;
			myDoc.addEventListener(Event.ENTER_FRAME,checkStaff);
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE,removeFeedback);
			
		}

	}
	
}
