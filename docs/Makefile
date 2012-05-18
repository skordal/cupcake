# Top-Level Makefile for the Cupcake GUI Toolkit
# (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
# Report bugs and issues on <http://github.com/skordal/cupcake/issues>
include ../config.mk

.PHONY: all clean

PODFILES := \
	Cupcake.pod \
	Cupcake.Graphics.pod \
	Cupcake.Windows.pod
MANPAGES := $(PODFILES:.pod=.3)

all: $(MANPAGES)

clean:
	-$(RM) $(MANPAGES)

%.3: %.pod
	$(M4) $< | $(POD2MAN) -s 3 -q none -c "Cupcake GUI Toolkit Manual" -r "cupcake-0.1" \
		-n $(shell basename $@ .3) > $@


