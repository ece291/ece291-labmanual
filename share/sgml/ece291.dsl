<!-- $FreeBSD: doc/share/sgml/freebsd.dsl,v 1.43 2001/07/27 21:16:55 murray Exp $ -->
<!-- $FreeBSD: doc/en_US.ISO8859-1/share/sgml/freebsd.dsl,v 1.12 2001/07/28 03:00:03 murray Exp $ -->
<!-- $Id: ece291.dsl,v 1.7 2001/08/02 01:49:24 pete Exp $ -->
<!DOCTYPE style-sheet PUBLIC "-//James Clark//DTD DSSSL Style Sheet//EN" [
<!ENTITY % output.html              "IGNORE">
<!ENTITY % output.html.images       "IGNORE">
<!ENTITY % output.print             "IGNORE">
<!ENTITY % output.print.niceheaders "IGNORE">
<!ENTITY % output.print.pdf         "IGNORE">
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

        (define (book-titlepage-recto-elements)
          (list (normalize "title")
                (normalize "subtitle")
                (normalize "graphic")
                (normalize "mediaobject")
                (normalize "corpauthor")
                (normalize "authorgroup")
                (normalize "author")
                (normalize "editor")
                (normalize "copyright")
                (normalize "abstract")
                (normalize "legalnotice")
                (normalize "isbn")))

	(define html-index-filename
	  (if nochunks
	    "html.index"
	    "html-split.index"))

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

; The new Cascading Style Sheets for the HTML output are very confused
; by our images when used with div class="mediaobject".  We can
; clear up the confusion by ignoring the whole mess and just
; displaying the image.

        (element mediaobject
          (if (node-list-empty? (select-elements (children (current-node)) (normalize "imageobject")))
            (process-children)
            (process-node-list (select-elements (children (current-node)) (normalize "imageobject")))))

        (define %graphic-default-extension%
          "png")

      ]]>

      <!-- Print only ................................................... --> 
      <![ %output.print; [
        (define (toc-depth nd)
          (if (string=? (gi nd) (normalize "book"))
              3
              1))

        (element (primaryie ulink)
          (indexentry-link (current-node)))
        (element (secondaryie ulink)
          (indexentry-link (current-node)))
        (element (tertiaryie ulink)
          (indexentry-link (current-node)))

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

      ; Option to prevent section labels from being numbered after the third
      ;  level.
      ; The section titles are still bold, spaced away from the text, and
      ;  sized according to their nesting level.
      (define minimal-section-labels #f)
      (define max-section-level-labels
        (if minimal-section-labels 3 10))

      (define ($section-title$)
        (let* ((sect (current-node))
      	       (info (info-element))
	       (exp-children (if (node-list-empty? info)
		 	         (empty-node-list)
			         (expand-children (children info) 
					          (list (normalize "bookbiblio") 
						        (normalize "bibliomisc")
						        (normalize "biblioset")))))
	       (parent-titles (select-elements (children sect) (normalize "title")))
  	       (info-titles   (select-elements exp-children (normalize "title")))
	       (titles        (if (node-list-empty? parent-titles)
		   	          info-titles
			          parent-titles))
	       (subtitles     (select-elements exp-children (normalize "subtitle")))
	       (renderas (inherited-attribute-string (normalize "renderas") sect))
	       (hlevel                          ;; the apparent section level;
	        (if renderas                    ;; if not real section level,
  	            (string->number             ;;   then get the apparent level
	             (substring renderas 4 5))  ;;   from "renderas",
	            (SECTLEVEL)))               ;; else use the real level
	       (hs (HSIZE (- 4 hlevel))))

          (make sequence
            (make paragraph
 	      font-family-name: %title-font-family%
	      font-weight:  (if (< hlevel 5) 'bold 'medium)
	      font-posture: (if (< hlevel 5) 'upright 'italic)
	      font-size: hs
	      line-spacing: (* hs %line-spacing-factor%)
	      space-before: (* hs %head-before-factor%)
	      space-after: (if (node-list-empty? subtitles)
	    	  	       (* hs %head-after-factor%)
	 	  	       0pt)
	      start-indent: (if (or (>= hlevel 3)
			            (member (gi) (list (normalize "refsynopsisdiv") 
					    	       (normalize "refsect1") 
						       (normalize "refsect2") 
						       (normalize "refsect3"))))
	 		        %body-start-indent%
			        0pt)
	      first-line-start-indent: 0pt
	      quadding: %section-title-quadding%
	      keep-with-next?: #t
	      heading-level: (if %generate-heading-level% (+ hlevel 1) 0)
  	      ;; SimpleSects are never AUTO numbered...they aren't hierarchical
	      (if (> hlevel (- max-section-level-labels 1))
	          (empty-sosofo)
	          (if (string=? (element-label (current-node)) "")
	  	      (empty-sosofo)
		      (literal (element-label (current-node)) 
			       (gentext-label-title-sep (gi sect)))))
	      (element-title-sosofo (current-node)))
            (with-mode section-title-mode
	      (process-node-list subtitles))
            ($section-info$ info))))

      ]]>

      <!-- More aesthetically pleasing chapter headers for print output -->
      <![ %output.print.niceheaders; [
<!--
      (define ($component-title$)
	(let* ((info (cond
		((equal? (gi) (normalize "appendix"))
		 (select-elements (children (current-node)) (normalize "docinfo")))
		((equal? (gi) (normalize "article"))
		 (node-list-filter-by-gi (children (current-node))
					 (list (normalize "artheader")
					       (normalize "articleinfo"))))
		((equal? (gi) (normalize "bibliography"))
		 (select-elements (children (current-node)) (normalize "docinfo")))
		((equal? (gi) (normalize "chapter"))
		 (select-elements (children (current-node)) (normalize "docinfo")))
		((equal? (gi) (normalize "dedication")) 
		 (empty-node-list))
		((equal? (gi) (normalize "glossary"))
		 (select-elements (children (current-node)) (normalize "docinfo")))
		((equal? (gi) (normalize "index"))
		 (select-elements (children (current-node)) (normalize "docinfo")))
		((equal? (gi) (normalize "preface"))
		 (select-elements (children (current-node)) (normalize "docinfo")))
		((equal? (gi) (normalize "reference"))
		 (select-elements (children (current-node)) (normalize "docinfo")))
		((equal? (gi) (normalize "setindex"))
		 (select-elements (children (current-node)) (normalize "docinfo")))
		(else
		 (empty-node-list))))
	 (exp-children (if (node-list-empty? info)
			   (empty-node-list)
			   (expand-children (children info) 
					    (list (normalize "bookbiblio") 
						  (normalize "bibliomisc")
						  (normalize "biblioset")))))
	 (parent-titles (select-elements (children (current-node)) (normalize "title")))
	 (info-titles   (select-elements exp-children (normalize "title")))
	 (titles        (if (node-list-empty? parent-titles)
			    info-titles
			    parent-titles))
	 (subtitles     (select-elements exp-children (normalize "subtitle"))))
    (make sequence
      (make paragraph
	font-family-name: %title-font-family%
	font-weight: 'bold
	font-size: (HSIZE 4)
	line-spacing: (* (HSIZE 4) %line-spacing-factor%)
	space-before: (* (HSIZE 4) %head-before-factor%)
	start-indent: 0pt
	first-line-start-indent: 0pt
	quadding: %component-title-quadding%
	heading-level: (if %generate-heading-level% 1 0)
	keep-with-next?: #t

	(if (string=? (element-label) "")
	    (empty-sosofo)
	    (literal (gentext-element-name-space (current-node))
		     (element-label)
		     (gentext-label-title-sep (gi)))))
      (make paragraph
	font-family-name: %title-font-family%
	font-weight: 'bold
	font-posture: 'italic
	font-size: (HSIZE 6)
	line-spacing: (* (HSIZE 6) %line-spacing-factor%)
;	space-before: (* (HSIZE 5) %head-before-factor%)
	start-indent: 0pt
	first-line-start-indent: 0pt
	quadding: %component-title-quadding%
	heading-level: (if %generate-heading-level% 1 0)
	keep-with-next?: #t

	(if (node-list-empty? titles)
	    (element-title-sosofo) ;; get a default!
	    (with-mode component-title-mode
	      (make sequence
		(process-node-list titles)))))

      (make paragraph
	font-family-name: %title-font-family%
	font-weight: 'bold
	font-posture: 'italic
	font-size: (HSIZE 3)
	line-spacing: (* (HSIZE 3) %line-spacing-factor%)
	space-before: (* 0.5 (* (HSIZE 3) %head-before-factor%))
	space-after: (* (HSIZE 4) %head-after-factor%)
	start-indent: 0pt
	first-line-start-indent: 0pt
	quadding: %component-subtitle-quadding%
	keep-with-next?: #t

	(with-mode component-title-mode
	  (make sequence
	    (process-node-list subtitles))))

      (make rule
	length: 475pt
	display-alignment: 'start
	space-before: (* (HSIZE 5) %head-before-factor%)
	line-thickness: 0.5pt))))

      (element authorgroup
        (empty-sosofo))
-->
      ]]>

      <![ %output.print.pdf; [

      (declare-characteristic heading-level
        "UNREGISTERED::James Clark//Characteristic::heading-level" 2)

      (define %generate-heading-level%
        #t)

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

      (element chapterinfo 
        (process-children))
      (element sect1info 
        (process-children))
      (element sect2info 
        (process-children))
      (element (chapterinfo authorgroup author)
        (make sequence
          (process-node-list (select-elements (descendants (current-node))
                                (normalize "contrib")))
          (literal (author-list-string))))
      (element (sect1info authorgroup author)
        (make sequence
          (process-node-list (select-elements (descendants (current-node))
                                (normalize "contrib")))
          (literal (author-list-string))))
      (element (sect2info authorgroup author)
        (make sequence
          (process-node-list (select-elements (descendants (current-node))
                                (normalize "contrib")))
          (literal (author-list-string))))
      (element (chapterinfo authorgroup)
        (process-children))
      (element (sect1info authorgroup)
        (process-children))
      (element (sect2info authorgroup)
        (process-children))

      (element (author contrib)
        (make sequence
          (process-children)
          (literal " by ")))

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
          (list (normalize "chapter")           "  ")
          (list (normalize "sect1")             "  ")
          (list (normalize "sect2")             "  ")
          (list (normalize "sect3")             "  ")
          (list (normalize "sect4")             "  ")
          (list (normalize "sect5")             "  ")
          ))

    </style-specification-body>
  </style-specification>

  <external-specification id="docbook" document="docbook.dsl">
</style-sheet>
