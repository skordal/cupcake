// The Cupcake GUI Toolkit
// (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
// Report bugs and issues on <http://github.com/skordal/cupcake/issues>

// Backend initialization and finalization code
#include "backend.h"

xcb_connection_t * connection = NULL;
xcb_screen_t * screen = NULL;
xcb_visualtype_t * visual_type = NULL;

xcb_atom_t protocols_atom;
xcb_atom_t delete_window_atom;

static bool initialized = false;
static bool running = false;

static pthread_t event_thread;

// Event handling thread main function:
void * backend_event_thread(void * unused __attribute((unused)));

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

	int old;
	pthread_setcancelstate(PTHREAD_CANCEL_ENABLE, &old);
	pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, &old);

	// Create the event handling thread:
	if(pthread_create(&event_thread, NULL, backend_event_thread, NULL) != 0)
		return false;
	
	initialized = true;
	return true;
}

// Finalizes the backend:
void backend_finalize()
{
	xcb_disconnect(connection);
	initialized = false;
}

// Backend main loop function, simply waits for the event thread to finish:
void backend_main_loop()
{
	void * retval;
	pthread_join(event_thread, &retval);
}

// Terminates the backend main loop by cancelling the event thread:
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
	xcb_configure_notify_event_t * notify_event;
	xcb_client_message_event_t * client_message_event;

	running = true;
	printf("[backend_event_thread] started event thread.\n");

	while((event = xcb_wait_for_event(connection)) != NULL)
	{
		backend_window_t * window_data;
		switch(event->response_type & ~0x80)
		{
			case XCB_EXPOSE:
				expose_event = (xcb_expose_event_t *) event;
				// TODO: Post expose event to window
				xcb_flush(connection);
				break;
			case XCB_CLIENT_MESSAGE:
				client_message_event = (xcb_client_message_event_t *) event;
				// TODO: Post close event to window
				break;
			case XCB_CONFIGURE_NOTIFY:
				notify_event = (xcb_configure_notify_event_t *) event;
				// TODO: Post resize event to window
				break;
			default:
				// Ignore unexpected events.
				break;
		}

		free(event);
	}

	printf("[backend_event_thread] event thread terminated\n");
	return NULL;
}

