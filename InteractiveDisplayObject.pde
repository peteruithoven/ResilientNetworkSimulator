/*
 * hitWidth & hitHeight
 * boolean hitTestCenter
 */
public class InteractiveDisplayObject extends DisplayObject
{
  boolean dragging = false;
  float dragX = 0;
  float dragY = 0;
  InteractiveDisplayObject()
  {
    //addMouseListener(this);
    registerMouseEvent(this);
  }
  void mouseEvent(MouseEvent event) 
  {
    if(hitTest(mouseX,mouseY))
    {
      switch (event.getID()) 
      {
        case MouseEvent.MOUSE_PRESSED:
          mousePressed();
          dragging = true;
          dragX = mouseX-x;
          dragY = mouseY-y;
          break;
        case MouseEvent.MOUSE_RELEASED:
          mouseReleased();
          break;
        case MouseEvent.MOUSE_CLICKED:
          mouseClicked();
          break;
        case MouseEvent.MOUSE_MOVED:
          mouseMoved();
          break;
      }
    }
    if(dragging)
    { 
      switch (event.getID()) 
      {
        case MouseEvent.MOUSE_RELEASED:
          dragging = false;
          stoppedDragging();
          break;
        case MouseEvent.MOUSE_DRAGGED:
          mouseDragged();
          break;
      }
    }
  }
  void mousePressed() { }
  void mouseReleased() { }
  void mouseClicked() { }
  void mouseDragged() { }
  void mouseMoved() { }
  void startedDragging() { }
  void stoppedDragging() { }
  
  boolean hitTest(float hitX, float hitY)
  {
    return (hitX >= x && hitX <= x+width && 
      hitY >= y && hitY <= y+height);
  }
}
