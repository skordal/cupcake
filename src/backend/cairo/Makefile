# The Cupcake GUI Toolkit Cairo Backend Makefile
# (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
# Report bugs and issues on <http://github.com/skordal/cupcake/issues>
include ../../../config.mk

.PHONY: all clean

SOURCE_FILES := \
	backend.c \
	fonts.c \
	graphics.c \
	windows.c

OBJECT_FILES = $(SOURCE_FILES:.c=.o)

all: $(OBJECT_FILES)

clean:
	-$(RM) $(OBJECT_FILES)

%.o: %.c
	$(GNATCC) -c $(CFLAGS) -o $@ $<

