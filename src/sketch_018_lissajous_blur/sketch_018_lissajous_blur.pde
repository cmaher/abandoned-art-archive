// https://web.archive.org/web/20170622040109/http://abandonedart.org/works/118_lissajousblur/_081211_lissajous4.pde
// Dec 2008 
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


float _a, _b, _centx, _centy, _x, _y;
int _num = 12;
color _col;
float _noiseoff;
int _angle;

void setup()
{
  size(500, 300);
  smooth(); 
  frameRate(12);
  background(0);
  
  _centx = (width / 2);
  _centy = (height / 2);
  _noiseoff = random(1);
  
  _col = color(random(255), random(255), random(255));
  _angle = 1;
  
  restart();
}

void restart() {
   _noiseoff = _noiseoff + .001;
   _a = 4;
   _b = _a + (noise(_noiseoff) * 1) - 0.5;
   _angle++;
   if (_angle == 360) { _angle = 0; }
}


void clearBackground() {
  fill(0, 5);
  rect(0,0,width, height);
}

void draw() {
  clearBackground();
  
  translate(_centx, _centy);
  noFill();
  stroke(_col, 5);
  strokeWeight(6);
  beginShape();
  for (int i=0;i < 30; i++) {    
    _x = sin(_a * i + radians(_angle) + PI / 2) * _centx;  
    _y = sin(_b * i + radians(_angle)) * _centy;  
    curveVertex(_x, _y);
  }
  endShape();   
  
  restart();
}

//================================= interaction

void mousePressed() { 
  _noiseoff = random(1);
  _col = color(random(255), random(255), random(255));
}


//================================= objects
