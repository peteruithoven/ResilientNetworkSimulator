public class LightningButton extends InteractiveDisplayObject
{
  LightningButton()
  {
    fillColor = #FAE500;
    strokeColor = #FAE500;
    //alphaValue = 255;
    
    width = 30; //20;
    height = 40; //30;
  }
  void draw()
  {
    strokeWeight(2);
    stroke(strokeColor,alphaValue);
    fill(#000000);
    rect(x,y,width,height);
    
    noStroke();
    fill(fillColor);
    
    float padding = 5;
    float width = this.width-padding*2;
    float height = this.height-padding*2;
    float x = this.x+padding;
    float y = this.y+padding;
    
    beginShape();
    vertex(x+width*0.3, y);
    vertex(x+width*0.9, y);
    vertex(x+width*0.6, y+height*0.35);
    vertex(x+width, y+height*0.35);
    vertex(x+width*0.3, y+height);
    vertex(x+width*0.526, y+height*.57);
    vertex(x, y+height*.57);
    endShape(CLOSE);
  }
}
