# The Cupcake GUI Toolkit Makefile
# (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
# Report bugs and issues on <http://github.com/skordal/cupcake/issues>
include ../config.mk

.PHONY: all backends clean

# Ada source files to build:
SOURCE_FILES := \
	cupcake.adb \
	cupcake-backends.adb \
	cupcake-primitives.adb \
	cupcake-windows.adb

# Ada specification files to build:
SPEC_FILES := \
	cupcake-colors.ads

# Object files to build:
OBJECT_FILES := $(SOURCE_FILES:.adb=.o) $(SPEC_FILES:.ads=.o)

all: backends $(OBJECT_FILES)
	$(AR) rc libcupcake-tk.a $(OBJECT_FILES) $(shell find backends -type f | grep '\.o')
	$(RANLIB) libcupcake-tk.a
	gcc -shared -o libcupcake-tk.so $(OBJECT_FILES) $(shell find backends -type f | grep '\.o') \
		$(LDFLAGS)

backends:
	@$(MAKE) -C backends

clean:
	-$(RM) $(OBJECT_FILES)
	-$(RM) $(SOURCE_FILES:.adb=.ali)
	-$(RM) $(SPEC_FILES:.ads=.ali)
	-$(RM) libcupcake-tk.so libcupcake-tk.a
	@$(MAKE) -C backends clean

%.o: %.adb %.ads
	$(GNATCC) -c $(GNATFLAGS) -Ibackends -o $@ $<

%.o: %.ads
	$(GNATCC) -c $(GNATFLAGS) -Ibackends -o $@ $<

