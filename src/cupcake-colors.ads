--  The Cupcake GUI Toolkit
--  (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
--  Report bugs and issues on <http://github.com/skordal/cupcake/issues>
--  vim:ts=3:sw=3:et:si:sta

package Cupcake.Colors is

   --  Color component type:
   subtype Color_Component_Type is Float range 0.0 .. 1.0;

   --  Color type:
   type Color is record
      R, G, B : Color_Component_Type;
   end record;

   --  Multiplies all color components of a Color with a constant:
   function "*" (Left : in Color; Right : in Float) return Color;
   function "*" (Left : in Float; Right : in Color) return Color with Inline;

   --  Predefined color constants:
   BLACK : constant Color := (0.0, 0.0, 0.0);
   WHITE : constant Color := (1.0, 1.0, 1.0);

   RED   : constant Color := (1.0, 0.0, 0.0);
   GREEN : constant Color := (0.0, 1.0, 0.0);
   BLUE  : constant Color := (0.0, 0.0, 1.0);

   DEFAULT_BACKGROUND_COLOR : constant Color := (0.85, 0.85, 0.85);
   DEFAULT_FOREGROUND_COLOR : constant Color := BLACK;

end Cupcake.Colors;

