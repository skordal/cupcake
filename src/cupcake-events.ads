-- The Cupcake GUI Toolkit
-- (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
-- Report bugs and issues on <http://github.com/skordal/cupcake/issues>

with Cupcake.Primitives;

package Cupcake.Events is

	-- Event numbers:
	type Event_Type is (
		EXPOSE, WINDOW_RESIZE, WINDOW_EVENT,
		MOUSE_ENTER, MOUSE_LEAVE, MOUSE_BUTTON_PRESS,
		MOUSE_BUTTON_RELEASE, MOUSE_MOVE, KEYBOARD_PRESS, KEYBOARD_RELEASE
	);

	-- Window event type:
	type Window_Event_Type is (
		WINDOW_SHOWN, WINDOW_CLOSED, WINDOW_MINIMIZED, WINDOW_MAXIMIZED
	);

	-- Mouse button type:
	type Mouse_Button_Type is (LEFT_BUTTON, MIDDLE_BUTTON, RIGHT_BUTTON);

	-- State of a button:
	type Button_State_Type is (UP, DOWN);

	-- Type of keyboard event:
	type Keyboard_Event_Type is (CHARACTER_KEY, SPECIAL_KEY);

	-- Meta key info record:
	type Meta_Key_Info is record
			CTRL	: Boolean := false;
			ALT	: Boolean := false;
			ALTGR	: Boolean := false;
			META	: Boolean := false;
			SHIFT	: Boolean := false;
		end record;

	-- Keyboard key event record:
	type Keyboard_Event (Event_Type : Keyboard_Event_Type := CHARACTER_KEY) is record
			Button_State : Button_State_Type := DOWN;
			Meta_Keys : Meta_Key_Info;
			case Event_Type is
				when CHARACTER_KEY =>
					Key : Character;
				when SPECIAL_KEY =>
					Key_Code : Natural;
			end case;
		end record;

	-- Event handler types:
	type Expose_Handler_Access is access procedure;
	type Resize_Handler_Access is access procedure(New_Size : in Primitives.Dimension);
	type Window_Event_Handler_Access is access procedure(Event_Type : in Window_Event_Type);
	type Mouse_Move_Handler_Access is access procedure(Position : in Primitives.Point);
	type Mouse_Button_Handler_Access is access function(Position : in Primitives.Point;
		Button : in Mouse_Button_Type; Button_State : in Button_State_Type) return Boolean;
	type Keyboard_Handler_Access is access function(Event : in Keyboard_Event) return Boolean;
	type Window_Shown_Handler_Access is access procedure;
	type Window_Closing_Handler_Access is access function return Boolean;

	-- Set of event handlers:
	type Event_Handler_Set is record
			Expose_Handler : Expose_Handler_Access := null;
			Resize_Handler : Resize_Handler_Access := null;
			Window_Event_Handler : Window_Event_Handler_Access := null;
			Mouse_Move_Handler : Mouse_Move_Handler_Access := null;
			Mouse_Button_Handler : Mouse_Button_Handler_Access := null;
			Keyboard_Handler : Keyboard_Handler_Access := null;
			Window_Shown_Handler : Window_Shown_Handler_Access := null;
			Window_Closing_Handler : Window_Closing_Handler_Access := null;
		end record;

end Cupcake.Events;

