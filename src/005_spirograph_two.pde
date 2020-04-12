// https://web.archive.org/web/20170704084618/http://abandonedart.org/works/003/003_spyro6.pde
// Oct 2008 
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



//================================= global vars

int num = 4;
int step = 10;
float centx, centy;
Particle[] pArr;

//================================= init

void setup() {
  size(500,300);
  frameRate(320);
  clearBackground();
  smooth();
  
  centx = width/2;
  centy = height/2;
  
  pArr = new Particle[num];
  for (int i=0;i<num;i++) {
    pArr[i] = new Particle(i);
  }
}

void clearBackground() {
  background(0);
}

//================================= frame loop

void draw() {
  // clearBackground();
  for (int i=0;i<num;i++) {
    pArr[i].update();
  }
}

//================================= interaction

void mousePressed() { 
  clearBackground();
  centx = mouseX;
  centy = mouseY;
  for (int i=0;i<num;i++) {
    pArr[i].init();
  }
}

//================================= objects

class Particle {
  int id;
  int count, life, step;
  float origx, origy;
  float x1, y1, x2, y2;
  int rd, gr, bl, alph;
  float angle, radius;
  
  Particle (int num) {
    id = num;
    init();
  }
  
  void trace(String str) {
    println("Particle " + id + ": " + str);
  }
  
  void init() {
    trace("init");
    count = 0;
    step = int(random(10));
    life = 180 * int(random(5) + 1);
    radius = random(width) + 10;
    // radius = random(50);
    
    //origx = centx + (radius * cos(angle));
    //origy = centy + (radius * sin(angle));
    x1 = 999;
    //y1 = origy;
    alph = 255;
    
    rd = int(random(255));
    //gr = int(random(255));
    //bl = int(random(255));
    bl = gr = rd;  // grey
  }
  
  void update() {
    count += step;
    angle = count; 
    // project x2,y2 from x1,y1, and draw a line to it
    x2 = centx + (radius * cos(angle));
    y2 = centy + (radius * sin(angle));
    // draw line to it
    if (x1 != 999) {
      strokeWeight(1);
      stroke(rd, gr, bl, alph);
      line(x1, y1, x2, y2);
    }
    // reset for next update
    x1 = x2; y1 = y2;
    
    alph -= step;
   
    // expiration  
    if (count >= life) { init(); }
  }
  
}