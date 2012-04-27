public class Outlet extends DisplayObject
{
  Plug plug;
  Node node;
  OutletsEventsListener listener;
  
  float angle; // used for layout in generator
  
  Outlet(color strokeColor, Node node, OutletsEventsListener listener)
  {
    this.strokeColor = strokeColor;
    this.node = node;
    this.listener = listener;
    width = height = 15*0.7;
    OutletStatic.outlets.add(this);
  }
  void draw()
  {
    fill(0,alphaValue);
    stroke(strokeColor,alphaValue);
    ellipseMode(CENTER);
    ellipse(x,y,width,height);
  }
  /*boolean hitTest(float hitX, float hitY)
  {
    return (hitX >= x-width/2 && hitX <= x+width/2 && 
      hitY >= y-height/2 && hitY <= y+height/2);
  }*/
  void update()
  {
    if(plug != null)
    {
      plug.x = x;
      plug.y = y;
    }
  }
  void connect(Plug plug)
  {
    this.plug = plug;
    listener.onConnected(this);
  }
  void disconnect()
  {
    plug = null;
    listener.onDisconnected(this);
  }
  void releasePlug()
  {
    if(plug != null)
   { 
     plug.release();
     disconnect();
   }
  }
  Node getConnection()
  {
    if(plug == null)
    {
      return null;
    }
    else
    {
      Cable cable = plug.cable;
      Plug otherPlug = (cable.plug1 == plug)? cable.plug2 : cable.plug1;
      if(otherPlug.outlet != null)
        return otherPlug.outlet.node;
      else
        return null;
    }
  }
}
static class OutletStatic
{
  static ArrayList outlets = new ArrayList();
}

interface OutletsEventsListener
{
  void onConnected(Outlet outlet);
  void onDisconnected(Outlet outlet);
}
