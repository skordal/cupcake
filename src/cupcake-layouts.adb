-- The Cupcake GUI Toolkit
-- (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
-- Report bugs and issues on <http://github.com/skordal/cupcake/issues>

with Ada.Unchecked_Deallocation;

package body Cupcake.Layouts is

	-- Default resize handler for layouts, sets the size of the layout and calls Recalculate:
	procedure Resize_Handler(This : in out Layout_Record; New_Size : in Primitives.Dimension) is
	begin
		This.Size := New_Size;
	end Resize_Handler;

	-- Default mouse handler for layouts, does nothing:
	function Mouse_Handler(This : in Layout_Record; Mouse_Event : in Events.Mouse_Event_Record)
		return Boolean is
	begin
		return true;
	end Mouse_Handler;

	-- Default keyboard handler for layouts, does nothing:
	function Keyboard_Handler(This : in Layout_Record; Keyboard_Event : in Events.Keyboard_Event_Record)
		return Boolean is
	begin
		return true;
	end Keyboard_Handler;

	-- Creates a new simple layout:
	function New_Simple_Layout return Layout is
		Retval : constant Layout := new Simple_Layout_Record;
	begin
		return Retval;
	end New_Simple_Layout;

	-- Destroys a simple layout:
	procedure Destroy(Object : not null access Simple_Layout_Record) is
		type Simple_Layout_Access is access all Simple_Layout_Record;
		procedure Free is new Ada.Unchecked_Deallocation(Object => Simple_Layout_Record,
			Name => Simple_Layout_Access);
		O : Simple_Layout_Access := Simple_Layout_Access(Object);
	begin
		Free(O);
	end Destroy;

	-- Adds a component to a simple layout:
	procedure Add_Component(This : in out Simple_Layout_Record; Component : in Components.Component) is
	begin
		This.Component := Component;
	end Add_Component;

	-- Handles an expose event for a simple layout:
	procedure Expose_Handler(This : in out Simple_Layout_Record; Graphics_Context : in Graphics.Context) is
		use Cupcake.Primitives;
		Component_Size : Primitives.Dimension := This.Component.Get_Size;
		X_Position, Y_Position : Natural := 0;
	begin
		if This.Size = Primitives.Null_Dimension then
			This.Size := Graphics_Context.Get_Size;
		end if;

		if This.Component /= null then
			if This.Component.Get_Expanding then
				This.Component.Expose_Handler(Graphics_Context);
			else
				if Component_Size.Width <= Graphics_Context.Get_Size.Width then
					X_Position := (Graphics_Context.Get_Size.Width - Component_Size.Width) / 2;
				else
					Component_Size.Width := Graphics_Context.Get_Size.Width;
				end if;

				if Component_Size.Height <= Graphics_Context.Get_Size.Height then
					Y_Position := (Graphics_Context.Get_Size.Height - Component_Size.Height) / 2;
				else
					Component_Size.Height := Graphics_Context.Get_Size.Height;
				end if;

				This.Component.Expose_Handler(Graphics.New_Context(Graphics_Context,
					(X_Position, Y_Position), Component_Size));
			end if;
		end if;
	end Expose_Handler;

end Cupcake.Layouts;

