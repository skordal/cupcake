-- The Cupcake GUI Toolkit
-- (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
-- Report bugs and issues on <http://github.com/skordal/cupcake/issues>

with Ada.Numerics;
with System;

with Cupcake.Colors;
with Cupcake.Primitives;

package Cupcake.Backends is
	use Ada.Numerics;

	-- Interface implemented by backends:
	type Backend is limited interface;
	type Backend_Access is access all Backend'Class;

	-- Backend exceptions:
	Initialization_Error : exception;

	-- Gets and sets the backend to be used for operations:
	function Get_Backend return Backend_Access with Inline;
	procedure Set_Backend(Use_Backend : in Backend_Access) with Inline;

	---- GENERAL BACKEND OPERATIONS: ----

	-- Gets the name of the backend:
	function Get_Name(This : in Backend) return String is abstract;

	-- Initializes the backend:
	procedure Initialize(This : in out Backend) is abstract;

	-- Checks if the backend has been initialized:
	function Is_Initialized(This : in Backend) return Boolean is abstract;

	-- Finalizes the backend:
	procedure Finalize(This : in out Backend) is abstract;

	-- Enters the main loop:
	procedure Enter_Main_Loop(This : in out Backend) is abstract;

	-- Exits the main loop:
	procedure Exit_Main_Loop(This : in out Backend) is abstract;

	---- BACKEND WINDOW OPERATIONS: ----

	-- Backend window type:
	type Window_Data_Pointer is new System.Address;
	Null_Window_Data_Pointer : constant Window_Data_Pointer := Window_Data_Pointer(System.Null_Address);

	-- Creates a new window:
	function New_Window(This : in Backend; Title : in String;
		Size : in Primitives.Dimension; Position : in Primitives.Point := (0, 0);
		Parent : in Window_Data_Pointer := Null_Window_Data_Pointer)
		return Window_Data_Pointer is abstract;

	-- Destroys a window:
	procedure Destroy_Window(This : in out Backend; Window_Data : in out Window_Data_Pointer)
		is abstract;

	-- Sets the title of a window:
	procedure Set_Window_Title(This : in Backend; Window_Data : in Window_Data_Pointer;
		Title : in String) is abstract;

	-- Sets the window visibility on screen:
	procedure Set_Window_Visibility(This : in Backend; Window_Data : in Window_Data_Pointer;
		Visibility : in Boolean) is abstract;

	---- WINDOW DRAWING OPERATIONS: ----

	-- Draws a straight line between two points:
	procedure Draw_Line(This : in out Backend; Window_Data : in Window_Data_Pointer;
		Origin, Destination : in Primitives.Point; Color : in Colors.Color := Colors.BLACK;
		Line_Width : in Float := 1.0) is abstract;

	-- Draws a circle with specified centre and radius; draws the circle between 0 and
	-- the specified amount of radians. This value can be negative, in which case the
	-- circle will be drawn counter-clockwise:
	procedure Draw_Circle(This : in out Backend; Window_Data : in Window_Data_Pointer;
		Origin : in Primitives.Point; Radius : in Float; Arc : in Float := 2.0 * Pi;
		Color : in Colors.Color := Colors.BLACK; Line_Width : in Float := 1.0) is abstract;

	-- Fills the specified area with the specified color:
	procedure Fill_Area(This : in out Backend; Window_Data : in Window_Data_Pointer;
		Area : in Primitives.Rectangle; Color : in Colors.Color) is abstract;

	---- FONT OPERATIONS: ----

	-- Backend font type:
	type Font_Data_Pointer is new System.Address;

private

	-- The active backend:
	Active_Backend : Backend_Access := null;

end Cupcake.Backends;

