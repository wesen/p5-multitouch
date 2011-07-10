import mtouch.*;

float xs[] = new float[8];
float ys[] = new float[8];
color colors[] = new color[4];

public void onFingerMove(int finger, float x, float y) {
  if (finger < xs.length) {
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
  colors[3] = color(255, 255, 0);
}

void draw() {
  background(0);
  noStroke();
  for (int i = 0; i < colors.length; i++) {
    float f1x = xs[i*2];
    float f2x = xs[i*2 + 1];
    float f1y = ys[i*2];
    float f2y = ys[i*2+1];
    fill(colors[i]);
    rect(f1x * width, f1y * height, (f2x - f1x) * width, (f2y - f1y) * height);
  }
}

