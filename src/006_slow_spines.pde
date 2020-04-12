// https://web.archive.org/web/20170707221555/http://abandonedart.org/works/005_spines/spines3.pde
// Sept 2008 
// http://www.abandonedart.org
// http://www.zenbullets.com
//
// This work is licensed under a Creative Commons 3.0 License.
// (Attribution - NonCommerical - ShareAlike)
// http://creativecommons.org/licenses/by-nc-sa/3.0/
// 
// This basically means, you are free to use it as long as you:
// 1. give http://www.zenbullets.com a credit
// 2. don't use it for commercial gain
// 3. share anything you create with it in the same way I have
//
// These conditions can be waived if you want to do something groovy with it 
// though, so feel free to email me via http://www.zenbullets.com


int num = 100;           // total number of particles

// blackout - four cycles, black, colour1, white, colour2
String blackout =  "colour2";

Particle[] pArr;


void setup() {
  size(500,300); 
  frameRate(30); 
      
  background(0);
  pArr = new Particle[num];

  for (int i=0;i<num;i++) {
    float r = PI*i/num;
    pArr[i] = new Particle(r);
  }

}

void draw() {
  for (int i=0;i<num;i++) {
    pArr[i].move();
  }
}

void mousePressed() {
    // manually switch blackout periods
    if (blackout == "colour1") {
      blackout = "black";
    } else if (blackout == "black")  {
      blackout = "colour2";
    } else if (blackout == "colour2")  {
      blackout = "white";
    } else if (blackout == "white")  {
      blackout = "colour1";
    }
    
    // change origin point to mouse pos
  for (int i=0;i<num;i++) {
    pArr[i].origin(mouseX, mouseY);
  }
}


class Particle {
  float ox, oy;
  float x, y;
  float xx, yy;

  float vx;
  float vy;
  int age=int(random(200));
  
  // colour
  int rc;
  int gc;
  int bc;
  int alph = 100;
  
  // line
  int maxline = 2;
  int linethick;

  Particle(float r) {
    ox = 250;
    oy = 200;
    x = ox;
    y = oy;
    
    xx = 0;            // position x'
    yy = 0;            // position y'

    vx = 2*cos(r);     // velocity x
    vy = 2*sin(r);     // velocity y

    rc = int(random(255));
    gc = int(random(255));
    bc = int(random(255)); 
  
    linethick = int(random(maxline)); 
  }
  
  void origin(float ex, float why) {
    // ox = ex;
    oy = why;
  }

  void move() {
    xx=x;
    yy=y;

    x+=vx;
    y+=vy;

    vx += (random(500)-random(500))*0.005;
    vy += (random(500)-random(500))*0.005;

    // stroke(red(i),green(i),blue(i),700);
      strokeWeight(linethick);
    if (blackout == "colour1") {
      strokeWeight(linethick * 2);
      stroke(rc,gc,bc,60);
    } else if (blackout == "colour2") {
      stroke(rc,gc,bc,60);
    } else if (blackout == "black") {
      stroke(0,0,0,alph);
    } else if (blackout == "white") {
      stroke(255,255,255,alph);
    }
    
    line(ox+xx,oy+yy,ox+x,oy+y);
    line(ox-xx,oy+yy,ox-x,oy+y);

    // expiration
    age++;
    if (age>200) {
      float t = random(TWO_PI);
      x=30*sin(t);
      y=30*cos(t);
      xx=0;
      yy=0;
      vx=0;
      vy=0;
      age=0;
    }
  }
}



