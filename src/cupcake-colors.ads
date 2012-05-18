-- The Cupcake GUI Toolkit
-- (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
-- Report bugs and issues on <http://github.com/skordal/cupcake/issues>

package Cupcake.Colors is

	-- Color component type:
	subtype Color_Component_Type is Long_Float range 0.0 .. 1.0;

	-- Color type:
	type Color is record
			R, G, B : Color_Component_Type;
		end record;

	-- Predefined color constants:
	BLACK	: constant Color := (0.0, 0.0, 0.0);
	WHITE	: constant Color := (1.0, 1.0, 1.0);

	RED	: constant Color := (1.0, 0.0, 0.0);
	GREEN	: constant Color := (0.0, 1.0, 0.0);
	BLUE	: constant Color := (0.0, 0.0, 1.0);

	DEFAULT_BACKGROUND_COLOR : constant Color := (0.85, 0.85, 0.85);

end Cupcake.Colors;

