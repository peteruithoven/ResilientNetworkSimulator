public class House extends Node
{
  //final int ENERGY_COSTS = 5;
  
  House(String id)
  {
    super(id);
    width = 20;
    height = 30;
    fillColor = #005DA1;
    
    createOutlets(3,fillColor);
    
    energyDemand = 1;
    energyProduction = 0;
    enabled = true;
    updateVisuals();
  }
  void draw()
  {
    //alphaValue = round(energy/maxEnergyReserve*125+125);
    alphaValue = ((energy >= 0)? 255: 125);
    
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
    
    if(showText)
    {
      fill(#ffffff);
      float roundedEnergy = float(round(energy*100))/100;
      text(Float.toString(roundedEnergy),x-7,y+10);
    }
  }
  void mouseDragged()
  {
    x = round(mouseX-dragX);
    y = round(mouseY-dragY);

    update();
  }
  void mouseClicked()
  {
    disturb(false);
  }
  void update()
  {
    outlets[0].x = x;
    outlets[1].x = x+width;
    outlets[0].y = outlets[1].y = y+height*0.7;
    outlets[2].x = x+width/2;
    outlets[2].y = y+height;
    for(int i=0;i<outlets.length;i++)
    {
      outlets[i].update();
    }
  }
}
