package gm2d.skin;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.Matrix;

import flash.display.SimpleButton;
import gm2d.svg.Svg;
import gm2d.svg.SvgRenderer;
import gm2d.ui.Layout;
import gm2d.ui.Button;
import gm2d.ui.Widget;
import gm2d.ui.Size;
import gm2d.ui.WidgetState;


class ButtonRenderer
{
   public static function fromSvg( inSvg:Svg,?inLayer:String)
   {
      var renderer = new SvgRenderer(inSvg,inLayer);

      var result:Dynamic = {};

      var interior = renderer.getMatchingRect(Skin.svgInterior);
      var bounds = renderer.getMatchingRect(Skin.svgBounds);
      if (bounds==null)
         bounds = renderer.getExtent(null, null);
      if (interior==null)
         interior = bounds;
      var scaleRect = Skin.getScaleRect(renderer,bounds);

      result.offset = new Point(1,1);

      result.style = Style.StyleCustom(function(inWidget:Widget)
      {
         inWidget.mChrome.graphics.clear();
         renderer.renderRect0(inWidget.mChrome.graphics,null,scaleRect,bounds,inWidget.mRect);
      });
      result.minSize = new Size(bounds.width, bounds.height);
      result.padding = new Rectangle(interior.x-bounds.x, interior.y-bounds.y,
                             bounds.width-interior.width,
                             bounds.height-interior.height);
      result.textFormat = LabelRenderer.fromSvg(inSvg, [inLayer, "dialog", null] );

      return result;
   }
}


