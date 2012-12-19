package gm2d.skin;

import gm2d.text.TextField;
import gm2d.text.TextFormat;
import gm2d.ui.Layout;

import gm2d.ui.HitBoxes;
import gm2d.ui.Button;
import gm2d.ui.IDockable;
import gm2d.display.Sprite;
import gm2d.display.BitmapData;
import gm2d.display.Bitmap;
import gm2d.display.Shape;
import gm2d.display.Graphics;
import gm2d.text.TextField;
import gm2d.text.TextFieldAutoSize;
import gm2d.geom.Point;
import gm2d.geom.Rectangle;
import gm2d.geom.Matrix;


class TabRenderer
{
   public static inline var TOP = 0;
   public static inline var LEFT = 1;
   public static inline var RIGHT = 2;
   public static inline var BOTTOM = 3;

   public function new() { }

   public dynamic function renderBackground(bitmap:BitmapData)
   {
      var skin = Skin.current;
      var shape = skin.mDrawing;
      var gfx = shape.graphics;
      var w = bitmap.width;
      var tabHeight = bitmap.height;
      gfx.clear();

      var mtx = new gm2d.geom.Matrix();

      mtx.createGradientBox(tabHeight,tabHeight,Math.PI * 0.5);

      var cols:Array<Int> = [ skin.guiDark, skin.tabGradientColor];
      var alphas:Array<Float> = [1.0, 1.0];
      var ratio:Array<Int> = [0, 255];
      gfx.beginGradientFill(gm2d.display.GradientType.LINEAR, cols, alphas, ratio, mtx );
      gfx.drawRect(0,0,w,tabHeight);
      bitmap.draw(shape);
   }

   public dynamic function renderTabs(inTabContainer:Sprite,
                              inRect:Rectangle,
                              inPanes:Array<IDockable>,
                              inCurrent:IDockable,
                              outHitBoxes:HitBoxes,
                              inShowRestore:Bool,
                              inSide:Int,
                              inOverlapped:Bool,
                              inShowText:Bool,
                              inShowIcon:Bool )
   {
      var skin = Skin.current;
      var tabHeight = skin.tabHeight;
      var tmpText = skin.mText;
      var shape = skin.mDrawing;

      var borderLeft = 2;
      var borderRight = 8;
      var bmpPad = 2;
      var tabGap = 0;
      var tabX = new Array<Float>();

      var w = inSide==TOP || inSide==BOTTOM ? inRect.width : inRect.height;
      if (inOverlapped)
      {
         // Calculate actual width
         var tx = 1.0;
         tabX.push(tx);
         for(pane in inPanes)
         {
            var text = pane.getShortTitle();
            if (text=="") text="Tab";
            tmpText.text = text;
            tx += borderLeft + tmpText.textWidth + borderRight;
            var icon = pane.getIcon();
            if (icon!=null)
               tx += icon.width + bmpPad*2;
            tx+=tabGap;
         }
         tabX.push(tx);
         w = tx + 3;
      }

      var bitmap = new BitmapData(Std.int(w), tabHeight ,true, #if neko { a:0, rgb:0 } #else 0 #end );
      var display = new Bitmap(bitmap);
      var boxOffset = outHitBoxes.getHitBoxOffset(inTabContainer,inRect.x,inRect.y);
      display.x = inRect.x;
      display.y = inRect.y;
      inTabContainer.addChild(display);

      renderBackground(bitmap);
      var gfx = shape.graphics;
      gfx.clear();


      var buts = [ MiniButton.POPUP ];
      if (inShowRestore)
         buts.push( MiniButton.RESTORE );
      var x = bitmap.width - 4;
      for(but in buts)
      {
         var bmp = skin.getButtonBitmapData(but,HitBoxes.BUT_STATE_UP);
         if (bmp!=null) 
         {
            x-= bmp.width;
            var y = (tabHeight-bmp.height)/2;

            bitmap.copyPixels( bmp, new Rectangle(0,0,bmp.width,bmp.height), new Point(x,y), null, null, true );

            outHitBoxes.add( new Rectangle(boxOffset.x + x,boxOffset.y +  y,bmp.width,bmp.height), HitAction.BUTTON(null,but) );
         }
      }

      var trans = new gm2d.geom.Matrix();
      var y0 = inOverlapped ? 4 : 2;
      trans.tx = 1;
      trans.ty = y0;

      var cx = trans.tx;
      for(pane in inPanes)
      {
         var text = pane.getShortTitle();
         if (text=="") text="Tab";
         tmpText.text = text;
         var tw = borderLeft + tmpText.textWidth + borderRight;
         var icon = pane.getIcon();
         var iconWidth = 0;
         if (icon!=null)
            iconWidth = icon.width + bmpPad*2;
         tw += iconWidth;


         var r = new Rectangle(trans.tx,0,tw,tabHeight);
         if (!inOverlapped)
            outHitBoxes.add(new Rectangle(trans.tx+boxOffset.x,boxOffset.y,tw,tabHeight), TITLE(pane) );

         if (pane==inCurrent)
         {
            cx = trans.tx;
            trans.tx+=tw+tabGap;
         }
         else
         {
            gfx.clear();
            gfx.lineStyle(1,0x404040);
            gfx.beginFill(skin.guiDark);
            gfx.drawRoundRect(0.5,0.5,tw,tabHeight+2,6,6);
            trans.ty = y0;
            bitmap.draw(shape,trans);
            trans.tx+=borderLeft;
            if (icon!=null)
            {
               var bmp = new Bitmap(icon);
               trans.tx+=bmpPad;
               trans.ty = Std.int( (tabHeight - bmp.height)* 0.5 );
               bitmap.draw(bmp,trans);
               trans.tx+=iconWidth-bmpPad;
            }
            trans.ty = Std.int( (tabHeight - tmpText.textHeight)*0.5 );
            bitmap.draw(tmpText,trans);
            trans.tx += tw-borderLeft+tabGap-iconWidth;
         }
      }
      if (inCurrent!=null)
      {
         if (inCurrent!=inPanes[0])
         {
            cx -=2;
            borderLeft += 2;
         }
         else
         {
            cx -=1;
            borderLeft += 1;
         }
         borderRight += 2;
 
         var text = inCurrent.getShortTitle();
         if (text=="") text="Tab";
         tmpText.text = text;

         var tw = borderLeft + tmpText.textWidth + borderRight;

         var icon = inCurrent.getIcon();
         var iconWidth = 0;
         if (icon!=null)
            iconWidth = icon.width + bmpPad*2;
         tw+=iconWidth;
         trans.ty = y0-1;
         trans.tx = 0;

         gfx.clear();
         gfx.lineStyle(1,0x404040);
         gfx.beginFill(skin.guiMedium);
         gfx.moveTo(-1,tabHeight-4);
         gfx.lineTo(cx,tabHeight-4);
         gfx.lineTo(cx,6);
         gfx.curveTo(cx,2,cx+5,1);
         gfx.lineTo(cx+tw-5,1);
         gfx.curveTo(cx+tw,1,cx+tw,6);
         gfx.lineTo(cx+tw,tabHeight-4);
         gfx.lineTo(w+2,tabHeight-4);
         gfx.lineTo(w+2,tabHeight);
         gfx.lineTo(-2,tabHeight);
         bitmap.draw(shape,trans);
         trans.tx = cx+borderLeft;

         if (icon!=null)
         {
            var bmp = new Bitmap(icon);
            trans.tx += bmpPad;
            trans.ty = (tabHeight - icon.height) >> 1;
            bitmap.draw(bmp,trans);
            trans.tx+=bmpPad;
            trans.tx+=iconWidth-bmpPad;
         }
         trans.ty = Std.int( (tabHeight - tmpText.textHeight)*0.5 );
         bitmap.draw(tmpText,trans);
      }

      if (!inOverlapped)
      {
         gfx.clear();
         gfx.beginFill(skin.guiMedium);
         gfx.drawRect(0,tabHeight-2,w,8);
         bitmap.draw(shape);
      }

      if (inOverlapped)
      {
         var centre = true;
         switch(inSide)
         {
            case TOP:
               display.y -= tabHeight-2;
               if (centre)
                  display.x += Std.int((inRect.width-w)*0.5);
               for(i in 0...tabX.length-1)
                  outHitBoxes.add(new Rectangle(display.x+boxOffset.x ,boxOffset.y+display.y,
                           tabX[i+1]-tabX[i],tabHeight), TITLE(inPanes[i]) );
            case BOTTOM:
               display.y += inRect.height;
            case RIGHT:
               display.rotation = 90;
               display.x += inRect.width + tabHeight;
            case LEFT:
               display.rotation = -90;
               display.x -= tabHeight;
               display.y += inRect.height;
         }
      }
   }
}




