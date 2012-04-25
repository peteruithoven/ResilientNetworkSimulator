public class Generator extends Node
{
  Generator(String id)
  {
    super(id);
    
    GeneratorStatic.instances.add(this);
    
    enabled = false;
    width = height = 35;
    fillColor = strokeColor = #A16E00;
    
    createOutlets(4,strokeColor);
    
    energyDemand = 0;
    energyProduction = 0; // is determined after it's enable
    
    updateVisuals();
  }
  void mouseClicked()
  {
    enabled = !enabled;
    
    println("devide energyProduction");
    int numEnabledGenerators = 0;
    ArrayList generators = GeneratorStatic.instances;
    for(int i=0;i<generators.size();i++)
    if(((Generator) generators.get(i)).enabled ) numEnabledGenerators++;
    for(int i=0;i<generators.size();i++)
    {
      Generator generator = (Generator) generators.get(i);
      generator.energyProduction = TOTAL_ENERGY_PRODUCTION/numEnabledGenerators;
      println("  "+toString()+" p: "+generator.energyProduction);
    }
  }
  void draw()
  {
    //println("draw "+toString());
    fill(#000000,alphaValue);
    stroke(strokeColor,alphaValue);
    strokeWeight(2);
    ellipseMode(CORNER);
    //println("x: "+x+" y: "+y+" width: "+width+" height: "+height);
    ellipse(x, y, width, height);
    
    noFill();
    noStroke();
    if(enabled)
    {
      fill(fillColor,alphaValue);
      float energyPercentage = energyProduction/TOTAL_ENERGY_PRODUCTION;
      if(energyPercentage > 1) energyPercentage = 1;
      else if(energyPercentage < 0) energyPercentage = 0;
      
      //println("  TOTAL_ENERGY_PRODUCTION: "+TOTAL_ENERGY_PRODUCTION);
      //println("  energyProduction: "+energyProduction);
      //println("  energyPercentage: "+energyPercentage);
      //float barHeight = height*energyPercentage;
      //println("barHeight: "+barHeight);
      //rect(x,y+(height-barHeight),width,barHeight);
      
      drawPie(x,y,width,height,energyPercentage);
      //updateEnergy();
    }
  }
  /*void updateEnergy()
  {
    energyInput = 0;
    int numPlugs = 0;
    for(int i=0;i<outlets.length;i++)
    {
      Outlet outlet = outlets[i];
      if(outlet.plug != null)
      {
        energyInput += outlet.plug.energyOutput;
        numPlugs++;
      }
    }
    energyOutput = energyInput+=energyProduction;
    for(int i=0;i<outlets.length;i++)
    {
      Outlet outlet = outlets[i];
      if(outlet.plug != null) outlet.plug.energyInput = energyOutput/numPlugs;
    }
  }*/
  void mouseDragged()
  {
    x = round(mouseX-dragX);
    y = round(mouseY-dragY);
    update();
  }
  void update()
  {
    outlets[0].x = x;
    outlets[1].x = x+width;
    outlets[0].y = outlets[1].y = y+height/2;
    outlets[2].y = y;
    outlets[3].y = y+height;
    outlets[2].x = outlets[3].x = x+width/2;
    for(int i=0;i<outlets.length;i++)
    {
      outlets[i].update();
    }
  }
  void drawPie(float x, float y, float width, float height, float percentage)
  {
    float arcPart = PI*2*percentage;
    //println("energyPercentage: "+energyPercentage);
    //println("arcPart: "+arcPart);
    
    //arc(x, y, width, height, arcPart, PI-arcPart);
    arc(x, y, width, height, 0, arcPart);
    //arc(x, y, width, height, -PI/4+arcPart, PI-arcPart); // 60 degrees
  }
}
static class GeneratorStatic
{
  static ArrayList instances = new ArrayList();
}
