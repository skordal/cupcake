-- The Cupcake GUI Toolkit
-- (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
-- Report bugs and issues on <http://github.com/skordal/cupcake/issues>

with Cupcake.Components;
with Cupcake.Events;
with Cupcake.Graphics;
with Cupcake.Primitives;

private with Ada.Containers.Vectors;

package Cupcake.Layouts is

	-- Layout base type - inherits from Component_Record, so that nested layouts
	-- becomes possible:
	type Layout_Record is abstract new Components.Component_Record with private;
	type Layout is access all Layout_Record'Class;

	procedure Destroy(Object : not null access Layout_Record) is abstract;

	-- Event handlers, passes events on to the layout's components:
	procedure Expose_Handler(This : in out Layout_Record; Graphics_Context : in Graphics.Context) is null;
	procedure Resize_Handler(This : in out Layout_Record; New_Size : in Primitives.Dimension);
	function Mouse_Handler(This : in Layout_Record; Mouse_Event : in Events.Mouse_Event_Record)
		return Boolean;
	function Keyboard_Handler(This : in Layout_Record; Keyboard_Event : in Events.Keyboard_Event_Record)
		return Boolean;

	-- Adds a component to a layout:
	procedure Add_Component(This : in out Layout_Record; Component : in Components.Component)
		is abstract;

	-- Simple layout, centers or expands a simple component:
	type Simple_Layout_Record (<>) is new Layout_Record with private;

	-- Creates a simple layout:
	function New_Simple_Layout return Layout;

	-- Destroys a simple layout:
	procedure Destroy(Object : not null access Simple_Layout_Record);

	overriding procedure Add_Component(This : in out Simple_Layout_Record;
		Component : in Components.Component);
	pragma Inline(Add_Component);
	overriding procedure Expose_Handler(This : in out Simple_Layout_Record;
		Graphics_Context : in Graphics.Context);

private
	-- Component vector:
	use Components; -- Used to get access to the "=" operator for Components.Component
	package Component_Vectors is new Ada.Containers.Vectors(Index_Type => Positive,
		Element_Type => Components.Component);

	-- Layout base type definition:
	type Layout_Record is abstract new Components.Component_Record with record
			Size : Primitives.Dimension;
		end record;

	-- Simple layout type definition:
	type Simple_Layout_Record is new Layout_Record with record
			Component : Components.Component := null;
		end record;

end Cupcake.Layouts;

