-- The Cupcake GUI Toolkit
-- (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
-- Report bugs and issues on <http://github.com/skordal/cupcake/issues>

with Cupcake.Colors;
with Cupcake.Primitives;

package Cupcake.Backends.Cairo is

	-- Cairo backend type:
	type Cairo_Backend is new Backends.Backend with private;

	---- GENERAL OPERATIONS:

	-- Gets the name of the backend:
	function Get_Name(This : in Cairo_Backend) return String;

	-- Initializes the backend:
	procedure Initialize(This : in out Cairo_Backend);

	-- Checks if the backend has been initialized:
	function Is_Initialized(This : in Cairo_Backend) return Boolean;
	pragma Inline(Is_Initialized);

	-- Finalizes the backend:
	procedure Finalize(This : in out Cairo_Backend);

	-- Enters the main loop:
	procedure Enter_Main_Loop(This : in out Cairo_Backend);

	-- Exits the main loop:
	procedure Exit_Main_Loop(This : in out Cairo_Backend);

	---- WINDOW OPERATIONS: ----

	-- Creates a new window, which is not shown on the screen before Show is called:
	function New_Window(This : in Cairo_Backend; Title : in String; Size : in Primitives.Dimension;
		Position : in Primitives.Point := (0, 0);
		Parent : in Backends.Window_Data_Pointer := Backends.Null_Window_Data_Pointer)
		return Backends.Window_Data_Pointer;

	-- Destroys a window:
	procedure Destroy_Window(This : in out Cairo_Backend; Window_Data : in out Backends.Window_Data_Pointer);

	-- Gets the ID for a window:
	function Get_Window_ID(This : in Cairo_Backend; Window_Data : in Backends.Window_Data_Pointer)
		return Backends.Window_ID_Type;

	-- Sets the title for a window:
	procedure Set_Window_Title(This : in Cairo_Backend; Window_Data : in Backends.Window_Data_Pointer;
		Title : in String);

	-- Sets the size of a window:
	procedure Set_Window_Size(This : in Cairo_Backend; Window_Data : in Backends.Window_Data_Pointer;
		Size : in Primitives.Dimension);

	-- Sets the window visibility on the screen:
	procedure Set_Window_Visibility(This : in Cairo_Backend; Window_Data : in Backends.Window_Data_Pointer;
		Visibility : in Boolean);

	---- DRAWING OPERATIONS: ----

	-- Draws a line:
	procedure Draw_Line(This : in out Cairo_Backend; Window_Data : in Window_Data_Pointer;
		Origin, Destination : in Primitives.Point; Color : in Colors.Color := Colors.BLACK;
		Line_Width : in Float := 1.0);

	-- Draws a circle:
	procedure Draw_Circle(This : in out Cairo_Backend; Window_Data : in Window_Data_Pointer;
		Origin : in Primitives.Point; Radius : in Float; Arc : in Float := 2.0 * Pi;
		Color : in Colors.Color := Colors.BLACK; Line_Width : in Float := 1.0);

	-- Fills an area with a color:
	procedure Fill_Area(This : in out Cairo_Backend; Window_Data : in Window_Data_Pointer;
		Area : in Primitives.Rectangle; Color : in Colors.Color);
private

	-- Cairo backend type record:
	type Cairo_Backend is new Backends.Backend with record
			Initialized : Boolean := false;
		end record;

end Cupcake.Backends.Cairo;

