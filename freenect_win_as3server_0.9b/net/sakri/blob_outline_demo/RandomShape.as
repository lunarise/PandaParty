package net.sakri.blob_outline_demo{
	
	import flash.display.Shape;

	public class RandomShape extends Shape{
		
		public function RandomShape(min_size:uint=10,max_size:uint=20,color:uint=0xFF0000){
			super();
			render(min_size,max_size,color);
		}
		
		protected function render(min_size:uint,max_size:uint,color:uint):void{
			if(max_size<=min_size)max_size=min_size+1;
			this.graphics.beginFill(color);
			if(Math.random()>.5){
				var radius:uint=Math.round(min_size/2+Math.random()*(max_size/2-min_size/2));
				this.graphics.drawCircle(0,0,radius);				
			}else{
				var width:uint=Math.round(min_size+Math.random()*(max_size-min_size));
				var height:uint=Math.round(min_size+Math.random()*(max_size-min_size));
				this.graphics.drawRect(-Math.floor(width/2),-Math.floor(height/2),width,height);
			}


			this.graphics.endFill();
		}
		
	}
}