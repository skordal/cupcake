-- The Cupcake GUI Toolkit
-- (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
-- Report bugs and issues on <http://github.com/skordal/cupcake/issues>

package Cupcake.Primitives is

	-- Simple point type:
	type Point is record
			X, Y : Integer;
		end record;

	-- Type for specifying dimensions:
	type Dimension is record
			Width, Height : Natural;
		end record;

	-- Rectangle type:
	type Rectangle is record
			Origin : Point;
			Size : Dimension;
		end record;
	
	-- Circle type:
	type Circle is record
			Center : Point;
			Radius : Float;
		end record;
	
	-- Line type:
	type Line is record
			Origin : Point;
			End_Point : Point;
		end record;

end Cupcake.Primitives;

