package gm2d.ui;

import flash.text.TextField;
import flash.display.BitmapData;
import flash.events.MouseEvent;
import flash.ui.Keyboard;
import gm2d.ui.Button;
import gm2d.skin.Skin;
import gm2d.ui.Layout;

class TextInput extends Control
{
   public var text(get_text,set_text):String;
   var mText:TextField;
   var mTextLayout:Layout;
   static var boxHeight = 22;

   public function new(inVal="", ?onUpdate:String->Void,?inLineage:Array<String>)
   {

       super(Widget.addLine(inLineage,"TextInput"));

       mText = new TextField();
       mText.autoSize = flash.text.TextFieldAutoSize.LEFT;
       mText.background = true;
       mText.backgroundColor = 0xffffff;
       addChild(mText);

       mText.type = flash.text.TextFieldType.INPUT;
       mText.autoSize = flash.text.TextFieldAutoSize.NONE;
       mRenderer.renderLabel(mText);
       mText.text = inVal;
       mText.x = 0.5;
       mText.y = 0.5;
       mText.border = true;
       mText.borderColor = 0x000000;

       mTextLayout = new TextLayout(mText).setAligflashnt(Layout.AlignStretch);

       var extra = createExtraWidgetLayout();
       if (extra==null)
          setItemLayout( mTextLayout );
       else
       {
          var grid = new GridLayout(2,"grid",0);
          grid.setColStretch(0,1);
          grid.add( mTextLayout );
          grid.add( extra );
          grid.setAligflashnt(Layout.AlignStretch  | Layout.AlignCenterY );
          grid.setSpacing(0,0);
          grid.mDbgObj = this;
          setItemLayout(grid);
       }


       mTextLayout.mDebugCol = 0xff00ff;

       if (onUpdate!=null)
       {
          var t= mText;
          mText.addEventListener(flash.events.Event.CHANGE, function(_) onUpdate(t.text) );
       }
 
       build();
   }

   public function createExtraWidgetLayout() : Layout { return null; }

   public function setTextWidth(inW:Float)
   {
      mTextLayout.setBestWidth(inW);
      build();
   }

   public function set_text(inText:String)
   {
       mText.text = inText;
       return inText;
   }
   public function parseInt() : Int
   {
      return Std.parseInt( mText.text );
    }

   override public function onCurrentChanged(inCurrent:Bool)
   {
      super.onCurrentChanged(inCurrent);
      if (stage!=null)
         stage.focus = inCurrent ? mText : null;
   }


   public override function onKeyDown(event:flash.events.KeyboardEvent ) : Bool
   {
      #if flash
      var code:UInt = event.keyCode;
      #else
      var code:Int = event.keyCode;
      #end

      // Let these ones thought to the keeper...
      if (code==Keyboard.DOWN || code==Keyboard.UP || code==Keyboard.TAB)
         return false;
      return true;
   }


   public function get_text() { return mText.text; }

   public override function redraw()
   {
       var gfx = graphics;
       gfx.clear();
       //gfx.lineStyle(1,0x808080);
       //gfx.beginFill(0xf0f0ff);
       //gfx.drawRect(0.5,0.5,mRect.width-1,23);
       //gfx.lineStyle();
       //mText.width = mRect.width - 2;
       //mText.y =  (boxHeight - 2 - mText.textHeight)/2;
       //mText.height =  boxHeight-mText.y;
   }

}


