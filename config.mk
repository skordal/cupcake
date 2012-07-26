# Build configuration settings
# (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
# Report bugs and issues on <http://github.com/skordal/cupcake/issues>

# Build tools:
AR      ?= ar
GNATCC  ?= gnatgcc
MAKE    ?= make
RANLIB  ?= ranlib

# Documentation build tools:
M4      ?= m4
POD2MAN ?= pod2man

# Build flags:
GNATFLAGS += -O2 -g -fPIC -gnatwa -gnatVa -gnaty -gnatE -gnat2012
CFLAGS    += -O2 -g -fPIC -Wall -std=gnu99 $(shell pkg-config --cflags xcb cairo)
LDFLAGS   += $(shell pkg-config --libs xcb cairo) -Wl,-rpath=/usr/lib

