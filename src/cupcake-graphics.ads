-- The Cupcake GUI Toolkit
-- (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
-- Report bugs and issues on <http://github.com/skordal/cupcake/issues>

with Cupcake.Colors;
with Cupcake.Primitives;
with Cupcake.Fonts;

package Cupcake.Graphics is

	type Context_Record (<>) is tagged limited private;
	type Context is access all Context_Record'Class;

	-- Creates a new graphics context for the specified backend specific window:
	-- TODO: Use Window instead of Backend_Data_Ptr for the argument. For now,
	--       using Backend_Data_Ptr is done to prevent circular dependencies.
	function New_Context(Backend_Data : in Backend_Data_Ptr; Size : in Primitives.Dimension)
		return Context;
	-- Creates a new sub-context with the specified context as its parents
	-- and the bounds specified in Translation and Size:
	function New_Context(Parent : in Context; Translation : in Primitives.Point;
		Size : in Primitives.Dimension) return Context;

	-- Destroys a graphics context:
	procedure Destroy(Object : not null access Context_Record);

	-- Graphics context attribute operations:
	procedure Set_Size(This : out Context_Record'Class; New_Size : in Primitives.Dimension);
	function Get_Size(This : in Context_Record'Class) return Primitives.Dimension;
	pragma Inline(Set_Size, Get_Size);

	-- Graphics context drawing operations:
	procedure Fill(This : in Context_Record'Class; Color : in Colors.Color;
		Shape : in Primitives.Rectangle);

	-- Renders a string of text:
	procedure Render_String(This : in Context_Record'Class; Color : in Colors.Color;
		Text : in String; Font : in Fonts.Font; Position : in Primitives.Point);

	-- Gets the length (in pixels) of a string:
	function Get_String_Length(This : in Context_Record'Class; Text : in String;
		Font : in Fonts.Font) return Natural;

private

	-- Graphics context definition:
	type Context_Record is tagged limited record
			Parent : Context := null;
			Translation : Primitives.Point := (0, 0);
			Size : Primitives.Dimension;
			Backend_Data : Backend_Data_Ptr;
		end record;

end Cupcake.Graphics;

