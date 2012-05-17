-- The Cupcake GUI Toolkit
-- (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
-- Report bugs and issues on <http://github.com/skordal/cupcake/issues>

with Ada.Unchecked_Deallocation;

package body Cupcake.Graphics is

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

end Cupcake.Graphics;

