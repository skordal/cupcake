-- The Cupcake GUI Toolkit
-- (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
-- Report bugs and issues on <http://github.com/skordal/cupcake/issues>

with Ada.Unchecked_Deallocation;
with Interfaces.C.Strings;

package body Cupcake.Graphics is
	-- Available backend methods:
	procedure Backend_Set_Color(Backend_Data : in Backend_Data_Ptr;
		R, G, B : in Long_Float);
	procedure Backend_Fill_Rectangle(Backend_Data : in Backend_Data_Ptr;
		X, Y, Width, Height : in Natural);
	procedure Backend_Render_String(Backend_Data : in Backend_Data_Ptr;
		Font : Backend_Data_Ptr; X, Y : Natural; Text : Interfaces.C.Strings.chars_ptr);

	pragma Import(C, Backend_Set_Color, "backend_set_color");
	pragma Import(C, Backend_Fill_Rectangle, "backend_fill_rectangle");
	pragma Import(C, Backend_Render_String, "backend_render_string");

	-- Creates a new graphics context for a window:
	function New_Context(Backend_Data : in Backend_Data_Ptr; Size : in Primitives.Dimension)
		return Context is
		Retval : constant Context := new Context_Record;
	begin
		Retval.Backend_Data := Backend_Data;
		Retval.Size := Size;

		return Retval;
	end New_Context;

	-- Creates a new graphics context for a part of a window:
	function New_Context(Parent : in Context; Translation : in Primitives.Point;
		Size : in Primitives.Dimension) return Context is
		Retval : constant Context := new Context_Record;
	begin
		Retval.Parent := Parent;
		Retval.Backend_Data := Parent.Backend_Data;
		Retval.Translation := Translation;
		Retval.Size := Size;

		return Retval;
	end New_Context;

	-- Destroys a graphics context:
	procedure Destroy(Object : not null access Context_Record) is
		type Context_Access is access all Context_Record;
		Con : Context_Access := Context_Access(Object);

		procedure Free is new Ada.Unchecked_Deallocation(Object => Context_Record,
			Name => Context_Access);
	begin
		Free(Con);
	end Destroy;

	-- Sets the size of a graphics context:
	procedure Set_Size(This : out Context_Record'Class; New_Size : in Primitives.Dimension) is
	begin
		This.Size := New_Size;
	end Set_Size;

	-- Gets the size of a graphics context:
	function Get_Size(This : in Context_Record'Class) return Primitives.Dimension is
	begin
		return This.Size;
	end Get_Size;

	-- Fills a rectangle with the specified color:
	procedure Fill(This : in Context_Record'Class; Color : in Colors.Color;
		Shape : Primitives.Rectangle) is
		use Cupcake.Primitives;
		Translated_Rectangle : Primitives.Rectangle;
	begin
		Translated_Rectangle.Origin := Shape.Origin + This.Translation;
		Translated_Rectangle.Size := Shape.Size;

		Backend_Set_Color(This.Backend_Data, Color.R, Color.G, Color.B);
		Backend_Fill_Rectangle(This.Backend_Data, Translated_Rectangle.Origin.X,
			Translated_Rectangle.Origin.Y, Translated_Rectangle.Size.Width,
			Translated_Rectangle.Size.Height);
	end Fill;

	-- Renders a string of text:
	procedure Render_Text(This : in Context_Record'Class; Color : in Colors.Color;
		Text : in String; Font : in Fonts.Font; Position : in Primitives.Point) is
		use Cupcake.Primitives;
		Translated_Position : constant Primitives.Point := This.Translation + Position;
		C_Text : Interfaces.C.Strings.chars_ptr := Interfaces.C.Strings.New_String(Text);
	begin
		Backend_Set_Color(This.Backend_Data, Color.R, Color.G, Color.B);
		Backend_Render_String(This.Backend_Data, Font.Get_Backend_Data, Translated_Position.X,
			Translated_Position.Y, C_Text);

		Interfaces.C.Strings.Free(C_Text);
	end Render_Text;

end Cupcake.Graphics;

