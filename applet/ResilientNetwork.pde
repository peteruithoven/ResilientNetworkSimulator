final float TOTAL_ENERGY_PRODUCTION = 6;
final int NUM_HOUSES = 9;
final int NUM_GENERATORS = 3;
final int NUM_CABLES = 20;

ArrayList displayObjects;
ArrayList nodes;
ArrayList generators;

int prevEnergyTime = 0;
int prevLightningTime = 0;
int prevEnergySpreadTime = 0;
Lightning lightning;

void setup()
{
  size(600,400); 
  smooth();
  
  displayObjects = new ArrayList();
  nodes = new ArrayList();
  generators = new ArrayList();
  for(int i=0;i<NUM_HOUSES;i++)
  {
    House house = new House("H"+(i+1));
    house.x = random(60,width-house.width*2);
    house.y = random(house.height,height-house.height*2);
    house.update();
    displayObjects.add(house);
    nodes.add(house);
  }
  for(int i=0;i<NUM_GENERATORS;i++)
  {
    Generator generator = new Generator("G"+(i+1));
    generator.x = random(60,width-generator.width*2);
    generator.y = random(generator.height,height-generator.height*2);
    generator.update();
    displayObjects.add(generator);
    generators.add(generator);
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
    displayObjects.add(cable);
    nextY += cable.plug1.height+5; 
  }
  
  lightning = new Lightning();
}
void draw()
{
  background(0);
  
  if(millis()-prevEnergySpreadTime > 83) //12fps
  {
    spreadEnergy();
    spreadEnergy();
    spreadEnergy();
    spreadEnergy();
    spreadEnergy();
    prevEnergySpreadTime = millis();
  }
  if(millis()-prevEnergyTime > 300)
  {
    updateEnergy();
    prevEnergyTime = millis();
  }
  
  if(millis()-prevLightningTime > 30000)
  {
    lightning();
    prevLightningTime = millis();
  }
}
void updateEnergy()
{
  println("updateEnergy");
  for(int i=0;i<nodes.size();i++)
  {
    Node node = (Node) nodes.get(i);
    node.updateEnergy();
  }
}
void spreadEnergy()
{
  println("spreadEnergy");
  for(int i=0;i<nodes.size();i++)
  {
    Node node = (Node) nodes.get(i);
    node.spreadEnergy();
  }
}
void resetEnergy()
{
  println("resetEnergy");
  for(int i=0;i<nodes.size();i++)
  {
    Node node = (Node) nodes.get(i);
    node.resetEnergy();
  }
}
void keyPressed()
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
  }
  println("overview");
  for(int i=0;i<nodes.size();i++)
  {
    Node node = (Node) nodes.get(i);
    println("  "+node.toString());
  }
}
void lightning()
{
  int randomIndex = round(random(0, nodes.size()-1));
  Node node = (Node) nodes.get(randomIndex);
  if(node instanceof Generator) node.setEnergy(0);
  else node.setEnergy(-1);
  lightning.x = node.x+node.width/2-lightning.width/2;
  lightning.y = node.y+node.height/2-lightning.height/2;
  lightning.alphaValue = 175;
}
