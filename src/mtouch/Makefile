all: libmtouch.jnilib

mtouch.o: mtouch.c
	$(CC) -std=c99 -Wall -Werror -O3 -I/System/Library/Frameworks/JavaVM.framework/Headers -c -o $@ $<

libmtouch.jnilib: mtouch.o
	$(CC) -dynamiclib  -F/System/Library/PrivateFrameworks -framework MultitouchSupport -framework JavaVM -o $@ $<

clean:
	- rm -f *class *jnilib *.o