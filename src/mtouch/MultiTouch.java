/*
 * Multitouch wrapper for p5
 *
 * After code by http://www.steike.com/code/
 * (c) Manuel Odendahl - wesen@ruinwesen.com
 */

package mtouch;

public class MultiTouch {
  static {
    System.loadLibrary("mtouch");
  }

  public static native void startMultiTouch();
  public static native void stopMultiTouch();

  public static native void registerListener();
  public static native void unregisterListener();

  public static native void registerObject(Object obj);

  public static class CallbackObject {
    public CallbackObject() {
    }

    public void onFingerMove(int finger, float x, float y) {
      System.out.println("finger: " + finger + " at " + x + ", " + y);
    }
  };

  public static void main(String args[]) {
    CallbackObject obj = new CallbackObject();
    
    registerObject(obj);
    startMultiTouch();

    try { while(true) { Thread.sleep(5000); } } catch (Exception e) {};
    
    stopMultiTouch();
  }
}