-- The Cupcake GUI Toolkit
-- (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
-- Report bugs and issues on <http://github.com/skordal/cupcake/issues>

with Cupcake.Primitives;
with Cupcake.Graphics;

package Cupcake.Events is

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
	type Keyboard_Event_Record (Event_Type : Keyboard_Event_Type) is record
			Button_State : Button_State_Type := DOWN;
			Meta_Keys : Meta_Key_Info;
			case Event_Type is
				when CHARACTER_KEY =>
					Key : Character;
				when SPECIAL_KEY =>
					Key_Code : Natural;
			end case;
		end record;

	-- Mouse event enumeration:
	type Mouse_Event_Type is (MOUSE_MOVE_EVENT, MOUSE_BUTTON_EVENT, MOUSE_ENTER_EVENT, MOUSE_LEAVE_EVENT);

	-- A mouse event:
	type Mouse_Event_Record (Event_Type : Mouse_Event_Type) is record
			Position : Primitives.Point;
			case Event_Type is
				when MOUSE_BUTTON_EVENT =>
					Button_State : Button_State_Type;
					Button : Mouse_Button_Type;
				when others =>
					null;
			end case;
		end record;

	-- Interface for an object receiving events:
	type Event_Receiver is limited interface;

	-- Event handlers included in the Event_Receiver interface:
	procedure Expose_Handler(This : in Event_Receiver; Graphics_Context : in Graphics.Context) is abstract;
	procedure Resize_Handler(This : in out Event_Receiver; New_Size : in Primitives.Dimension) is abstract;
	function Mouse_Handler(This : in Event_Receiver; Mouse_Event : in Mouse_Event_Record)
		return Boolean is abstract; -- Returns false if the event should not propagate to child objects.
	function Keyboard_Handler(This : in Event_Receiver; Keyboard_Event : in Keyboard_Event_Record)
		return Boolean is abstract; -- Returns false if the event should not propagate to child objects.

	-- Event receiver interface for windows. This interface contains more events
	-- than does the normal Event_Receiver interface, because windows can also
	-- receive special window events.
	type Window_Event_Receiver is limited interface and Event_Receiver;

	-- Additional event handlers included in the Window_Event_Receiver interface:
	procedure Window_Shown_Handler(This : in Window_Event_Receiver) is abstract;
	function Window_Closing_Handler(This : in Window_Event_Receiver)
		return Boolean is abstract; -- Returns false if the window should not close.

end Cupcake.Events;

