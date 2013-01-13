package  {
	
	import flash.display.MovieClip;
	import Tone;
	import flash.media.Sound;
	import flash.events.SampleDataEvent;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.events.TimerEvent;
	
	public class SoundPlayer extends MovieClip {
		
		private var beatCounter;
		private var noteData;
		private var noteValue;
		private var noteLengthValue;
		private var _tone:Tone;
		private var timer:Timer;
		private var cleanedArray = new Array();
		
		public function SoundPlayer() {
			
			//sampleNoteArray is an array used to hold all the note data for a given measure
			//it is populated by nested arrays like SampleNoteData, which hold data like the note (for ex. c2) at [0] and the noteLength (for ex. a quarter note) at [1]
			//in this example, sampleNoteArray is holding 4 SampleNoteData arrays which hold data on notes
			var sampleNoteArray = new Array;
			var sampleNoteData = new Array;
			sampleNoteData[0] = "c2";
			sampleNoteData[1] = "quarter";
			var sampleNoteData2 = new Array;
			sampleNoteData2[0] = "g1";
			sampleNoteData2[1] = "quarter";
			var sampleNoteData3 = new Array;
			sampleNoteData3[0] = "a2";
			sampleNoteData3[1] = "quarter";
			var sampleNoteData4 = new Array;
			sampleNoteData4[0] = "f1";
			sampleNoteData4[1] = "quarter";
			//append each sampleNoteData to the end of the sampleNoteArray
			sampleNoteArray.push(sampleNoteData);
			sampleNoteArray.push(sampleNoteData2);
			sampleNoteArray.push(sampleNoteData3);
			sampleNoteArray.push(sampleNoteData4);
			
			
			
			
			cleanedArray = populateMeasureData(sampleNoteArray);
			trace("UP TOP cleanedArray " + [beatCounter] + " equals: " + cleanedArray[beatCounter]);
			
			//this will play the information according to the data in sampleNoteArray
			//playMeasure take in an int for tempo(simplified to the total amount of milliseconds in the measure), and the array containing all the note data for the measure
			playMeasure(2000,cleanedArray);
			
			
		}
		//this takes in an argument for the note length, ex. quarter, half, whole, and associates them with an appropriate number representation
		public function getNoteLength(theNoteLength:String){
			trace("getting note length");
			var returnNoteLength;
			if(theNoteLength == "quarter"){
				returnNoteLength = .25;
			}
			if(theNoteLength == "half"){
				returnNoteLength = .5;
			}
			if(theNoteLength == "whole"){
				returnNoteLength = 1;
			}
			
			return returnNoteLength;
		}
		
		public function getFrequency(theNote:String){
			trace("getting the frequency");
			
			var _notes = new Array;
			
			
			//Array whit the frequency of notes
			_notes.push(262.43); //C4
			_notes.push(293.67); //D4
			_notes.push(329.63); //E4
			_notes.push(349.23); //F4
			_notes.push(392.00); //G4
			_notes.push(440.00); //A4
			_notes.push(493.88); //B4
			
			_notes.push(523.25); //C5
			_notes.push(587.33); //D5
			_notes.push(659.26); //E5
			_notes.push(698.46); //F5
			_notes.push(783.99); //G5
			_notes.push(880.00); //A5
			_notes.push(987.77); //B5
			
			var returnFrequency;
			if(theNote == "c1"){
				returnFrequency = _notes[0];
			}
			if(theNote == "d1"){
				returnFrequency = _notes[1];
			}
			if(theNote == "e1"){
				returnFrequency = _notes[2];
			}
			if(theNote == "f1"){
				returnFrequency = _notes[3];
			}
			if(theNote == "g1"){
				returnFrequency = _notes[4];
			}
			if(theNote == "a1"){
				returnFrequency = _notes[5];
			}
			if(theNote == "b1"){
				returnFrequency = _notes[6];
			}
			if(theNote == "c2"){
				returnFrequency = _notes[7];
			}
			if(theNote == "d2"){
				returnFrequency = _notes[8];
			}
			if(theNote == "e2"){
				returnFrequency = _notes[9];
			}
			if(theNote == "f2"){
				returnFrequency = _notes[10];
			}
			if(theNote == "g2"){
				returnFrequency = _notes[11];
			}
			if(theNote == "a2"){
				returnFrequency = _notes[12];
			}
			if(theNote == "b2"){
				returnFrequency = _notes[13];
			}
			
			return returnFrequency;
			
			
			
			
		}
		
		public function playMeasure(tempo:int,noteArray:Array){
			trace("in playMeasure");
			
			var defaultTempo = 2000;
			const BPM = 4;
			beatCounter = 0;
			timer  = new Timer(tempo/BPM,BPM);
			
			//sleep for appropriate amount of time based on noteLengthValue and tempo or default tempo (length of time will be tempo*noteLengthValue)
			timer.addEventListener(TimerEvent.TIMER, beat);
    		timer.start();
				
			
			
			
			
			
			
		}
		public function beat(event:TimerEvent):void {
			trace("in beat");
			trace("cleanedArray " + [beatCounter] + " equals: " + cleanedArray[beatCounter]);
			if(cleanedArray[beatCounter] != null){
      			noteData = cleanedArray[beatCounter];
				noteValue = noteData[0];
				noteLengthValue = getNoteLength(noteData[1]);
				trace("the note is: " + noteValue);
				trace("the note length is: " + noteLengthValue);
				trace("hey in loop for " + beatCounter + " time");
       			_tone = new Tone(getFrequency(noteValue));
				_tone.play();
			}
			beatCounter++;
		}
		public function populateMeasureData(noteArray:Array){
			trace("in populateMeasureData");
			var currentNoteArray = new Array();
			var newNoteArray = new Array();
			var currentNote;
			var currentNoteLength;
			var theCounter = 0;
			trace("popmeasuredata array length is: " + noteArray.length);
			while(theCounter < noteArray.length){
				trace("in while loop for popmearuredata");
				currentNoteArray = noteArray[theCounter];
				currentNote = currentNoteArray[0];
				currentNoteLength = currentNoteArray[1];
				newNoteArray.push(currentNoteArray);
				if(currentNoteLength == 'whole'){
					newNoteArray.push(null);
					newNoteArray.push(null);
					newNoteArray.push(null);
					
				}
				else if(currentNoteLength == 'half'){
					newNoteArray.push(null);
					
				}
				theCounter++;
				
				
			}
			
			return newNoteArray;
			
			
			
		}
	}
	
	
	
}
