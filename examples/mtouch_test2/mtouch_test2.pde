import mtouch.*;

float xs[] = new float[8];
float ys[] = new float[8];
color colors[] = new color[8];

public void onFingerMove(int finger, float x, float y) {
  if (finger < colors.length) {
    xs[finger] = x;
    ys[finger] = y;
  }
}


void setup() {
  MultiTouch.registerObject(this);
  MultiTouch.startMultiTouch();
  size(400, 400);
  frameRate(20);
  
  colors[0] = color(255, 0, 0);
  colors[1] = color(0, 255, 0);
  colors[2] = color(0, 0, 255);
  colors[3] = color(255, 0, 255);
  colors[4] = color(0, 255, 255);
  colors[5] = color(127, 127, 127);
  colors[6] = color(255, 255, 255);
  colors[7] = color(255, 255, 0);
}

void draw() {
  background(0);
  noStroke();
  for (int i = 0; i < colors.length; i++) {
    float fx = xs[i] * width;
    float fy = ys[i] * height;
    fill(colors[i]);
    ellipse(fx - 10, fy - 10, 20, 20);
  }
}

