package  code {
	import flash.events.*;
	import flash.net.*;
	import code.Staff;
	
	public class LessonOne extends Lessons {
		var question:String;
		var myDoc:Document;
		
		public function LessonOne(theDoc:Document) {
			lesson = 0;
			myDoc = theDoc;
		}
		
		
		override public function getXML():void {
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, loadXML);
			xmlLoader.load(new URLRequest("code/xml/lessons.xml"));
		}
		
		override public function loadXML(e:Event):void {
			lessonXML = new XML(e.target.data);
			getLesson();
		}
		
		override public function getLesson():void {
			myDoc.instructions.text = lessonXML.question.directions.text()[lesson];
			var letter:String = lessonXML.question.answers.answer.text()[randomizeQuestion()];
			
			trace(letter);
			Staff.drawLines(myDoc,letter);
		}

		override public function randomizeQuestion():int {
			return Math.floor(Math.random() * lessonXML.question.answers.answer.length());
		}

	}
	
}
