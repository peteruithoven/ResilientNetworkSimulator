public class DisplayObject 
{
  float x = 0, y = 0, rotation = 0, width = 0, height = 0;
  color fillColor, strokeColor;
  int alphaValue = 255;
  int index = 0;
  DisplayObject()
  {
    registerDraw(this);
    index = DisplayObjectStatic.index++;
  }
  
  void draw()
  {
    println("draw");
  }
}
static class DisplayObjectStatic
{
  static int index = 0;
}

