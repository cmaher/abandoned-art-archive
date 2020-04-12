// https://web.archive.org/web/20170901151619/http://abandonedart.org/works/007_interference/diagonals4.pde

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

int num = 20;
int scrwidth = 500;
int scrheight = 300;
Diagonals da, db;
int maxline = 60;

//================================= init

void setup() {
  size(scrwidth,scrheight);
  background(255);
  frameRate(30);
  smooth();
  // x, y, speed, thickness, grey
  da = new Diagonals();
  db = new Diagonals();
}

//================================= frame loop

void draw() {
  da.update();
  db.update();
}

//================================= interaction

void mousePressed() { 
  background(255);
}

//================================= objects

class Diagonals {
  int x, y, speed, thick, rd, gr, bl, alph, len;
  
  Diagonals () {
    init();
  }
  
  void init() {
    x = 0;
    y = int(random(100) - maxline) ; 
    speed = int(random(40) + 10);
    thick = int(random(10) + 2);
    
    // cycle colour and b/w
    if ((rd == 0) || (rd == 255)) {
      rd = int(random(255));
      gr = int(random(255));
      bl = int(random(255));
    } else {
      if (rd > 125) {
        rd=255; gr=255; bl=255;
      } else {
        rd=0; gr=0; bl=0;
      }
    }
    
    // alph = int(random(10) + 90);
    // alph = 100;
    len = int(random(maxline - 10) + 10);
  }
  
  void update() {
    strokeWeight(thick);
    stroke(rd, gr, bl);
    line(x, y, x, y-len);
    x = x + speed;
    if (x > scrwidth) { 
      x = -50; 
      y = y + 50;
      if (y > (scrheight + maxline)) { init(); }
    }
  }
  
}
