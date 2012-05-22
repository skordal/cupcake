// The Cupcake GUI Toolkit
// (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
// Report bugs and issues on <http://github.com/skordal/cupcake/issues>

// This header file contains definitions of functions used by the graphics
// subsystem. The methods using the functions in this file can be found in
// the package Cupcake.Graphics.

// All coordinates used below are relative to the window.

#ifndef GRAPHICS_H
#define GRAPHICS_H

// Draws a line between the specified coordinates:
void backend_draw_line(void * window, int x1, int y1, int x2, int y2, float line_width);

// Sets the current color to be used in susequent drawing operations:
void backend_set_color(void * window, float r, float g, float b);

// Fills the specified rectangle:
void backend_fill_rectangle(void * window, int x, int y, int w, int h);

#endif

