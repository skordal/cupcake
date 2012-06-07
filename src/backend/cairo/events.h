// The Cupcake GUI Toolkit
// (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
// Report bugs and issues on <http://github.com/skordal/cupcake/issues>

// Procedures here are exported by the Ada code in Cupcake.Windows.
// They are used by backend code to make sure events are passed to
// windows and components.

#ifndef EVENTS_H
#define EVENTS_H

#include <stdbool.h>
#include <stdint.h>

// Posts an expose event to the specified window:
extern void post_expose(uint32_t window_id);
extern void post_resize(uint32_t window_id, unsigned int width, unsigned int height);
extern bool post_window_close(uint32_t window_id);

#endif

