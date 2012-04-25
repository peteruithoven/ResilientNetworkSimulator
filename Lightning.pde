public class Lightning extends DisplayObject
{
  Lightning()
  {
    strokeColor = #FAE500;
    alphaValue = 0;
    
    width = 45;
    height = 70;
  }
  void draw()
  {
    strokeWeight(2);
    stroke(strokeColor,alphaValue);
    noFill();
    
    beginShape();
    vertex(x+width*0.3, y);
    vertex(x+width*0.9, y);
    vertex(x+width*0.6, y+height*0.35);
    vertex(x+width, y+height*0.35);
    vertex(x+width*0.3, y+height);
    vertex(x+width*0.526, y+height*.57);
    vertex(x, y+height*.57);
    endShape(CLOSE);
    
    alphaValue--;
    //if(alphaValue < 
    if(alphaValue < 0) alphaValue = 0;
  }
}
