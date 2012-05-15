# Top-Level Makefile for the Cupcake GUI Toolkit
# (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
# Report bugs and issues on <http://github.com/skordal/cupcake/issues>

.PHONY: all demos clean

all:
	@make -C src all

demos: all
	@make -C demos all

clean:
	@make -C src clean
	@make -C demos clean

