//https://web.archive.org/web/20170831112414/http://abandonedart.org/works/499_meol/noiseplane6_5.pde
// Jun 2010 
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

float _noiseseed;
int _fade = 0;

//================================= init

void setup() {
  size(500, 300);
  smooth(); 
  background(0);
  
  restart();
}

float ystart, yrangenoiseseed, yrangenoise, yrange;
float yinc = 0.1;

void restart() {
  
  _noiseseed = random(10);
  println(_noiseseed);
  
  strokeWeight(0.5);
  stroke(255, 10);
  
  yrangenoiseseed = random(10);
  yrangenoise = yrangenoiseseed;
  yrange = 500 * (noise (yrangenoise));
  
  ystart = -yrange;
  
}

//================================= frame loop

void draw() {
  
  if (_fade > 0) {
  
    fill(0, 10);
    noStroke();
    rect(0,0,width,height);
    _fade--;
  }
  stroke(255, 15);
  noFill();
  
  translate(width/2, height/2);
  rotate(frameCount * 0.005);
    
    ystart += yinc;
  
    float thisNoise = _noiseseed;
    float lastx = -1.0;
    float lasty = -1.0;
    
    for (int x = 0; x < width; x++) {
      thisNoise += 0.01;
      float y = ystart + (noise(thisNoise) * yrange);
      if (lastx != -1.0) {
        line(lasty, lastx, y, x);
        line(lastx, lasty, x, y);
      }
      lastx = x;
      lasty = y; 
    }
    
    yrangenoise += 0.0003;
    yrange = 500 * (noise (yrangenoise));
    
    if (ystart > 0) { 
      restart();
      _fade = 50;
    }
    
}


//================================= interaction

void mousePressed() { 
  restart();
}