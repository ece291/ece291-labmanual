#
# $IdPath$
#
# Build the ECE 291 Lab Manual.
#

MAINTAINER=pete@bilogic.org

DOC?= book

FORMATS?= html-split pdf ps

#BOOK_OUTPUT= 1
HAS_INDEX= true

OPENJADE?= yes

#
# SRCS lists the individual SGML files that make up the document.  Changes to
# any of these files will force a rebuild
#

# SGML content
SRCS=  book.sgml

SRCS+= introduction/chapter.sgml
SRCS+= using-pc/chapter.sgml
SRCS+= text-editors/chapter.sgml

SRCS+= assembly/chapter.sgml
SRCS+= nasm/chapter.sgml
SRCS+= debugging/chapter.sgml
SRCS+= data-structures/chapter.sgml
SRCS+= c-prog/chapter.sgml
SRCS+= libraries/chapter.sgml

SRCS+= io-devices/chapter.sgml
SRCS+= graphics/chapter.sgml
SRCS+= serial-comm/chapter.sgml
SRCS+= parallel-comm/chapter.sgml

SRCS+= pmode-intro/chapter.sgml
SRCS+= djgpp/chapter.sgml
SRCS+= start-pmode/chapter.sgml
SRCS+= realprot-diff/chapter.sgml
SRCS+= pmodelib-intro/chapter.sgml

SRCS+= sound/chapter.sgml

SRCS+= pmodelib-ref/appendix.sgml
SRCS+= inst-ref/appendix.sgml
SRCS+= flags-xref/appendix.sgml
SRCS+= ascii-code/appendix.sgml

SRCS+= glossary.sgml
SRCS+= colophon.sgml

# Entities
SRCS+= chapters.ent

# Images
IMAGES=  titlepage.dia
IMAGES+= introduction/mpgrade.tex
IMAGES+= introduction/bigpicture.dia
IMAGES+= assembly/flags.dia
IMAGES+= data-structures/lineararray.tex
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
IMAGES+= c-prog/enterstack-value.dia
IMAGES+= c-prog/enterstack-ref.dia
IMAGES+= io-devices/speaker.dia
IMAGES+= graphics/text-memory.dia
IMAGES+= graphics/text-memory-size.tex
IMAGES+= graphics/attrib-byte.dia
IMAGES+= graphics/mode13h-offset.tex
IMAGES+= serial-comm/typconn.dia
IMAGES+= serial-comm/baudfreq.dia
IMAGES+= serial-comm/nullmodem.dia
IMAGES+= serial-comm/adapter.dia
IMAGES+= serial-comm/plug9pins.dia
IMAGES+= serial-comm/plug9pins-null.dia
IMAGES+= parallel-comm/timing.dia
IMAGES+= parallel-comm/logic.dia
IMAGES+= sound/dma.dia
IMAGES+= sound/dma1.dia
IMAGES+= ascii-code/quickref.dia

SYMLINKS= ${DESTDIR} index.html

# Turn on all the chapters.
CHAPTERS?= ${SRCS:M*.sgml:Nbook.sgml}

SGMLFLAGS+= ${CHAPTERS:S/\/chapter//:S/\/appendix//:S/.sgml//:S/^/-i chap./}

DOC_PREFIX?= ${.CURDIR}/..
.include "${DOC_PREFIX}/share/mk/doc.project.mk"

