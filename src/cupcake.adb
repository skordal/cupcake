--  The Cupcake GUI Toolkit
--  (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
--  Report bugs and issues on <http://github.com/skordal/cupcake/issues>
--  vim:ts=3:sw=3:et:si:sta

with Ada.Text_IO;

with Cupcake.Backends;
with Cupcake.Backends.Cairo;

package body Cupcake is
   package Text_IO renames Ada.Text_IO;

   --  Initializes Cupcake:
   procedure Initialize is
      Backend : constant Backends.Backend_Access :=
         new Backends.Cairo.Cairo_Backend;
   begin
      if Cupcake.Debug_Mode then
         Text_IO.Put_Line ("[Cupcake.Initialize] Initializing Cupcake-TK...");
      end if;

      Backends.Set_Backend (Backend);
      Backends.Get_Backend.Initialize;

      if Cupcake.Debug_Mode then
         Text_IO.Put_Line ("[Cupcake.Initialize] Using backend: "
            & Backends.Get_Backend.Get_Name);
      end if;
   end Initialize;

   --  Finalizes Cupcake:
   procedure Finalize is
   begin
      if Cupcake.Debug_Mode then
         Text_IO.Put_Line ("[Cupcake.Finalize] Finalizing...");
      end if;
   end Finalize;

   --  Enters the main loop:
   procedure Enter_Main_Loop is
   begin
      Backends.Get_Backend.Enter_Main_Loop;
   end Enter_Main_Loop;

   --  Exits the main loop:
   procedure Exit_Main_Loop is
   begin
      Backends.Get_Backend.Exit_Main_Loop;
   end Exit_Main_Loop;

end Cupcake;

