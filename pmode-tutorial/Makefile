#
# $Id: Makefile,v 1.1 2001/08/01 20:00:25 pete Exp $
#
# Build the ECE 291 Protected Mode Tutorial.
#

MAINTAINER=pete@bilogic.org

DOC?= book

FORMATS?= html-split

#
# SRCS lists the individual SGML files that make up the document.  Changes to
# any of these files will force a rebuild
#

# SGML content
SRCS=  book.sgml
SRCS+= introduction/chapter.sgml
SRCS+= dev-env/chapter.sgml
SRCS+= start-pmode/chapter.sgml

# Entities
SRCS+= chapters.ent

# Images

SYMLINKS= ${DESTDIR} index.html

DOC_PREFIX?= ${.CURDIR}/..
.include "${DOC_PREFIX}/share/mk/doc.project.mk"

