-- The Cupcake GUI Toolkit
-- (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
-- Report bugs and issues on <http://github.com/skordal/cupcake/issues>

package body Cupcake.Fonts is
	-- Available backend methods:
	function Backend_New_Font(Family : in Font_Family_Type; Style : in Font_Style_Type;
		Size : in Font_Size_Type) return Backend_Data_Ptr;
	pragma Import(C, Backend_New_Font, "backend_new_font");

	-- Creates a new font:
	function New_Font(Family : in Font_Family_Type; Style : in Font_Style_Type;
		Size : in Font_Size_Type) return Font is
		Retval : constant Font := new Font_Record;
	begin
		Retval.Backend_Data := Backend_New_Font(Family, Style, Size);
		Retval.Family := Family;
		Retval.Style := Style;
		Retval.Size := Size;
		return Retval;
	end New_Font;

	-- Gets the backend data pointer for a font:
	function Get_Backend_Data(This : in Font_Record'Class) return Backend_Data_Ptr is
	begin
		return This.Backend_Data;
	end Get_Backend_Data;

end Cupcake.Fonts;
