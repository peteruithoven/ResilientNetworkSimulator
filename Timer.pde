public class Timer
{
  boolean running = false;
  int interval = 1000;
  int startTime = 0;
  int count = 0;
  int repeatCount = 0;
  TimerListener listener;
  
  Timer(TimerListener listener)
  {
    this.listener = listener;
    registerDraw(this);
  } 
  void draw()
  {
    if(!running) return;
    
    int elapsedTime = millis();
    if(elapsedTime > startTime+interval)
    {
      tick();
      if(count < repeatCount || repeatCount == 0)
        start();
      else
        reset();
    }
  }
  void start()
  {
    startTime = millis();
    running = true;
  }
  void pause()
  {
    // TODO unregisterDraw
    running = false;
  }
  void reset()
  {
    pause();
    count = 0;
  }
  private void tick()
  {
    count++;
    listener.tick(this);
  }
  
  //////// getters & setters //////// 
  int getInterval()
  {
    return interval;
  }
  void setInterval(int value)
  {
    interval = value;
    if(interval < 500) interval = 500;
  }
  int getRepeatCount()
  {
    return repeatCount;
  }
  void setRepeatCount(int value)
  {
    repeatCount = value;
  }
}
interface TimerListener
{
  void tick(Timer timer);
}
