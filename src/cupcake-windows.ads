-- The Cupcake GUI Toolkit
-- (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
-- Report bugs and issues on <http://github.com/skordal/cupcake/issues>

with Ada.Finalization;

with Cupcake.Colors;
with Cupcake.Events;
with Cupcake.Primitives;

private with Ada.Containers.Doubly_Linked_Lists;
private with Cupcake.Graphics;

package Cupcake.Windows is
	use Ada;

	-- Normal window type:
	type Window_Record (<>) is new Finalization.Limited_Controlled and Events.Window_Event_Receiver with private;
	type Window is access all Window_Record'Class;

	-- Type used for window IDs:
	type Window_ID_Type is mod 2**32;
	for Window_ID_Type'Size use 32;

	-- Creates a new window:
	function New_Window(Width, Height : in Positive; Title : in String) return Window;
	function New_Window(Size : in Primitives.Dimension; Title : in String) return Window;

	-- Destroys a window:
	procedure Destroy(Object : not null access Window_Record);

	-- Finalizes a window:
	overriding procedure Finalize(Object : in out Window_Record);

	-- Window operations:
	procedure Show(This : in Window_Record'Class);
	procedure Close(This : in Window_Record'Class);
	pragma Inline(Show, Close);

	function Get_Size(This : in Window_Record'Class) return Primitives.Dimension;
	pragma Inline(Get_Size);

	function Get_Background_Color(This : in Window_Record'Class) return Colors.Color;
	procedure Set_Background_Color(This : out Window_Record'Class; Color : in Colors.Color);
	pragma Inline(Get_Background_Color, Set_Background_Color);

	-- Gets the window ID:
	function Get_ID(This : in Window_Record'Class) return Window_ID_Type;
	pragma Inline(Get_ID);

private
	-- List of displayed application windows, used for event propagation:
	package Window_Lists is new Ada.Containers.Doubly_Linked_Lists(Window);
	Window_List : Window_Lists.List;

	-- Normal window type definition:
	type Window_Record is new Finalization.Limited_Controlled and Events.Window_Event_Receiver with record
			Window_ID : Window_ID_Type;
			Size : Primitives.Dimension;
			Background_Color : Colors.Color := Colors.DEFAULT_BACKGROUND_COLOR;
			Graphics_Context : Graphics.Context;
			Backend_Data : Backend_Data_Ptr;
		end record;

	-- Event handlers for windows:
	procedure Expose_Handler(This : in Window_Record; Graphics_Context : in Graphics.Context);
	procedure Resize_Handler(This : in out Window_Record; New_Size : in Primitives.Dimension);
	function Mouse_Handler(This : in Window_Record; Mouse_Event : in Events.Mouse_Event_Record)
		return Boolean;
	function Keyboard_Handler(This : in Window_Record; Keyboard_Event : in Events.Keyboard_Event_Record)
		return Boolean;
	procedure Window_Shown_Handler(This : in Window_Record) is null;
	function Window_Closing_Handler(This : in Window_Record) return Boolean;

	-- Finds a window by its ID:
	function Find_Window_By_ID(ID : in Window_ID_Type) return Window;

	-- Gets the backend data pointer from a window by its ID:
	function Get_Backend_Data_For_Window_By_ID(ID : in Window_ID_Type) return Backend_Data_Ptr;
	pragma Export(C, Get_Backend_Data_For_Window_By_ID);

	-- Various methods used by the backend code to send events to windows:
	procedure Post_Expose(ID : in Window_ID_Type);
	function Post_Window_Close(ID : in Window_ID_Type) return Integer; -- 1 = close ok | 0 = don't close

	pragma Export(C, Post_Expose);
	pragma Export(C, Post_Window_Close);

	-- Method called to check if there are remaining windows:
	function Get_Num_Windows_Remaining return Natural;
	pragma Inline(Get_Num_Windows_Remaining);
	pragma Export(C, Get_Num_Windows_Remaining);

end Cupcake.Windows;

