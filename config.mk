# Build configuration settings
# (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
# Report bugs and issues on <http://github.com/skordal/cupcake/issues>

# Build tools:
AR     ?= ar
GNATCC ?= gnatgcc
RANLIB ?= ranlib

# Build flags:
GNATFLAGS += -O2 -fPIC -gnatwa -gnatVa
CFLAGS    += -O2 -fPIC -Wall -std=gnu99 -g
LDFLAGS   += $(shell pkg-config --libs xcb cairo) -Wl,-rpath=/usr/local/lib

