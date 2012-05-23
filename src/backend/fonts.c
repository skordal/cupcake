// The Cupcake GUI Toolkit
// (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
// Report bugs and issues on <http://github.com/skordal/cupcake/issues>

// Backend font functionality
#include "backend.h"

// Allocates a new font:
backend_font_t * backend_new_font(backend_font_family_t family, backend_font_style_t style, double size)
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
void backend_free_font(backend_font_t * font)
{
	free(font);
}

// Renders text with the specified attributes:
void backend_render_string(backend_window_t * window, backend_font_t * font, int x, int y,
	const char * text)
{
	cairo_select_font_face(window->cairo_context, font->family, font->style, font->weight);
	cairo_set_font_size(window->cairo_context, font->size);
	cairo_move_to(window->cairo_context, x, y);
	cairo_show_text(window->cairo_context, text);
}

// Gets the length of a rendered string:
double backend_string_length(backend_window_t * window, backend_font_t * font, const char * text)
{
	cairo_text_extents_t length_info;

	cairo_select_font_face(window->cairo_context, font->family, font->style, font->weight);
	cairo_text_extents(window->cairo_context, text, &length_info);

	return length_info.width;
}
