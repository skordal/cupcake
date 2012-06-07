// The Cupcake GUI Toolkit
// (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
// Report bugs and issues on <http://github.com/skordal/cupcake/issues>

#ifndef WINDOWS_H
#define WINDOWS_H

// Backend specific window data. The pointer to this structure is called
// Cupcake.Windows.Backend_Data_Ptr in the Ada code.
typedef struct {
	xcb_window_t window_id;
	cairo_surface_t * cairo_surface;
	cairo_t * cairo_context;
} backend_window_t;

// Creates a window:
backend_window_t * backend_window_create(const backend_window_t * parent,
	int width, int height);
// Finalizes a window:
void backend_window_finalize(backend_window_t * window);

// Gets the ID number of a window:
uint32_t backend_window_get_id(const backend_window_t * window);

// Sets the window title:
void backend_window_set_title(backend_window_t * window, const char * title);
// Shows a window:
void backend_window_show(backend_window_t * window);
// Closes a window:
void backend_window_close(backend_window_t * window);

#endif

