/*
 * Multitouch wrapper for p5
 *
 * After code by http://www.steike.com/code/
 * (c) Manuel Odendahl - wesen@ruinwesen.com
 */

#include <math.h>
#include <unistd.h>
#include <CoreFoundation/CoreFoundation.h>
#include <jni.h>
#include "MultiTouch.h"

typedef struct { float x,y; } mtPoint;
typedef struct { mtPoint pos,vel; } mtReadout;

typedef struct {
  int frame;
  double timestamp;
  int identifier, state, foo3, foo4;
  mtReadout normalized;
  float size;
  int zero1;
  float angle, majorAxis, minorAxis; // ellipsoid
  mtReadout mm;
  int zero2[2];
  float unk2;
} Finger;

typedef void *MTDeviceRef;
typedef int (*MTContactCallbackFunction)(int,Finger*,int,double,int);

MTDeviceRef MTDeviceCreateDefault();
void MTRegisterContactFrameCallback(MTDeviceRef, MTContactCallbackFunction);
void MTDeviceStart(MTDeviceRef, int); // thanks comex
void MTDeviceStop(MTDeviceRef);

/***************************************************************************
 *
 * JNI calls
 *
 ***************************************************************************/

static jclass cls;
static jmethodID mid;

#define MT_CLASS "MultiTouch"
#define MT_METHOD "onFingerMove"
#define MT_SIG "(IFF)V"

static MTDeviceRef mtouch_dev;
static bool mtouch_started = false;
static JavaVM *jvm = NULL;


int callback(int device, Finger *data, int nFingers, double timestamp, int frame) {
  JNIEnv *env = NULL;

  int res = (*jvm)->AttachCurrentThread(jvm, (void **)&env, NULL);

  if (res == 0) {
    if (cls != NULL) {
      if (mid) {
        for (int i=0; i<nFingers; i++) {
          Finger *f = &data[i];
          (*env)->CallStaticVoidMethod(env, cls, mid,
                                       i,
                                       f->normalized.pos.x,
                                       f->normalized.pos.y);
#ifdef DEBUG
          printf("Frame %7d: Angle %6.2f, ellipse %6.3f x%6.3f; "
                 "position (%6.3f,%6.3f) vel (%6.3f,%6.3f) "
                 "ID %d, state %d [%d %d?] size %6.3f, %6.3f?\n",
                 f->frame,
                 f->angle * 90 / atan2(1,0),
                 f->majorAxis,
                 f->minorAxis,
                 f->normalized.pos.x,
                 f->normalized.pos.y,
                 f->normalized.vel.x,
                 f->normalized.vel.y,
                 f->identifier, f->state, f->foo3, f->foo4,
                 f->size, f->unk2);
#endif
        }
      }
    }
    res = (*jvm)->DetachCurrentThread(jvm);
  }
  return 0;
}

JNIEXPORT void JNICALL Java_MultiTouch_startMultiTouch(JNIEnv *env, jclass obj) {
  if (mtouch_started) {
    printf("mtouch already started\n");
    return;
  }
  mtouch_dev = MTDeviceCreateDefault();
  MTRegisterContactFrameCallback(mtouch_dev, callback);
  MTDeviceStart(mtouch_dev, 0);
  mtouch_started = true;
}

JNIEXPORT void JNICALL Java_MultiTouch_stopMultiTouch(JNIEnv *env, jclass obj) {
  if (!mtouch_started) {
    printf("mtouch not started\n");
    return;
  }
  MTDeviceStop(mtouch_dev);
  mtouch_dev = NULL;
  mtouch_started = false;
}

JNIEXPORT void JNICALL Java_MultiTouch_registerListener(JNIEnv *env, jclass obj) {
  if (jvm == NULL) {
    (*env)->GetJavaVM(env, &jvm);
  }

  cls = (*env)->FindClass(env, MT_CLASS);

  /* make new global ref for callback thread */
  cls = (*env)->NewGlobalRef(env, cls);
  if (cls == NULL) {
    printf("Java class %s not found\n", MT_CLASS);
    goto error;
  } else {
    mid = (*env)->GetStaticMethodID(env, cls, MT_METHOD, MT_SIG);
    if (mid == NULL) {
      printf("Java callback method %s not found!\n", MT_METHOD);
      goto error;
    }
  }

 error:
  return;
}

JNIEXPORT void JNICALL Java_MultiTouch_unregisterListener(JNIEnv *env, jclass obj) {
  if (!mtouch_started) {
    printf("mtouch not started\n");
    return;
  }
  MTDeviceStop(mtouch_dev);
  mtouch_dev = NULL;
  mtouch_started = false;
}
