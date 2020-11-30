# $FreeBSD$

.include <src.opts.mk>

PACKAGE=runtime
PROG=	expr
SRCS=	expr.y
YFLAGS=

# expr relies on signed integer wrapping
CFLAGS+= -fwrapv

NO_WMISSING_VARIABLE_DECLARATIONS=

.include <bsd.prog.mk>
