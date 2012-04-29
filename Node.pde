class Node extends InteractiveDisplayObject implements OutletsEventsListener
{
  String id = "";
  float energy = 0;
  float prevEnergy = 0;
  float energyDemand = 0;
  float energyProduction = 0;
  
  float minEnergyReserve = 0.1;
  float maxEnergyReserve = 1;
  float minEnergy = -0.1;
  
  Node energySource;
  boolean enabled = true;
  
  Outlet[] outlets;
  
  NodeListener nodeListener;
  
  Node(String id)
  {
    this.id = id;
  }
  void createOutlets(int numOutlets, color strokeColor)
  {
    outlets = new Outlet[numOutlets];
    for(int i=0;i<numOutlets;i++)
      outlets[i] = new Outlet(strokeColor,this,this);
  }
  void onConnected(Outlet outlet)
  {
    if(DEBUG) println(toString()+" onConnected: nc: "+getConnected().size());
  }
  void onDisconnected(Outlet outlet)
  {
    if(DEBUG) println(toString()+" onDisconnected: nc: "+getConnected().size());
    
    // if energySource, remove it
    Node connection = outlet.getConnection();
    if(connection != null && connection == energySource)
      energySource = null;
  }
  void updateEnergy()
  {
    if(DEBUG) println("  "+toString());
    if(!enabled) return;
    //energy += energyProduction-energyDemand;
    //setEnergy(energy + (energyProduction-energyDemand));
    setEnergy(energy + (energyProduction-energyDemand)/10);
    if(DEBUG) println("  >"+toString());
    
    
  }
  void spreadEnergy()
  {
    //if(energy <= 0) return; //Only nodes with energy to spare get to spread energy
    if(energy <= minEnergyReserve) return; //Only nodes with energy to spare get to spread energy
    

    ArrayList connections = getConnected();
    if(DEBUG) println("  "+toString()+"  nc: "+connections.size());
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
    if(DEBUG) println("  >"+toString());
  }
  ArrayList getConnected()
  {
    ArrayList connections = new ArrayList();
    //println("  outlets.length: "+outlets.length);
    int numConnected = 0;
    for(int i=0;i<outlets.length;i++)
    {
      Outlet outlet = outlets[i];
      Node connection = outlet.getConnection();
      if(connection != null)
        connections.add(connection);
    }
    //println("numConnected: "+connections.size());
    return connections;
  }
  void transferEnergy(Node targetNode,float energy)
  {
    if(targetNode.energy < energy)
    {
      //this.energy -= energy;
      //println("      transferEnergy: te: "+this.energy+" e: "+energy);
      setEnergy(this.energy - energy);
      if(DEBUG) println("    cNode: "+targetNode.toString());
      //targetNode.energy += energy;
      targetNode.setEnergy(targetNode.energy + energy);
      targetNode.energySource = this;
      if(DEBUG) println("    >cNode: "+targetNode.toString());
      if(DEBUG) println("    >"+toString());
    }
    else
    {
      targetNode.energySource = null;  
    }
  }
  void resetEnergy()
  {
    //setEnergy(0);
    setEnergy(minEnergyReserve);
  }
  void setEnergy(float energy)
  {
    //if(getConnected().size() > 0)
    //{
      //println("      setEnergy: "+energy);
    //}
    if(float(round(energy*100))/100 == 0) energy = round(energy);
    if(energy<minEnergy) energy = minEnergy;
    else if(energy>maxEnergyReserve) energy = maxEnergyReserve;
    
    if(energy != this.energy)
    {
      if(energy < 0) disturb(true);
      if(nodeListener != null && energy < 0 && this.energy >= 0)
        nodeListener.nodeLostEnergy(this);
      this.prevEnergy = this.energy;
      this.energy = energy;
    }
    //updateVisuals();
  }
  void disturb(boolean allOutlets)
  {
    if(DEBUG) println("  "+toString()+" disturb");
    if(allOutlets)
    {
      for(int i=0;i<outlets.length;i++)
      {
        Outlet outlet = outlets[i];
        outlet.releasePlug();
      }
    }
    else
    {
      ArrayList connected = new ArrayList();
      for(int i=0;i<outlets.length;i++)
      {
        Outlet outlet = outlets[i];
        if(outlet.getConnection() != null) connected.add(outlet);
      }
      if(connected.size() > 0)
      {
        int randomIndex = round(random(0,connected.size()-1));
        Outlet outlet = (Outlet) connected.get(randomIndex);
        outlet.releasePlug();
      }
    }
  }
  void updateVisuals()
  {
    //alphaValue = ((energy >= 0)? 255: 125);
    //println("  updateVisuals "+toString());
    //for(int i=0;i<outlets.length;i++) outlets[i].alphaValue = alphaValue;
  }
  String toString()
  {
    //return id+" e: "+energy+" (d: "+energyDemand+" p: "+energyProduction+")";
    return id+" \te: "+energy;
  }
  void addNodeListener(NodeListener nodeListener)
  {
    this.nodeListener = nodeListener;
  }
}
interface NodeListener
{
  void nodeLostEnergy(Node node);
}
