package gm2d;

import flash.display.DisplayObjectContainer;

class Lib
{
   public static var current(get_current,null) : DisplayObjectContainer;
   public static var debug:Bool = false;
   public static var isOpenGL(get_isOpenGL,null):Bool;


   static function get_current() : DisplayObjectContainer
   {
      #if flash
      return flash.Lib.current;
      #else
      return flash.Lib.current;
      #end
   }

   static function get_isOpenGL()
   {
      #if flash
      return false;
      #else
      return flash.Lib.stage.isOpenGL;
      #end
   }
}

