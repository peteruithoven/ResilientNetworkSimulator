final float TOTAL_ENERGY_PRODUCTION = 17;
final float TOTAL_ENERGY_STORAGE = 3; // in generators
final int NUM_HOUSES = 15;
final int NUM_GENERATORS = 3;
final int NUM_CABLES = round((NUM_GENERATORS+NUM_HOUSES)+(NUM_GENERATORS+NUM_HOUSES)/6); // 2 connections per line + 1 per 6
final int NUM_SPREAD = 10;
final boolean LIGHTNING_DISTURBS_ALL_OUTLETS = false;
final boolean DEBUG = false;
final boolean AUTO_LIGHTNING = false;
// Manual lightning
final int LIGHTNING_INTERVAL = 700;
final int NUM_LIGHTNING = 3;

boolean showText = false;

Main main;
void setup(){ main = new Main(); }
void draw(){ main.draw(); }
void keyPressed(){ main.keyPressed(key); }

class Main implements ObjectListener, TimerListener, NodeListener
{
  ArrayList nodes;
  ArrayList nodesLightningClone;
  
  int prevEnergyTime = 0;
  int prevLightningTime = 0;
  int prevEnergySpreadTime = 0;
  Lightning lightning;
  LightningButton lightningButton;
  DamageDisplay damageDisplay;
  Timer lightningTimer;
  
  Main()
  {
    size(600,400); 
    smooth();
    
    nodes = new ArrayList();
    for(int i=0;i<NUM_HOUSES;i++)
    {
      House house = new House("H"+(i+1));
      house.x = random(60,width-house.width*2);
      house.y = random(house.height,height-house.height*2);
      house.update();
      house.addNodeListener(this);
      nodes.add(house);
    }
    for(int i=0;i<NUM_GENERATORS;i++)
    {
      Generator generator = new Generator("G"+(i+1));
      //generator.addListener(this);
      generator.x = random(60,width-generator.width*2);
      generator.y = random(generator.height,height-generator.height*2);
      generator.update();
      nodes.add(generator);
    }
    float nextX = 10;
    float nextY = 10;
    for(int i=0;i<NUM_CABLES;i++)
    {
      Cable cable = new Cable();
      cable.plug1.x = nextX;
      cable.plug1.y = nextY;
      cable.plug2.x = nextX+40;
      cable.plug2.y = nextY;
      nextY += cable.plug1.height+5; 
    }
    
    lightning = new Lightning();
    lightningButton = new LightningButton();
    lightningButton.addListener(this);
    lightningButton.x = width-lightningButton.width-10;
    lightningButton.y = height-lightningButton.height-10;
    
    lightningTimer = new Timer(this);
    lightningTimer.setInterval(LIGHTNING_INTERVAL);
    lightningTimer.setRepeatCount(NUM_LIGHTNING);
    
    damageDisplay = new DamageDisplay();
    damageDisplay.x = lightningButton.x-10;
    damageDisplay.y = height-10;
  }
  void draw()
  {
    background(0);
    
    //if(millis()-prevEnergySpreadTime > 83) //12fps
    //{
      for(int i=0;i<NUM_SPREAD;i++)
        spreadEnergy();
      
      prevEnergySpreadTime = millis();
    //}
    if(millis()-prevEnergyTime > 300)
    {
      updateEnergy();
      prevEnergyTime = millis();
    }
    
    if(AUTO_LIGHTNING)
    {
      if(millis()-prevLightningTime > 10000) // 10 sec
      {
        startLightning();
        prevLightningTime = millis();
      }
    }
  }
  void updateEnergy()
  {
    if(DEBUG) println("updateEnergy");
    for(int i=0;i<nodes.size();i++)
    {
      Node node = (Node) nodes.get(i);
      node.updateEnergy();
    }
  }
  void spreadEnergy()
  {
    if(DEBUG) println("spreadEnergy");
    for(int i=0;i<nodes.size();i++)
    {
      Node node = (Node) nodes.get(i);
      node.spreadEnergy();
    }
  }
  void resetEnergy()
  {
    if(DEBUG) println("resetEnergy");
    for(int i=0;i<nodes.size();i++)
    {
      Node node = (Node) nodes.get(i);
      node.resetEnergy();
    }
  }
  void keyPressed(char key)
  {
    switch(key)
    {
      case 's':
        spreadEnergy();
        break;
      case 'u':
        updateEnergy();
        break;
      case 'a':
      case ' ':
        updateEnergy();
        spreadEnergy();
        spreadEnergy();
        spreadEnergy();
        spreadEnergy();
        spreadEnergy();
        break;
      case 'r':
        resetEnergy();
        break;
      case 'l':
        startLightning();
        break;
      case 't':
        showText = !showText;
        break;
    }
    if(DEBUG)
    {
      println("overview");
      for(int i=0;i<nodes.size();i++)
      {
        Node node = (Node) nodes.get(i);
        println("  "+node.toString());
      }
    }
  }
  void startLightning()
  {
    nodesLightningClone = (ArrayList) nodes.clone();
    damageDisplay.damage = 0;
    damageDisplay.enabled = true;
    lightningTimer.reset();
    lightningTimer.start();
  }
  // lightningTimer tick handler
  void tick(Timer timer)
  {
    if(DEBUG) println("lightning "+timer.count+" / "+timer.repeatCount);
    doLightning();
  }
  void doLightning()
  { 
    int randomNodeIndex = round(random(0, nodesLightningClone.size()-1));
    //doLightning(randomNodeIndex);
    
    Node node = (Node) nodesLightningClone.get(randomNodeIndex);
    nodesLightningClone.remove(randomNodeIndex);
    //if(node instanceof Generator) node.setEnergy(0);
    //else node.setEnergy(-1);
    node.disturb(LIGHTNING_DISTURBS_ALL_OUTLETS);
    lightning.x = node.x+node.width/2-lightning.width/2;
    lightning.y = node.y+node.height/2-lightning.height/2;
    lightning.alphaValue = 175;
  }
  void clicked(InteractiveDisplayObject object)
  {
    startLightning();
  }
  void nodeLostEnergy(Node node)
  {
    damageDisplay.damage++;
  }
}
