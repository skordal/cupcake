// The Cupcake GUI Toolkit
// (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
// Report bugs and issues on <http://github.com/skordal/cupcake/issues>

// This header contains prototypes for the various font related
// backend functions.

#ifndef FONTS_H
#define FONTS_H

typedef enum {
	FAMILY_SERIF = 1,
	FAMILY_SANS_SERIF = 2,
	FAMILY_MONOSPACE = 3
} backend_font_family_t;

typedef enum {
	STYLE_PLAIN = 1,
	STYLE_ITALIC = 2,
	STYLE_BOLD = 3
} backend_font_style_t;

// Allocates a new font with the specified parameters, and returns
// a handle to the font.
void * backend_new_font(backend_font_family_t, backend_font_style_t, double size);
// Frees a previously allocated font:
void backend_free_font(void * font);

// Renders a string of text at the specified position:
void backend_render_string(void * window, void * font, int x, int y, const char * text);

// Gets the length of a rendered text string:
double backend_string_length(void * window, void * font, const char * text);

#endif

