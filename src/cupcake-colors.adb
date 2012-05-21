-- The Cupcake GUI Toolkit
-- (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
-- Report bugs and issues on <http://github.com/skordal/cupcake/issues>

package body Cupcake.Colors is

	-- Multiplies the components of a color with a constant:
	function "*" (Left : in Color; Right : in Long_Float) return Color is
		Retval : Color;
	begin
		Retval.R := Left.R * Right;
		Retval.G := Left.G * Right;
		Retval.B := Left.B * Right;
		return Retval;
	end "*";

	-- Multiplies the components of a color with a constant:
	function "*" (Left : in Long_Float; Right : in Color) return Color is
	begin
		return Right * Left;
	end "*";

end Cupcake.Colors;

