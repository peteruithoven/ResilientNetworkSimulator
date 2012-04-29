public class DamageDisplay extends DisplayObject
{
  int textAlignMode;
  int damage;
  boolean enabled = false;
  
  DamageDisplay()
  {
    textAlignMode = RIGHT;
    fillColor = #FAE500;
    damage = 0;
  }
  void draw()
  {
    if(!enabled) return;
    fill(fillColor);
    textAlign(textAlignMode);
    text("Damage: "+damage, x, y);
  }
}
