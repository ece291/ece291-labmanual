#
# $Id: Makefile,v 1.3 2001/06/27 22:34:56 pete Exp $
#
# Build the ECE 291 Lab Manual.
#

MAINTAINER=pete@bilogic.org

DOC?= book

FORMATS?= html-split pdf

#
# SRCS lists the individual SGML files that make up the document.  Changes to
# any of these files will force a rebuild
#

# SGML content
SRCS=  book.sgml
SRCS+= preface.sgml
SRCS+= introduction/chapter.sgml
SRCS+= using-pc/chapter.sgml
SRCS+= libraries/chapter.sgml
SRCS+= data-structures/chapter.sgml
SRCS+= io-devices/chapter.sgml
SRCS+= serial-comm/chapter.sgml
SRCS+= parallel-comm/chapter.sgml
SRCS+= glossary.sgml

# Entities
SRCS+= registers.ent
SRCS+= chapters.ent

# Images
IMAGES=  data-structures/lineararray.tex
IMAGES+= data-structures/lineararrayac.tex
IMAGES+= data-structures/dimensionalac.tex
IMAGES+= data-structures/llistinitial.dia
IMAGES+= data-structures/llistdelete.dia
IMAGES+= data-structures/llistafterdelete.dia
IMAGES+= data-structures/llistinsert.dia
IMAGES+= data-structures/llistbeforeinsert.dia
IMAGES+= data-structures/llistafterinsert.dia
IMAGES+= data-structures/btree.dia
IMAGES+= data-structures/hashfunction.tex
IMAGES+= data-structures/hfmod.tex
IMAGES+= data-structures/hfxor.tex
IMAGES+= io-devices/speaker.dia
IMAGES+= serial-comm/typconn.dia

SYMLINKS= ${DESTDIR} index.html

DOC_PREFIX?= ${.CURDIR}/..
.include "${DOC_PREFIX}/share/mk/doc.project.mk"

