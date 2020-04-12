// https://web.archive.org/web/20170901150100/http://abandonedart.org/?p=843
// July 2010
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



//===================================================================== libs

import traer.physics.*;

//===================================================================== 

// DISPLAY OPTIONS
Boolean _autoRotate = false;
color _backGroundColour = color(0, 0, 0);

// THE ENVIRONMENT
float _gravity = 0.01;
float _drag = 0.05;

// THE FIGURE
int _figureHeight = 200;
int _figureRad = 100;
color _figureColour = color(255, 255, 255, 150);

// THE CLOTH
float _springiness = 0.25;
float _damping = 0.01;

//===================================================================== 

// objects
ClothMan _clothman;

// view
float _xView, _yView, _zView;
float _xRotate, _yRotate, _zRotate;

// physics
ParticleSystem _physics;

//===================================================================== init

void setup() {
  size(500, 300, P3D);
  initViewPoint();
  // smooth();
  _physics = new ParticleSystem(_gravity, _drag);
  _physics.setGravity(0, 0, -_gravity);
  
  _clothman = new ClothMan();
}

void draw() {
  _physics.tick();
  _clothman.updateMe();
  
  background(_backGroundColour);
  pushMatrix();
  translateViewPoint();
  _clothman.drawMe();
  popMatrix();
}

void initViewPoint() {
  _xView = width/2;
  _yView = height/2;
  _zView = -80;
  _xRotate = radians(75);
  _yRotate = 0;
  _zRotate = 0;
}

void translateViewPoint() {  
  translate(_xView, _yView, _zView);
  rotateX(_xRotate);
  rotateY(_yRotate);
  if (_autoRotate) {
    rotateZ(frameCount * 0.01);
  } else {
    rotateZ(_zRotate);
  }
}

//===================================================================== mouse interaction

float _lastDragY = 0;
float _lastDragX = 0;
float _startDragX = 0;
float _startDragY = 0;
String _selected;


void mousePressed() { 
  _startDragX = mouseX;
  _startDragY = mouseY;
  _lastDragX = _startDragX;
  _lastDragY = _startDragY;
  _selected = "top";
  if (mouseY > height/2) { _selected = "bottom"; }
}


void mouseDragged() {
  if (_selected == "top") {
    _clothman.setTopZ(_lastDragY - mouseY);
  } else {
    _clothman.setBottomZ(_lastDragY - mouseY);
  }
  _yRotate += (mouseX - _lastDragX)/100;
  _lastDragX = mouseX;
  _lastDragY = mouseY;
}

    //======================================== OBJECTS
   

class PointObj {
  float x, y, z;
  
  PointObj(float ex, float why, float zed) {
    x = ex;
    y = why; 
    z = zed;
  }
  
} 

class ClothMan {
  
    private int myLength, myRad;
    private color myCol;
    private int topZ, bottomZ;
    
    private int circumSteps = 45;
    private int lenSteps = 30;
    private Particle[][] particles;
    
    private float radNoise;
    private float xWobble = 0;
    
    //======================================== init / debug
    
    ClothMan () {
      myLength = _figureHeight;
      topZ = myLength;
      bottomZ = 0;
      myRad = _figureRad;
      myCol = _figureColour;
      
      radNoise = random(10);
      
      particles = new Particle[circumSteps][lenSteps];
      float angStep = 360 / circumSteps;
      float lenStep = myLength / (lenSteps - 1);
      float ang = 0;
      for (int circ = 0; circ < circumSteps; circ++) {
        float radian = radians(ang);
        float xpoint = 0 + (myRad * cos(radian));
        float ypoint = 0 + (myRad * sin(radian));
        float zpoint = 0;
        for (int zed = 0; zed < lenSteps; zed++) {
            particles[circ][zed] = _physics.makeParticle(0.2, xpoint, ypoint, zpoint);  // mass, x, y, z
            if (zed > 0) {
              _physics.makeSpring(particles[circ][zed - 1], particles[circ][zed], _springiness, _damping, lenStep);
            } 
            zpoint += lenStep;
        }
        ang += angStep;
      }
      for (int zed = 0; zed < lenSteps; zed++) {
        Particle p1 = particles[circumSteps - 1][zed];
        Particle p2 = particles[0][zed];
        float distApart = dist( p1.position().x(), p1.position().y(), p1.position().z(), 
                                p2.position().x(), p2.position().y(), p2.position().z());
        _physics.makeSpring(p2, p1, _springiness, _damping, distApart);
        for (int circ = 1; circ < circumSteps; circ++) {
          p1 = particles[circ - 1][zed];
          p2 = particles[circ][zed];
          distApart = dist( p1.position().x(), p1.position().y(), p1.position().z(), 
                            p2.position().x(), p2.position().y(), p2.position().z());
          _physics.makeSpring(p2, p1, _springiness, _damping, distApart);
        }
      }  
      
      setRingZ(0, topZ);
      setRingZ(lenSteps-1, bottomZ);
    }
    
    //======================================== drawing
    
    public void drawMe() {
      stroke(myCol);
      noFill();
      
      
      // draw verticals
      for (int circ = 0; circ < circumSteps; circ++) {
        int lastCirc = circ -1;
        if (lastCirc < 0) { lastCirc = circumSteps-1; }
        beginShape(TRIANGLE_STRIP);
        vertex(particles[circ][0].position().x(), 
                    particles[circ][0].position().y(), 
                    particles[circ][0].position().z());
        for (int zed = 0; zed < lenSteps; zed++) {
          vertex(particles[lastCirc][zed].position().x(), 
                      particles[lastCirc][zed].position().y(), 
                      particles[lastCirc][zed].position().z());
          vertex(particles[circ][zed].position().x(), 
                      particles[circ][zed].position().y(), 
                      particles[circ][zed].position().z());
        }
        vertex(particles[circ][lenSteps-1].position().x(), 
                    particles[circ][lenSteps-1].position().y(), 
                    particles[circ][lenSteps-1].position().z());
        endShape();
      }  
      
      // draw horizontals
      for (int zed = 0; zed < lenSteps; zed++) {
        if ((zed == 0) || (zed == lenSteps-1)) {
        beginShape();
        curveVertex(particles[0][zed].position().x(), 
                    particles[0][zed].position().y(), 
                    particles[0][zed].position().z());
        for (int circ = 0; circ < circumSteps; circ++) {
          curveVertex(particles[circ][zed].position().x(), 
                      particles[circ][zed].position().y(), 
                      particles[circ][zed].position().z());
        }
        curveVertex(particles[0][zed].position().x(), 
                    particles[0][zed].position().y(), 
                    particles[0][zed].position().z());
        curveVertex(particles[0][zed].position().x(), 
                    particles[0][zed].position().y(), 
                    particles[0][zed].position().z());
        endShape();
      }
      }  
  
    }
    
    
    //======================================== animation
    
    private void updateMe() {
      float angStep = 360 / circumSteps;
      float ang = 0;
      
      radNoise += 0.1;
      xWobble = 0;
      float thisRad = myRad + (noise(radNoise) * 160) - 80;
      
      int variance = 100;
      
      float waverStart = radNoise;
      
      // wobble top and bottom
      for (int circ = 0; circ < circumSteps; circ++) {
        float radian = radians(ang);
        waverStart += 0.8;
        float rad = thisRad + (noise(waverStart) * variance);
        float xpoint = xWobble + (rad * cos(radian));
        float ypoint = 0 + (rad * sin(radian));
        
        particles[circ][0].position().set(xpoint, ypoint, particles[circ][0].position().z()); 
        particles[circ][lenSteps-1].position().set(xpoint, ypoint, particles[circ][lenSteps-1].position().z()); 
        
        ang += angStep;
      }
    }
    
    //======================================== interaction
    
    public void setTopZ(float zChange) {
      topZ += int(zChange);
      setRingZ(0, topZ);
    }
    
    public void setBottomZ(float zChange) {
      bottomZ += int(zChange);
      setRingZ(lenSteps-1, bottomZ);
    }
    
    private void setRingZ(int rank, int zed) {
      float angStep = 360 / circumSteps;
      float ang = 0;
      float zpoint = zed;
      float thisRad = myRad - 100;
      
      for (int circ = 0; circ < circumSteps; circ++) {
        float radian = radians(ang);
        float xpoint = 0 + (thisRad * cos(radian));
        float ypoint = 0 + (thisRad * sin(radian));
        particles[circ][rank].position().set(xpoint, ypoint, zpoint); 
        particles[circ][rank].makeFixed();
        ang += angStep;
      }
    }
    
}
