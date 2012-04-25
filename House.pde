public class House extends Node
{
  //final int ENERGY_COSTS = 5;
  
  House(String id)
  {
    super(id);
    width = 20;
    height = 30;
    fillColor = #005DA1;
    
    createOutlets(2,fillColor);
    
    energyDemand = 1;
    energyProduction = 0;
    enabled = true;
    updateVisuals();
  }
  void draw()
  {
    //println("  draw "+toString()+" a: "+alphaValue);
    //noStroke();
    stroke(fillColor);
    //int alphaVal = ;
    //fill(fillColor,125);
    //fill(fillColor,((energy >= 0)? 255: 125));
    fill(fillColor,alphaValue);
    //println("x: "+x+" y: "+y+" width: "+width+" height: "+height);
    //rect(x, y, width, height);
    
    beginShape();
    vertex(x, y+height*0.4);
    vertex(x+width*.5, y);
    vertex(x+width, y+height*0.4);
    vertex(x+width, y+height);
    vertex(x, y+height);
    endShape(CLOSE);
  }
  void mouseDragged()
  {
    x = round(mouseX-dragX);
    y = round(mouseY-dragY);

    update();
  }
  void mouseClicked()
  {
    disturb();
  }
  void update()
  {
    outlets[0].x = x;
    outlets[1].x = x+width;
    outlets[0].y = outlets[1].y = y+height*0.7;
    outlets[0].update();
    outlets[1].update();
  }
}
