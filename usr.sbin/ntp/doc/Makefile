# $FreeBSD$

.include <src.opts.mk>

SUBDIR=	drivers hints icons pic scripts

FILESDIR=	${SHAREDIR}/doc/ntp

MAN=	ntp.conf.5 ntp.keys.5
MAN+=	ntp-keygen.8 ntpd.8 ntpdate.8 ntpdc.8 ntpq.8 ntptime.8 sntp.8

.PATH: ${SRCTOP}/contrib/ntp/html \
	${SRCTOP}/contrib/ntp/util \
	${SRCTOP}/contrib/ntp/ntpd \
	${SRCTOP}/contrib/ntp/ntpsnmpd

.include <bsd.prog.mk>
