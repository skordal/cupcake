-- The Cupcake GUI Toolkit
-- (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
-- Report bugs and issues on <http://github.com/skordal/cupcake/issues>

package Cupcake is

	-- Cupcake version:
	VERSION_MAJOR    : constant := 0;
	VERSION_MINOR    : constant := 1;
	VERSION_REVISION : constant := 0;

	-- Exception thrown if an error occurs during initialization:
	Initialization_Error : exception;

	-- Initializes Cupcake. This must be called before any other functions.
	procedure Initialize;

	-- Finalizes Cupcake. This must be the last Cupcake procedure called.
	procedure Finalize;

	-- Runs the main loop:
	procedure Main_Loop;
	pragma Import(C, Main_Loop, "backend_main_loop");

	-- Exits the main loop:
	procedure Main_Loop_Terminate;
	pragma Import(C, Main_Loop_Terminate, "backend_main_loop_terminate");

	-- Set to true to get debug messages:
	Debug_Mode : constant Boolean := true;

end Cupcake;

