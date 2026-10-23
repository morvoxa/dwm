# dwm - dynamic window manager
# See LICENSE file for copyright and license details.

include config.mk

SRC = drw.c dwm.c util.c
OBJ = ${SRC:.c=.o}

all: dwm

.c.o:
	${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk

config.h:
	cp config.def.h $@

dwm: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	rm -f dwm ${OBJ} dwm-${VERSION}.tar.gz

dist: clean
	mkdir -p dwm-${VERSION}
	cp -R LICENSE Makefile README config.def.h config.mk\
		dwm.1 drw.h util.h ${SRC} dwm.png transient.c dwm-${VERSION}
	tar -cf dwm-${VERSION}.tar dwm-${VERSION}
	gzip dwm-${VERSION}.tar
	rm -rf dwm-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f dwm ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/dwm
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < dwm.1 > ${DESTDIR}${MANPREFIX}/man1/dwm.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/dwm.1
	# Langsung arahkan ke /usr/share/xsessions agar terbaca oleh LightDM
	mkdir -p ${DESTDIR}/usr/share/xsessions
	echo "[Desktop Entry]" > ${DESTDIR}/usr/share/xsessions/dwm.desktop
	echo "Name=dwm" >> ${DESTDIR}/usr/share/xsessions/dwm.desktop
	echo "Comment=Dynamic window manager" >> ${DESTDIR}/usr/share/xsessions/dwm.desktop
	echo "Exec=${PREFIX}/bin/dwm" >> ${DESTDIR}/usr/share/xsessions/dwm.desktop
	echo "Type=XSession" >> ${DESTDIR}/usr/share/xsessions/dwm.desktop
	chmod 644 ${DESTDIR}/usr/share/xsessions/dwm.desktop

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/dwm\
		${DESTDIR}${MANPREFIX}/man1/dwm.1\
		${DESTDIR}/usr/share/xsessions/dwm.desktop
