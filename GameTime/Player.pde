public class Player {
  private float x, y, w, h;
  private int health, atkSpd, aSCap, fmode, gAmmo;
  private int effectlength;
  private PImage dude;
  int dMod;
  boolean left = false;
  boolean right = false;
  boolean up = false;
  boolean down = false;
  public Player(float xcor, float ycor, float w, float h) {
    x=xcor;
    y=ycor;
    this.w = w;
    this.h = h;
    health = 100;
    atkSpd = 0;
    aSCap = 5;
    dude = loadImage("Dude.png");
    fmode = 1;
    dMod = 1;
    gAmmo = 3;
  }
  //access granted
  public float getX() {
    return x;
  }
  public float getY() {
    return y;
  }
  public PVector getVector(){
    return new PVector(x,y);
  }
  public int getHealth() {
    if (health <= 0){
      return 0;
    }
    return health;
  }
  public int getGammo(){
    return gAmmo;
  }
  public void damage(int d) {
    health -= d; //reduces health by d
  }
  
  //Attack Speed
  public int getAtkSpd(){
    return atkSpd;
  }
  public void setAS(int as){
    aSCap = as;
    aSr();
  }
  public void aSd() {//reduces attack speed timer (attackSpeedDown)
    if (atkSpd == 0) {
      return;
    } else {
      atkSpd--;
    }
  }
  public void aSr() {//resets attack speed timer (attackSpeedReset)
    atkSpd = aSCap;
  }
  
  //Movement
  void setUp(boolean x) {
    up = x;
  }
  void setDown(boolean x) {
    down = x;
  }
  void setLeft(boolean x) {
    left=x;
  }
  void setRight(boolean x) {
    right = x;
  }
  
  void move(Mouse m) {
    if (up && y > -900) {
      y=y-5;
      m.setYmod(m.getYmod() - 5);
      //translate(0,5);
    }
    if (down && y < 900) {
      y=y+5;
      m.setYmod(m.getYmod() + 5);
      //translate(0,-5);
    }
    if (left && x > -2000) {      
      x=x-5;
      m.setXmod(m.getXmod() - 5);
      //translate(5,0);
    }
    if (right && x < 2000) {
      x+=5;
      m.setXmod(m.getXmod() + 5);
      //translate(-5,0);
    }
  }
  void turn(Mouse m){
    PVector other = new PVector(m.getX()-x,m.getY()-y);
    rotate(other.heading());
  }
  
  void display() {
    imageMode(CENTER);
    image(dude,x,y);
  }
  boolean alive(){
    return health>0;
  }
  boolean hasGrenade(){
    boolean result = gAmmo > 0;
    gAmmo--;
    if(gAmmo < 0){
      gAmmo = 0;
    }
    return result;
  }
  void switchF(){
    if (fmode == 1){
      fmode = 2;
    } else {
      fmode = 1;
    }
  }
  void getGrenade(){
    fmode = 3;
  }
  void consume(PowerUp p){
    if(p.getType() == 0){
      health+=p.getValue();
      if(health > 100){
        health = 100;
      }
    } else if (p.getType() == 1){
      gAmmo++;
    } else if (p.getType() == 2){
      effectlength = 600;
      dMod = 2;
    }
  }
  void effectDown(){
    effectlength--;
    if(effectlength <=0){
      dMod = 1;
    }
  }
}

