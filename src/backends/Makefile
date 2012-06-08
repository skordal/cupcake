# The Cupcake GUI Toolkit Backends Top-Level Makefile
# (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
# Report bugs and issues on <http://github.com/skordal/cupcake/issues>
include ../../config.mk

.PHONY: all cairo clean

# Backend to build (only one to choose from for now):
USE_BACKEND := \
	cairo

all: $(USE_BACKEND)

clean:
	-$(MAKE) -C cairo clean

$(USE_BACKEND): cupcake-backends-$(USE_BACKEND).ads cupcake-backends-$(USE_BACKEND).adb
	$(MAKE) -C $(USE_BACKEND) all
	$(GNATCC) -c -I.. $(GNATFLAGS) -o cupcake-backends-$(USE_BACKEND).o cupcake-backends-$(USE_BACKEND).adb

