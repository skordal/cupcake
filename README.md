The Cupcake GUI Toolkit
=======================

What is it?
-----------

Cupcake is a GUI toolkit for Ada. It is designed to be uncomplicated and easy to use.

What is its current status?
---------------------------------------

Cupcake's current capabilities are:
* Can show windows, and even fill their backgrounds with pretty colours.
* Can close windows, which is a pretty nice feature to have.
* Can draw text using Cairo's "toy" font backend, which is good enough for now.
* ...but cannot really do anything else.
* Also has some rudimentary man-pages.

These capabilities are demonstrated nicely by the demo programme.

How do I build and install it?
------------------------------

To build Cupcake, you need the following pre-requisites:
* An Ada compiler, such as GCC GNAT.
* A C compiler, as some backend code is written in C.
* Cairo built with the XCB backend, and the XCB library itself.
* Pod2Man, else the build will fail when trying to build manual pages.

When everything is ready to go, simply issue _make_, and watch the library be built, hopefully without problems.

Where do I report bugs?
-----------------------

Bugs are reported on the project's GitHub page, <http://github.com/skordal/cupcake/issues>. Patches and other contributions are also welcome on this page.

How is it licensed?
-------------------

Cupcake is licensed under the MIT license, which can be found in the COPYING.md file.

