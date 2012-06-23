The Cupcake GUI Toolkit
=======================

What is it?
-----------

Cupcake is a GUI toolkit for Ada. It is designed to be uncomplicated and easy to use.

What is its current status?
---------------------------------------

The project is in heavy development, and code changes from day to day. In addition, the code may be strange and weird, but there is probably a reason for it, and it will be fixed later.

Cupcake's current capabilities are:
* Can show a window on the screen.

How do I build and install it?
------------------------------

To build Cupcake, you need the following pre-requisites:
* Ada and C compilers, GCC is recommended as I use it myself.
* Cairo built with the XCB backend, and XCB itself.
* FontConfig and FreeType for font handling (not implemented yet, but coming soon).
* Pod2Man and M4 if you want to build the manual pages.

When everything is ready to go, simply issue _make_, and watch the library be built, hopefully without problems. To do a simple test of the library functionality, you may run the demo applications in the demos folder.

Where do I report bugs?
-----------------------

Bugs are reported on the project's GitHub page, <http://github.com/skordal/cupcake/issues>. Patches and other contributions are also welcome on this page.

How is it licensed?
-------------------

Cupcake is licensed under the MIT license, which can be found in the COPYING.md file.

