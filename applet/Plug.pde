public class Plug extends InteractiveDisplayObject
{
  Cable cable; 
  Outlet outlet;
  float snapDis = 10;
  Plug(Cable cable)
  {
    this.cable = cable;
    this.fillColor = #A10018; //#71000C;
    width = height = 10;
  }
  void draw()
  {
    fill(fillColor);
    noStroke();
    ellipseMode(CENTER);
    ellipse(x,y,width,height);
  }
  void mouseDragged()
  {
    x = mouseX-dragX;
    y = mouseY-dragY;
    checkSnap();
  }
  void mousePressed()
  {
    if(this.outlet != null)
    {
      outlet.disconnect();
      outlet = null;
    }
  }
  void stoppedDragging()
  {
    this.outlet = checkSnap();
    if(this.outlet != null)
    {
      this.outlet.connect(this);
      //this.outlet.plug = this;
      //onConnect();
    }
  }
  Outlet checkSnap()
  {
    ArrayList outlets = OutletStatic.outlets;
    for(int i=0;i<outlets.size();i++)
    {
      Outlet outlet = (Outlet) outlets.get(i);
      if(outlet.plug != null) continue;
      float disX = x-outlet.x;
      float disY = y-outlet.y;
      float dis = sqrt(sq(disX) + sq(disY));
      if(dis <= snapDis)
      {
        x = outlet.x;
        y = outlet.y;
        return outlet;
      }
    }
    return null;
  }
  boolean hitTest(float hitX, float hitY)
  {
    return (hitX >= x-width/2 && hitX <= x+width/2 && 
      hitY >= y-height/2 && hitY <= y+height/2);
  }
  void release()
  {
    Node node = outlet.node;
    x += outlet.x-(node.x+node.width/2);
    y += outlet.y-(node.y+node.height/2);
    outlet = null;
  }
}
