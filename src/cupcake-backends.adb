--  The Cupcake GUI Toolkit
--  (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
--  Report bugs and issues on <http://github.com/skordal/cupcake/issues>
--  vim:ts=3:sw=3:et:si:sta

package body Cupcake.Backends is

   --  Gets the backend class to be used:
   function Get_Backend return Backend_Access is
   begin
      return Active_Backend;
   end Get_Backend;

   --  Sets the backend to be used:
   procedure Set_Backend (Use_Backend : in Backend_Access) is
   begin
      Active_Backend := Use_Backend;
   end Set_Backend;

end Cupcake.Backends;

