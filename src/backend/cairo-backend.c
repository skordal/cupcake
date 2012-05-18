// The Cupcake GUI Toolkit
// (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
// Report bugs and issues on <http://github.com/skordal/cupcake/issues>

// Windowing backend using XCB and Cairo.

#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#include <xcb/xcb.h>
#include <xcb/xproto.h>
#include <cairo/cairo.h>

#include "backend.h"
#include "fonts.h"
#include "graphics.h"

static xcb_connection_t * connection = NULL;
static xcb_screen_t * screen = NULL;
static xcb_visualtype_t * visual_type = NULL;

static bool initialized = false;
static bool running = false;

static pthread_t event_thread = NULL;

static xcb_atom_t protocols_atom;
static xcb_atom_t delete_window_atom;

// Event handling thread main function:
void * backend_event_thread(void * unused __attribute((unused)));

// Backend specific window data. The pointer to this structure is called
// Cupcake.Windows.Backend_Data_Ptr in the Ada code.
typedef struct {
	xcb_window_t window_id;
	cairo_surface_t * cairo_surface;
	cairo_t * cairo_context;
} backend_window_t;

// Backend specific font data:
typedef struct {
	const char * family;
	cairo_font_slant_t style;
	cairo_font_weight_t weight;
	double size;
} backend_font_t;

// Initializes the backend:
bool backend_initialize()
{
	xcb_intern_atom_cookie_t cookie;
	xcb_intern_atom_reply_t * reply;

	// Connect to the X server:
	connection = xcb_connect(NULL, NULL);
	if(connection == NULL)
	{
		perror("could not connect to X server");
		return false;
	}

	// Get the screen:
	screen = xcb_setup_roots_iterator(xcb_get_setup(connection)).data;

	// Get the visual type for the root visual:
	for(xcb_depth_iterator_t depth_iterator = xcb_screen_allowed_depths_iterator(screen);
		depth_iterator.rem; xcb_depth_next(&depth_iterator))
	{
		xcb_visualtype_iterator_t visual_iterator = xcb_depth_visuals_iterator(
			depth_iterator.data);
		for(; visual_iterator.rem; xcb_visualtype_next(&visual_iterator))
		{
			if(screen->root_visual == visual_iterator.data->visual_id)
			{
				visual_type = visual_iterator.data;
				goto _visual_found;
			}
		}
	}
_visual_found:

	// Get atoms for destroying our own windows:
	cookie = xcb_intern_atom(connection, 0, 12, "WM_PROTOCOLS");
	reply = xcb_intern_atom_reply(connection, cookie, NULL);

	protocols_atom = reply->atom;
	free(reply);

	cookie = xcb_intern_atom(connection, 0, 16, "WM_DELETE_WINDOW");
	reply = xcb_intern_atom_reply(connection, cookie, NULL);

	delete_window_atom = reply->atom;
	free(reply);

	// Create the event handling thread:
	if(pthread_create(&event_thread, NULL, backend_event_thread, NULL) != 0)
		return false;
	
	int old;

	pthread_setcancelstate(PTHREAD_CANCEL_ENABLE, &old);
	pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, &old);

	initialized = true;
	return true;
}

// Finalizes the backend:
void backend_finalize()
{
	xcb_disconnect(connection);
	initialized = false;
}

// Creates a window:
void * backend_window_create(const void * parent, int width, int height)
{
	assert(initialized);

	backend_window_t * new_window = malloc(sizeof(backend_window_t));
	new_window->window_id = xcb_generate_id(connection);

	uint32_t window_event_mask = XCB_EVENT_MASK_EXPOSURE|XCB_EVENT_MASK_STRUCTURE_NOTIFY;
	xcb_create_window(connection, XCB_COPY_FROM_PARENT, new_window->window_id,
		parent == NULL ? screen->root : ((backend_window_t *) parent)->window_id,
		0, 0, width, height, 4, XCB_WINDOW_CLASS_INPUT_OUTPUT, screen->root_visual,
		XCB_CW_EVENT_MASK, &window_event_mask);
	new_window->cairo_surface = cairo_xcb_surface_create(connection, new_window->window_id,
		visual_type, width, height);
	new_window->cairo_context = cairo_create(new_window->cairo_surface);

	xcb_change_property(connection, XCB_PROP_MODE_REPLACE, new_window->window_id,
		protocols_atom, XCB_ATOM_ATOM, 32, 1, &delete_window_atom);

	xcb_flush(connection);
	return new_window;
}

// Finalizes a window:
void backend_window_finalize(void * window)
{
	assert(window != NULL);
	backend_window_t * win = window;

	cairo_destroy(win->cairo_context);
	cairo_surface_destroy(win->cairo_surface);

	xcb_unmap_window(connection, win->window_id);
	xcb_destroy_window(connection, win->window_id);

	free(win);
}

// Gets the ID number of a window:
uint32_t backend_window_get_id(const void * window)
{
	assert(window != NULL);
	return ((backend_window_t *) window)->window_id;
}

// Sets the title of a window:
void backend_window_set_title(void * window, const char * title)
{
	xcb_change_property(connection, XCB_PROP_MODE_REPLACE,
		((backend_window_t *) window)->window_id, XCB_ATOM_WM_NAME, XCB_ATOM_STRING,
		8, strlen(title), title);
	xcb_change_property(connection, XCB_PROP_MODE_REPLACE,
		((backend_window_t *) window)->window_id, XCB_ATOM_WM_NAME, XCB_ATOM_STRING,
		8, strlen(title), title);
	xcb_flush(connection);
}

// Shows a window:
void backend_window_show(void * window)
{
	xcb_map_window(connection, ((backend_window_t *) window)->window_id);
	xcb_flush(connection);
}

// Closes a window:
void backend_window_close(void * window)
{
	if(post_window_close(((backend_window_t *) window)->window_id))
	{
		xcb_unmap_window(connection, ((backend_window_t *) window)->window_id);
		xcb_flush(connection);
	}

	if(get_num_windows_remaining() == 0)
		backend_main_loop_terminate();
}

// Backend main loop:
void backend_main_loop()
{
	void * retval;
	pthread_join(event_thread, &retval);
}

// Terminates the backend main loop:
void backend_main_loop_terminate()
{
	running = false;
	usleep(100);
	pthread_cancel(event_thread);
}

// Thread for processing events:
void * backend_event_thread(void * unused __attribute((unused)))
{
	xcb_generic_event_t * event;
	xcb_expose_event_t * expose_event;
	xcb_client_message_event_t * client_message_event;

	running = true;
	printf("[backend_event_thread] started event thread.\n");

	while((event = xcb_wait_for_event(connection)) != NULL)
	{
		switch(event->response_type & ~0x80)
		{
			case XCB_EXPOSE:
				expose_event = (xcb_expose_event_t *) event;
				post_expose(expose_event->window);
				xcb_flush(connection);
				break;
			case XCB_CLIENT_MESSAGE:
				client_message_event = (xcb_client_message_event_t *) event;

				// The backend_window_close function sends a window_closing event
				// to the window and closes the window if allowed. If such a message
				// is sent here, the window will not get closed, just removed from
				// the list of open windows.
				backend_window_t * window_data = get_backend_data_for_window_by_id(
					client_message_event->window);
				if(window_data != NULL)
					backend_window_close(window_data);
			default:
				// Ignore unexpected events.
				break;
		}

		free(event);
	}

	printf("[backend_event_thread] stopping event thread\n");
	return NULL;
}

// Sets the color for the specified window's cairo context:
void backend_set_color(void * window, double r, double g, double b)
{
	cairo_t * cairo_context = ((backend_window_t *) window)->cairo_context;
	cairo_set_source_rgb(cairo_context, r, g, b);
}

// Fills the area specified:
void backend_fill_rectangle(void * window, int x, int y, int w, int h)
{
	cairo_t * cairo_context = ((backend_window_t *) window)->cairo_context;
	cairo_rectangle(cairo_context, x, y, w, h);
	cairo_fill(cairo_context);
}

// Allocates a new font:
void * backend_new_font(backend_font_family_t family, backend_font_style_t style, double size)
{
	backend_font_t * retval = malloc(sizeof(backend_font_t));
	retval->size = size;

	switch(family)
	{
		case FAMILY_SERIF:
			retval->family = "serif";
			break;
		case FAMILY_SANS_SERIF:
			retval->family = "sans-serif";
			break;
		case FAMILY_MONOSPACE:
			retval->family = "monospace";
			break;

	}

	switch(style)
	{
		case STYLE_PLAIN:
			retval->style = CAIRO_FONT_SLANT_NORMAL;
			retval->weight = CAIRO_FONT_WEIGHT_NORMAL;
			break;
		case STYLE_ITALIC:
			retval->style = CAIRO_FONT_SLANT_ITALIC;
			retval->weight = CAIRO_FONT_WEIGHT_NORMAL;
		case STYLE_BOLD:
			retval->style = CAIRO_FONT_SLANT_NORMAL;
			retval->weight = CAIRO_FONT_WEIGHT_BOLD;
			break;
	}

	return retval;
}

// Frees a previously allocated font:
void backend_free_font(void * font)
{
	free(font);
}

// Renders text with the specified attributes:
void backend_render_string(void * window, void * font, int x, int y, const char * text)
{
	backend_window_t * win = (backend_window_t *) window;
	backend_font_t * fnt = (backend_font_t *) font;

	cairo_select_font_face(win->cairo_context, fnt->family, fnt->style, fnt->weight);
	cairo_set_font_size(win->cairo_context, fnt->size);
	cairo_move_to(win->cairo_context, x, y);
	cairo_show_text(win->cairo_context, text);
}

// Gets the length of a rendered string:
double backend_string_length(void * window, void * font, const char * text)
{
	cairo_text_extents_t length_info;
	backend_font_t * fnt = (backend_font_t *) font;

	cairo_select_font_face(((backend_window_t *) window)->cairo_context,
		fnt->family, fnt->style, fnt->weight);
	cairo_text_extents(((backend_window_t *) window)->cairo_context, text, &length_info);

	return length_info.width;
}

