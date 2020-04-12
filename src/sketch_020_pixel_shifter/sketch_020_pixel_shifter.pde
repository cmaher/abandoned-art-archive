// http://abandonedart.org/works/121_pixelshifter/_081207_pixelshiftCol.pde
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

int num = 5;
int bgCol = 0;

float rot;

//================================= init

void setup() {
  size(500, 300);
  smooth(); 
  frameRate(60);
  
  rot = 0;
  
  clearBackground();
}

void clearBackground() {
  background(bgCol);
}

//================================= frame loop

int xdest = 0;
int ydest = 0;

void draw() {
  rot += PI/24;
  
  translate(width/2, height/2);
  rotate(rot);
  
  int xstep;
  if (xdest == 0) {
    xstep = 0; 
    xdest = int(random(width) - (width/2));
  } else if (xdest > 0) {   
    xstep = 1; 
    xdest--;
  } else {
    xstep = -1; 
    xdest++;
  }
  
  int ystep;
  if (ydest == 0) {
    ystep = 0; 
    ydest = int(random(height) - (height/2));
  } else if (ydest > 0) {   
    ystep = 1; 
    ydest--;
  } else {
    ystep = -1; 
    ydest++;
  }
   
  drawStuff();
  // pixelShift(-2,-2);
  pixelShift(xstep,ystep);
}

void drawStuff() {
  fill(255);
  stroke(0,0,0);
  rect(0,0,50,50);
  noStroke();
  fill(0,0,255);
  rect(2,2,46,46);
  // stroke(255,0,0);
  fill(255,0,0);
  rect(4,4,42,42);
}

void pixelShift(int xshift, int yshift) {
  // copy screen into an array
  color transArr[] = new color[width * height];
  
  loadPixels();
  arraycopy(pixels, transArr);
  
   for (int y=1; y < height; y++) {
      for (int x=1; x < width; x++){
        
        if ((x+xshift < width) && (x+xshift > 0)) {
          if ((y+yshift < height) && (y+yshift > 0)) {
            pixels[x + (y*width)] = transArr[(x+xshift)+ ((y+yshift)*width)];
          }
        }
        
      }
    }
  updatePixels();
  
}

//================================= interaction

void mousePressed() { 
  clearBackground();
}


//================================= objects

