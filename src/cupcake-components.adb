-- The Cupcake GUI Toolkit
-- (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
-- Report bugs and issues on <http://github.com/skordal/cupcake/issues>

with Cupcake.Colors;

package body Cupcake.Components is

	-- Default mouse handler which ignores mouse events:
	function Mouse_Handler(This : in Component_Record; Mouse_Event : in Events.Mouse_Event_Record)
		return Boolean is
	begin
		return true;
	end Mouse_Handler;

	-- Default keyboard handler which ignores keyboard events:
	function Keyboard_Handler(This : in Component_Record; Keyboard_Event : in Events.Keyboard_Event_Record)
		return Boolean is
	begin
		return true;
	end Keyboard_Handler;

	-- Sets the expanding property of a component:
	procedure Set_Expanding(This : out Component_Record'Class; Expanding : in Boolean := true) is
	begin
		This.Expanding := Expanding;
	end Set_Expanding;

	-- Gets the expanding property of a component:
	function Get_Expanding(This : in Component_Record'Class) return Boolean is
	begin
		return This.Expanding;
	end Get_Expanding;

	-- Gets the preferred size of a component:
	function Get_Preferred_Size(This : in Component_Record'Class) return Primitives.Dimension is
	begin
		return This.Preferred_Size;
	end Get_Preferred_Size;

	-- Creates a new label component:
	function New_Label(Text : in String; Expanding : in Boolean := false) return Component is
		Retval : constant Component := new Label_Record;
		Size : constant Primitives.Dimension := (Integer(Default_Font.Get_Size) * Text'Length,
			Integer(Default_Font.Get_Size));
	begin
		Label_Record(Retval.all).Text := To_Unbounded_String(Text);
		Label_Record(Retval.all).Minimum_Size := Size;
		Label_Record(Retval.all).Preferred_Size := Size;
		Label_Record(Retval.all).Size := Size;
		Label_Record(Retval.all).Expanding := Expanding;

		return Retval;
	end New_label;

	-- Expose handler for the label component:
	procedure Expose_Handler(This : in out Label_Record; Graphics_Context : in Graphics.Context) is
		Text_String : constant String := To_String(This.Text);
		Text_Width : constant Natural := Graphics_Context.Get_String_Length(Text_String, Default_Font);
		X_Offset, Y_Offset : Natural := 0;
	begin
		if not This.Expanding then
			This.Size.Width := Text_Width;
		end if;

		if This.Expanding then
			X_Offset := (Graphics_Context.Get_Size.Width - Text_Width) / 2;
			Y_Offset := (Graphics_Context.Get_Size.Height - Natural(Default_Font.Get_Size)) / 2;
		end if;

		Graphics_Context.Render_String(Colors.BLACK, Text_String, Default_Font, 
			(X_Offset, Y_Offset + Natural(Default_Font.Get_Size)));
	end Expose_Handler;

end Cupcake.Components;

