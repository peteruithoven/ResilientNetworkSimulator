public class Cable extends DisplayObject
{
  int energy;
  float x2 = 0, y2 = 0;
  Plug plug1;
  Plug plug2;
  
  Cable()
  {
    strokeColor = #A10018;
    
    plug1 = new Plug(this);
    plug2 = new Plug(this);
  }
  void draw()
  {
    x = plug1.x;
    y = plug1.y;
    x2 = plug2.x;
    y2 = plug2.y;
    
    stroke(strokeColor);
    noFill();
    strokeWeight(2);
    line(x,y,x2,y2);
  }
}
