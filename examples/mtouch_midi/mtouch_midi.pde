import rwmidi.*;
import mtouch.*;

/* Testprogramm das Mausklicks nach MIDI CC konvertier. */
MidiOutput output;

// Definition fuer die MIDI Zuweisungen
int MIDI_KANAL = 0;

boolean sendX = true;
boolean sendY = true;

/* Arrays zum Speichern der Finger positionen */
float xs[] = new float[8];
int p_x_cc[] = new int[8];
float ys[] = new float[8];
int p_y_cc[] = new int[8];
color colors[] = new color[4];

/* diese funktion wird immer aufgerufen wenn ein finger sich auf dem trackpad bewegt. */
public void onFingerMove(int finger, float x, float y) {
  if (finger < xs.length) {
    xs[finger] = x;
    ys[finger] = y;

    if (sendX) {
      /* mit dem vorigen CC vergleich, und nur dann schicken, wenn er sich auch tatsaechlich veraendert hat. */
      int x_cc = round(map(xs[finger], 0, 1, 0, 127));
      if (x_cc != p_x_cc[finger]) {
        output.sendController(MIDI_KANAL, finger * 2 + 1, x_cc);
        p_x_cc[finger] = x_cc;
      }
    }
    if (sendY) {
      int y_cc = round(map(ys[finger], 0, 1, 0, 127));
      if (y_cc != p_y_cc[finger]) {
        output.sendController(MIDI_KANAL, finger * 2 + 2, y_cc);
        p_y_cc[finger] = y_cc;
      }
    }
  }
}

void keyPressed() {
  switch (key) {
  case 'x':
    sendX = !sendX;
    if (sendX) {
      println("X aktiviert");
    } 
    else {
      println("X deaktiviert");
    }
    break;

  case 'y':
    sendY = !sendY;
    if (sendY) {
      println("Y aktiviert");
    } 
    else {
      println("Y deaktiviert");
    }
    break;
  }
}

void setup() {
  MultiTouch.registerObject(this);
  MultiTouch.startMultiTouch();

  // output objekt zum senden von MIDI noten erstellen.
  // in diesem Fall wird das erste (index 0) Geraet geoeffnet
  output = RWMidi.getOutputDevices()[0].createOutput();

  size(800, 200);
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

