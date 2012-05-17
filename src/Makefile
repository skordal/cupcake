# The Cupcake GUI Toolkit Makefile
# (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
# Report bugs and issues on <http://github.com/skordal/cupcake/issues>
include ../config.mk

.PHONY: all clean

# Ada source files to build:
SOURCE_FILES := \
	cupcake.adb \
	cupcake-graphics.adb \
	cupcake-windows.adb

# Ada specification files to build:
SPEC_FILES := \
	cupcake-events.ads \
	cupcake-primitives.ads

# C source files to build:
C_SOURCE_FILES := \
	cairo-backend.c

# Object files to build:
OBJECT_FILES := $(SOURCE_FILES:.adb=.o) $(SPEC_FILES:.ads=.o) \
	$(C_SOURCE_FILES:.c=.o)

all: $(OBJECT_FILES)
	$(AR) rc libcupcake-tk.a $(OBJECT_FILES)
	$(RANLIB) libcupcake-tk.a
	gcc -shared -o libcupcake-tk.so $(OBJECT_FILES) $(LDFLAGS)

clean:
	-$(RM) $(OBJECT_FILES)
	-$(RM) $(SOURCE_FILES:.adb=.ali)
	-$(RM) $(SPEC_FILES:.ads=.ali)
	-$(RM) libcupcake-tk.so libcupcake-tk.a

%.o: %.adb %.ads
	$(GNATCC) -c $(GNATFLAGS) -o $@ $<

%.o: %.ads
	$(GNATCC) -c $(GNATFLAGS) -o $@ $<

%.o: %.c
	$(GNATCC) -c $(CFLAGS) -o $@ $<

# Dependency information:
cairo-backend.o: cairo-backend.c backend.h events.h

