package net.sakri.so_texty.util{
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	
	public class TextFieldUtil{
		

		public static function cloneTextField(tf:TextField):TextField{
			var field:TextField=new TextField();
			//field.alpha=tf.alpha;
			field.antiAliasType=tf.antiAliasType;
			field.autoSize=tf.autoSize;
			field.background=tf.background;
			field.backgroundColor=tf.backgroundColor;
			field.border=tf.border;
			field.borderColor=tf.borderColor;
			//field.defaultTextFormat=tf.defaultTextFormat;
			field.embedFonts=tf.embedFonts;
			field.height=tf.height;
			field.multiline=tf.multiline;
			field.opaqueBackground=tf.opaqueBackground;
			field.selectable=tf.selectable;
			field.width=tf.width;
			field.textColor=tf.textColor;
			field.sharpness=tf.sharpness;
			//field.styleSheet=tf.styleSheet;
			field.defaultTextFormat=tf.getTextFormat();
			if(tf.htmlText==null){
				field.htmlText=tf.htmlText;				
			}else{
				field.text=tf.text;		
			}
			return field;
		}

		public static function createBasicTextField(text:String,font:String="Verdana",size:uint=80,color:uint=0x000000):TextField{
			var tf:TextField=new TextField();
			tf.width=tf.height=10;
			var format:TextFormat=new TextFormat(font,size,color,true);
			tf.autoSize=TextFieldAutoSize.LEFT;
			tf.text=text;
			tf.setTextFormat(format);
			return tf;
		}

	}
}