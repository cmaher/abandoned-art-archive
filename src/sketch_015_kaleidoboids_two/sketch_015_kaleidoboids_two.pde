// https://web.archive.org/web/20170628182812/http://abandonedart.org/works/115_kaleidoboids2/_081012_kaleidoboids2.pde
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

Flock flock;


//================================= init

void setup() {
  size(500,300);
  frameRate(12);
  smooth();
  sampleColour();
  launch(width/2,height/2);
}

void launch(float ex, float why) {
  background(0);
  flock = new Flock();
  for (int i = 0; i < 250; i++) {
    flock.addBoid(new Boid(new Vector3D(ex, why),2.0,0.05));
  }
}

//================================= colour sampling

int numcols = 600; // 30x20
color[] colArr = new color[numcols];

void sampleColour() {
  PImage img;
  img = loadImage("redpalette.png");
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

//================================= frame loop

void draw() {
  
  flock.run();
  kaleidoscope();
}

void kaleidoscope() {
  // top right, mirror top left in the x
  loadPixels();
  for (int yy = 0; yy < int(height/2)+1; yy++) {
    for (int x = int(width/2); x < width; x++) {
      pixels[x+(yy*width)] = pixels[(width-x)+(yy*width)];
    }
  }
  updatePixels();  
  // bottom, mirror top
  loadPixels();
  for (int yyy = int(height/2); yyy < height; yyy++) {
    for (int xx = 0; xx < width; xx++) {
      pixels[xx+(yyy*width)] = pixels[xx+( (height-yyy)*width )];
    }
  }
  updatePixels();
}




//================================= interaction

void mousePressed() {
  launch(mouseX, mouseY);
}





//================================= boids objects (c/o processing.org)

// Simple Vector class

class Vector3D {
  float x;
  float y;
  float z;

  Vector3D(float x_, float y_, float z_) {
    x = x_; 
    y = y_; 
    z = z_;
  }

  Vector3D(float x_, float y_) {
    x = x_; 
    y = y_; 
    z = 0f;
  }

  Vector3D() {
    x = 0f; 
    y = 0f; 
    z = 0f;
  }

  void setX(float x_) {
    x = x_;
  }

  void setY(float y_) {
    y = y_;
  }

  void setZ(float z_) {
    z = z_;
  }

  void setXY(float x_, float y_) {
    x = x_;
    y = y_;
  }

  void setXYZ(float x_, float y_, float z_) {
    x = x_;
    y = y_;
    z = z_;
  }

  void setXYZ(Vector3D v) {
    x = v.x;
    y = v.y;
    z = v.z;
  }
  float magnitude() {
    return (float) Math.sqrt(x*x + y*y + z*z);
  }

  Vector3D copy() {
    return new Vector3D(x,y,z);
  }

  Vector3D copy(Vector3D v) {
    return new Vector3D(v.x, v.y,v.z);
  }

  void add(Vector3D v) {
    x += v.x;
    y += v.y;
    z += v.z;
  }

  void sub(Vector3D v) {
    x -= v.x;
    y -= v.y;
    z -= v.z;
  }

  void mult(float n) {
    x *= n;
    y *= n;
    z *= n;
  }

  void div(float n) {
    x /= n;
    y /= n;
    z /= n;
  }

  /* float dot(Vector3D v) {
   //implement DOT product
   }*/

  /* Vector3D cross(Vector3D v) {
   //implement CROSS product
   }*/

  void normalize() {
    float m = magnitude();
    if (m > 0) {
      div(m);
    }
  }

  void limit(float max) {
    if (magnitude() > max) {
      normalize();
      mult(max);
    }
  }

  float heading2D() {
    float angle = (float) Math.atan2(-y, x);
    return -1*angle;
  }

  Vector3D add(Vector3D v1, Vector3D v2) {
    Vector3D v = new Vector3D(v1.x + v2.x,v1.y + v2.y, v1.z + v2.z);
    return v;
  }

  Vector3D sub(Vector3D v1, Vector3D v2) {
    Vector3D v = new Vector3D(v1.x - v2.x,v1.y - v2.y,v1.z - v2.z);
    return v;
  }

  Vector3D div(Vector3D v1, float n) {
    Vector3D v = new Vector3D(v1.x/n,v1.y/n,v1.z/n);
    return v;
  }

  Vector3D mult(Vector3D v1, float n) {
    Vector3D v = new Vector3D(v1.x*n,v1.y*n,v1.z*n);
    return v;
  }

  float distance (Vector3D v1, Vector3D v2) {
    float dx = v1.x - v2.x;
    float dy = v1.y - v2.y;
    float dz = v1.z - v2.z;
    return (float) Math.sqrt(dx*dx + dy*dy + dz*dz);
  }

  void display(float x, float y, float scayl) {
    pushMatrix();
    float arrowsize = 4;
    // Translate to location to render vector
    translate(x,y);
    stroke(255);
    // Call vector heading function to get direction (note that pointing up is a heading of 0) and rotate
    rotate(heading2D());
    // Calculate length of vector & scale it to be bigger or smaller if necessary
    float len = magnitude()*scayl;
    // Draw three lines to make an arrow (draw pointing up since we've rotate to the proper direction)
    line(0,0,len,0);
    line(len,0,len-arrowsize,+arrowsize/2);
    line(len,0,len-arrowsize,-arrowsize/2);
    popMatrix();
  } 

}




// The Boid class

class Boid {

  Vector3D loc, lastloc;
  Vector3D vel;
  Vector3D acc;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  
  int myAlpha, myCol;
  boolean wrapped = false;

  Boid(Vector3D l, float ms, float mf) {
    acc = new Vector3D(0,0);
    vel = new Vector3D(random(-1,1),random(-1,1));
    loc = l.copy();
    lastloc = l.copy();
    r = 20.0;
    maxspeed = ms;
    maxforce = mf;
    
    myAlpha = int(random(100) + 15);
    myCol = colArr[int(random(numcols))];
  }
  
  void run(ArrayList boids) {
    flock(boids);
    update();
    borders();
    render();
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList boids) {
    Vector3D sep = separate(boids);   // Separation
    Vector3D ali = align(boids);      // Alignment
    Vector3D coh = cohesion(boids);   // Cohesion
    // Arbitrarily weight these forces
    sep.mult(2.0);
    ali.mult(1.0);
    coh.mult(1.0);
    // Add the force vectors to acceleration
    acc.add(sep);
    acc.add(ali);
    acc.add(coh);
  }
  
  // Method to update location
  void update() {
    // Update velocity
    vel.add(acc);
    // Limit speed
    vel.limit(maxspeed);
    loc.add(vel);
    // Reset accelertion to 0 each cycle
    acc.setXYZ(0,0,0);
  }

  void seek(Vector3D target) {
    acc.add(steer(target,false));
  }
 
  void arrive(Vector3D target) {
    acc.add(steer(target,true));
  }

  // A method that calculates a steering vector towards a target
  // Takes a second argument, if true, it slows down as it approaches the target
  Vector3D steer(Vector3D target, boolean slowdown) {
    Vector3D steer;  // The steering vector
    Vector3D desired = target.sub(target,loc);  // A vector pointing from the location to the target
    float d = desired.magnitude(); // Distance from the target is the magnitude of the vector
    // If the distance is greater than 0, calc steering (otherwise return zero vector)
    if (d > 0) {
      // Normalize desired
      desired.normalize();
      // Two options for desired vector magnitude (1 -- based on distance, 2 -- maxspeed)
      if ((slowdown) && (d < 100.0)) desired.mult(maxspeed*(d/100.0)); // This damping is somewhat arbitrary
      else desired.mult(maxspeed);
      // Steering = Desired minus Velocity
      steer = target.sub(desired,vel);
      steer.limit(maxforce);  // Limit to maximum steering force
    } else {
      steer = new Vector3D(0,0);
    }
    return steer;
  }
  
  void render() {
    strokeWeight(random(4));  // mm, blotches
    stroke(myCol, myAlpha);
    if (!wrapped) {
      line(loc.x, loc.y, lastloc.x, lastloc.y);
    }
    lastloc = loc.copy();
  }
  
  // Wraparound
  void borders() {
    wrapped = false;
    if (loc.x < -r)  { 
       loc.x = width+r;
       wrapped = true;
    }
    if (loc.y < -r)  { 
       loc.y = height+r;
       wrapped = true;
    }
    if (loc.x > width+r)  { 
       loc.x = -r;
       wrapped = true;
    }
    if (loc.y > height+r)  { 
       loc.y = -r;
       wrapped = true;
    }
  }

  // Separation
  // Method checks for nearby boids and steers away
  Vector3D separate (ArrayList boids) {
    float desiredseparation = 25.0;
    Vector3D sum = new Vector3D(0,0,0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (int i = 0 ; i < boids.size(); i++) {
      Boid other = (Boid) boids.get(i);
      float d = loc.distance(loc,other.loc);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        Vector3D diff = loc.sub(loc,other.loc);
        diff.normalize();
        diff.div(d);        // Weight by distance
        sum.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      sum.div((float)count);
    }
    return sum;
  }
  
  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  Vector3D align (ArrayList boids) {
    float neighbordist = 50.0;
    Vector3D sum = new Vector3D(0,0,0);
    int count = 0;
    for (int i = 0 ; i < boids.size(); i++) {
      Boid other = (Boid) boids.get(i);
      float d = loc.distance(loc,other.loc);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.vel);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.limit(maxforce);
    }
    return sum;
  }

  // Cohesion
  // For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
  Vector3D cohesion (ArrayList boids) {
    float neighbordist = 50.0;
    Vector3D sum = new Vector3D(0,0,0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (int i = 0 ; i < boids.size(); i++) {
      Boid other = (Boid) boids.get(i);
      float d = loc.distance(loc,other.loc);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.loc); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      return steer(sum,false);  // Steer towards the location
    }
    return sum;
  }
}




// The Flock (a list of Boid objects)

class Flock {
  ArrayList boids; // An arraylist for all the boids

  Flock() {
    boids = new ArrayList(); // Initialize the arraylist
  }

  void run() {
    for (int i = 0; i < boids.size(); i++) {
      Boid b = (Boid) boids.get(i);  
      b.run(boids);  // Passing the entire list of boids to each boid individually
    }
  }

  void addBoid(Boid b) {
    boids.add(b);
  }

}
