-- The Cupcake GUI Toolkit
-- (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
-- Report bugs and issues on <http://github.com/skordal/cupcake/issues>

with Ada.Unchecked_Deallocation;

package body Cupcake.Windows is

	-- Creates a new window:
	function New_Window(Width, Height : in Positive; Title : in String) return Window is
		Size : constant Primitives.Dimension := (Width, Height);
	begin
		return New_Window(Size, Title);
	end New_Window;

	-- Creates a new window:
	function New_Window(Size : in Primitives.Dimension; Title : in String) return Window is
		Retval : constant Window := new Window_Record;
	begin
		Retval.Backend_Data := Backends.Get_Backend.New_Window(Title, Size);
		Retval.ID := Backends.Get_Backend.Get_Window_ID(Retval.Backend_Data);
		Retval.Size := Size;
		return Retval;
	end New_Window;

	-- Destroys a window:
	procedure Destroy(Object : not null access Window_Record) is
		-- Deallocation procedure for window records:
		type Window_Access is access all Window_Record;
		procedure Free is new Ada.Unchecked_Deallocation(Object => Window_Record,
			Name => Window_Access);

		Win : Window_Access := Window_Access(Object);
	begin
		Object.Set_Visible(false);
		Backends.Get_Backend.Destroy_Window(Object.Backend_Data);
		Free(Win);
	end Destroy;

	-- Sets the visibility of a window:
	procedure Set_Visible(This : access Window_Record'Class; Visible : Boolean := true) is
		use Window_Lists;
		Window_Cursor : Cursor := Window_List.Find(Item => This);
	begin
		Backends.Get_Backend.Set_Window_Visibility(This.Backend_Data, Visible);
		if Visible and not Has_Element(Window_Cursor) then
			Window_List.Append(This);
		elsif not Visible and Has_Element(Window_Cursor) then
			Window_List.Delete(Window_Cursor);
		end if;
	end Set_Visible;

	-- Gets the size of a window:
	function Get_Size(This : in Window_Record'Class) return Primitives.Dimension is
	begin
		return This.Size;
	end Get_Size;

	-- Sets the size of a window:
	procedure Set_Size(This : in out Window_Record'Class; Size : in Primitives.Dimension) is
	begin
		Backends.Get_Backend.Set_Window_Size(This.Backend_Data, Size);
	end Set_Size;

	-- Gets the background color of a window:
	function Get_Background_Color(This : in Window_Record'Class) return Colors.Color is
	begin
		return This.Background_Color;
	end Get_Background_Color;

	-- Sets the background color of a window:
	procedure Set_Background_Color(This : out Window_Record'Class; Color : in Colors.Color) is
	begin
		This.Background_Color := Color;
	end Set_Background_Color;

end Cupcake.Windows;

