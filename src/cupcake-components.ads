-- The Cupcake GUI Toolkit
-- (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
-- Report bugs and issues on <http://github.com/skordal/cupcake/issues>

private with Ada.Strings.Unbounded;

with Cupcake.Colors;
with Cupcake.Events;
with Cupcake.Fonts;
with Cupcake.Graphics;
with Cupcake.Primitives;

package Cupcake.Components is

	-- Constant for unbounded component dimensions, i.e. components that are infinitely
	-- expandable:
	Unbounded_Size : constant Primitives.Dimension := (Natural'Last, Natural'Last);

	---- COMPONENT BASE CLASS ----

	-- Component base type:
	type Component_Record is abstract new Events.Event_Receiver with private;
	type Component is access all Component_Record'Class;

	-- Event handlers for components:
	procedure Expose_Handler(This : in out Component_Record; Graphics_Context : in Graphics.Context) is abstract;
	procedure Resize_Handler(This : in out Component_Record; New_Size : in Primitives.Dimension) is null;
	function Mouse_Handler(This : in Component_Record; Mouse_Event : in Events.Mouse_Event_Record)
		return Boolean;
	function Keyboard_Handler(This : in Component_Record; Keyboard_Event : in Events.Keyboard_Event_Record)
		return Boolean;

	---- LABEL COMPONENT ----

	-- Label component:
	type Label_Record (<>) is new Component_Record with private;

	-- Creates a new label:
	function New_Label(Text : in String) return Component;

	-- Expose handler for the label:
	overriding procedure Expose_Handler(This : in out Label_Record; Graphics_Context : in Graphics.Context);

private
	use Ada.Strings.Unbounded;

	-- Default font for use in components, initializes when the first component
	-- is created:
	Default_Font : Fonts.Font := Fonts.New_Font(Fonts.SANS_SERIF, Fonts.PLAIN, 12.0);

	-- Component base type definition:
	type Component_Record is abstract new Events.Event_Receiver with record
			Background_Color : Colors.Color := Colors.DEFAULT_BACKGROUND_COLOR;
			Foreground_Color : Colors.Color := Colors.DEFAULT_FOREGROUND_COLOR;
		end record;

	-- Label component type definition:
	type Label_Record is new Component_Record with record
			Text : Unbounded_String;
			Font : Fonts.Font := Default_Font;
		end record;

end Cupcake.Components;

