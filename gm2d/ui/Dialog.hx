package gm2d.ui;

import flash.events.MouseEvent;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import gm2d.ui.Layout;
import flash.filters.BitmapFilter;
import flash.filters.DropShadowFilter;
import gm2d.ui.HitBoxes;
import flash.geom.Rectangle;
import gm2d.skin.Skin;
import gm2d.skin.Renderer;


class Dialog extends Window
{
   var mPane:Pane;
   var mContent:Sprite;
   var mHitBoxes:HitBoxes;
   var mSize:Size;
   var mouseWatcher:MouseWatcher;
   public var shouldConsumeEvent : MouseEvent -> Bool;


   public function new(inPane:Pane, ?inAttribs:Dynamic, ?inLineage:Array<String>)
   {
      super(Widget.addLine(inLineage,"Dialog"), inAttribs);
      mPane = inPane;
      mContent = new Sprite();
      inPane.setDock(null,this);

      //var dbgObject = new flash.display.Shape();
      //addChild(dbgObject);
      //Layout.setDebug(dbgObject);

      mHitBoxes = new HitBoxes(this,onHitBox);

      // todo - make title box
      setItemLayout(inPane.itemLayout);

      build();

      // TODO - use hit boxes/MouseWatcher
      mChrome.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, doDrag);

      if (gm2d.Lib.isOpenGL)
         cacheAsBitmap = true;
   }

   override public function getHitBoxes() : HitBoxes { return mHitBoxes; }

   override public function getPane() : Pane { return mPane; }


   function doneDrag(_)
   {
      stopDrag();
      stage.removeEventListener(flash.events.MouseEvent.MOUSE_UP, doneDrag);
   }

   function doDrag(_)
   {
      startDrag();
      stage.addEventListener(flash.events.MouseEvent.MOUSE_UP, doneDrag);
   }

   public function goBack() { Game.closeDialog(); }

   function onHitBox(inAction:HitAction,inEvent:MouseEvent)
   {
      switch(inAction)
      {
         case BUTTON(_,id):
            if (id==MiniButton.CLOSE)
               goBack();
         default:
      }
   }

   public function center(inWidth:Float,inHeight:Float)
   {
      var p = (parent==null) ? this : parent;
      x = ( (inWidth - mRect.width)/2 )/p.scaleX;
      y = ( (inHeight - mRect.height)/2 )/p.scaleY;
   }

   public dynamic function onClose() { }
 }


