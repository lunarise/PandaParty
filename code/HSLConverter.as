package code {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
   
   //from http://sakef.jp/blog/2010/10/rgb2hsv/
   
	public static class HSLConverter extends Sprite
   {
       
      //RGB → HSV変換関数 
      public static function RGB2HSV(color:uint):Array
      {
         var hsv:Array = [0, 0, 0];
         var r:Number = ((color >> 16) & 0xFF) / 255;
         var g:Number = ((color >> 8) & 0xFF)/255;
         var b:Number = (color & 0xFF) / 255;
         var max:Number = Math.max(r,g,b);
         var min:Number = Math.min(r,g,b);
         if(max != 0)
         {
            hsv[1] = (max - min) / max;
            if(max == r) hsv[0] = 60 * (g - b)/(max-min);
            else if(max == g) hsv[0] = 60 * (b - r)/(max - min) + 120;
            else hsv[0] = 60 * (r - g)/(max - min) + 240;
            if(hsv[0] < 0) hsv[0] += 360;
         }
         hsv[2] = max;
         return hsv;
      }
       
      // HSV → RGB変換関数
      public static function HSV2RGB(h:Number, s:Number, v:Number):uint
      {
         if(s == 0) return uint(v*255<<16) | uint(v*255<<8) | uint(v*255);
         else
         {
            var rgb:uint = 0xffffff;
            var hi:int = (h/60)>>0;
            var f:Number = (h/60 - hi);
            var p:Number = v*(1 - s);
            var q:Number = v*(1 - f*s);
            var t:Number = v*(1-(1-f)*s);
            if(hi==0) rgb = uint(v*255<<16) | uint(t*255<<8) | uint(p*255);
            else if(hi==1) rgb = uint(q*255<<16) | uint(v*255<<8) | uint(p*255);
            else if(hi==2) rgb = uint(p*255<<16) | uint(v*255<<8) | uint(t*255);
            else if(hi==3) rgb = uint(p*255<<16) | uint(q*255<<8) | uint(v*255);
            else if(hi==4) rgb = uint(t*255<<16) | uint(p*255<<8) | uint(v*255);
            else if(hi==5) rgb = uint(v*255<<16) | uint(p*255<<8) | uint(q*255);
            return rgb;
		}

	}
	
}
