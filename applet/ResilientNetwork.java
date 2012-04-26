import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class ResilientNetwork extends PApplet {

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

public void setup()
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
public void draw()
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
public void updateEnergy()
{
  println("updateEnergy");
  for(int i=0;i<nodes.size();i++)
  {
    Node node = (Node) nodes.get(i);
    node.updateEnergy();
  }
}
public void spreadEnergy()
{
  println("spreadEnergy");
  for(int i=0;i<nodes.size();i++)
  {
    Node node = (Node) nodes.get(i);
    node.spreadEnergy();
  }
}
public void resetEnergy()
{
  println("resetEnergy");
  for(int i=0;i<nodes.size();i++)
  {
    Node node = (Node) nodes.get(i);
    node.resetEnergy();
  }
}
public void keyPressed()
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
public void lightning()
{
  int randomIndex = round(random(0, nodes.size()-1));
  Node node = (Node) nodes.get(randomIndex);
  if(node instanceof Generator) node.setEnergy(0);
  else node.setEnergy(-1);
  lightning.x = node.x+node.width/2-lightning.width/2;
  lightning.y = node.y+node.height/2-lightning.height/2;
  lightning.alphaValue = 175;
}
public class Cable extends DisplayObject
{
  int energy;
  float x2 = 0, y2 = 0;
  Plug plug1;
  Plug plug2;
  
  Cable()
  {
    strokeColor = 0xffA10018;
    
    plug1 = new Plug(this);
    plug2 = new Plug(this);
  }
  public void draw()
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
public class DisplayObject 
{
  float x = 0, y = 0, rotation = 0, width = 0, height = 0;
  int fillColor, strokeColor;
  int alphaValue = 255;
  int index = 0;
  DisplayObject()
  {
    registerDraw(this);
    index = DisplayObjectStatic.index++;
  }
  
  public void draw()
  {
    println("draw");
  }
}
static class DisplayObjectStatic
{
  static int index = 0;
}

public class Generator extends Node
{
  Generator(String id)
  {
    super(id);
    
    GeneratorStatic.instances.add(this);
    
    enabled = false;
    width = height = 35;
    fillColor = strokeColor = 0xffA16E00;
    
    createOutlets(4,strokeColor);
    
    energyDemand = 0;
    energyProduction = 0; // is determined after it's enable
    
    updateVisuals();
  }
  public void mouseClicked()
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
  public void draw()
  {
    //println("draw "+toString());
    fill(0xff000000,alphaValue);
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
  public void mouseDragged()
  {
    x = round(mouseX-dragX);
    y = round(mouseY-dragY);
    update();
  }
  public void update()
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
  public void drawPie(float x, float y, float width, float height, float percentage)
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
public class House extends Node
{
  //final int ENERGY_COSTS = 5;
  
  House(String id)
  {
    super(id);
    width = 20;
    height = 30;
    fillColor = 0xff005DA1;
    
    createOutlets(2,fillColor);
    
    energyDemand = 1;
    energyProduction = 0;
    enabled = true;
    updateVisuals();
  }
  public void draw()
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
    vertex(x, y+height*0.4f);
    vertex(x+width*.5f, y);
    vertex(x+width, y+height*0.4f);
    vertex(x+width, y+height);
    vertex(x, y+height);
    endShape(CLOSE);
  }
  public void mouseDragged()
  {
    x = round(mouseX-dragX);
    y = round(mouseY-dragY);

    update();
  }
  public void mouseClicked()
  {
    disturb();
  }
  public void update()
  {
    outlets[0].x = x;
    outlets[1].x = x+width;
    outlets[0].y = outlets[1].y = y+height*0.7f;
    outlets[0].update();
    outlets[1].update();
  }
}
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
  public void mouseEvent(MouseEvent event) 
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
  public void mousePressed() { }
  public void mouseReleased() { }
  public void mouseClicked() { }
  public void mouseDragged() { }
  public void mouseMoved() { }
  public void startedDragging() { }
  public void stoppedDragging() { }
  
  public boolean hitTest(float hitX, float hitY)
  {
    return (hitX >= x && hitX <= x+width && 
      hitY >= y && hitY <= y+height);
  }
}
public class Lightning extends DisplayObject
{
  Lightning()
  {
    strokeColor = 0xffFAE500;
    alphaValue = 0;
    
    width = 45;
    height = 70;
  }
  public void draw()
  {
    strokeWeight(2);
    stroke(strokeColor,alphaValue);
    noFill();
    
    beginShape();
    vertex(x+width*0.3f, y);
    vertex(x+width*0.9f, y);
    vertex(x+width*0.6f, y+height*0.35f);
    vertex(x+width, y+height*0.35f);
    vertex(x+width*0.3f, y+height);
    vertex(x+width*0.526f, y+height*.57f);
    vertex(x, y+height*.57f);
    endShape(CLOSE);
    
    alphaValue--;
    //if(alphaValue < 
    if(alphaValue < 0) alphaValue = 0;
  }
}
class Node extends InteractiveDisplayObject implements OutletsEventsListener
{
  String id = "";
  float energy = 0;
  float energyDemand = 0;
  float energyProduction = 0;
  
  float minEnergyReserve = 0.1f;
  float maxEnergyReserve = 1;
  float minEnergy = -0.1f;
  
  Node energySource;
  boolean enabled = true;
  
  
  Outlet[] outlets;
  
  
  
  Node(String id)
  {
    this.id = id;
  }
  public void createOutlets(int numOutlets, int strokeColor)
  {
    outlets = new Outlet[numOutlets];
    for(int i=0;i<numOutlets;i++)
      outlets[i] = new Outlet(strokeColor,this,this);
  }
  public void onConnected(Outlet outlet)
  {
    println(toString()+" onConnected: nc: "+getConnected().size());
  }
  public void onDisconnected(Outlet outlet)
  {
    println(toString()+" onDisconnected: nc: "+getConnected().size());
  }
  public void updateEnergy()
  {
    println("  "+toString());
    if(!enabled) return;
    //energy += energyProduction-energyDemand;
    //setEnergy(energy + (energyProduction-energyDemand));
    setEnergy(energy + (energyProduction-energyDemand)/10);
    println("  >"+toString());
    
    
  }
  public void spreadEnergy()
  {
    //if(energy <= 0) return; //Only nodes with energy to spare get to spread energy
    if(energy <= minEnergyReserve) return; //Only nodes with energy to spare get to spread energy
    

    ArrayList connections = getConnected();
    println("  "+toString()+"  nc: "+connections.size());
    int numDemandingConnections = 0;
    for(int j=0;j<connections.size();j++)
    {
      Node connection = (Node) connections.get(j);
      // no point to giving energy to nodes with more energy
      // and if this connection gave energy to this node it makes no sense to send energy back
      if(connection.energy < energy && energySource != connection) 
        numDemandingConnections++; 
    }
    // if there are no connections that demand energy
    if(numDemandingConnections == 0 && energySource != null)
    {
      // we send the energy back to the source.
      //println("    transfer to source");
      //transferEnergy(energySource,energy);
      transferEnergy(energySource,energy-minEnergyReserve);
    }
    else if(numDemandingConnections > 0)
    {
      // we devide the spare energy over the connections that need energy

      float energyPerConnection = (energy-minEnergyReserve)/numDemandingConnections;
      //println("    transfer to connections e:"+energy+" ndc: "+numDemandingConnections+" epc: "+energyPerConnection);
      for(int j=0;j<connections.size();j++)
      {
        Node connection = (Node) connections.get(j);
        if(energySource != connection)
          transferEnergy(connection,energyPerConnection);
      }
    }
    println("  >"+toString());
  }
  public ArrayList getConnected()
  {
    ArrayList connections = new ArrayList();
    //println("  outlets.length: "+outlets.length);
    int numConnected = 0;
    for(int i=0;i<outlets.length;i++)
    {
      Outlet outlet = outlets[i];
      if(outlet.plug != null)
      {
        Cable cable = outlet.plug.cable;
        Plug otherPlug = (cable.plug1 == outlet.plug)? cable.plug2 : cable.plug1;
        if(otherPlug.outlet != null)
        {
          connections.add(otherPlug.outlet.node);
        }
      }
    }
    //println("numConnected: "+connections.size());
    return connections;
  }
  public void transferEnergy(Node targetNode,float energy)
  {
    if(targetNode.energy < energy)
    {
      //this.energy -= energy;
      //println("      transferEnergy: te: "+this.energy+" e: "+energy);
      //println("      te-e: "+(this.energy - energy));
      setEnergy(this.energy - energy);
      println("    cNode: "+targetNode.toString());
      //targetNode.energy += energy;
      targetNode.setEnergy(targetNode.energy + energy);
      targetNode.energySource = this;
      println("    >cNode: "+targetNode.toString());
      println("    >"+toString());
    }
    else
    {
      targetNode.energySource = null;  
    }
  }
  public void resetEnergy()
  {
    //setEnergy(0);
    setEnergy(minEnergyReserve);
  }
  public void setEnergy(float energy)
  {
    //if(getConnected().size() > 0)
    //{
      //println("      setEnergy: "+energy);
    //}
    if(PApplet.parseFloat(round(energy*100))/100 == 0) energy = round(energy);
    //if(energy<-1) energy = -1;
    if(energy<minEnergy) energy = minEnergy;
    else if(energy>maxEnergyReserve) energy = maxEnergyReserve;
    
    if(energy != this.energy)
    {
      //println("      energy != this.energy");
      if(energy < 0) disturb();
      this.energy = energy;
    }
    updateVisuals();
  }
  public void disturb()
  {
    println("  "+toString()+" disturb");
    for(int i=0;i<outlets.length;i++)
    {
      Outlet outlet = outlets[i];
      outlet.releasePlug();
    }
  }
  public void updateVisuals()
  {
    alphaValue = ((energy >= 0)? 255: 125);
    //println("  updateVisuals "+toString());
    //for(int i=0;i<outlets.length;i++) outlets[i].alphaValue = alphaValue;
  }
  public String toString()
  {
    //return id+" e: "+energy+" (d: "+energyDemand+" p: "+energyProduction+")";
    return id+" \te: "+energy;
  }
}
public class Outlet extends DisplayObject
{
  Plug plug;
  Node node;
  OutletsEventsListener listener;
  
  Outlet(int strokeColor, Node node, OutletsEventsListener listener)
  {
    this.strokeColor = strokeColor;
    this.node = node;
    this.listener = listener;
    width = height = 15*0.7f;
    OutletStatic.outlets.add(this);
  }
  public void draw()
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
  public void update()
  {
    if(plug != null)
    {
      plug.x = x;
      plug.y = y;
    }
  }
  public void connect(Plug plug)
  {
    this.plug = plug;
    listener.onConnected(this);
  }
  public void disconnect()
  {
    plug = null;
    listener.onDisconnected(this);
  }
  public void releasePlug()
  {
    if(plug != null)
   { 
     plug.release();
     disconnect();
   }
  }
}
static class OutletStatic
{
  static ArrayList outlets = new ArrayList();
}

interface OutletsEventsListener
{
  public void onConnected(Outlet outlet);
  public void onDisconnected(Outlet outlet);
}
public class Plug extends InteractiveDisplayObject
{
  Cable cable; 
  Outlet outlet;
  float snapDis = 10;
  Plug(Cable cable)
  {
    this.cable = cable;
    this.fillColor = 0xffA10018; //#71000C;
    width = height = 10;
  }
  public void draw()
  {
    fill(fillColor);
    noStroke();
    ellipseMode(CENTER);
    ellipse(x,y,width,height);
  }
  public void mouseDragged()
  {
    x = mouseX-dragX;
    y = mouseY-dragY;
    checkSnap();
  }
  public void mousePressed()
  {
    if(this.outlet != null)
    {
      outlet.disconnect();
      outlet = null;
    }
  }
  public void stoppedDragging()
  {
    this.outlet = checkSnap();
    if(this.outlet != null)
    {
      this.outlet.connect(this);
      //this.outlet.plug = this;
      //onConnect();
    }
  }
  public Outlet checkSnap()
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
  public boolean hitTest(float hitX, float hitY)
  {
    return (hitX >= x-width/2 && hitX <= x+width/2 && 
      hitY >= y-height/2 && hitY <= y+height/2);
  }
  public void release()
  {
    Node node = outlet.node;
    x += outlet.x-(node.x+node.width/2);
    y += outlet.y-(node.y+node.height/2);
    outlet = null;
  }
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "ResilientNetwork" });
  }
}
