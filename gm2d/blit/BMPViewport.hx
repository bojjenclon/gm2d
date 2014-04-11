package gm2d.blit;

import flash.display.Sprite;
import flash.display.Stage;
import flash.display.BitmapData;
import flash.events.Event;
import flash.geom.Rectangle;

class BMPViewport extends Viewport
{
   public var gm2dBitmapData:BitmapData;
   var mBitmap:flash.display.Bitmap;


   public function new(inWidth:Int, inHeight:Int,inTransparent:Bool,inBackground)
   {
      super(inWidth,inHeight,inTransparent,inBackground);

      gm2dBitmapData = new BitmapData(inWidth,inHeight,inTransparent, getBG() );
      mBitmap = new flash.display.Bitmap(gm2dBitmapData);
      addChild(mBitmap);
   }

   public override function createLayer() : Layer
   {
      var layer = BMPLayer.gm2dCreate(this);
      addLayer(layer);
      return layer;
   }

   override function resize(inWidth:Int, inHeight:Int)
   {
      gm2dBitmapData = new BitmapData(inWidth,inHeight,mTransparent, getBG() );
      mBitmap.bitmapData = gm2dBitmapData;
      super.resize(inWidth,inHeight);
   }


   override function renderViewport()
   {
      gm2dBitmapData.lock();
      gm2dBitmapData.fillRect(mRect,getBG());
      for(layer in mLayers)
         if (layer.visible)
            layer.gm2dRender(originX,originY);
      gm2dBitmapData.unlock();

   }

}

