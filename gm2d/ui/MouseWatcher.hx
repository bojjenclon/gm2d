package gm2d.ui;

import gm2d.events.MouseEvent;
import gm2d.display.Stage;
import gm2d.display.DisplayObject;
import gm2d.geom.Point;

class MouseWatcher
{
   var mWatch:DisplayObject;
   var mEventStage:Stage;

   public var onDown:MouseEvent->Void;
   public var onDrag:MouseEvent->Void;
   public var onUp:MouseEvent->Void;
   public var isDown:Bool;
   public var prevPos:Point;
   public var pos:Point;
   public var downPos:Point;

   public function new(inWatch:DisplayObject,
                inOnDown:MouseEvent->Void,
                inOnDrag:MouseEvent->Void,
                inOnUp:MouseEvent->Void,
                inX:Float, inY:Float, inWatchDown:Bool)
   {
      mWatch = inWatch;
      pos = new Point(inX,inY);
      downPos = new Point(inX,inY);
      prevPos = new Point(inX,inY);
      onDown = inOnDown;
      onDrag = inOnDrag;
      onUp = inOnUp;

      if (inWatchDown)
      {
         isDown = false;
         mEventStage = null;
         inWatch.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
      }
      else
      {
         isDown = true;
         mEventStage = inWatch.stage;
         mEventStage.addEventListener(MouseEvent.MOUSE_MOVE, onStageDrag);
         mEventStage.addEventListener(MouseEvent.MOUSE_UP, onStageUp);
      }
   }


   public static function create(inWatch:DisplayObject,
                       ?inOnDown:MouseEvent->Void,
                       ?inOnDrag:MouseEvent->Void,
                       ?inOnUp:MouseEvent->Void)
   {
      return new MouseWatcher(inWatch, inOnDown, inOnDrag, inOnUp, 0, 0, true );
   }

    public static function watchDrag(inWatch:DisplayObject,inX:Float, inY:Float,
                       ?inOnDrag:MouseEvent->Void,
                       ?inOnUp:MouseEvent->Void)
   {
      return new MouseWatcher(inWatch, null, inOnDrag, inOnUp, inX, inY, false );
   }


   function onMouseDown(ev:MouseEvent)
   {
       mEventStage = mWatch.stage;
       pos = new Point(ev.stageX,ev.stageY);
       downPos = new Point(ev.stageX,ev.stageY);
       prevPos = new Point(ev.stageX,ev.stageY);
       isDown = true;
       mEventStage.addEventListener(MouseEvent.MOUSE_MOVE, onStageDrag);
       mEventStage.addEventListener(MouseEvent.MOUSE_UP, onStageUp);
       if (onDown!=null)
          onDown(ev);
   }
   function removeStageListeners()
   {
      if (mEventStage!=null)
      {
         mEventStage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageDrag);
         mEventStage.removeEventListener(MouseEvent.MOUSE_UP, onStageUp);
         mEventStage = null;
      }
   }

   function onStageUp(ev:MouseEvent)
   {
      removeStageListeners();
      if (onUp!=null)
         onUp(ev);
   }

   function onStageDrag(ev:MouseEvent)
   {
      prevPos.x = pos.x;
      prevPos.y = pos.y;
      pos.x = ev.stageX;
      pos.y = ev.stageY;
      if (onDrag!=null)
         onDrag(ev);
   }
}



