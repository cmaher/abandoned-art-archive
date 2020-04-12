// https://web.archive.org/web/20170630103636/http://abandonedart.org/works/004/004_spots.pde
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

int num = 8;
Particle[] pArr;


//================================= init

void setup()  {
  size(500, 300);
  smooth();
  frameRate(60);
  clearBackground();
  
  pArr = new Particle[num];
  for (int i=0;i<num;i++) {
    pArr[i] = new Particle(i);
  }
}

void clearBackground() {
  background(0);
}

//================================= frame loop

void draw()  {
  // clearBackground();
  for (int i=0;i<num;i++) {
    pArr[i].update();
  }
}

//================================= interaction

void mousePressed() {
  clearBackground();
  for (int i=0;i<num;i++) {
    pArr[i].init();
  }
}


//================================= objects

class Particle {
  int id;  
  
  float x, y;           
  float pct = 0.0;
  
  float beginX, beginY; 
  float endX,  endY;    
  float distX,  distY;
  int grey, alph;
  
  float exponent = 4;   
  float step = 0.01;    
  
  Particle (int num) {
    id = num;
    init();
  }
  
  void trace(String str) {
    println("Particle " + id + ": " + str);
  }
  
  void init() {
    
    grey = int(random(255));
    alph = int(random(100));
  
    beginX = random(width * 2) - (width/2);
    beginY = random(height * 2) - (height/2);
    
    endX = random(width * 2) - (width/2);
    endY = random(height * 2) - (height/2);
    
    
    distX = endX - beginX;
    distY = endY - beginY;
  }
  
  void update() {
    pct += step;
    if (pct < 1.0) {
      x = beginX + (pct * distX);
      y = beginY + (pow(pct, exponent) * distY);
    } else {
      pct = 0.0;
      beginX = x;
      beginY = y;
      endX = random(width);
      endY = random(height);
      distX = endX - beginX;
      distY = endY - beginY;  
    }
    
    // alter rad accrding to distance
    float rad = distX;
    if (distY > distX) { rad = distY; }
    
    noStroke();
    fill(grey, alph);
    ellipse(x, y, rad, rad);
    
    // mirror it
    
    float mirrorx = width - x;
    ellipse(mirrorx, y, 6, 6);
  }
  
}

