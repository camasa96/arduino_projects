/**
 * Sine Wave
 * by Daniel Shiffman.  
 * 
 * Render a simple sine wave. 
 */

import processing.serial.*;
Serial port; 
float Value = 0;

int xspacing = 16;   // How far apart should each horizontal location be spaced
int w;              // Width of entire wave

float theta = 0.0;  // Start angle at 0
float amplitude;// = 75.0;  // Height of wave
float period = 500.0;  // How many pixels before the wave repeats
float dx;  // Value for incrementing X, a function of period and xspacing
float[] yvalues;  // Using an array to store height values for the wave
float[] yvalues1;  // Using an array to store height values for the wave

void setup() {
  size(640, 640);
  amplitude = height/8;
  w = width+16;
  dx = (TWO_PI / period) * xspacing;
  yvalues = new float[w/xspacing];
  yvalues1 = new float[w/xspacing];

  port = new Serial(this, "COM4", 115200);
  port.bufferUntil('\n');
}

void draw() {
  background(0);
  calcWave();
  renderWave();
}

void calcWave() {
  // Increment theta (try different values for 'angular velocity' here
  theta += 0.02;

  // For every x value, calculate a y value with sine function
  float x = theta;
  for (int i = 0; i < yvalues.length; i++) {
    yvalues[i] = sin(x)*amplitude;
    yvalues1[i] = sin(x+4*Value/1023)*amplitude;

    x+=dx;
  }
}

void renderWave() {
  noStroke();
  fill(255);
  ellipseMode(CENTER);
  // A simple way to draw the wave with an ellipse at each location
  for (int x = 0; x < yvalues.length; x++) {
    fill(255, 0, 0);
    ellipse(x*xspacing, height/4+yvalues[x], 16, 16);
    
    fill(0, 255, 0);
    ellipse(x*xspacing, 2*height/4+yvalues1[x], 16, 16);
    
    fill(255, 255, 0);
    ellipse(x*xspacing, 3*height/4+yvalues[x]+yvalues1[x], 16, 16);


    // ellipse(x*xspacing+Value, 2*height/4+yvalues[x], 16, 16);

    //    ellipse(x*xspacing+yvalues[x]/2, 3*height/4, 8, 8);
  }
}


void serialEvent (Serial port)
{
  try {
    Value = float(port.readStringUntil('\n'));
  } 
  catch (Exception e) {
    println("Connection...");
  }
}

void stop() {
  port.clear();
  port.stop();
} 

