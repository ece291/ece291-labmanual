#
# $FreeBSD: doc/share/mk/doc.docbook.mk,v 1.58 2001/12/12 11:49:37 phantom Exp $
#
# This include file <doc.docbook.mk> handles building and installing of
# DocBook documentation in the FreeBSD Documentation Project.
#
# Documentation using DOCFORMAT=docbook is expected to be marked up
# according to the DocBook DTD
#

# ------------------------------------------------------------------------
#
# Document-specific variables
#
#	DOC		This should be set to the name of the DocBook
#			marked-up file, without the .sgml or .docb suffix.
#			
#			It also determins the name of the output files -
#			${DOC}.html.
#
#	DOCBOOKSUFFIX	The suffix of your document, defaulting to .sgml
#
#	SRCS		The names of all the files that are needed to
#			build this document - This is useful if any of
#			them need to be generated.  Changing any file in
#			SRCS causes the documents to be rebuilt.
#
#       HAS_INDEX       This document has index terms and so an index
#                       can be created if specified with GEN_INDEX.
#

# ------------------------------------------------------------------------
#
# Variables used by both users and documents:
#
#	SGMLFLAGS	Additional options to pass to various SGML
#			processors (e.g., jade, nsgmls).  Typically
#			used to define "IGNORE" entities to "INCLUDE"
#			 with "-i<entity-name>"
#
#	JADEFLAGS	Additional options to pass to Jade.  Typically
#			used to set additional variables, such as
#			"%generate-article-toc%".
#
#	TIDYFLAGS	Additional flags to pass to Tidy.  Typically
#			used to set "-raw" flag to handle 8bit characters.
#
#	EXTRA_CATALOGS	Additional catalog files that should be used by
#			any SGML processing applications.
#
#	NO_TIDY		If you do not want to use tidy, set this to "YES".
#
#       GEN_INDEX       If this document has an index (HAS_INDEX) and this
#                       variable is defined, then index.sgml will be added 
#                       to the list of dependencies for source files, and 
#                       collateindex.pl will be run to generate index.sgml.
#
#	CSS_SHEET	Full path to a CSS stylesheet suitable for DocBook.
#			Default is ${DOC_PREFIX}/share/misc/docbook.css
#
# Print-output options :
#
#       NICE_HEADERS    If defined, customized chapter headers will be created
#			that you may find more aesthetically pleasing.	Note
#			that this option only effects print output formats for
#			Enlish language books.
#
#       MIN_SECT_LABELS If defined, do not display the section number for 4th
#                       and 5th level section titles.  This would change 
#                       "N.N.N.N Section title" into "Section Title" while
#                       higher level sections are still printed with numbers.
#
#       TRACE={1,2}     Trace TeX's memory usage.  Set this to 1 for minimal
#                       tracing or 2 for maximum tracing.  TeX memory 
#                       statistics will be written out to <filename>.log.
#                       For more information see the TeXbook, p301.
#
#       TWO_SIDE        If defined, two sided output will be created.  This 
#                       means that new chapters will only start on odd 
#                       numbered (aka right side, aka recto) pages and the 
#                       headers and footers will be aligned appropriately 
#                       for double sided paper.  Blank pages may be added as
#                       needed.
#
#       JUSTIFY         If defined, text will be right justified so that the
#                       right edge is smooth.  Words may be hyphenated using
#                       the defalt TeX hyphenation rules for this purpose.
#
#       BOOK_OUTPUT     A collection of options are set suitable for printing
#                       a book.  This option may be an order of magnitude more
#                       CPU intensive than the default build.
#

#
# Documents should use the += format to access these.
#

DOCBOOKSUFFIX?= sgml

MASTERDOC?=	${.CURDIR}/${DOC}.${DOCBOOKSUFFIX}

.if ${MACHINE_ARCH} == "alpha"
OPENJADE=	yes
.endif

.if defined(OPENJADE)
JADE?=		${PREFIX}/bin/openjade
JADECATALOG?=	${PREFIX}/share/sgml/openjade/catalog
NSGMLS?=	${PREFIX}/bin/onsgmls
JADEFLAGS+=	-V openjade
.else
JADE?=		${PREFIX}/bin/jade
JADECATALOG?=	${PREFIX}/share/sgml/jade/catalog
NSGMLS?=	${PREFIX}/bin/nsgmls
.endif

DSLHTML?=	${DOC_PREFIX}/share/sgml/default.dsl
DSLPRINT?=	${DOC_PREFIX}/share/sgml/default.dsl
DSLPGP?=	${DOC_PREFIX}/share/sgml/pgp.dsl
FREEBSDCATALOG=	${DOC_PREFIX}/share/sgml/catalog
LANGUAGECATALOG=${DOC_PREFIX}/share/sgml/catalog

ISO8879CATALOG=	${PREFIX}/share/sgml/iso8879/catalog
DOCBOOKCATALOG=	${PREFIX}/share/sgml/docbook/catalog
DSSSLCATALOG=	${PREFIX}/share/sgml/docbook/dsssl/modular/catalog
COLLATEINDEX=	${PREFIX}/share/sgml/docbook/dsssl/modular/bin/collateindex.pl

IMAGES_LIB?=

CATALOGS=	-c ${LANGUAGECATALOG} -c ${FREEBSDCATALOG} \
		-c ${DSSSLCATALOG} -c ${ISO8879CATALOG} \
		-c ${DOCBOOKCATALOG} -c ${JADECATALOG} \
		${EXTRA_CATALOGS:S/^/-c /g}
SGMLFLAGS+=	-D ${CANONICALOBJDIR}
JADEOPTS=	${JADEFLAGS} ${SGMLFLAGS} ${CATALOGS}

KNOWN_FORMATS=	html html.tar html-split html-split.tar \
		txt rtf ps pdf tex dvi tar pdb

CSS_SHEET?=	${DOC_PREFIX}/share/misc/docbook.css
PDFTEX_DEF?=	${DOC_PREFIX}/share/web2c/pdftex.def

HTMLOPTS?=	-ioutput.html -d ${DSLHTML} ${HTMLFLAGS}

PRINTOPTS?=	-ioutput.print -d ${DSLPRINT} ${PRINTFLAGS}

.if defined(BOOK_OUTPUT)
NICE_HEADERS=1
MIN_SECT_LABELS=1
TWO_SIDE=1
JUSTIFY=1
#WITH_FOOTNOTES=1
#GEN_INDEX=1
TEXCMDS+=	\def\TwoSideStartOnRight{1}
.endif
.if defined(JUSTIFY)
TEXCMDS+=	\RequirePackage{url}
PRINTOPTS+=	-ioutput.print.justify
.endif
.if defined(TWO_SIDE)
PRINTOPTS+=	-V %two-side% -ioutput.print.twoside
TEXCMDS+=	\def\PageTwoSide{1}
.endif
.if defined(NICE_HEADERS)
PRINTOPTS+=    -ioutput.print.niceheaders
.endif
.if defined(MIN_SECT_LABELS)
PRINTOPTS+=    -V minimal-section-labels
.endif
.if defined(TRACE)
TEXCMDS+=	\tracingstats=${TRACE}
.endif

PERL?=		/usr/bin/perl
PKG_CREATE?=	/usr/sbin/pkg_create
SORT?=		/usr/bin/sort
TAR?=		/usr/bin/tar
TOUCH?=		/usr/bin/touch
XARGS?=		/usr/bin/xargs

TEX?=		${PREFIX}/bin/tex
PDFTEX?=	${PREFIX}/bin/pdftex
TIDY?=		${PREFIX}/bin/tidy
TIDYOPTS?=	-i -m -raw -preserve -f /dev/null ${TIDYFLAGS}
HTML2TXT?=	${PREFIX}/bin/links
HTML2TXTOPTS?=	-dump ${HTML2TXTFLAGS}
HTML2PDB?=	${PREFIX}/bin/iSiloBSD
HTML2PDBOPTS?=	-y -d0 -Idef ${HTML2PDBFLAGS}
DVIPS?=		${PREFIX}/bin/dvips
.if defined(PAPERSIZE)
DVIPSOPTS?=	-t ${PAPERSIZE:L} ${DVIPSFLAGS}
.endif

GZIP?=	-9
GZIP_CMD?=	gzip -qf ${GZIP}
BZIP2?=	-9
BZIP2_CMD?=	bzip2 -qf ${BZIP2}
ZIP?=	-9
ZIP_CMD?=	${PREFIX}/bin/zip -j ${ZIP}

# ------------------------------------------------------------------------
#
# Look at ${FORMATS} and work out which documents need to be generated.
# It is assumed that the HTML transformation will always create a file
# called index.html, and that for every other transformation the name
# of the generated file is ${DOC}.format.
#
# ${_docs} will be set to a list of all documents that must be made
# up to date.
#
# ${CLEANFILES} is a list of files that should be removed by the "clean"
# target. ${COMPRESS_EXT:S/^/${DOC}.${_cf}.&/ takes the COMPRESS_EXT
# var, and prepends the filename to each listed extension, building a
# second list of files with the compressed extensions added.
#

# Note: ".for _curformat in ${KNOWN_FORMATS}" is used several times in
# this file. I know they could have been rolled together in to one, much
# larger, loop. However, that would have made things more complicated
# for a newcomer to this file to unravel and understand, and a syntax
# error in the loop would have affected the entire
# build/compress/install process, instead of just one of them, making it
# more difficult to debug.
#

# Note: It is the aim of this file that *all* the targets be available,
# not just those appropriate to the current ${FORMATS} and
# ${INSTALL_COMPRESSED} values.
#
# For example, if FORMATS=html and INSTALL_COMPRESSED=gz you could still
# type
#
#     make book.rtf.bz2
#
# and it will do the right thing. Or
#
#     make install-rtf.bz2
#
# for that matter. But don't expect "make clean" to work if the FORMATS
# and INSTALL_COMPRESSED variables are wrong.
#

.if ${.OBJDIR} != ${.CURDIR}
LOCAL_CSS_SHEET= ${.OBJDIR}/${CSS_SHEET:T}
.else
LOCAL_CSS_SHEET= ${CSS_SHEET:T}
.endif

.for _curformat in ${FORMATS}
_cf=${_curformat}

.if ${_cf} == "html-split"
_docs+= index.html HTML.manifest ln*.html
CLEANFILES+= $$([ -f HTML.manifest ] && ${XARGS} < HTML.manifest) \
		HTML.manifest ln*.html
CLEANFILES+= PLIST.${_curformat}

.else
_docs+= ${DOC}.${_curformat}
CLEANFILES+= ${DOC}.${_curformat}
CLEANFILES+= PLIST.${_curformat}

.if ${_cf} == "html-split.tar"
CLEANFILES+= $$([ -f HTML.manifest ] && ${XARGS} < HTML.manifest) \
		HTML.manifest ln*.html

.elif ${_cf} == "html.tar"
CLEANFILES+= ${DOC}.html

.elif ${_cf} == "txt"
CLEANFILES+= ${DOC}.html-text

.elif ${_cf} == "dvi"
CLEANFILES+= ${DOC}.aux ${DOC}.log ${DOC}.tex

.elif ${_cf} == "tex"
CLEANFILES+= ${DOC}.aux ${DOC}.log

.elif ${_cf} == "ps"
CLEANFILES+= ${DOC}.aux ${DOC}.dvi ${DOC}.log ${DOC}.tex-ps

.elif ${_cf} == "pdf"
CLEANFILES+= ${DOC}.aux ${DOC}.dvi ${DOC}.log ${DOC}.out ${DOC}.tex-pdf

.elif ${_cf} == "pdb"
_docs+= ${.CURDIR:T}.pdb
CLEANFILES+= ${.CURDIR:T}.pdb

.endif
.endif

.if (${LOCAL_CSS_SHEET} != ${CSS_SHEET}) && \
    (${_cf} == "html-split" || ${_cf} == "html-split.tar" || \
     ${_cf} == "html" || ${_cf} == "html.tar" || ${_cf} == "txt")
CLEANFILES+= ${LOCAL_CSS_SHEET}
.endif

.endfor


#
# Build a list of install-${format}.${compress_format} targets to be
# by "make install". Also, add ${DOC}.${format}.${compress_format} to
# ${_docs} and ${CLEANFILES} so they get built/cleaned by "all" and
# "clean".
#

.if defined(INSTALL_COMPRESSED) && !empty(INSTALL_COMPRESSED)
.for _curformat in ${FORMATS}
_cf=${_curformat}
.for _curcomp in ${INSTALL_COMPRESSED}

.if ${_cf} != "html-split" && ${_cf} != "html"
_curinst+= install-${_curformat}.${_curcomp}
_docs+= ${DOC}.${_curformat}.${_curcomp}
CLEANFILES+= ${DOC}.${_curformat}.${_curcomp}

.if  ${_cf} == "pdb"
_docs+= ${.CURDIR:T}.${_curformat}.${_curcomp}
CLEANFILES+= ${.CURDIR:T}.${_curformat}.${_curcomp}

.endif
.endif
.endfor
.endfor
.endif

#
# Index generation
#
CLEANFILES+= 		${INDEX_SGML}

.if defined(GEN_INDEX) && defined(HAS_INDEX)
JADEFLAGS+=		-i chap.index
HTML_SPLIT_INDEX?=	html-split.index
HTML_INDEX?=		html.index
PRINT_INDEX?=		print.index
INDEX_SGML?=		index.sgml

CLEANFILES+= 		${HTML_SPLIT_INDEX} ${HTML_INDEX} ${PRINT_INDEX}
.endif

.MAIN: all

all: ${_docs}

index.html HTML.manifest: ${SRCS} ${LOCAL_IMAGES_LIB} ${LOCAL_IMAGES_PNG} \
			  ${INDEX_SGML} ${HTML_SPLIT_INDEX} ${LOCAL_CSS_SHEET}
	${JADE} -V html-manifest ${HTMLOPTS} -ioutput.html.images \
		${JADEOPTS} -t sgml ${MASTERDOC}
.if !defined(NO_TIDY)
	-${TIDY} ${TIDYOPTS} $$(${XARGS} < HTML.manifest)
.endif

${DOC}.html: ${SRCS} ${LOCAL_IMAGES_LIB} ${LOCAL_IMAGES_PNG} \
	     ${INDEX_SGML} ${HTML_INDEX} ${LOCAL_CSS_SHEET}
	${JADE} -V nochunks ${HTMLOPTS} -ioutput.html.images \
		${JADEOPTS} -t sgml ${MASTERDOC} > ${.TARGET} || \
		(${RM} -f ${.TARGET} && false)
.if !defined(NO_TIDY)
	-${TIDY} ${TIDYOPTS} ${.TARGET}
.endif

# Special target to produce HTML with no images in it.
${DOC}.html-text: ${SRCS} ${INDEX_SGML} ${HTML_INDEX}
	${JADE} -V nochunks ${HTMLOPTS} \
		${JADEOPTS} -t sgml ${MASTERDOC} > ${.TARGET} || \
		(${RM} -f ${.TARGET} && false)

${DOC}.html-split.tar: HTML.manifest ${LOCAL_IMAGES_LIB} \
		       ${LOCAL_IMAGES_PNG} ${LOCAL_CSS_SHEET}
	${TAR} cf ${.TARGET} $$(${XARGS} < HTML.manifest) \
		${LOCAL_IMAGES_LIB} ${IMAGES_PNG} ${CSS_SHEET:T}

${DOC}.html.tar: ${DOC}.html ${LOCAL_IMAGES_LIB} \
		 ${LOCAL_IMAGES_PNG} ${LOCAL_CSS_SHEET}
	${TAR} cf ${.TARGET} ${DOC}.html \
		${LOCAL_IMAGES_LIB} ${IMAGES_PNG} ${CSS_SHEET:T}

${DOC}.txt: ${DOC}.html-text
	${HTML2TXT} ${HTML2TXTOPTS} ${.ALLSRC} > ${.TARGET}

${DOC}.pdb: ${DOC}.html ${LOCAL_IMAGES_LIB} ${LOCAL_IMAGES_PNG}
	${HTML2PDB} ${HTML2PDBOPTS} ${DOC}.html ${.TARGET}

${.CURDIR:T}.pdb: ${DOC}.pdb
	${LN} -f ${.ALLSRC} ${.TARGET}

.if defined(INSTALL_COMPRESSED) && !empty(INSTALL_COMPRESSED)
.for _curcomp in ${INSTALL_COMPRESSED}
${.CURDIR:T}.pdb.${_curcomp}: ${DOC}.pdb.${_curcomp}
	${LN} -f ${.ALLSRC} ${.TARGET}
.endfor
.endif

${DOC}.rtf: ${SRCS} ${LOCAL_IMAGES_EPS}
	${JADE} -V rtf-backend ${PRINTOPTS} \
		${JADEOPTS} -t rtf -o ${.TARGET} ${MASTERDOC}

#
# This sucks, but there's no way round it.  The PS and PDF formats need
# to use different image formats, which are chosen at the .tex stage.  So,
# we need to create a different .tex file depending on our eventual output
# format, which will then lead on to a different .dvi file as well.
#

${DOC}.tex: ${SRCS} ${LOCAL_IMAGES_EPS} ${INDEX_SGML} ${PRINT_INDEX}
	${JADE} -V tex-backend ${PRINTOPTS} \
		${JADEOPTS} -t tex -o ${.TARGET} ${MASTERDOC}

${DOC}.tex-ps: ${DOC}.tex
	${LN} -f ${.ALLSRC} ${.TARGET}

${DOC}.tex-pdf: ${SRCS} ${IMAGES_PDF} ${INDEX_SGML} ${PRINT_INDEX}
	${CP} -p ${PDFTEX_DEF} ${.TARGET}
	${JADE} -V tex-backend ${PRINTOPTS} -ioutput.print.pdf \
		${JADEOPTS} -t tex -o /dev/stdout ${MASTERDOC} >> ${.TARGET}

${DOC}.dvi: ${DOC}.tex ${LOCAL_IMAGES_EPS}
	@${ECHO} "==> TeX pass 1/3"
	-${TEX} "&jadetex" '${TEXCMDS} \nonstopmode\input{${DOC}.tex}'
	@${ECHO} "==> TeX pass 2/3"
	-${TEX} "&jadetex" '${TEXCMDS} \nonstopmode\input{${DOC}.tex}'
	@${ECHO} "==> TeX pass 3/3"
	-${TEX} "&jadetex" '${TEXCMDS} \nonstopmode\input{${DOC}.tex}'

${DOC}.pdf: ${DOC}.tex-pdf ${IMAGES_PDF}
	@${ECHO} "==> PDFTeX pass 1/3"
	-${PDFTEX} "&pdfjadetex" '${TEXCMDS} \nonstopmode\input{${DOC}.tex-pdf}'
	@${ECHO} "==> PDFTeX pass 2/3"
	-${PDFTEX} "&pdfjadetex" '${TEXCMDS} \nonstopmode\input{${DOC}.tex-pdf}'
	@${ECHO} "==> PDFTeX pass 3/3"
	${PDFTEX} "&pdfjadetex" '${TEXCMDS} \nonstopmode\input{${DOC}.tex-pdf}'

${DOC}.ps: ${DOC}.dvi
	${DVIPS} ${DVIPSOPTS} -o ${.TARGET} ${.ALLSRC}

${DOC}.tar: ${SRCS} ${LOCAL_IMAGES} ${LOCAL_CSS_SHEET}
	${TAR} cf ${.TARGET} -C ${.CURDIR} ${SRCS} \
		-C ${.OBJDIR} ${IMAGES} ${CSS_SHEET:T}

#
# Build targets for any formats we've missed that we don't handle.
#
.for _curformat in ${ALL_FORMATS}
.if !target(${DOC}.${_curformat})
${DOC}.${_curformat}:
	@${ECHO_CMD} \"${_curformat}\" is not a valid output format for this document.
.endif
.endfor


# ------------------------------------------------------------------------
#
# Validation targets
#

#
# Lets you quickly check that the document conforms to the DTD without
# having to convert it to any other formats
#

lint validate:
	${NSGMLS} -s ${SGMLFLAGS} ${CATALOGS} ${MASTERDOC}


# ------------------------------------------------------------------------
#
# Index targets
#

#
# Generate a different .index file based on the format name
#
# If we're not generating an index (the default) then we need to create
# an empty index.sgml file so that we can reference index.sgml in book.sgml
#

${INDEX_SGML}:
	${PERL} ${COLLATEINDEX} -N -o ${.TARGET}

${HTML_INDEX}:
	${JADE} -V html-index -V nochunks ${HTMLOPTS} -ioutput.html.images \
		${JADEOPTS} -t sgml ${MASTERDOC} > /dev/null
	${PERL} ${COLLATEINDEX} -g -o ${INDEX_SGML} ${.TARGET}

${HTML_SPLIT_INDEX}:
	${JADE} -V html-index ${HTMLOPTS} -ioutput.html.images \
		${JADEOPTS} -t sgml ${MASTERDOC} > /dev/null
	${PERL} ${COLLATEINDEX} -g -o ${INDEX_SGML} ${.TARGET}

${PRINT_INDEX}: ${HTML_INDEX}
	${CP} -p ${HTML_INDEX} ${.TARGET}


# ------------------------------------------------------------------------
#
# Compress targets
#

#
# The list of compression extensions this Makefile knows about. If you
# add new compression schemes, add to this list (which is a list of
# extensions, hence bz2, *not* bzip2) and extend the _PROG_COMPRESS_*
# targets.
#

KNOWN_COMPRESS=	gz bz2 zip

#
# You can't build suffix rules to do compression, since you can't
# wildcard the source suffix. So these are defined .USE, to be tacked on
# as dependencies of the compress-* targets.
#

_PROG_COMPRESS_gz: .USE
	${GZIP_CMD} < ${.ALLSRC} > ${.TARGET}

_PROG_COMPRESS_bz2: .USE
	${BZIP2_CMD} < ${.ALLSRC} > ${.TARGET}

_PROG_COMPRESS_zip: .USE
	${ZIP_CMD} ${.TARGET} ${.ALLSRC}

#
# Build a list of targets for each compression scheme and output format.
# Don't compress the html-split or html output format (because they need
# to be rolled in to tar files first).
#
.for _curformat in ${KNOWN_FORMATS}
_cf=${_curformat}
.for _curcompress in ${KNOWN_COMPRESS}
.if ${_cf} == "html-split" || ${_cf} == "html"
${DOC}.${_cf}.tar.${_curcompress}: ${DOC}.${_cf}.tar \
				   _PROG_COMPRESS_${_curcompress}
.else
${DOC}.${_cf}.${_curcompress}: ${DOC}.${_cf} _PROG_COMPRESS_${_curcompress}
.endif
.endfor
.endfor

#
# Build targets for any formats we've missed that we don't handle.
#
.for _curformat in ${ALL_FORMATS}
.for _curcompress in ${KNOWN_COMPRESS}
.if !target(${DOC}.${_curformat}.${_curcompress})
${DOC}.${_curformat}.${_curcompress}:
	@${ECHO_CMD} \"${_curformat}.${_curcompress}\" is not a valid output format for this document.
.endif
.endfor
.endfor


# ------------------------------------------------------------------------
#
# Install targets
#
# Build install-* targets, one per allowed value in FORMATS. Need to
# build two specific targets;
#
#    install-html-split - Handles multiple .html files being generated
#                         from one source. Uses the HTML.manifest file
#                         created by the stylesheets, which should list
#                         each .html file that's been created.
#
#    install-*          - Every other format. The wildcard expands to
#                         the other allowed formats, all of which should
#                         generate just one file.
#
# "beforeinstall" and "afterinstall" are hooks in to this process.
# Redefine them to do things before and after the files are installed,
# respectively.

#
# Build a list of install-format targets to be installed. These will be
# dependencies for the "realinstall" target.
#

.if !defined(INSTALL_ONLY_COMPRESSED) || empty(INSTALL_ONLY_COMPRESSED)
_curinst+= ${FORMATS:S/^/install-/g}
.endif

realinstall: ${_curinst}

.for _curformat in ${KNOWN_FORMATS}
_cf=${_curformat}
.if !target(install-${_cf})
.if ${_cf} == "html-split"
install-${_curformat}: index.html
.else
install-${_curformat}: ${DOC}.${_curformat}
.endif
	@[ -d ${DESTDIR} ] || ${MKDIR} -p ${DESTDIR}
.if ${_cf} == "html-split"
	${INSTALL_DOCS} $$(${XARGS} < HTML.manifest) ${DESTDIR}
.else
	${INSTALL_DOCS} ${.ALLSRC} ${DESTDIR}
.endif
.if (${_cf} == "html-split" || ${_cf} == "html") && !empty(LOCAL_CSS_SHEET)
	${INSTALL_DOCS} ${LOCAL_CSS_SHEET} ${DESTDIR}
.if ${_cf} == "html-split"
	@if [ -f ln*.html ]; then \
		${INSTALL_DOCS} ln*.html ${DESTDIR}; \
	fi
	@if [ -f ${.OBJDIR}/${DOC}.ln ]; then \
		cd ${DESTDIR}; sh ${.OBJDIR}/${DOC}.ln; \
	fi
.endif
.for _curimage in ${IMAGES_LIB}
	@[ -d ${DESTDIR}/${LOCAL_IMAGES_LIB_DIR}/${_curimage:H} ] || \
		${MKDIR} -p ${DESTDIR}/${LOCAL_IMAGES_LIB_DIR}/${_curimage:H}
	${INSTALL_DOCS} ${LOCAL_IMAGES_LIB_DIR}/${_curimage} \
			${DESTDIR}/${LOCAL_IMAGES_LIB_DIR}/${_curimage:H}
.endfor
# Install the images.  First, loop over all the image names that contain a
# directory seperator, make the subdirectories, and install.  Then loop over
# the ones that don't contain a directory separator, and install them in the
# top level.
.for _curimage in ${IMAGES_PNG:M*/*}
	${MKDIR} -p ${DESTDIR}/${_curimage:H}
	${INSTALL_DOCS} ${_curimage} ${DESTDIR}/${_curimage:H}
.endfor
.for _curimage in ${IMAGES_PNG:N*/*}
	${INSTALL_DOCS} ${_curimage} ${DESTDIR}
.endfor
.elif ${_cf} == "tex" || ${_cf} == "dvi"
.for _curimage in ${IMAGES_EPS:M*/*}
	${MKDIR} -p ${DESTDIR}/${_curimage:H}
	${INSTALL_DOCS} ${_curimage} ${DESTDIR}/${_curimage:H}
.endfor
.for _curimage in ${IMAGES_EPS:N*/*}
	${INSTALL_DOCS} ${_curimage} ${DESTDIR}
.endfor
.elif ${_cf} == "pdb"
	${LN} -f ${DESTDIR}/${.ALLSRC} ${DESTDIR}/${.CURDIR:T}.${_curformat}
.endif

.if ${_cf} == "html-split"
.for _compressext in ${KNOWN_COMPRESS}
install-${_curformat}.tar.${_compressext}: ${DOC}.${_curformat}.tar.${_compressext}
	@[ -d ${DESTDIR} ] || ${MKDIR} -p ${DESTDIR}
	${INSTALL_DOCS} ${.ALLSRC} ${DESTDIR}
.endfor
.else
.for _compressext in ${KNOWN_COMPRESS}
install-${_curformat}.${_compressext}: ${DOC}.${_curformat}.${_compressext}
	@[ -d ${DESTDIR} ] || ${MKDIR} -p ${DESTDIR}
	${INSTALL_DOCS} ${.ALLSRC} ${DESTDIR}
.if ${_cf} == "pdb"
	${LN} -f ${DESTDIR}/${.ALLSRC} \
		 ${DESTDIR}/${.CURDIR:T}.${_curformat}.${_compressext}
.endif
.endfor
.endif
.endif
.endfor

#
# Build install- targets for any formats we've missed that we don't handle.
#

.for _curformat in ${ALL_FORMATS}
.if !target(install-${_curformat})
install-${_curformat}:
	@${ECHO_CMD} \"${_curformat}\" is not a valid output format for this document.

.for _compressext in ${KNOWN_COMPRESS}
install-${_curformat}.${_compressext}:
	@${ECHO_CMD} \"${_curformat}.${_compressext}\" is not a valid output format for this document.
.endfor
.endif
.endfor


# ------------------------------------------------------------------------
#
# Package building
#

#
# realpackage is what is called in each subdirectory when a package
# target is called, or, rather, package calls realpackage in each
# subdirectory as it goes.
#
# packagelist returns the list of targets that would be called during
# package building.
#

realpackage: ${FORMATS:S/^/package-/}
packagelist:
	@${ECHO_CMD} ${FORMATS:S/^/package-/}

#
# Build a list of package targets for each output target.  Each package
# target depends on the corresponding install target running.
#

.for _curformat in ${KNOWN_FORMATS}
_cf=${_curformat}
.if ${_cf} == "html-split"
PLIST.${_curformat}: index.html
	@${SORT} HTML.manifest > PLIST.${_curformat}
.else
PLIST.${_curformat}: ${DOC}.${_curformat}
	@${ECHO_CMD} ${DOC}.${_curformat} > PLIST.${_curformat}
.endif
.if (${_cf} == "html-split" || ${_cf} == "html") && \
    (!empty(LOCAL_IMAGES_LIB) || !empty(IMAGES_PNG) || !empty(CSS_SHEET))
	@${ECHO_CMD} ${LOCAL_IMAGES_LIB} ${IMAGES_PNG} ${LOCAL_CSS_SHEET} | \
		${XARGS} -n1 >> PLIST.${_curformat}
.elif (${_cf} == "tex" || ${_cf} == "dvi") && !empty(IMAGES_EPS)
	@${ECHO_CMD} ${IMAGES_EPS} | ${XARGS} -n1 >> PLIST.${_curformat}
.elif ${_cf} == "pdb"
	@${ECHO_CMD} ${.CURDIR:T}.${_curformat} >> PLIST.${_curformat}
.endif

${PACKAGES}/${.CURDIR:T}.${LANGCODE}.${_curformat}.tgz: PLIST.${_cf}
	@${PKG_CREATE} -v -f ${.ALLSRC} -p ${DESTDIR} -s ${.OBJDIR} \
		-c -"FDP ${.CURDIR:T} ${_curformat} package" \
		-d -"FDP ${.CURDIR:T} ${_curformat} package" ${.TARGET}

package-${_curformat}: ${PACKAGES}/${.CURDIR:T}.${LANGCODE}.${_curformat}.tgz
.endfor

.if ${LOCAL_CSS_SHEET} != ${CSS_SHEET}
${LOCAL_CSS_SHEET}: ${CSS_SHEET}
	${CP} -p ${.ALLSRC} ${.TARGET}
.endif
