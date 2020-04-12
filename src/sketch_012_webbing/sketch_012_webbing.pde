// http://abandonedart.org/works/016_webbing/_081019_nodenetwork4a2.pde
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

int num = 140;
int count = 0;
float[] xArr;
float[] yArr;
int r,g,b;
int lr,lg,lb;

Particle p;

//================================= init

void setup() {
  size(500, 300);
  smooth(); 
  frameRate(12);
  
  r = g= b = 0;
  
  clearBackground();
  count = 0;
  restart();
  
  p = new Particle();
  
}

void clearBackground() {
  background(0);
}

void restart() {
 if (count > 0) {
   xArr = new float[num];
   yArr = new float[num];
   count = 1; 
 } else {
   xArr = new float[num];
   yArr = new float[num];
 } 
 println("rstart");
 lr = r; lg = g; lb = b; 
 r = int(random(255));
 g = int(random(255));
 b = int(random(255));
}

//================================= frame loop

void draw() {
 
  fill(0, 2);
  rect(0, 0, width, height);
  
  drawPoints();
}

  
void drawPoints() {
  
  p.update();
  
  float newx = p.x;
  float newy = p.y;
  
  int alph = 2;
  // line to all the others
  for (int i=count;i>0;i--) {
    
    strokeWeight(1);
    stroke(r, g, b, alph);
    line(newx, newy, xArr[i], yArr[i]);
    
    
    strokeWeight(1);
    stroke(255, 40);
    line(newx, newy, p.lastx, p.lasty);
    
  }
  
  // next
  count++;
  if (count >= num) {
    restart(); 
  }
  xArr[count] = newx;
  yArr[count] = newy; 
  
  

}

//================================= interaction

void mousePressed() { 
  clearBackground();
}



//================================= objects

class Particle {
  
  float x, y; 
float lastx, lasty;  
  float pct = 0.0;
  
  float beginX, beginY; 
  float endX,  endY;    
  float distX,  distY;
  int grey, alph;
  
  float exponent = 2;   // Determines the curve
  float step = 0.05;    // Size of each step along the path
  
  Particle () {
    init();
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
    lastx = x;
    lasty = y;
    
    pct += step;
    if (pct < 1.0) {
      x = beginX + (pct * distX);
      y = beginY + (pow(pct, exponent) * distY);
    } else {
      pct = 0.0;
      beginX = x;
      beginY = y;
    endX = random(width * 2) - (width/2);
    endY = random(height * 2) - (height/2);
      distX = endX - beginX;
      distY = endY - beginY;  
    }
    
  }
  
}



