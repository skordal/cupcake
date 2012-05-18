-- The Cupcake GUI Toolkit
-- (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
-- Report bugs and issues on <http://github.com/skordal/cupcake/issues>

package Cupcake.Fonts is

	-- Font family:
	type Font_Family_Type is (SERIF, SANS_SERIF, MONOSPACE);
	for Font_Family_Type use (SERIF => 1, SANS_SERIF => 2, MONOSPACE => 3);
	pragma Convention(C, Font_Family_Type);

	-- Font style:
	type Font_Style_Type is (PLAIN, ITALIC, BOLD);
	for Font_Style_Type use (PLAIN => 1, ITALIC => 2, BOLD => 3);
	pragma Convention(C, Font_Style_Type);

	-- Font size type:
	subtype Font_Size_Type is Long_Float;

	-- Font type:
	type Font_Record is tagged limited private;
	type Font is access all Font_Record'Class;

	-- Exception raised if a requested font is not available:
	Unavailable_Font_Error : exception;

	-- Creates a font with the specified parameters:
	function New_Font(Family : in Font_Family_Type; Style : in Font_Style_Type;
		Size : in Font_Size_Type) return Font;
	
	-- Frees a font:
	procedure Destroy(Object : not null access Font_Record);

	-- Gets the backend data pointer for a font object:
	function Get_Backend_Data(This : in Font_Record'Class) return Backend_Data_Ptr;
	pragma Inline(Get_Backend_Data);

	-- Gets the size of a font:
	function Get_Size(This : in Font_Record'Class) return Font_Size_Type;
	pragma Inline(Get_Size);

private
	-- Font type definition:
	type Font_Record is tagged limited record
			Backend_Data : Backend_Data_Ptr;
			Family : Font_Family_Type;
			Style : Font_Style_Type;
			Size : Font_Size_Type;
		end record;

end Cupcake.Fonts;

