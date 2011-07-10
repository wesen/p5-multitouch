Apple MultiTouch Library for processing.org
===========================================

INSTALLATION
------------

Use ant to build the dist directory:

```
$ ant dist
```

Copy the dist/mtouch folder to your Processing folder.

Usage
-----

```java
import mtouch.*;

float f1x, f1y;
float f2x, f2y;

public void onFingerMove(int finger, float x, float y) {
  if (finger == 0) {
    f1x = x;
    f1y = 1.0 - y;
  } else {
    f2x = x;
    f2y = 1.0 - y;
  }
}


void setup() {
  MultiTouch.registerObject(this);
  MultiTouch.startMultiTouch();
  size(400, 400);
  frameRate(20);
}

void draw() {
  background(0);
  fill(255, 0, 0);
  noStroke();
  rect(f1x * width, f1y * height, (f2x - f1x) * width, (f2y - f1y) * height);
}
```