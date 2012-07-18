-- The Cupcake GUI Toolkit
-- (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
-- Report bugs and issues on <http://github.com/skordal/cupcake/issues>

with Ada.Text_IO;
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
		Window_Cursor : Cursor := Visible_Window_List.Find(Item => This);
	begin
		Backends.Get_Backend.Set_Window_Visibility(This.Backend_Data, Visible);
		if Visible and not Has_Element(Window_Cursor) then
			Visible_Window_List.Append(This);
		elsif not Visible and Has_Element(Window_Cursor) then
			Visible_Window_List.Delete(Window_Cursor);
		end if;
	end Set_Visible;

	-- Gets the ID of a window:
	function Get_ID(This : in Window_Record'Class) return Backends.Window_ID_Type is
	begin
		return This.ID;
	end Get_ID;

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

	-- Expose event handler:
	procedure Expose_Handler(This : in Window_Record'Class) is
	begin
		Backends.Get_Backend.Fill_Area(This.Backend_Data, ((0, 0), This.Size), This.Background_Color);
	end Expose_Handler;

	-- Resize event handler:
	procedure Resize_Handler(This : in out Window_Record'Class; New_Size : in Primitives.Dimension) is
	begin
		This.Size := New_Size;
	end Resize_Handler;

	-- Posts an expose event to a window:
	procedure Post_Expose(ID : in Backends.Window_ID_Type) is
		Target : constant Window := Get_Visible_Window(ID);
	begin
		if Target /= null then
			Target.Post_Expose;
		end if;
	end Post_Expose;

	-- Posts an expose event to a window:
	procedure Post_Expose(This : in Window_Record'Class) is
	begin
		if Debug_Mode then
			Ada.Text_IO.Put_Line("[Cupcake.Windows.Post_Expose] "
				& "Expose received for window ID "
				& Backends.Window_ID_Type'Image(This.Get_ID));
		end if;

		This.Expose_Handler;
	end Post_Expose;

	-- Posts a resize event to a window:
	procedure Post_Resize(ID : in Backends.Window_ID_Type; Width, Height : in Natural) is
	begin
		Post_Resize(ID, (Width, Height));
	end Post_Resize;

	-- Posts a resize event to a window:
	procedure Post_Resize(ID : in Backends.Window_ID_Type; New_Size : in Primitives.Dimension) is
		use Primitives;
		Target : constant Window := Get_Visible_Window(ID);
	begin
		if Target /= null and then Target.Size /= New_Size then
			if Debug_Mode then
				Ada.Text_IO.Put_Line("[Cupcake.Windows.Post_Resize] "
					& "Resize event received for window ID "
					& Backends.Window_ID_Type'Image(ID));
			end if;
			Target.Resize_Handler(New_Size);
		end if;
	end Post_Resize;

	-- Gets a pointer to a visible window or null if no window was found:
	function Get_Visible_Window(ID : in Backends.Window_ID_Type) return Window is
		use Backends;
	begin
		for Win of Visible_Window_List loop
			if Win.ID = ID then
				return Win;
			end if;
		end loop;

		return null;
	end Get_Visible_Window;

end Cupcake.Windows;

