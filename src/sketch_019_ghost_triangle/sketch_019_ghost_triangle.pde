// http://abandonedart.org/works/119_ghosttriangle/_081207_fractalicious10.pde
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

int _maxlevels = 4;
float _strutFactor;  
float _noiseoff = 0.0;     
Branch[] _branchArr = {};   // stores branches, so drawing can be separated
HPoint[] _pointArr = {};    // initial points

int offset = 0;
int sqlen = 100;

float midx, midy;
int topx, topy;

int numsides = 3;
  
//================================= init

void setup() {
  size(500, 300);
  smooth(); 
  frameRate(12);
  background(0);
  
  midx = width / 2;
  midy = height / 2;
  topx = int(midx-(sqlen/2));
  topy = int(midy-(sqlen/2));
  
  restart();
}

void restart() {
  _noiseoff = random(1);
  rotateStartPoints();
  clearBackground();
  createTree();
}


void addPoint(float x, float y) {
    HPoint hp = new HPoint(x, y);
    _pointArr = (HPoint[])append(_pointArr, hp);
}

void clearBackground() {
  fill(0, 2);
  rect(0,0,width, height);
}

void rotateStartPoints() {
  
  offset++;
  if (offset > (360/numsides)) { offset = 0; }
  
  _pointArr = (HPoint[])expand(_pointArr, 0);
  int radius = 150;
  for (float x = 0; x < 360; x+= (360/numsides)) {
      float rad = radians(x + offset);
      float x1 = midx + (radius * cos(rad));
      float y1 = midy + (radius * sin(rad));
      addPoint(x1, y1);
    }  
}

void createTree() {
   _noiseoff = _noiseoff + .01;
   _strutFactor = (noise(_noiseoff) * 2) - 1;
   
   _branchArr = (Branch[])expand(_branchArr, 0);
   Branch root = new Branch(0, 1, _pointArr);
  
   for (int i = 0; i < _branchArr.length; i++) {
     Branch thisB = _branchArr[i];
     thisB.drawme();
   } 
   
}

//================================= frame loop

void draw() {
 clearBackground();
 createTree();
}

//================================= interaction

void mousePressed() { 
  restart();
}


//================================= objects



class HPoint {
  float x, y;
  HPoint(float ex, float why) {
    x = ex; y = why;
  }
}


class Branch {
  int level;
  int num;
  HPoint[] hpArr = {};    // points of the shape
  HPoint[] mpArr = {};    // midpoints of each side
  HPoint[] ppArr = {};    // end of each projected strut
  
  Branch (int lev, int n, HPoint[] arr) {
    level = lev;  num = n;
    hpArr = arr;
    init();
  }
  
  void init() {
    
   for (int i = 0; i < hpArr.length; i++) {
     int nexti = i+1;
     if (nexti == hpArr.length) { nexti = 0; }
     mpArr = (HPoint[])append(mpArr, calcMidPoint(hpArr[i], hpArr[nexti]));
   } 
   
   for (int j = 0; j < hpArr.length; j++) {
     
     int nextj = j+int(hpArr.length / 2)+1;
     
     if (nextj >= hpArr.length) { nextj -= hpArr.length; }
     ppArr = (HPoint[])append(ppArr, calcProjPoint(mpArr[j], hpArr[nextj]));
     
   } 
    
    _branchArr = (Branch[])append(_branchArr, this);
    
    if ((level+1) < _maxlevels) {
      Branch newbrCent = new Branch(level+1, 0, ppArr);
      
      for (int k = 0; k < hpArr.length; k++) {
       int nextk = k-1;
       if (nextk < 0) { nextk += hpArr.length; }
        HPoint[] npArr = {  ppArr[k], mpArr[k], hpArr[k], mpArr[nextk], ppArr[nextk] };
        Branch newbr = new Branch(level+1, k+1, npArr);
      }  
       
    }
    
  }
  
  
  void drawme() {
     stroke(255, level * 20);
   for (int k = 0; k< ppArr.length; k++) {
     int nextk = k+1;
     if (nextk == ppArr.length) { nextk = 0; }
     line(ppArr[k].x, ppArr[k].y, ppArr[nextk].x, ppArr[nextk].y);
   } 
    
  }
  
  
  
  HPoint calcMidPoint(HPoint end1, HPoint end2) {
    float mx, my;
    if (end1.x > end2.x) {
      mx = end2.x + ((end1.x - end2.x)/2);
    } else {
      mx = end1.x + ((end2.x - end1.x)/2);
    }
    if (end1.y > end2.y) {
      my = end2.y + ((end1.y - end2.y)/2);
    } else {
      my = end1.y + ((end2.y - end1.y)/2);
    }
    return new HPoint(mx, my);
  }
  
  HPoint calcProjPoint(HPoint mp, HPoint op) {
    float px, py;
    
    float adj, opp, hyp;    // triangle, opp = xdiff, adj = ydiff
    if (op.x > mp.x) { 
      opp = op.x - mp.x;
    } else {
      opp = mp.x - op.x; 
    }
    if (op.y > mp.y) {
      adj = op.y - mp.y;
    } else {
      adj = mp.y - op.y;
    }
    float angle = atan(opp/adj);
    float xfactor = sin(angle) * _strutFactor;
    float yfactor = cos(angle) * _strutFactor;
    if (op.x > mp.x) { 
      px = mp.x + (opp * xfactor);
    } else {
      px = mp.x - (opp * xfactor); 
    }
    if (op.y > mp.y) {
      py = mp.y + (adj * yfactor);
    } else {
      py = mp.y - (adj * yfactor);
    }  
    return new HPoint(px, py); 
    
    //return new HPoint(op.x, op.y);
  }
  
  
}