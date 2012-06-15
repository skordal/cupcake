-- The Cupcake GUI Toolkit
-- (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
-- Report bugs and issues on <http://github.com/skordal/cupcake/issues>

with Ada.Text_IO;
with Interfaces.C.Strings;

package body Cupcake.Backends.Cairo is
	-- Procedure settings the current color, used by several subprograms below:
	procedure Backend_Set_Color(Window_Data : in Backends.Window_Data_Pointer;
		R, G, B : in Colors.Color_Component_Type);
	pragma Import(C, Backend_Set_Color);

	-- Gets the name of the backend:
	function Get_Name(This : in Cairo_Backend) return String is
		pragma Unreferenced(This);
	begin
		return "cairo";
	end Get_Name;

	-- Initializes the backend:
	procedure Initialize(This : in out Cairo_Backend) is
		function Backend_Initialize return Integer;
		pragma Import(C, Backend_Initialize);
	begin
		if Backend_Initialize /= 1 then
			raise Initialization_Error;
		end if;

		This.Initialized := true;
	end Initialize;

	-- Checks if the backend has been initialized:
	function Is_Initialized(This : in Cairo_Backend) return Boolean is
	begin
		return This.Initialized;
	end Is_Initialized;

	-- Finalizes the backend:
	procedure Finalize(This : in out Cairo_Backend) is
		procedure Backend_Finalize;
		pragma Import(C, Backend_Finalize);
	begin
		if This.Initialized then
			Backend_Finalize;
			This.Initialized := false;
		elsif Debug_Mode then
			Ada.Text_IO.Put_Line("[Cupcake.Backends.Cairo.Cairo_Backend.Finalize] "
				& "Cannot finalize an uninitialized backend!");
		end if;
	end Finalize;

	-- Enters the main loop:
	procedure Enter_Main_Loop(This : in out Cairo_Backend) is
		pragma Unreferenced(This);

		procedure Backend_Main_Loop;
		pragma Import(C, Backend_Main_Loop);
	begin
		Backend_Main_Loop;
	end Enter_Main_Loop;

	-- Exits the main loop:
	procedure Exit_Main_Loop(This : in out Cairo_Backend) is
		pragma Unreferenced(This);

		procedure Backend_Main_Loop_Terminate;
		pragma Import(C, Backend_Main_Loop_Terminate);
	begin
		Backend_Main_Loop_Terminate;
	end Exit_Main_Loop;

	-- Creates a new window:
	function New_Window(This : in Cairo_Backend; Title : in String; Size : in Primitives.Dimension;
		Position : in Primitives.Point := (0, 0);
		Parent : in Window_Data_Pointer := Null_Window_Data_Pointer) return Window_Data_Pointer is
		use Cupcake.Primitives;

		function Backend_Window_Create(Parent : in Window_Data_Pointer;
			Width, Height : Positive) return Window_Data_Pointer;
		pragma Import(C, Backend_Window_Create);

		Retval : constant Window_Data_Pointer := Backend_Window_Create(Parent,
			Size.Width, Size.Height);
	begin
		if Debug_Mode and then Position /= (0, 0) then
			Ada.Text_IO.Put_Line("[Cupcake.Backends.Cairo.Cairo_Backend.New_Window] "
				& "The position argument is currently ignored.");
		end if;

		This.Set_Window_Title(Retval, Title);
		return Retval;
	end New_Window;

	-- Destroys a window:
	procedure Destroy_Window(This : in out Cairo_Backend; Window_Data : in out Window_Data_Pointer) is
		pragma Unreferenced(This);

		procedure Backend_Window_Finalize(Window : in out Window_Data_Pointer);
		pragma Import(C, Backend_Window_Finalize);
	begin
		Backend_Window_Finalize(Window_Data);
	end Destroy_Window;

	-- Gets the ID for a window:
	function Get_Window_ID(This : in Cairo_Backend; Window_Data : in Backends.Window_Data_Pointer)
		return Backends.Window_ID_Type is

		function Backend_Window_Get_ID(Window_Data : in Window_Data_Pointer)
			return Backends.Window_ID_Type;
		pragma Import(C, Backend_Window_Get_ID);
	begin
		return Backend_Window_Get_ID(Window_Data);
	end Get_Window_ID;

	-- Sets the title of a window:
	procedure Set_Window_Title(This : in Cairo_Backend; Window_Data : in Window_Data_Pointer;
		Title : in String) is
		use Interfaces.C.Strings;
		pragma Unreferenced(This);

		procedure Backend_Window_Set_Title(Window_Data : in Window_Data_Pointer;
			Title : in chars_ptr);
		pragma Import(C, Backend_Window_Set_Title);
		C_Title : chars_ptr := New_String(Title);
	begin
		Backend_Window_Set_Title(Window_Data, C_Title);
		Free(C_Title);
	end Set_Window_Title;

	-- Sets the window visibility:
	procedure Set_Window_Visibility(This : in Cairo_Backend; Window_Data : in Window_Data_Pointer;
		Visibility : in Boolean) is
		pragma Unreferenced(This);

		procedure Backend_Window_Show(Window_Data : in Window_Data_Pointer);
		procedure Backend_Window_Close(Window_Data : in Window_Data_Pointer);
		pragma Import(C, Backend_Window_Show);
		pragma Import(C, Backend_Window_Close);
	begin
		if Visibility then
			Backend_Window_Show(Window_Data);
		else
			Backend_Window_Close(Window_Data);
		end if;
	end Set_Window_Visibility;

	-- Draws a line:
	procedure Draw_Line(This : in out Cairo_Backend; Window_Data : in Window_Data_Pointer;
		Origin, Destination : in Primitives.Point; Color : in Colors.Color := Colors.BLACK;
		Line_Width : in Float := 1.0) is
		pragma Unreferenced(This);

		procedure Backend_Draw_Line(Window_Data : in Window_Data_Pointer;
			X1, Y1, X2, Y2 : Natural; Line_Width : in Float);
		pragma Import(C, Backend_Draw_Line);
	begin
		Backend_Set_Color(Window_Data, Color.R, Color.G, Color.B);
		Backend_Draw_Line(Window_Data, Origin.X, Origin.Y, Destination.X, Destination.Y,
			Line_Width);
	end Draw_Line;

	-- Draws a circle:
	procedure Draw_Circle(This : in out Cairo_Backend; Window_Data : in Window_Data_Pointer;
		Origin : in Primitives.Point; Radius : in Float; Arc : in Float := 2.0 * Pi;
		Color : in Colors.Color := Colors.BLACK; Line_Width : in Float := 1.0) is
		pragma Unreferenced(This);
	begin
		Ada.Text_IO.Put_Line("[Cupcake.Backends.Cairo.Cairo_Backend.Draw_Circle] "
			& "Not implemented!");
	end Draw_Circle;

	-- Fills an area:
	procedure Fill_Area(This : in out Cairo_Backend; Window_Data : in Window_Data_Pointer;
		Area : in Primitives.Rectangle; Color : in Colors.Color) is
		pragma Unreferenced(This);

		procedure Backend_Fill_Rectangle(Window_Data : in Window_Data_Pointer;
			X, Y, W, H : Natural);
		pragma Import(C, Backend_Fill_Rectangle);
	begin
		Backend_Set_Color(Window_Data, Color.R, Color.G, Color.B);
		Backend_Fill_Rectangle(Window_Data, Area.Origin.X, Area.Origin.Y,
			Area.Size.Width, Area.Size.Height);
	end Fill_Area;

end Cupcake.Backends.Cairo;


