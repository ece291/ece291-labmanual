# $Id: Makefile,v 1.3 2001/08/01 20:02:32 pete Exp $

SUBDIR = labmanual pmode-tutorial lectures

DOC_PREFIX?= ${.CURDIR}
.include "${DOC_PREFIX}/share/mk/doc.project.mk"

