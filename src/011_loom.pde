// http://abandonedart.org/works/009_loom2/loom5.pde
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



//================================= global vars

int num = 12;
Particle[] pArr;

//================================= init

void setup() {
  size(500,300);
  frameRate(60);
  clearBackground();
  smooth();
  
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
  int count, life, step;
  int origx = -5;
  int origy;
  float x1, y1, x2, y2;
  int rd, gr, bl, alph;
  float exponential;
  
  int horYpos = 0;
  
  Particle (int num) {
    id = num;
    if (id % 2 == 0) { origx = int(width/2); } 
    init();
  }
  
  void trace(String str) {
    println("Particle " + id + ": " + str);
  }
  
  void init() {
    trace("init");
    count = 0;
    step = 5;
    life = width;
    origx = origx + 120;
    if (origx > width) { origx = 0 - int(random(45)); }
    origy = -height;
    x1 = origx;
    y1 = origy;
    rd = int(random(255));
    bl = gr = rd;  // grey
    alph = 255;
    
    horYpos = 0;
    
    exponential = random(1);
  }
  
  void update() {
    count += step; 
    alph -= 2;
    if (alph < 0) { alph = 0; }
    // project x2,y2 from x1,y1, and draw a line to it
    x2 = x1 + count;
    float n = norm(x2, 0, width);
    y2 = pow(n, exponential);
    y2 *= (height * 2);
    // draw line to it
    if (count >= (width/2)) {
      strokeWeight(1);
      stroke(rd, gr, bl, alph);
      line(x1, y1, x2, y2);
    
      // mirror it
      line(width-x1, y1, width-x2, y2);
      
      // middle line
      horYpos += 6;
      line(width-x1, horYpos, x1, horYpos);
    }
    
    // reset for next update
    x1 = x2; y1 = y2; 
    if (x1 > width) { x1 = origx; }
    if (y1 > height) { y1 = origy; }
    // expiration  
    if (count >= life) { init(); }
  }
  
}

