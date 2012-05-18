-- Cupcake TK Demo Application
-- (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
-- Report bugs and issues on <http://github.com/skordal/cupcake/issues>

with Ada.Text_IO; use Ada.Text_IO;

with Cupcake;
with Cupcake.Components;
with Cupcake.Layouts;
with Cupcake.Primitives;
with Cupcake.Windows;

use Cupcake;

procedure Demo is
	Test_Window : Windows.Window;
	Window_Size : constant Primitives.Dimension := (Width => 800, Height => 600);
	Window_Layout : Layouts.Layout := Layouts.New_Simple_Layout;
	Test_Label : Components.Component := Components.New_Label("Test application");
begin
	Put_Line("Initializing cupcake... ");
	Initialize;

	Test_Window := Windows.New_Window(Window_Size, "Test Application");
	Test_Window.Set_Layout(Window_Layout);
	Window_Layout.Add_Component(Test_Label);
	Test_Window.Show;

	Main_Loop;

	Windows.Destroy(Test_Window);
	Finalize;
exception
	when Cupcake.Initialization_Error =>
		Put_Line("Could not initialize cupcake!");
end Demo;

