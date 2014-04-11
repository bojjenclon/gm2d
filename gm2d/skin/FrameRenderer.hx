package gm2d.skin;

import gm2d.ui.HitBoxes;
import flash.filters.BitmapFilter;
import flash.filters.BitmapFilterType;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;
import flash.display.Sprite;
import flash.display.DisplayObject;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.display.Shape;
import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.Matrix;

import flash.display.SimpleButton;
import gm2d.ui.IDockable;
import gm2d.ui.Layout;
import gm2d.ui.Widget;
import gm2d.ui.Size;
import gm2d.svg.SvgRenderer;
import gm2d.svg.Svg;


class FrameRenderer
{
   public static function create(borders:Float, titleHeight:Float) : Renderer
   {
      var result = new Renderer();
      result.padding = new Rectangle(borders, borders+titleHeight, borders*2, borders*2+titleHeight);
      return result;
   }

   public static function fromSvg(inSvg:Svg,?inLayer:String)
   {
      var renderer = new SvgRenderer(inSvg,inLayer);

      var interior = renderer.getMatchingRect(Skin.svgInterior);
      var bounds = renderer.getMatchingRect(Skin.svgBounds);
      if (bounds==null)
         bounds = renderer.getExtent(null, null);
      if (interior==null)
         interior = bounds;
      var scaleRect = Skin.getScaleRect(renderer,bounds);

      var result = new Renderer();
      result.style = Style.StyleCustom( function(widget:Widget)
         {
         var gfx = widget.mChrome.graphics;
         var matrix = new Matrix();
         matrix.tx = widget.mRect.x-(bounds.x);
         matrix.ty = widget.mRect.y-(bounds.y);
         if (scaleRect!=null)
         {
            var rect = widget.mRect;
            var extraX = rect.width-(bounds.width-scaleRect.width);
            var extraY = rect.height-(bounds.height-scaleRect.height);
            //trace("Add " + extraX + "x" + extraY );
            renderer.render(gfx,matrix,null,scaleRect, extraX, extraY );
         }
         else
            renderer.render(gfx,matrix);

         if (gm2d.Lib.isOpenGL)
            widget.mChrome.cacheAsBitmap = true;
      });

      result.minItemSize = new Size(bounds.width, bounds.height);
      result.padding = new Rectangle(interior.x-bounds.x, interior.y-bounds.y,
                             bounds.width-interior.width, bounds.height-interior.height );
      return result;
   }
}

