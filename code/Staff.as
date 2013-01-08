package code {
	import flash.display.*;
	public class Staff {
		private static var staff: Array = new Array(
											  new Array("f"),
											  new Array("d"),
											  new Array("b"),
											  new Array("g"),
											  new Array("e"));
											  
		
		public static function drawLines(doc:Document,emphasis:String="none") {
				var wholeStaff:Shape = new Shape(); 
				//doc.staffArea;
				var sHeight:int = doc.staffArea.height;
				var sWidth:int = doc.staffArea.width;
				var lineSpace:int = doc.staffArea.height/6;
				
				for(var i:int=1; i <= staff.length; i++) {
					if(emphasis=="none" || emphasis !== staff[i-1][0] ) {
						wholeStaff.graphics.lineStyle(3, 0x000000, 1);
					} else {
						trace(staff[i-1][0]);
						if(emphasis === staff[i-1][0])
							wholeStaff.graphics.lineStyle(10, 0x000000, 1);
					}
					
					wholeStaff.graphics.moveTo(doc.staffArea.x, doc.staffArea.y+(lineSpace * i)); 
					wholeStaff.graphics.lineTo(doc.staffArea.x + doc.staffArea.width, doc.staffArea.y+(lineSpace * i));
					//wholeStaff.graphics.moveTo(0, 0); 
					//wholeStaff.graphics.lineTo(100,100);
					doc.staffArea.addChild(wholeStaff);
					
					staff[i-1].push(new Array(doc.staffArea.x,doc.staffArea.y+(lineSpace * i)));
			}
		}

	}
	
}
