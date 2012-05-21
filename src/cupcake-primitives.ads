-- The Cupcake GUI Toolkit
-- (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
-- Report bugs and issues on <http://github.com/skordal/cupcake/issues>

package Cupcake.Primitives is

	-- Simple point type:
	type Point is record
			X, Y : Integer;
		end record;

	-- Point operators:
	function "+" (Left, Right : in Point) return Point;
	function "-" (Left, Right : in Point) return Point;

	-- Type for specifying dimensions:
	type Dimension is record
			Width, Height : Natural;
		end record;

	-- Null dimension:
	Null_Dimension : constant Dimension := (0, 0);

	-- Rectangle type:
	type Rectangle is record
			Origin : Point;
			Size : Dimension;
		end record;
	
	-- Line type:
	type Line is record
			Start : Point;
			Endpoint : Point;
		end record;

end Cupcake.Primitives;

