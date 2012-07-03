// The Cupcake GUI Toolkit
// (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
// Report bugs and issues on <http://github.com/skordal/cupcake/issues>

// This header contains functions and procedures exported from the Ada
// code that can be used by backends written in C.

#ifndef EXPORTS_H
#define EXPORTS_H

// Posts an expose event to a window identified by the specified ID:
void post_expose(uint32_t window_id);
// Posts a resize event to a window identified by its ID:
void post_resize(uint32_t window_id, uint32_t width, uint32_t height);

#endif

