# The Cupcake GUI Toolkit Makefile
# (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
# Report bugs and issues on <http://github.com/skordal/cupcake/issues>
include ../../config.mk

.PHONY: all clean

SOURCE_FILES := \
	cairo-backend.c

OBJECT_FILES = $(SOURCE_FILES:.c=.o)

all: $(OBJECT_FILES)

clean:
	-$(RM) $(OBJECT_FILES)

%.o: %.c
	$(GNATCC) -c $(CFLAGS) -o $@ $<

# Dependency information:
cairo-backend.o: cairo-backend.c backend.h events.h


