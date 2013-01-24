//import processing.opengl.*;

/**
 * 3D Lorenz Attractor
 * by Benjamin G Callam (3/22/04)
 *  <br> - Click adds a particle, mouse Y coord controlls zoom 
 *  <br> - Only using P3D cause were in a browser (use openGL)
 */

Lorenz[] elements;
int t = 20;

void setup()
{
  size(600, 600, P3D);
  frameRate(30);
  colorMode(HSB, 100);
  colorMode(RGB);
  perspective( PI*0.45, width/height, 1.0, 700 );
  //smooth();
  lights();
  directionalLight(126, 126, 126, 0, 0, -1);
  ambientLight(102, 102, 102);
  lightSpecular(200,200,200);
  randomSeed(0);
  pushMatrix();
  elements = new Lorenz[2];
  elements[0] = new Lorenz((random(-200,200)-50)/2, (random(-100,100)-25)/2, (random(-40,40))/2, null); 
  elements[1] = new Lorenz((random(-200,200)-50)/2, (random(-100,100)-25)/2, (random(-40,40))/2, null); 
}


void draw()
{
  background(0);

  directionalLight(700, 700, 700, 0, 0, -1);
  lightSpecular(255,255,225);
  ambientLight(255, 255, 255);
  colorMode(HSB, 100);

  //camera(width-mouseX*.7, height-mouseY*.7, height-(mouseX/(mouseY+1))*.7, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0);
  camera(elements[elements.length-1].x0*10, elements[elements.length-1].y0*10, (elements[elements.length-1].z0*10)+(height-mouseY)*2, elements[1].x0, elements[1].y0, elements[1].z0, 0.0, 0.0, -1.0);
  for(int i =0;i < elements.length; i++) {
    elements[i].display();
    elements[i].evaluateTime();
    elements[i] = elements[i].updateLorenz() ;
  }

  colorMode(RGB);
  noFill();
  stroke(255,255,255);
  box(500);




}

void mousePressed()  {
  elements = (Lorenz[])append(elements, (new Lorenz((random(-200,200)-50)/2, (random(-100,100)-25)/2, (random(-40,40))/2, null))) ; 
}

class Lorenz
{
  float x0, x1; 
  float y0, y1; 
  float z0, z1; 
  // Lorenz constants
  float h = 0.01;
  float a = 10.0;
  float b = 28.0;
  float c = 8.0 / 3.0;
  // float n = 0;

  // Lifeperiod of sphere
  float time;
  float timeOrigin;

  // The child
  Lorenz child = null;

  // iterative construction function
  Lorenz(float xPos, float yPos, float zPos, Lorenz chld) {
    x0 = xPos;
    y0 = yPos;
    z0 = zPos;
    child = chld;
    time = t;
    timeOrigin = t;

    // Calculate next element
    x1=x0+h*a*(y0-x0);
    y1=y0+h*(x0*(b-z0)-y0);
    z1=z0+h*(x0*y0-c*z0);
  }

  Lorenz updateLorenz(){
    return (new Lorenz(x1,y1,z1,this));
  }

  // If time is expired, then return true
  boolean evaluateTime () {
    // see if the child is dead
    if( child != null){
      if(child.evaluateTime()) { 
        child = null;
      } 
    }
    time--;
    if(time<1)
      return true;
    else
      return false;
  }

  void display() {
    noStroke();
    pushMatrix();
    float currentTime = (time/timeOrigin);
    //stroke(currentTime/10,currentTime/6,currentTime/2,(time/timeOrigin)/2);
    fill(255-(255*(time/timeOrigin)),255-(255*(time/timeOrigin)),255-(255*(time/timeOrigin)),((time/timeOrigin)*255/4));
    //fill(currentTime/5,currentTime/3,currentTime,(time/timeOrigin));
    int spacer = 10;
    translate(y0*spacer, x0*spacer, (z0*spacer)/2);
    sphere(((time/timeOrigin)*20)+10);
    popMatrix();

    if(child!=null){    
      child.display();
    }
  }
}
