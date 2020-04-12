// https://web.archive.org/web/20100405113732/http://abandonedart.org/works/010_snakediver/snake.pde
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
Particle[] pArr;

//================================= init

void setup() {
  size(500, 300);
  smooth(); 
  frameRate(60);
  
  strokeWeight(5);
  stroke(255, 100);
  
  pArr = new Particle[num];
  for (int i=0;i<num;i++) {
    pArr[i] = new Particle(i);
  }
}


//================================= frame loop

void draw() {
  fill(0, 2);
  rect(0, 0, width, height);
  
  for (int i=0;i<num;i++) {
    pArr[i].update();
  }
  
}




//================================= objects

class Particle {
  int id;  
  
  float ex, why;           
  float pct = 0.0;
  float beginX, beginY; 
  float endX,  endY;    
  float distX,  distY;
  float exponent = 4;   
  float step = 0.01;   

  float[] x = new float[30];
  float[] y = new float[30];
  float segLength = 15;
  
  Particle (int num) {
    id = num;
    ex = random(width * 2) - (width/2);
    why = random(height * 2) - (height/2);
    init();
  }
  
  void trace(String str) {
    println("Particle " + id + ": " + str);
  }
  
  void init() {
    beginX = ex;
    beginY = why;
    endX = random(width * 2) - (width/2);
    endY = random(height * 2) - (height/2);
    distX = endX - beginX;
    distY = endY - beginY;
    pct = 0.0;
  }
  
  void update() {
    
    pct += step;
    if (pct < 1.0) {
      ex = beginX + (pct * distX);
      why = beginY + (pow(pct, exponent) * distY);
    } else {
      init();
    }
  
    dragSegment(0, ex, why);
    for(int i=0; i<x.length-1; i++) {
      dragSegment(i+1, x[i], y[i]);
    }
  }
  
  void dragSegment(int i, float xin, float yin) {
    float dx = xin - x[i];
    float dy = yin - y[i];
    float angle = atan2(dy, dx);  
    x[i] = xin - cos(angle) * segLength;
    y[i] = yin - sin(angle) * segLength;
    segment(x[i], y[i], angle);
  }
  
  void segment(float x, float y, float a) {
    pushMatrix();
    translate(x, y);
    rotate(a);
    line(0, 0, segLength, 0);
    popMatrix();
  }
}





