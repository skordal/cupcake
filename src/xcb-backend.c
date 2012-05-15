// The Cupcake GUI Toolkit
// (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
// Report bugs and issues on <http://github.com/skordal/cupcake/issues>

// This file contains various helper code for the XCB backend.

#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#include <xcb/xcb.h>

// XCB connection structure:
static xcb_connection_t * connection = NULL;
static xcb_screen_t * screen = NULL;
static cairo_t * cairo_context = NULL;

// Connects to the X server and does initialization:
int backend_initialize()
{
	connection = xcb_connect(NULL, NULL);
	if(connection == NULL)
		return 0;
	
	screen = xcb_setup_roots_iterator(xcb_get_setup(connection)).data;
	return 1;
}

// Disconnects from the X server and does cleanup:
void backend_finalize()
{
	if(connection != NULL)
		xcb_disconnect(connection);
}

// Creates a window and returns its identifier:
uint32_t backend_create_window(int width, int height, int pos_x, int pos_y, uint32_t parent)
{
	int window_id = xcb_generate_id(connection);

	if(parent == -1)
		parent = screen->root;

	xcb_create_window(connection,
		XCB_COPY_FROM_PARENT, window_id, parent, pos_x, pos_y,
		width, height, 5, XCB_WINDOW_CLASS_INPUT_OUTPUT, screen->root_visual,
		0, NULL);
	xcb_flush(connection);

	return window_id;
}

// Creates a graphics context:

// Sets the window title:
void backend_set_window_title(uint32_t window_id, const char * title, const char * icon_title)
{
	xcb_change_property(connection, XCB_PROP_MODE_REPLACE, window_id,
		XCB_ATOM_WM_NAME, XCB_ATOM_STRING, 8, strlen(title), title);
	xcb_change_property(connection, XCB_PROP_MODE_REPLACE, window_id,
		XCB_ATOM_WM_ICON_NAME, XCB_ATOM_STRING, 8, strlen(icon_title), icon_title);
}

// Sets the window size:
void backend_set_window_size(uint32_t window_id, int width, int height)
{
	uint32_t size[] = {width, height};
	xcb_configure_window(connection, window_id,
		XCB_CONFIG_WINDOW_WIDTH|XCB_CONFIG_WINDOW_HEIGHT, size);
}

// Shows a window:
void backend_show_window(uint32_t window_id)
{
	xcb_map_window(connection, window_id);
	xcb_flush(connection);
}

// Closes a window:
void backend_close_window(uint32_t window_id)
{
	xcb_unmap_window(connection, window_id);
	xcb_flush(connection);
}

