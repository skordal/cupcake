-- The Cupcake GUI Toolkit
-- (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
-- Report bugs and issues on <http://github.com/skordal/cupcake/issues>

with Ada.Finalization;
with Cupcake.Primitives;
private with Cupcake.Events;

private with System;
private with Ada.Containers.Doubly_Linked_Lists;

package Cupcake.Windows is
	use Ada;

	-- Normal window type:
	type Window_Record (<>) is new Finalization.Limited_Controlled with private;
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

	-- Shows a window. This procedure sends a Window_Shown event to the window.
	procedure Show(This : in Window_Record'Class);
	pragma Inline(Show);

	-- Closes a window. This procedure sends a Window_Closing event to the window.
	procedure Close(This : in Window_Record'Class);
	pragma Inline(Close);

	-- Window size operations:
	function Get_Size(This : in Window_Record) return Primitives.Dimension;
	pragma Inline(Get_Size);

	-- Gets the window ID:
	function Get_ID(This : in Window_Record'Class) return Window_ID_Type;
	pragma Inline(Get_ID);

private
	-- List of displayed application windows, used for event propagation:
	package Window_Lists is new Ada.Containers.Doubly_Linked_Lists(Window);
	Window_List : Window_Lists.List;

	-- Type used for the pointer to backend specific data:
	subtype Backend_Data_Ptr is System.Address;

	-- Normal window type definition:
	type Window_Record is new Finalization.Limited_Controlled with record
			Window_ID : Window_ID_Type;
			Size : Primitives.Dimension;
			Backend_Data : Backend_Data_Ptr;
			Event_Handlers : Events.Event_Handler_Set;
		end record;

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

