// The Cupcake GUI Toolkit
// (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
// Report bugs and issues on <http://github.com/skordal/cupcake/issues>

// Backend window operations
#include "backend.h"

// Creates a window:
backend_window_t * backend_window_create(const backend_window_t * parent, int width, int height)
{
	backend_window_t * new_window = malloc(sizeof(backend_window_t));
	new_window->window_id = xcb_generate_id(connection);

	uint32_t window_event_mask = XCB_EVENT_MASK_EXPOSURE|XCB_EVENT_MASK_STRUCTURE_NOTIFY;
	xcb_create_window(connection, XCB_COPY_FROM_PARENT, new_window->window_id,
		parent == NULL ? screen->root : ((backend_window_t *) parent)->window_id,
		0, 0, width, height, 4, XCB_WINDOW_CLASS_INPUT_OUTPUT, screen->root_visual,
		XCB_CW_EVENT_MASK, &window_event_mask);

	// Set up cairo specific parameters:
	new_window->cairo_surface = cairo_xcb_surface_create(connection, new_window->window_id,
		visual_type, width, height);
	new_window->cairo_context = cairo_create(new_window->cairo_surface);

	// Make sure we are responsible for deleting the window ourselves:
	xcb_change_property(connection, XCB_PROP_MODE_REPLACE, new_window->window_id,
		protocols_atom, XCB_ATOM_ATOM, 32, 1, &delete_window_atom);

	xcb_flush(connection);
	return new_window;
}

// Finalizes a window:
void backend_window_finalize(backend_window_t * window)
{
	cairo_destroy(window->cairo_context);
	cairo_surface_destroy(window->cairo_surface);

	xcb_unmap_window(connection, window->window_id);
	xcb_destroy_window(connection, window->window_id);

	free(window);
}

// Gets the ID number of a window:
uint32_t backend_window_get_id(const backend_window_t * window)
{
	return window->window_id;
}

// Sets the title of a window:
void backend_window_set_title(backend_window_t * window, const char * title)
{
	xcb_change_property(connection, XCB_PROP_MODE_REPLACE,
		window->window_id, XCB_ATOM_WM_NAME, XCB_ATOM_STRING,
		8, strlen(title), title);
	xcb_change_property(connection, XCB_PROP_MODE_REPLACE,
		window->window_id, XCB_ATOM_WM_NAME, XCB_ATOM_STRING,
		8, strlen(title), title);
	xcb_flush(connection);
}

// Shows a window:
void backend_window_show(backend_window_t * window)
{
	xcb_map_window(connection, window->window_id);
	xcb_flush(connection);
}

// Closes a window:
void backend_window_close(backend_window_t * window)
{
	xcb_unmap_window(connection, window->window_id);
	xcb_flush(connection);
}

