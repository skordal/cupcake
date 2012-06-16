-- The Cupcake GUI Toolkit
-- (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
-- Report bugs and issues on <http://github.com/skordal/cupcake/issues>

with Cupcake.Colors;
with Cupcake.Primitives;

private with Cupcake.Backends;

package Cupcake.Windows is

	-- Normal window type:
	type Window_Record (<>) is tagged private;
	type Window is access all Window_Record'Class;

	-- Creates a new window:
	function New_Window(Width, Height : in Positive; Title : in String) return Window;
	function New_Window(Size : in Primitives.Dimension; Title : in String) return Window;

	-- Destroys a window:
	procedure Destroy(Object : not null access Window_Record);

	-- Window operations:
	procedure Show(This : in Window_Record'Class) with Inline;
	procedure Close(This : in Window_Record'Class) with Inline;

	function Get_Size(This : in Window_Record'Class) return Primitives.Dimension
		with Inline, Pure_Function;

	function Get_Background_Color(This : in Window_Record'Class) return Colors.Color
		with Inline, Pure_Function;
	procedure Set_Background_Color(This : out Window_Record'Class; Color : in Colors.Color)
		with Inline;

private
	-- Normal window type definition:
	type Window_Record is tagged record
			Size : Primitives.Dimension;
			Background_Color : Colors.Color := Colors.DEFAULT_BACKGROUND_COLOR;
			Backend_Data : Backends.Window_Data_Pointer;
			ID : Backends.Window_ID_Type;
		end record;

end Cupcake.Windows;

