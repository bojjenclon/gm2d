package gm2d.ui2;

import nme.display.DisplayObjectContainer;

import gm2d.app.Screen;
import gm2d.app.Game;
import nme.display.BitmapData;
import nme.display.Graphics;
import nme.display.Sprite;
import nme.text.TextField;
import nme.events.MouseEvent;
import nme.text.TextFieldAutoSize;
import gm2d.ui2.IDock;
import gm2d.ui2.DockPosition;
import gm2d.ui2.Layout;
import gm2d.ui2.SkinItem;

#if (waxe && !nme_menu)
import wx.Menu;
#end

interface Menubar
{
   public function layout(inWidth:Float) : Float;
   #if (waxe && !nme_menu)
   public function addItems(inMenu:Menu,inItem:MenuItem) : Void;
   #end
   public function add(inItem:MenuItem) : Void;
   public function closeMenu(inItem:MenuItem):Void;
} 

class SpriteMenubar extends Widget implements Menubar implements IDock
{
   var menubar:Widget;
   var mWidth:Float;
   var mHeight:Float;
   var mNextX:Float;
   var mCurrentItem:Int;
	var mNormalParent:DisplayObjectContainer;

   var mItems:Array<MenuItem>;
   var mButtons:Array<Button>;
   var buttonLayout:GridLayout;

   public function new(inParent:DisplayObjectContainer,?dummy:Int)
   {
      buttonLayout = new GridLayout(null);
      super( { item:ITEM_LAYOUT(buttonLayout) } );
      if (inParent!=null)
         inParent.addChild(this);
      mItems = [];
      mButtons = [];
      mNextX = 2;
      mCurrentItem = -1;
		mNormalParent = null;
   }

   override public function getClass() { return "Menubar"; }

   public function add(inItem:MenuItem)
   {
      var pos = mItems.length;
      mItems.push(inItem);
      
      var me = this;
      var nx = mNextX;
      var but = Button.TextButton(inItem.gmText,function(){me.popup(pos);});
      mButtons.push(but);
		//Skin.current.styleMenu(but);
      but.addEventListener(MouseEvent.MOUSE_OVER, function(_) me.onMouseItem(pos) );

      but.x = mNextX;
      mNextX += but.width + 10;
      addChild(but);
   }

   function onMouseItem(inPos:Int)
   {
      if (mCurrentItem>=0  && mCurrentItem!=inPos)
         popup(inPos);
   }

   public function popup(inPos:Int)
   {
      Game.closePopup();
      mCurrentItem = inPos;
      //mButtons[mCurrentItem].getLabel().background = true;
      //mButtons[mCurrentItem].getLabel().textColor = 0xffffff;
		if (mNormalParent==null)
		{
		   mNormalParent = parent;
			Game.moveToPopupLayer(this);
		}
      Game.popup( new PopupMenu(mItems[inPos],this), mButtons[inPos].x, mHeight );
   }

   public function closeMenu(inItem:MenuItem)
   {
	   if (mNormalParent!=null)
		{
		   mNormalParent.addChildAt(this,0);
			mNormalParent = null;
		}
      if (mCurrentItem>=0 && mItems[mCurrentItem]==inItem)
      {
         //mButtons[mCurrentItem].getLabel().background = false;
         //mButtons[mCurrentItem].getLabel().textColor = 0x000000;
         mCurrentItem = -1;
      }
   }

   public function layout(inWidth:Float) : Float
   {
      mWidth = inWidth;
      mHeight = widgetLayout.getBestHeight();
      onLayout(0,0,mWidth, mHeight);
      return mHeight;
   }




   // IDock....
   public function getDock():IDock { return this; }
   public function canAddDockable(inPos:DockPosition):Bool { return inPos==DOCK_OVER; }
   public function addDockable(child:IDockable,inPos:DockPosition,inSlot:Int):Void
   {
   }
   public function getDockablePosition(child:IDockable):Int
   {
      return -1;
   }
   public function removeDockable(child:IDockable):IDockable
   {
      return null;
   }
   public function raiseDockable(child:IDockable):Bool
   {
      return false;
   }
   public function minimizeDockable(child:IDockable):Bool
   {
      return false;
   }
   public function addSibling(inReference:IDockable,inIncoming:IDockable,inPos:DockPosition):Void
   {
   }
   public function getSlot():Int
   {
      return -1;
   }
   public function setDirty(inLayout:Bool, inChrome:Bool):Void
   {
   }
   #if (waxe && !nme_menu)
   public function addItems(inMenu:Menu,inItem:MenuItem) : Void
   {
      throw "Not wx menubar";
   }
   #end

}




#if (waxe && !nme_menu)



class WxMenubar implements Menubar
{
   var mWxMenuBar:wx.MenuBar;
   var mAdded:Bool;

   public function new(inParent:DisplayObjectContainer)
   {
      mAdded = false;
      mWxMenuBar = new wx.MenuBar();
   }

   public function layout(inWidth:Float) : Float
   {
      if (!mAdded)
      {
         mAdded = true;
         ApplicationMain.frame.menuBar = mWxMenuBar;
      }
      return 0;
   }

   public function addItems(inMenu:Menu,inItem:MenuItem) : Void
   {
      for(child in inItem.mChildren)
      {
         if (child.onSelect!=null)
         {
            if (child.gmID<0)
               child.gmID = wx.Lib.nextID();
            ApplicationMain.frame.handle(child.gmID, child.onSelect);
         }
         inMenu.append(child.gmID, child.gmText);
      }
   }
   public function closeMenu(inItem:MenuItem):Void { }

   public function add(inItem:MenuItem)
   {
      //var menu = new Menu(inItem.gmText);
      var menu = new Menu();
      addItems(menu,inItem);
      mWxMenuBar.append(menu,inItem.gmText);
   }

}


#end


