package gm2d.skin;

import flash.display.BitmapData;

enum FillStyle
{
   FillNone;
   FillLight;
   FillMedium;
   FillDark;
   FillDisabled;
   FillBitmap( bmp:BitmapData );
   FillSolid( rgb:Int, a:Float );
}

