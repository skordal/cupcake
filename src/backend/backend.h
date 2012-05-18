// The Cupcake GUI Toolkit
// (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
// Report bugs and issues on <http://github.com/skordal/cupcake/issues>

// Header file containing the functions required by backends.

#ifndef CUPCAKE_BACKEND_H
#define CUPCAKE_BACKEND_H

#include <stdint.h>
#include <stdbool.h>

#include "events.h"

// Utility function exported from the Ada code: gets the backend specific
// data for a specific window ID:
extern void * get_backend_data_for_window_by_id(uint32_t window_id);

// Gets the number of windows remaining on the screen:
extern unsigned int get_num_windows_remaining();

// Initializes the backend. This function returns true if successful,
// or false if an error occured. It may also print an error message.
bool backend_initialize();

// Finalizes the backend. This function cleans up any resources allocated
// by the backend.
void backend_finalize();

// Creates a window:
void * backend_window_create(const void * parent,
	int width, int height);
// Finalizes a window:
void backend_window_finalize(void * window);

// Gets the ID number of a window:
uint32_t backend_window_get_id(const void * window);

// Sets the window title:
void backend_window_set_title(void * window, const char * title);
// Shows a window:
void backend_window_show(void * window);
// Closes a window:
void backend_window_close(void * window);

// Runs the main loop:
void backend_main_loop();

// Exits the main loop:
void backend_main_loop_terminate();

#endif

