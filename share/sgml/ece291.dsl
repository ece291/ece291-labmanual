<!-- $FreeBSD: doc/share/sgml/freebsd.dsl,v 1.33 2001/06/18 14:29:16 nik Exp $ -->
<!-- $Id: ece291.dsl,v 1.2 2001/06/26 22:44:53 pete Exp $ -->
<!DOCTYPE style-sheet PUBLIC "-//James Clark//DTD DSSSL Style Sheet//EN" [
<!ENTITY % output.html          "IGNORE">
<!ENTITY % output.html.images   "IGNORE">
<!ENTITY % output.print         "IGNORE">
<!ENTITY % output.print.pdf     "IGNORE">
<![ %output.html; [
<!ENTITY docbook.dsl PUBLIC "-//Norman Walsh//DOCUMENT DocBook HTML Stylesheet//EN" CDATA DSSSL>
]]>
<![ %output.print; [
<!ENTITY docbook.dsl PUBLIC "-//Norman Walsh//DOCUMENT DocBook Print Stylesheet//EN" CDATA DSSSL>
]]>
]>

<style-sheet>
  <style-specification use="docbook">
    <style-specification-body>

      <!-- HTML only .................................................... -->
      
      <![ %output.html; [
        <!-- Configure the stylesheet using documented variables -->

        (define %gentext-nav-use-tables%
          ;; Use tables to build the navigation headers and footers?
          #t)

        (define %html-ext%
          ;; Default extension for HTML output files
          ".html")

        (define %shade-verbatim%
          ;; Should verbatim environments be shaded?
          #f)

        (define %use-id-as-filename%
          ;; Use ID attributes as name for component HTML files?
          #t)
 
        (define %root-filename%
          ;; Name for the root HTML document
          "index")

        (define html-manifest
          ;; Write a manifest?
          #f)

        (define %stylesheet%
	  "docbook.css")

        (define firstterm-bold
          ;; Make FIRSTTERM elements bold?
          #t)

        <!-- Convert " ... " to &ldquo; ... &rdquo; in the HTML output. -->
        <!--(element quote
	  (make sequence
	    (literal "``")
	    (process-children)
	    (literal "''")))-->

      ]]>

      <!-- HTML with images  ............................................ -->

      <![ %output.html.images [

        (define %graphic-default-extension%
          "png")

      ]]>

      <!-- Print only ................................................... --> 
      <![ %output.print; [
        (define (toc-depth nd)
          (if (string=? (gi nd) (normalize "book"))
              3
              1))

	(define %graphic-extensions%
          '("eps" "tex" "png"))

        ;; TeX files should be in the preferred list of mediaobject
        ;; formats and extensions; used for equations.
        (define preferred-mediaobject-notations
          (list "EPS" "TEX" "PNG"))

        (define preferred-mediaobject-extensions
          (list "eps" "tex" "png"))

        ;; When selecting a filename to use, don't append the default
        ;; extension, instead, just use the bare filename, and let TeX
        ;; work it out.  jadetex will use the .eps file, while pdfjadetex
        ;; will use the .png file automatically.
        (define (graphic-file filename)
          (let ((ext (file-extension filename)))
            (if (or tex-backend   ;; TeX can work this out itself
                    (not filename)
                    (not %graphic-default-extension%)
                    (member ext %graphic-extensions%))
                 filename
                 (string-append filename "." %graphic-default-extension%))))

      ]]>

      <![ %output.print.pdf; [

      ]]>

      <!-- Both sets of stylesheets .................................... -->
      
      (define %section-autolabel%
        #t)

      (define %may-format-variablelist-as-table%
        #f)
      
      (define %indent-programlisting-lines%
        "")
 
      (define %indent-screen-lines%
        "    ")

      <!-- Slightly deeper customisations -->

      <!-- John Fieber's 'instant' translation specification had 
           '<command>' rendered in a mono-space font, and '<application>'
           rendered in bold. 

           Norm's stylesheet doesn't do this (although '<command>' is 
           rendered in bold).

           Configure the stylesheet to behave more like John's. -->

      (element command ($mono-seq$))

      (element application ($bold-seq$))

      <!-- Warnings and cautions are put in boxed tables to make them stand
           out. The same effect can be better achieved using CSS or similar,
           so have them treated the same as <important>, <note>, and <tip>
      -->
      (element warning ($admonition$))
      (element (warning title) (empty-sosofo))
      (element (warning para) ($admonpara$))
      (element (warning simpara) ($admonpara$))
      (element caution ($admonition$))
      (element (caution title) (empty-sosofo))
      (element (caution para) ($admonpara$))
      (element (caution simpara) ($admonpara$))

      (define (local-en-label-title-sep)
        (list
          (list (normalize "warning")		": ")
	  (list (normalize "caution")		": ")
          ))

    </style-specification-body>
  </style-specification>

  <external-specification id="docbook" document="docbook.dsl">
</style-sheet>
