all: libmtouch.jnilib

CFLAGS += -std=c99 -Wall -Werror -O3
CFLAGS += -arch i386 -arch x86_64

mtouch.o: mtouch.c
	$(CC) $(CFLAGS)  -I/System/Library/Frameworks/JavaVM.framework/Headers -c -o $@ $<

libmtouch.jnilib: mtouch.o
	$(CC) $(CFLAGS) -dynamiclib  -F/System/Library/PrivateFrameworks -framework MultitouchSupport -framework JavaVM -o $@ $<

clean:
	- rm -f *class *jnilib *.o