-- The Cupcake GUI Toolkit
-- (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
-- Report bugs and issues on <http://github.com/skordal/cupcake/issues>

with Ada.Text_IO;
with Ada.Unchecked_Deallocation;
with Interfaces.C.Strings;

package body Cupcake.Windows is
	package C renames Interfaces.C;

	-- Available backend functions:
	function Backend_Window_Create(Parent : in Backend_Data_Ptr;
		Width, Height : in Positive) return Backend_Data_Ptr;
	procedure Backend_Window_Finalize(Window : in Backend_Data_Ptr);
	procedure Backend_Window_Set_Title(Window : in Backend_Data_Ptr;
		Title : in C.Strings.chars_ptr);
	function Backend_Window_Get_ID(Window : in Backend_Data_Ptr) return Window_ID_Type;
	procedure Backend_Window_Show(Window : in Backend_Data_Ptr);
	procedure Backend_Window_Close(Window : in Backend_Data_Ptr);

	pragma Import(C, Backend_Window_Create, "backend_window_create");
	pragma Import(C, Backend_Window_Finalize, "backend_window_finalize");
	pragma Import(C, Backend_Window_Set_Title, "backend_window_set_title");
	pragma Import(C, Backend_Window_Get_ID, "backend_window_get_id");
	pragma Import(C, Backend_Window_Show, "backend_window_show");
	pragma import(C, Backend_Window_Close, "backend_window_close");

	-- Creates a new window:
	function New_Window(Width, Height : in Positive; Title : in String) return Window is
		Size : constant Primitives.Dimension := (Width, Height);
	begin
		return New_Window(Size, Title);
	end New_Window;

	-- Creates a new window:
	function New_Window(Size : in Primitives.Dimension; Title : in String) return Window is
		Retval : constant Window := new Window_Record;
		C_Title : C.Strings.chars_ptr := C.Strings.New_String(Title);
	begin
		Retval.Backend_Data := Backend_Window_Create(System.Null_Address,
			Size.Width, Size.Height);
		Retval.Window_ID := Backend_Window_Get_ID(Retval.Backend_Data);
		Retval.Size := Size;

		Backend_Window_Set_Title(Retval.Backend_Data, C_Title);
		C.Strings.Free(C_Title);

		Retval.Graphics_Context := Graphics.New_Context(Retval.Backend_Data, Size);

		Window_List.Append(Retval);

		return Retval;
	end New_Window;

	-- Destroys a window:
	procedure Destroy(Object : not null access Window_Record) is
		use Cupcake.Layouts;

		-- Deallocation procedure for window records:
		type Window_Access is access all Window_Record;
		procedure Free is new Ada.Unchecked_Deallocation(Object => Window_Record,
			Name => Window_Access);

		Win : Window_Access := Window_Access(Object);
	begin
		if Object.Layout /= null then
			Layouts.Destroy(Object.Layout);
		end if;

		Object.Close;
		Backend_Window_Finalize(Object.Backend_Data);
		Free(Win);
	end Destroy;

	-- Shows a window:
	procedure Show(This : in Window_Record'Class) is
	begin
		Backend_Window_Show(This.Backend_Data);
	end Show;

	-- Closes a window:
	procedure Close(This : in Window_Record'Class) is
	begin
		Backend_Window_Close(This.Backend_Data);
	end Close;

	-- Gets the window ID:
	function Get_ID(This : in Window_Record'Class) return Window_ID_Type is
	begin
		return This.Window_ID;
	end Get_ID;

	-- Gets the size of a window:
	function Get_Size(This : in Window_Record'Class) return Primitives.Dimension is
	begin
		return This.Size;
	end Get_Size;

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

	-- Sets the layout of a window:
	procedure Set_Layout(This : out Window_Record'Class; Layout : in Layouts.Layout) is
	begin
		This.Layout := Layout;
	end Set_Layout;

	-- Gets the layout of a window:
	function Get_Layout(This : in Window_Record'Class) return Layouts.Layout is
	begin
		return This.Layout;
	end Get_Layout;

	-- Expose handlers for windows:
	procedure Expose_Handler(This : in out Window_Record; Graphics_Context : in Graphics.Context) is
		use Cupcake.Layouts;
		Entire_Window : constant Primitives.Rectangle := ((0, 0), This.Get_Size);
	begin
		Graphics_Context.Fill(This.Get_Background_Color, Entire_Window);
		if This.Layout /= null then
			if Debug_Mode then
				Ada.Text_IO.Put_Line(
					"[Window_Record => Expose_Handler] Propagating expose event to layout");
			end if;
			This.Layout.Expose_Handler(Graphics_Context);
		end if;
	end Expose_Handler;

	-- Resize handler for windows:
	procedure Resize_Handler(This : in out Window_Record; New_Size : in Primitives.Dimension) is
		use Cupcake.Layouts;
	begin
		This.Size := New_Size;
		This.Graphics_Context.Set_Size(New_Size);
		if This.Layout /= null then
			This.Layout.Resize_Handler(New_Size);
		end if;
	end Resize_Handler;

	-- Mouse event handler:
	function Mouse_Handler(This : in Window_Record; Mouse_Event : in Events.Mouse_Event_Record)
		return Boolean is
	begin
		return true;
	end Mouse_Handler;

	-- Keyboard event handler:
	function Keyboard_Handler(This : in Window_Record; Keyboard_Event : in Events.Keyboard_Event_Record)
		return Boolean is
	begin
		return true;
	end Keyboard_Handler;

	-- Window closing handler:
	function Window_Closing_Handler(This : in Window_Record) return Boolean is
	begin
		return true;
	end Window_Closing_Handler;

	-- Window closing message handler:

	-- Finds a window by its ID:
	function Find_Window_By_ID(ID : in Window_ID_Type) return Window is
		use Window_Lists;
		Window_Cursor : Cursor := Window_List.First;
	begin
		while Has_Element(Window_Cursor) loop
			if Element(Window_Cursor).Window_ID = ID then
				return Element(Window_Cursor);
			end if;
			Window_Cursor := Next(Window_Cursor);
		end loop;

		return null;
	end Find_Window_By_ID;

	-- Gets the backend specific data pointer from a window by its ID:
	function Get_Backend_Data_For_Window_By_ID(ID : in Window_ID_Type) return Backend_Data_Ptr is
		Target : constant Window := Find_Window_By_ID(ID);
	begin
		return Target.Backend_Data;
	end Get_Backend_Data_For_Window_By_ID;

	-- Posts an expose event to a window:
	procedure Post_Expose(ID : in Window_ID_Type) is
		use Cupcake.Events;
		Target : constant Window := Find_Window_By_ID(ID);
	begin
		if Debug_Mode then
			Ada.Text_IO.Put_Line("Expose event received for window"
				& Window_ID_Type'Image(ID));
		end if;

		if Target = null then
			Ada.Text_IO.Put_Line("Invalid window ID" & Window_ID_Type'Image(ID));
		else
			Target.Expose_Handler(Target.Graphics_Context);
		end if;
	end Post_Expose;

	-- Posts a window close event to a window:
	function Post_Window_Close(ID : in Window_ID_Type) return Integer is
		use Cupcake.Events;
		Target : constant Window := Find_Window_By_ID(ID);
		Target_Cursor : Window_Lists.Cursor := Window_List.Find(Target);
		Closing : Boolean := false;
	begin
		Ada.Text_IO.Put_Line("Window close event received for window"
			& Window_ID_Type'Image(ID));
	
		if Target = null or not Window_Lists.Has_Element(Target_Cursor) then
			Ada.Text_IO.Put_Line("Invalid window ID or not visible window: "
				& Window_ID_Type'Image(ID));
			return 0;
		end if;

		Closing := Target.Window_Closing_Handler;

		if Closing then
			Window_List.Delete(Target_Cursor);
			return 1;
		else
			return 0;
		end if;
	end Post_Window_Close;

	-- Gets the number of windows remaining:
	function Get_Num_Windows_Remaining return Natural is
	begin
		return Natural(Window_List.Length);
	end Get_Num_Windows_Remaining;

end Cupcake.Windows;

