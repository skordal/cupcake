-- The Cupcake GUI Toolkit
-- (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
-- Report bugs and issues on <http://github.com/skordal/cupcake/issues>

package body Cupcake.Primitives is

	-- Adds two points together:
	function "+" (Left, Right : in Point) return Point is
	begin
		return ((Left.X + Right.X), (Left.Y + Right.Y));
	end "+";

	-- Subtracts two points:
	function "-" (Left, Right : in Point) return Point is
	begin
		return ((Left.X - Right.X), (Left.Y - Right.Y));
	end "-";

	-- Compares two points for equality:
	function "=" (Left, Right : in Point) return Boolean is
	begin
		return ((Left.X = Right.X) and (Left.Y = Right.Y));
	end "=";

end Cupcake.Primitives;

