CC = gcc
WARN = -Wall

OUT = $(LIBOUT) $(TESTOUT)
LIBOUT = triangle.dylib
TESTOUT = test.o

all: dyn_library dl_test

dyn_library: triangle.o
	$(CC) $(WARN) -dynamiclib -undefined suppress -flat_namespace triangle.o -o $(LIBOUT)

triangle.o: triangle.c
	$(CC) $(WARN) -O3 -c -DTRILIBRARY -DANSI_DECLARATORS triangle.c

dl_test: dlOpenTest.c
	$(CC) $(WARN) ./dlOpenTest.c -o $(TESTOUT)

clean:
	rm $(OUT) *.o