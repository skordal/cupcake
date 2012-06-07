// The Cupcake GUI Toolkit
// (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
// Report bugs and issues on <http://github.com/skordal/cupcake/issues>

// Header file containing the functions required by backends.

#ifndef CUPCAKE_BACKEND_H
#define CUPCAKE_BACKEND_H

#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <pthread.h>
#include <unistd.h>

#include <xcb/xcb.h>
#include <xcb/xproto.h>
#include <cairo/cairo.h>

#include "events.h"
#include "fonts.h"
#include "windows.h"

// XCB X server connection:
extern xcb_connection_t * connection;
// XCB screen:
extern xcb_screen_t * screen;
// XCB visual type:
extern xcb_visualtype_t * visual_type;

// XCB atoms relating to allowing us to close windows ourselves:
extern xcb_atom_t protocols_atom, delete_window_atom;

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

// Runs the main loop:
void backend_main_loop();
// Exits the main loop:
void backend_main_loop_terminate();

#endif

