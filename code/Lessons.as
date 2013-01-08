package code {
	import flash.events.*;
	import flash.net.*;
	
	public class Lessons {
		var lessonXML:XML = new XML();
		var lesson:int;
		var doc:Document;
		
		public function Lessons() {
			getXML();
		}
		
		public function getXML():void {
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, loadXML);
			xmlLoader.load(new URLRequest("code/xml/lessons.xml"));
		}
		
		public function loadXML(e:Event):void {
			lessonXML = new XML(e.target.data);
			getLesson();
		}
		
		public function getLesson():void {
			trace(lessonXML.question.directions.text()[lesson]);
		}

		public function randomizeQuestion():int {
			return Math.round(Math.random() * lessonXML.question.answers[0].length);
		}
	}
	
}
