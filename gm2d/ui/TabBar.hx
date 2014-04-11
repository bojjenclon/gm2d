package gm2d.ui;

import flash.geom.Rectangle;
import flash.display.Sprite;
import flash.display.Shape;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObjectContainer;
import flash.text.TextField;
//import gm2d.ui.HitBoxes;
import flash.geom.Point;
import flash.events.MouseEvent;
import gm2d.ui.HitBoxes;
import gm2d.ui.Dock;
import gm2d.ui.DockPosition;
import gm2d.Game;
import gm2d.skin.Skin;
import gm2d.skin.TabRenderer;
import gm2d.ui.WidgetState;
import gm2d.ui.Layout;


class TabBar extends Widget
{
   public var currentDockable:IDockable;
   public var isMaximised:Bool;

   var tabsWidth:Float;
   var tabsHeight:Float;
   var mHitBoxes:HitBoxes;
   var mDockables:Array<IDockable>;
   var tabRenderer:TabRenderer;

   public function new(inDockables:Array<IDockable>, inOnHitBox: HitAction->MouseEvent->Void)
   {
      super(["TabBar"] );
      mDockables = inDockables;
      tabRenderer = Skin.tabRenderer( ["Tabs","TabRenderer"] );
      var layout = new Layout();
      layout.setMinSize(20,18);
      layout.setAligflashnt(Layout.AlignStretch);
      layout.onLayout = layoutTabs;
      setItemLayout(layout);
      mLayout.setAligflashnt(Layout.AlignStretch | Layout.AlignTop);
      tabsWidth = tabsHeight = 0;
      mHitBoxes = new HitBoxes(this,inOnHitBox);
      build();
   }

   override public function redraw()
   {
      super.redraw();

      mHitBoxes.clear();

      var flags =   TabRenderer.SHOW_TEXT | TabRenderer.SHOW_ICON | TabRenderer.SHOW_POPUP;
      if (isMaximised)
         flags |=  TabRenderer.SHOW_RESTORE;
      tabRenderer.renderTabs(mChrome, new Rectangle(0,0,tabsWidth,tabsHeight),
          mDockables, currentDockable, mHitBoxes, TabRenderer.TOP, flags);
   }

   public function setTop(inCurrent:IDockable, inIsMaximised:Bool)
   {
      currentDockable = inCurrent;
      isMaximised = inIsMaximised;
      redraw();
   }


   function layoutTabs(inX:Float, inY:Float, inW:Float, inH:Float)
   {
      tabsWidth = inW;
      tabsHeight = inH;
   }
}
