# Cupcake Toolkit Demo Application Makefile
# (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
# Report bugs and issues on <http://github.com/skordal/cupcake/issues>

include ../config.mk

.PHONY: all clean

all: demo.adb
	gcc -c $(GNATFLAGS) -I../src -I../src/backends demo.adb -o demo.o
	gnatbind -I../src -I../src/backends demo.ali
	gnatlink -o demo demo.ali -L../src -lcupcake-tk -Wl,-rpath,$$(pwd)/../src

clean:
	gnatclean -q demo

