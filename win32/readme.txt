Windows 2000 instructions for documentation project:

---Setting up the tools---

(The following must be done every time you use a new machine)

The setup of all the files assumes you've mapped \\elalpha\ece291 to u:.

1) Copy the .lnk files to the desktop (cygwin, emacs, and dia).
2) Add doc.reg to the registry.

---Editing SGML files---

I highly recommend using emacs in viper (vi emulation) mode for editing SGML
files.  Its PSGML mode is extremely powerful and makes editing *much* easier.
To use emacs, copy .emacs and .viper to w:\.  This will enable viper mode by
default in addition to setting up everything in emacs (PSGML mode, syntax
highlighting, etc).  To disable viper, comment out the (setq viper-always t)
line in .viper.

Loading a file in emacs:
I can't get drag-n-drop to work well in emacs, so do file|load or
:e filename (eg :e u:\doc\labmanual\book.sgml)

Useful PSGML commands:
C-c C-q : Reformats contents of current element.  It also recurses into
           elements within the current element.  Warning: it doesn't know
           about line-specific elements like programlisting so don't use
           on a sect1 that includes a programlisting (for example).
C-c C-e : Adds new element.  Prompts for the name (with tab completion).
           It will also add any required elements and prompt for required
           attributes.
C-c C-r : Tag region.  Select a region of text with the mouse and then use
           this command to wrap it with an element.
C-c =   : Change name of current element.
C-c +   : Add attribute to current element.

---SGML Style guidelines---

Generally I've tried to follow the FreeBSD Documentation Project's formatting
guidelines, with one minor change: I use indenting of 1 space instead of two.
See
<http://www.freebsd.org/doc/en_US.ISO8859-1/books/fdp-primer/writing-style.html>
for their style guide (particularly section 10.1).  Chapters 3, 4, and 7 of
this book are also very helpful (ignore the FreeBSD-specific parts).

---Editing diagrams and equations---

Diagrams are done in Dia and have a .dia extension.  The .eps and .png files
are automatically generated if necessary.  NOTE: when creating a new diagram,
copy it from an already existing one (as the print settings can change how
the .eps and .png files are created).

Equations are done in TeX.

---The Makefile system---

When adding or deleting content, it's necessary to change the Makefile.  The
format is fairly straightforward.

---Rebuilding HTML and/or PDF---

Use bmake, not make (the makefiles are in BSD format, not GNU).

As it can take a long time to rebuild large documents (like the lab manual),
there is an option you can pass to the Makefile to only build a part of the
document (this will essentially build the entire document but missing the
chapters/appendicies you don't include).  You may get errors during
generation for cross-references that go between chapters.

 Examples (for the lab manual):
  bmake CHAPTERS=graphics    (includes just the graphics chapter)
  bmake CHAPTERS="ascii-code inst-ref" (includes the ASCII code and
                                       (instruction reference)

Also, you can speed up build time by only building one of the output formats
(eg, only HTML or only PDF).  This is done through the FORMATS option to
bmake:

 bmake FORMATS=html-split    (HTML output only)
 bmake FORMATS=pdf           (PDF output only)

The default is to build both.

Naturally, these options can be combined.

---More advanced stuff (stylesheets)---

TODO
