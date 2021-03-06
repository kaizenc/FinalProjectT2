import java.util.*;
import ddf.minim.*;

//sound
Minim laserm;
AudioSample laserp;
Minim monS;
AudioSample monsterDeath;
Minim powerS;
AudioSample powerupS;
Minim minim;
AudioPlayer player;
Minim explodem;
AudioSample explodes;

//awall
PImage wall;

//other stuffs
int mode;
Random r = new Random();
Random rand = new Random();
ArrayList<Bullet> bulletArr = new ArrayList<Bullet>();
ArrayList<Grenade> grenadeArr = new ArrayList<Grenade>();
ArrayList<Monster> monsterArr = new ArrayList<Monster>();
ArrayList<PowerUp> puArr = new ArrayList<PowerUp>();
ArrayList<Animation> aniArr = new ArrayList<Animation>();
float time;
Player p1;
Mouse mouse;
Menu menu;

//score
int score;

//rapid fire
boolean shooting = false;

void setup() {
  size(1280, 720);
  mode = 1;
  p1 = new Player(600, 350, 50, 50);
  mouse = new Mouse(3, 3);
  menu = new Menu();
  wall = loadImage("W.png");
  time = 0;
  minim = new Minim(this);
  monS = new Minim(this);
  laserm = new Minim(this);
  powerS = new Minim(this);
  explodem = new Minim(this);
  
  player = minim.loadFile("sounds/song.mp3");
  monsterDeath = monS.loadSample("sounds/combobreak.wav");
  laserp = laserm.loadSample("sounds/laser.wav");
  powerupS = powerS.loadSample("sounds/powerup.wav");
  explodes = explodem.loadSample("sounds/explosion.wav");
  
  score = 0;
}

void draw() {
  if (mode == 1) {//menu
    menu.display();
    score=0;
  } else {//literally the game
    player.play();
    time+=.00001;
    background(155);
    image(wall, 650-(p1.getX()/10), 350-(p1.getY()/10));

    pushMatrix();
    translate(width/2, height/2);
    p1.move(mouse);
    translate(-p1.getX(), -p1.getY());

    pushMatrix();//rotation
    translate(p1.getX(), p1.getY());
    p1.turn(mouse);
    translate(-p1.getX(), -p1.getY());
    if (p1.alive()) {
      p1.display();
    }
    popMatrix();

    pushMatrix();//mouse rotation
    translate(mouse.getX(), mouse.getY());
    rotate(radians(frameCount%360));
    translate(-mouse.getX(), -mouse.getY());
    if(p1.fmode == 2){
      mouse.display1();
    } else if(p1.fmode == 3){
      mouse.display2();
    } else {
      mouse.display();
    }
    popMatrix();
   
    p1.aSd();
    constantFIRE();
    p1.effectDown();
    
    ArrayList<Bullet> tbulletArr = new ArrayList<Bullet>();
    for (Bullet b : bulletArr) {

      pushMatrix();//rotation
      translate(b.getX(), b.getY());
      b.turn();
      translate(-b.getX(), -b.getY());
      b.display();
      popMatrix();

      b.shoot();
      
      if (b.rInc()) {
        tbulletArr.add(b);
      }
    }
    bulletShootMonster(); 
    for (Bullet b : tbulletArr) {
      bulletArr.remove(b);
    }
    aniDisplay();
    
    powerDisplay();
    powerConsume();
    grenadeDisplay();
    spawnMonster(); 
    fill(0);
    monsterMovement();
    obstacle();
    popMatrix();
    
    textSize(32); // Set text size to 32
    fill(0);
    text("Health: "+p1.getHealth(), 0, 40);
    fill(0);
    text("Score: "+score, 0, 80);
    text("Grenades: "+p1.getGammo(), 0, 120);
    if(p1.dMod != 1){
      text("2x Damage!", 0, 160);
    }
    
    if(!p1.alive()){
      textSize(90);
      text("GAME OVER",width/2,height/2);
      textSize(40);
      text("Press M to go back to the menu",width/2,height/2 + 100);
      monsterArr = new ArrayList<Monster>();
    }
  }
}

//The walls
void obstacle() {
  rect(-2100, -1000, 50, 5000); 
  rect(2050, -1000, 50, 5000);
  rect(-2100, 950, 50000, 50);
  rect(-2100, -1000, 50000, 50);
}
//Monster Interactions
void bulletShootMonster() {
  for (int b = 0; b < bulletArr.size (); b++) {
    for (int m = 0; m < monsterArr.size (); m++) {
      if (b>0 && bulletArr.size() >0) {
        if (HitCheck(b, m, bulletArr.get(b).getR()+5))
          if (b>0 && bulletArr.size() >0)
            b--;
      }
    }
  }
}
void playerDamaged(Monster m) {
  float r = m.getR() * .5;
  if (m.getX() <= p1.getX() + r &&
    m.getX() >= p1.getX() - r &&
    m.getY() <= p1.getY() + r &&
    m.getY() >= p1.getY() - r) {
    p1.damage(1);
  }
}
boolean HitCheck(int bi, int mi, float r) {
  r-=3;
  Bullet b = bulletArr.get(bi);
  Monster m = monsterArr.get(mi);
  float rad = m.getR() * .5;
  if (m.getX()-rad <= b.getX() + r &&
    m.getX()+rad >= b.getX() - r &&
    m.getY()-rad <= b.getY() + r &&
    m.getY()+rad >= b.getY() - r) {
    m.damage(b.getBulletDmg());
    if (m.shouldDie()) {
      score+=10;
      if(rand.nextInt(20) == 19){
        puArr.add(new PowerUp(m.getX(),m.getY(),0,20));
      } else if(rand.nextInt(20) == 19){
        puArr.add(new PowerUp(m.getX(),m.getY(),1,1));
      } else if(rand.nextInt(20) == 19){
        puArr.add(new PowerUp(m.getX(),m.getY(),2,1));
      }
      aniArr.add(new Animation("zDeath", 5, m.getVector(), m.getR(),m.rotation()));
      monsterArr.remove(mi);
      //monsterDeath.trigger();
    }
    bulletArr.remove(bi);
    return true;
  }
  return false;
}
void spawnMonster() {
  if (time > 10)
    time = 10;
  if (r.nextInt(100) < 1+(time)) {
    Monster john = new Monster(r.nextInt(3000)-2000, r.nextInt(1500)-1000);
    monsterArr.add(john);
  }
}
void monsterMovement() {
  for (Monster m : monsterArr) {
    m.follow(p1);
    playerDamaged(m);
    pushMatrix();//rotation
    translate(m.getX(), m.getY());
    m.turn();
    translate(-m.getX(), -m.getY());
    m.display();
    popMatrix();   
  }
}
void explode(Grenade g){
  explodes.trigger();
  ArrayList<Monster> temp = new ArrayList<Monster>();
  for(Monster m : monsterArr){
    if(PVector.sub(g.getVector(),m.getVector()).mag() <= 150){
      m.damage(g.getGrenadeDmg());
      if (m.shouldDie()) {
        temp.add(m);
      }
    }
  }
  for (Monster m : temp){
    score+=10;
    if(rand.nextInt(20) == 19){
      puArr.add(new PowerUp(m.getX(),m.getY(),0,20));
    } else if(rand.nextInt(20) == 19){
      puArr.add(new PowerUp(m.getX(),m.getY(),1,1));
    } else if(rand.nextInt(20) == 19){
      puArr.add(new PowerUp(m.getX(),m.getY(),2,1));
    }
    aniArr.add(new Animation("zDeath", 5, m.getVector(), m.getR(),m.rotation()));
    monsterArr.remove(m);
    //monsterDeath.trigger();
  }
}
//PowerUp Interactions
void powerDisplay(){
  ArrayList<PowerUp> temp = new ArrayList<PowerUp>();
  for (PowerUp p:puArr){
    if(p.timeOut()){
      temp.add(p);
    }
    p.display();
  }
  for (PowerUp p:temp){
    puArr.remove(p);
  }
}
void powerConsume(){
  ArrayList<PowerUp> temp = new ArrayList<PowerUp>();
  for (PowerUp p:puArr){
    if(PVector.sub(p1.getVector(),p.getVector()).mag() <= 30){
      temp.add(p);
      p1.consume(p);
      powerupS.trigger();
    }
  }
  for (PowerUp p:temp){
    puArr.remove(p);
  }
}
//boom boom
void grenadeDisplay(){
  ArrayList<Grenade> temp = new ArrayList<Grenade>();
  for (Grenade g:grenadeArr){
    g.display();
    g.shoot();
    if(g.rInc()){
      temp.add(g);
    }
  }
  for (Grenade g:temp){
    explode(g);
    aniArr.add(new Animation("explosion", 4, (int)g.getX(), (int)g.getY(),140.0));
    grenadeArr.remove(g);
  }
}
//SpecialFX
void aniDisplay(){
  ArrayList<Animation> temp = new ArrayList<Animation>();
  for (Animation a:aniArr){
    if(a.advance()){
      temp.add(a);
    }
    pushMatrix();//rotation
    translate(a.getX(), a.getY());
    a.turn();
    translate(-a.getX(), -a.getY());
    a.display();
    popMatrix();  
  }
  for (Animation a:temp){
    aniArr.remove(a);
  }
}




void mousePressed() {
  if (mode == 0 && p1.alive()) {
    if (p1.getAtkSpd() == 0) {
      if (p1.fmode == 1) {
        laserp.trigger();
        Bullet bull = new Bullet(p1.getX(), p1.getY(), 10, 3*p1.dMod, mouse);
        bulletArr.add(bull);
        p1.aSr();
      } else if (p1.fmode == 2) {
        laserp.trigger();
        Bullet bull1 = new Bullet(p1.getX(), p1.getY(), 10, 20*p1.dMod, mouse, 0);
        Bullet bull2 = new Bullet(p1.getX(), p1.getY(), 10, 20*p1.dMod, mouse, PI/6);
        Bullet bull3 = new Bullet(p1.getX(), p1.getY(), 10, 20*p1.dMod, mouse, -PI/6);
        Bullet bull4 = new Bullet(p1.getX(), p1.getY(), 10, 20*p1.dMod, mouse, PI/12);
        Bullet bull5 = new Bullet(p1.getX(), p1.getY(), 10, 20*p1.dMod, mouse, -PI/12);
        bulletArr.add(bull1);
        bulletArr.add(bull2);
        bulletArr.add(bull3);
        bulletArr.add(bull4);
        bulletArr.add(bull5);
        p1.aSr();
      } else if (p1.fmode == 3 && p1.hasGrenade()){
        grenadeArr.add(new Grenade(p1.getX(), p1.getY(), 10, 40*p1.dMod, mouse));
        p1.switchF();
      } else {
        p1.switchF();
      }
    }
  } else if (mode == 1) {
    if (menu.mouseIn()) {
      mode = 0;
      p1.fmode = 1;
    }
  }
}
void mouseReleased(){
  shooting = false;
}
void mouseDragged(){
  shooting = true;
}

void constantFIRE(){
  if (mode == 0 && p1.alive() && shooting == true) {
    if (p1.getAtkSpd() == 0) {
      if (p1.fmode == 1) {
        laserp.trigger();
        Bullet bull = new Bullet(p1.getX(), p1.getY(), 10, 3*p1.dMod, mouse);
        bulletArr.add(bull);
        p1.aSr();
      }
    }
  }
}

void keyPressed() {
  if (p1.alive()) {

    if (key== 's'||key=='S') {
      p1.setDown(true);
      p1.setUp(false);
    }
    if (key== 'W'||key=='w') {
      p1.setUp(true);
      p1.setDown(false);
    }
    if (key== 'a' || key== 'A') {
      p1.setLeft(true);
      p1.setRight(false);
    }
    if (key== 'd' || key== 'D') {
      p1.setLeft(false);
      p1.setRight(true);
    }
    if (key== 'f' || key== 'F') {
      p1.switchF();
      if (p1.fmode==2) {
        p1.setAS(20);
      } else {
        p1.setAS(5);
      }
    }
    if (key== 'g' || key== 'G') {
      p1.getGrenade();
    }
  }
  if (key== 'm'||key=='M') {
    mode = 1;
    p1 = new Player(600, 350, 50, 50);
    mouse = new Mouse(3, 3);
    bulletArr = new ArrayList<Bullet>();
    monsterArr = new ArrayList<Monster>();
    player.rewind();
    player.pause();
    score = 0;
  }
}
void keyReleased() {
  if (key== 'w'||key=='W') {
    p1.setUp(false);
  }
  if (key== 's'||key=='S') {
    p1.setDown(false);
  }
  if (key== 'a'||key=='A') {
    p1.setLeft(false);
  }
  if (key == 'd' || key =='D') {
    p1.setRight(false);
  }
}

