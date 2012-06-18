-- The Cupcake GUI Toolkit
-- (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
-- Report bugs and issues on <http://github.com/skordal/cupcake/issues>

with Cupcake.Colors;
with Cupcake.Primitives;

private with Ada.Containers.Doubly_Linked_Lists;
private with Cupcake.Backends;

package Cupcake.Windows is

	-- Normal window type:
	type Window_Record (<>) is tagged limited private;
	type Window is access all Window_Record'Class;

	-- Creates a new window:
	function New_Window(Width, Height : in Positive; Title : in String) return Window;
	function New_Window(Size : in Primitives.Dimension; Title : in String) return Window;

	-- Destroys a window:
	procedure Destroy(Object : not null access Window_Record);

	-- Sets the visibility of a window; this is used to show and close windows:
	procedure Set_Visible(This : access Window_Record'Class; Visible : Boolean := true);

	-- Window size operations:
	function Get_Size(This : in Window_Record'Class) return Primitives.Dimension
		with Inline, Pure_Function;
	procedure Set_Size(This : in out Window_Record'Class; Size : Primitives.Dimension)
		with Inline;

	function Get_Background_Color(This : in Window_Record'Class) return Colors.Color
		with Inline, Pure_Function;
	procedure Set_Background_Color(This : out Window_Record'Class; Color : in Colors.Color)
		with Inline;

private
	-- List of active windows, for event propagation:
	package Window_Lists is new Ada.Containers.Doubly_Linked_Lists(Element_Type => Window);
	Window_List : Window_Lists.List;

	-- Normal window type definition:
	type Window_Record is tagged limited record
			Size : Primitives.Dimension;
			Background_Color : Colors.Color := Colors.DEFAULT_BACKGROUND_COLOR;
			Backend_Data : Backends.Window_Data_Pointer;
			ID : Backends.Window_ID_Type;
		end record;

end Cupcake.Windows;

