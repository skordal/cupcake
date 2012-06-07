// The Cupcake GUI Toolkit
// (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
// Report bugs and issues on <http://github.com/skordal/cupcake/issues>

// Graphic backend functions:
#include "backend.h"

// Sets the color for the specified window's cairo context:
void backend_set_color(backend_window_t * window, float r, float g, float b)
{
	cairo_set_source_rgb(window->cairo_context, r, g, b);
}

// Draws a line:
void backend_draw_line(backend_window_t * window, int x1, int y1, int x2, int y2, float line_width)
{
	cairo_set_line_width(window->cairo_context, line_width);
	cairo_move_to(window->cairo_context, x1, y1);
	cairo_line_to(window->cairo_context, x2, y2);
	cairo_stroke(window->cairo_context);
}

// Fills the area specified:
void backend_fill_rectangle(backend_window_t * window, int x, int y, int w, int h)
{
	cairo_rectangle(window->cairo_context, x, y, w, h);
	cairo_fill(window->cairo_context);
}

