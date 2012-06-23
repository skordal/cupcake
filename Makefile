# Top-Level Makefile for the Cupcake GUI Toolkit
# (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
# Report bugs and issues on <http://github.com/skordal/cupcake/issues>
include config.mk

.PHONY: all demos docs clean

all:
	@$(MAKE) -C src all

demos: all
	@$(MAKE) -C demos all

docs:
	@$(MAKE) -C docs all

clean:
	@$(MAKE) -C src clean
	@$(MAKE) -C demos clean
	@$(MAKE) -C docs clean

