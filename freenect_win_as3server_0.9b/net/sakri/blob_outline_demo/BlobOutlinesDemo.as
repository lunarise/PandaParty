package net.sakri.blob_outline_demo{
	
	import __AS3__.vec.Vector;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import net.sakri.flash.bitmap.BitmapDataUtil;
	import net.sakri.flash.bitmap.BitmapEdgeScanner;
	import net.sakri.flash.bitmap.BitmapShapeExtractor;
	import net.sakri.flash.bitmap.ExtractedShapeCollection;
	import net.sakri.flash.component.SimpleStatsView;
			
	public class BlobOutlinesDemo extends Sprite{
		
		protected var _balls:Vector.<RandomShape>;
		protected var _num_shapes:uint;
		protected var _min_shape_size:uint=20;
		protected var _max_shape_size:uint=40;
		protected var _roam_space:Rectangle=new Rectangle(30,30,140,140);
		protected var _roam_space_center:Point;
		
		protected var _balls_snapshot:BitmapData;
		protected var _outline:BitmapData;
		protected var _outline_bm:Bitmap;
		
		protected var _shapes:ExtractedShapeCollection;
		protected var _stats:SimpleStatsView;
		protected var _bmd_width:uint;
		protected var _bmd_height:uint;
		protected var _scanner:BitmapEdgeScanner;
		
		public function BlobOutlinesDemo(num_balls:uint=30){
			super();
			_roam_space_center=new Point(_roam_space.x+Math.round(_roam_space.width/2),_roam_space.y+Math.round(_roam_space.height/2));
			_num_shapes=num_balls;
		}
		
		public function init():void{
			renderBalls();
			addEventListener(Event.ENTER_FRAME,enterFrame,false,0,true);
			_outline_bm=new Bitmap();
			_bmd_width=_roam_space.x*2+_roam_space.width;
			_bmd_height=_roam_space.y*2+_roam_space.height;
			_balls_snapshot=new BitmapData(_bmd_width,_bmd_height,true,0x00);
			_outline=new BitmapData(_bmd_width,_bmd_height,true,0x00);
			_outline_bm.x=400;
			addChild(_outline_bm);
			_scanner=new BitmapEdgeScanner(null);
			_stats=new SimpleStatsView();
			_stats.y=5;
			_stats.x=900;
			addChild(_stats);
		}
		
		protected function renderBalls():void{
			var ball:RandomShape;
			_balls=new Vector.<RandomShape>();
			for(var i:uint=0;i<_num_shapes;i++){
				ball=new RandomShape(_min_shape_size,_max_shape_size,0xFF0000);
				ball.x=_roam_space.x+Math.floor(Math.random()*_roam_space.width);
				ball.y=_roam_space.y+Math.floor(Math.random()*_roam_space.height);
				addChild(ball);
				_balls[i]=ball;
			}
		}
		
		protected function enterFrame(e:Event):void{
			for each(var b:RandomShape in _balls){
				if(_roam_space.contains(b.x,b.y)){
					b.x+=-2+Math.random()*4;
					b.y+=-2+Math.random()*4;
				}else{
					b.x=_roam_space_center.x;
					b.y=_roam_space_center.y;
				}				
			}
			_balls_snapshot.dispose();
			_balls_snapshot=new BitmapData(_bmd_width,_bmd_height,true,0x00);
			_balls_snapshot.draw(this);
			_outline.dispose();
			_outline=new BitmapData(_bmd_width,_bmd_height,true,0x00);
			_shapes=BitmapShapeExtractor.extractShapesDoubleSize(_balls_snapshot);
			var pixels:Vector.<Point>;
			var point:Point;
			var i:uint;
			for(i=0;i<_shapes.shapes.length;i++){
				drawEdgePoints(_shapes.shapes[i],_outline);
				/*
				pixels=getEdgePointsFromBitmapData(_shapes.shapes[i]);
				for each(point in pixels){
					_outline.setPixel32(Math.floor(point.x/2),Math.floor(point.y/2),0xFFFF0000);
				}*/
			}

			if(_shapes.negative_shapes.length){
				//shapes.negative_shapes[0] is the "space" around the character
				for(i=1;i<_shapes.negative_shapes.length;i++){
					drawEdgePoints(_shapes.negative_shapes[i],_outline);
					/*
					pixels=getEdgePointsFromBitmapData(_shapes.negative_shapes[i]);
					for each(point in pixels){
						_outline.setPixel32(Math.floor(point.x/2),Math.floor(point.y/2),0xFFFF0000);
					}*/
				}
			}
			
			_outline_bm.bitmapData=_outline;
		}
		
		public static const MAX_POINTS:uint=10000;//Failsafe
		protected function drawEdgePoints(bmd:BitmapData,draw_to:BitmapData):void{
			var first_non_trans:Point=BitmapDataUtil.getFirstNonTransparentPixel(bmd);
			if(first_non_trans==null)return;
			_scanner.reset(bmd);
			_scanner.moveTo(first_non_trans);
			var next:Point;
			//in the event of a bug (an error, infinate loop) in BitEdgeScanner, which is not perfect,
			//this loop stops at MAX_POINTS. Increase this number if working with big bitmapdatas. 
			for(var i:uint=0;i<MAX_POINTS;i++){
				next=_scanner.getNextEdgePoint();
				draw_to.setPixel32(Math.floor(next.x/2),Math.floor(next.y/2),0xFFFF0000);
				if(next.equals(first_non_trans))break;
				_scanner.moveTo(next);
			}
			//if(i>=MAX_POINTS)mx.controls.Alert.show("Error : shape scan has more than MAX_POINTS ("+MAX_POINTS+")");
		}
		
		public function destroy():void{
			removeEventListener(Event.ENTER_FRAME,enterFrame);
			for each(var b:RandomShape in _balls){
				removeChild(b);
				b=null;
			}
			_balls=null;
			_stats.destroy();
			removeChild(_stats);
			_balls_snapshot.dispose();
			_outline.dispose();
			removeChild(_outline_bm);
		}
		
	}
}