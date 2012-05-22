-- The Cupcake GUI Toolkit
-- (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
-- Report bugs and issues on <http://github.com/skordal/cupcake/issues>

package body Cupcake.Components is

	-- Default mouse handler which ignores mouse events:
	function Mouse_Handler(This : in Component_Record; Mouse_Event : in Events.Mouse_Event_Record)
		return Boolean is
		pragma Unreferenced(This, Mouse_Event);
	begin
		return true;
	end Mouse_Handler;

	-- Default keyboard handler which ignores keyboard events:
	function Keyboard_Handler(This : in Component_Record; Keyboard_Event : in Events.Keyboard_Event_Record)
		return Boolean is
		pragma Unreferenced(This, Keyboard_Event);
	begin
		return true;
	end Keyboard_Handler;

	-- Creates a new label component:
	function New_Label(Text : in String) return Component is
		Retval : constant Component := new Label_Record;
	begin
		Label_Record(Retval.all).Text := To_Unbounded_String(Text);
		return Retval;
	end New_label;

	-- Expose handler for the label component:
	procedure Expose_Handler(This : in out Label_Record; Graphics_Context : in Graphics.Context) is
		Text_String : constant String := To_String(This.Text);
	begin
		Graphics_Context.Render_String(This.Foreground_Color, Text_String, This.Font,
			(0, Natural(This.Font.Get_Size)));
	end Expose_Handler;

end Cupcake.Components;

