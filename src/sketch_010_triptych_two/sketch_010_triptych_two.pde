// http://abandonedart.org/works/014_triptych8/_081012_triptych8.pde
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

int nextNum = 1;   // keeps track fo current figure
float xstart1, xstart2, xstart3;

//================================= init

void setup() {
  size(500,300);
  frameRate(30);
  smooth();
  sampleColour();
  clearBackground();
  xstart1 = 1 * width/4;
  xstart2 = 2 * width/4;
  xstart3 = 3 * width/4;
  create();
  create();
  create();
}


//================================= colour sampling

int numcols = 600; // 30x20
color[] colArr = new color[numcols];

void sampleColour() {
  PImage img;
  img = loadImage("snowpalette.jpg");
  image(img,0,0);
  int count = 0;
  for (int x=0; x < img.width; x++){
    for (int y=0; y < img.height; y++) {
      if (count < numcols) {
        color c = get(x,y);
        colArr[count] = c;
      }
      count++;
    }
  }  
}

void create() {
  float x1, x2, y1, y2;
  stroke(40, 20, 60, random(100)+100);
  strokeWeight(1);
  
  float xpos = xstart1;
  if (nextNum == 2) {
    xpos = xstart2;
  } else if (nextNum == 3) {
    xpos = xstart3;
  } 
  
  int ytop = 20;
  int ybottom = height - 20;
  
  float step = 5 + (random(4) - 4);
  
  // calc gap according to mouse position
  float xfactor = float(mouseX) / float(width);
  float yfactor = float(mouseY) / float(height); 
  println(xfactor + ": " + yfactor);
  
  float angle = 0;
  x1 = xpos; y1 = ytop;
  for (int ys = (ytop + nextNum -3); ys < ybottom; ys+= 3) {
    float sine = (sin(angle) * 100 * xfactor);
    x2 = xpos + sine;
    y2 = ys;
    
    strokeWeight(random(2));  // mm, blotches
    line(x1, y1, x2, y2);
    
    angle += PI/ (50 * yfactor);
    x1 = x2; y1 = y2;
  }
  
  x1 = xpos; y1 = ytop;
  
  // shortcut
  x1 = xpos + (random(20) - 10);
  
  if (x1 > width) { 
    x1 = 0; 
  } else if (x1 < 0) {
    x1 = width;
  } 
  if (nextNum == 1) {
    xstart1 = x1;
  } else if (nextNum == 2) {
    xstart2 = x1;
  } else if (nextNum == 3) {
    xstart3 = x1;
  } 
  
  // spiral noise
  spiralScratch(xpos, random(ybottom) + ytop);
  
  // move to next figure for next drawing
  nextNum++;
  if (nextNum > 3) { nextNum = 1; }
}

void spiralScratch(float xpos, float ypos) {
  float x1, x2, y1, y2;
  float step = 5 + (random(4) - 4);
  
    strokeWeight(random(3));  // mm, blotches
    
    color myCol = colArr[int(random(numcols))];
    
  stroke(myCol, 40);
  float radius = 5;
  float rad = radians(90);
  x1 = xpos;
  y1 = ypos;
  for (int x = 0; x < (360 * 4); x+= step) {
    radius += (1 + (random(4) - 2));
    
    rad = radians(x + step);
    x2 = xpos + (radius * cos(rad))  + (random(4) - 2);
    y2 = ypos + (radius * sin(rad))  + (random(4) - 2);
    // draw line to it
   line(x1, y1, x2, y2);
   x1 = x2; y1 = y2;
  } 
}

void clearBackground() {
  background(255);
  // graph paper
  int gap = 10;
  strokeWeight(1);
  stroke(140, 40);
  for (int x=0;x<width;x+=gap) {
     line(x, 0, x, height);
  }
  for (int y=0;y<height;y+=gap) {
    line(0, y, width, y);
  } 
}

//================================= frame loop

void draw() {
  create();
}

//================================= interaction

void mousePressed() { 
  clearBackground();
  xstart1 = 1 * width/4;
  xstart2 = 2 * width/4;
  xstart3 = 3 * width/4;
}

//================================= objects



  