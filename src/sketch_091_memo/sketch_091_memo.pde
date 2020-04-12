// https://web.archive.org/web/20170826194404/http://abandonedart.org/works/491_memo/fluids_5_4.pde
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



// note that the msafluid library and the bits of memo's code I have reworked
// are covered by a BSD License. See:
// http://www.opensource.org/licenses/bsd-license.php
// http://memo.tv/msafluid_for_processing



import msafluid.*;
 
final float FLUID_WIDTH = 250;
 
float invWidth, invHeight;    // inverse of screen dimensions
float aspectRatio, aspectRatio2;
 
MSAFluidSolver2D fluidSolver;
 
PImage imgFluid;

float lastX = 999;
float lastY;
float lastX1, lastY1;
float angle, centreX, centreY, thisRadius, angChange, step;

int numSegs;
int startF;

 
void setup() {
    background(255);
    size(500, 300);    
    
    invWidth = 1.0f/width;
    invHeight = 1.0f/height;
    aspectRatio = width * invHeight;
    aspectRatio2 = aspectRatio * aspectRatio;
   
   launch();
}

void launch() {
    fluidSolver = new MSAFluidSolver2D((int)(FLUID_WIDTH), (int)(FLUID_WIDTH * height/width));
    fluidSolver.enableRGB(true).setFadeSpeed(0.001).setDeltaT(0.5).setVisc(0.00005);
    
    startF = int(random(255));
    imgFluid = createImage(fluidSolver.getWidth(), fluidSolver.getHeight(), RGB);
    
    angle = 0;
    angChange = 5;
    centreX = width/2; 
    centreY = height/2;
    thisRadius = 10;
}

void mousePressed() {
    launch();
}
 

void draw() {
    fluidSolver.update();
    for(int i=0; i<fluidSolver.getNumCells(); i++) {
        int d = 5;
        imgFluid.pixels[i] = color(fluidSolver.r[i] * d, fluidSolver.g[i] * d, fluidSolver.b[i] * d);
    }  
    imgFluid.updatePixels();//   fastblur(imgFluid, 2);
    image(imgFluid, 0, 0, width, height);
    filter(INVERT);
    
    angle += angChange;
    if ((angle > 720) || (angle < -720)) { 
      numSegs = int(random(5)) + 1;
      step = 360 / numSegs; 
      angChange = random(5) + 10;
      if (angle > 720) { angChange *= -1; }
      angle = 0;
      thisRadius = random(200) + 10;
    }
    float rad = radians(angle);
    float rad1 = radians(angle + 180);
    float newX = centreX + (thisRadius * cos(rad));
    float newY = centreY + (thisRadius * sin(rad));
    float newX1 = centreX + (thisRadius * cos(rad1));
    float newY1 = centreY + (thisRadius * sin(rad1));
    if (lastX != 999) {
      addForce(newX * invWidth, newY * invHeight, (newX - lastX)/6, (newY - lastY)/6);
      addForce(newX1 * invWidth, newY1 * invHeight, (newX1 - lastX1)/6, (newY1 - lastY1)/6);
    }
    lastX = newX;
    lastY = newY;
    lastX1 = newX1;
    lastY1 = newY1;
}
 
 
// add force and dye to fluid, and create particles
void addForce(float x, float y, float dx, float dy) {
    float speed = dx * dx  + dy * dy * aspectRatio2;    // balance the x and y components of speed with the screen aspect ratio
 
    if(speed > 0) {
        if(x<0) x = 0; 
        else if(x>1) x = 1;
        if(y<0) y = 0; 
        else if(y>1) y = 1;
 
        float colorMult = 5;
        float velocityMult = 30.0f;
 
        int index = fluidSolver.getIndexForNormalizedPosition(x, y);
 
        color drawColor;
 
        colorMode(HSB, 360, 1, 1);
        float hue = ((x + y) * 180 + frameCount + startF) % 360;
        drawColor = color(hue, 1, 1);
        colorMode(RGB, 1);  
        fluidSolver.rOld[index]  += red(drawColor) * colorMult;
        fluidSolver.gOld[index]  += green(drawColor) * colorMult;
        fluidSolver.bOld[index]  += blue(drawColor) * colorMult;
        fluidSolver.uOld[index] += dx * velocityMult;
        fluidSolver.vOld[index] += dy * velocityMult;
    }
}