dnl The Cupcake GUI Library Manual Pages
dnl (c) Kristian Klomsten Skordal 2012 <kristian.skordal@gmail.com>
dnl Report bugs and issues on <http://github.com/skordal/cupcake/issues>

dnl Creates the NAME and USAGE sections for the specified package.
dnl The arguments to this macro is as follows:
dnl   $1 => Package name, e.g. Cupcake.Windows
dnl   $2 => A single-line description of the package
define(PACKAGE, `
=head1 NAME

$1 - $2

=head1 USAGE

	with $1;
')

