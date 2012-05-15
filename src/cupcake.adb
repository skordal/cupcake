-- The Cupcake GUI Toolkit
-- (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
-- Report bugs and issues on <http://github.com/skordal/cupcake/issues>

with Ada.Text_IO;

package body Cupcake is
	package Text_IO renames Ada.Text_IO;

	-- Initializes Cupcake:
	procedure Initialize is
		function Backend_Initialize return Integer;
		pragma Import(C, Backend_Initialize, "backend_initialize");
	begin
		if Cupcake.Debug_Mode then
			Text_IO.Put_Line("[Cupcake.Initialize] Initializing Cupcake-TK...");
		end if;

		if Backend_Initialize = 0 then
			raise Initialization_Error with "could not initialize backend";
		end if;
	end Initialize;

	-- Finalizes Cupcake:
	procedure Finalize is
		procedure Backend_Finalize;
		pragma Import(C, Backend_Finalize, "backend_finalize");
	begin
		if Cupcake.Debug_Mode then
			Text_IO.Put_Line("[Cupcake.Finalize] Finalizing...");
		end if;

		Backend_Finalize;
	end Finalize;

end Cupcake;

