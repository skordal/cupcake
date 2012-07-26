--  The Cupcake GUI Toolkit
--  (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
--  Report bugs and issues on <http://github.com/skordal/cupcake/issues>
--  vim:ts=3:sw=3:et:si:sta

package Cupcake.Primitives is

   --  Simple point type:
   type Point is record
      X, Y : Integer;
   end record;

   --  Point operators:
   function "+" (Left, Right : in Point) return Point
      with Inline, Pure_Function;
   function "-" (Left, Right : in Point) return Point
      with Inline, Pure_Function;
   function "=" (Left, Right : in Point) return Boolean
      with Inline, Pure_Function;

   --  Type for specifying dimensions:
   type Dimension is record
      Width, Height : Natural;
   end record;

   --  Dimension operators:
   function "<" (Left, Right : in Dimension) return Boolean
      with Inline, Pure_Function;
   function ">" (Left, Right : in Dimension) return Boolean
      with Inline, Pure_Function;
   function "=" (Left, Right : in Dimension) return Boolean
      with Inline, Pure_Function;

   --  Rectangle type:
   type Rectangle is record
      Origin : Point;
      Size : Dimension;
   end record;

   --  Line type:
   type Line is record
      Start : Point;
      Endpoint : Point;
   end record;

end Cupcake.Primitives;

