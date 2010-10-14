FONTFORGE:=/usr/bin/env fontforge
XGRIDFIT:=/usr/bin/env xgridfit
VERSION:=$(shell date +"%Y%m%d")
FAMILY=Liberastika
PKGNAME=liberastika
XGFFILES=$(FAMILY)-Regular.xgf $(FAMILY)-Bold.xgf $(FAMILY)-Italic.xgf $(FAMILY)-BoldItalic.xgf upr_*.xgf it_*.xgf \
		skipautoinst.txt
SFDFILES=$(FAMILY)-Regular.sfd $(FAMILY)-Bold.sfd $(FAMILY)-Italic.sfd $(FAMILY)-BoldItalic.sfd
DOCUMENTS=AUTHORS ChangeLog COPYING README
TTFFILES=$(FAMILY)-Regular.ttf $(FAMILY)-Bold.ttf $(FAMILY)-Italic.ttf $(FAMILY)-BoldItalic.ttf
XGRIDFITFLAGS=-p 25 -G no
FFSCRIPTS=generate.ff 
EXTRAFFSCRIPTS=make_dup_vertshift.ff new_glyph.ff add_anchor_ext.ff \
	add_anchor_y.ff add_anchor_med.ff anchors.ff combining.ff make_comb.ff \
	dub_glyph.ff spaces_dashes.ff case_sub.ff add_ipa.ff hflip_glyph.ff \
	make_dup_rot.ff add_accented.ff dub_glyph_ch.ff same_cyrext.ff \
	make_cap_accent.ff make_superscript.ff dub_aligned.ff \
	cop_kern.ff cop_kern_acc.ff copy_anchors_acc.ff 
COMPRESS=xz -9
TEXENC=ot1,t1,t2a
#PYTHON=python -W all
PYTHON=fontforge -lang=py -script 

INSTALL=install
DESTDIR=
prefix=/usr
fontdir=$(prefix)/share/fonts/TTF
docdir=$(prefix)/doc/$(PKGNAME)

all: $(TTFFILES)

$(FAMILY)-Regular_.sfd: $(FAMILY)-Regular.sfd $(FFSCRIPTS) $(EXTRAFFSCRIPTS)
	$(FONTFORGE) -lang=ff -script generate.ff $(FAMILY)-Regular

$(FAMILY)-Regular.ttf: $(FAMILY)-Regular.py $(FAMILY)-Regular_.sfd
	$(FONTFORGE) -lang=py -script $(FAMILY)-Regular.py

$(FAMILY)-Regular.py: $(FAMILY)-Regular.xgf upr_*.xgf $(FAMILY)-Regular_acc.xgf
	$(XGRIDFIT) $(XGRIDFITFLAGS) $(FAMILY)-Regular.xgf

$(FAMILY)-Bold_.sfd: $(FAMILY)-Bold.sfd $(FFSCRIPTS) $(EXTRAFFSCRIPTS)
	$(FONTFORGE) -lang=ff -script generate.ff $(FAMILY)-Bold

$(FAMILY)-Bold.ttf: $(FAMILY)-Bold.py $(FAMILY)-Bold_.sfd
	$(FONTFORGE) -lang=py -script $(FAMILY)-Bold.py

$(FAMILY)-Bold.py: $(FAMILY)-Bold.xgf upr_*.xgf $(FAMILY)-Bold_acc.xgf
	$(XGRIDFIT) $(XGRIDFITFLAGS) $(FAMILY)-Bold.xgf

$(FAMILY)-Italic_.sfd: $(FAMILY)-Italic.sfd $(FFSCRIPTS) $(EXTRAFFSCRIPTS)
	$(FONTFORGE) -lang=ff -script generate.ff $(FAMILY)-Italic

$(FAMILY)-Italic.ttf: $(FAMILY)-Italic.py $(FAMILY)-Italic_.sfd
	$(FONTFORGE) -lang=py -script $(FAMILY)-Italic.py

$(FAMILY)-Italic.py: $(FAMILY)-Italic.xgf upr_*.xgf it_*.xgf $(FAMILY)-Italic_acc.xgf
	$(XGRIDFIT) $(XGRIDFITFLAGS) $(FAMILY)-Italic.xgf

$(FAMILY)-BoldItalic_.sfd: $(FAMILY)-BoldItalic.sfd $(FFSCRIPTS) $(EXTRAFFSCRIPTS)
	$(FONTFORGE) -lang=ff -script generate.ff $(FAMILY)-BoldItalic

$(FAMILY)-BoldItalic.ttf: $(FAMILY)-BoldItalic.py $(FAMILY)-BoldItalic_.sfd
	$(FONTFORGE) -lang=py -script $(FAMILY)-BoldItalic.py

$(FAMILY)-BoldItalic.py: $(FAMILY)-BoldItalic.xgf upr_*.xgf it_*.xgf  $(FAMILY)-BoldItalic_acc.xgf
	$(XGRIDFIT) $(XGRIDFITFLAGS) $(FAMILY)-BoldItalic.xgf

$(FAMILY)-Regular_acc.xgf: $(FAMILY)-Regular_.sfd inst_acc.py
	$(PYTHON) inst_acc.py -c -s skipautoinst.txt -i $(FAMILY)-Regular_.sfd  -o $(FAMILY)-Regular_acc.xgf

$(FAMILY)-Bold_acc.xgf: $(FAMILY)-Bold_.sfd inst_acc.py
	$(PYTHON) inst_acc.py -c -s skipautoinst.txt -i $(FAMILY)-Bold_.sfd  -o $(FAMILY)-Bold_acc.xgf

%_acc.xgf: %_.sfd inst_acc.py
	$(PYTHON) inst_acc.py -s skipautoinst.txt -i $*_.sfd  -o $*_acc.xgf

tex-support: all
	mkdir -p texmf
	-rm -rf ./texmf/*
	mkdir -p texmf/fonts/truetype/public/$(PKGNAME)
	cp -a $(TTFFILES) texmf/fonts/truetype/public/$(PKGNAME)/
	TEXMFVAR=`pwd`/texmf autoinst --encoding=$(TEXENC) \
	--extra="--typeface=$(PKGNAME) --no-updmap  --vendor=public  --type42" \
	--sanserif \
	$(TTFFILES)
	mkdir -p texmf/fonts/enc/dvips/$(PKGNAME)
	mv texmf/fonts/enc/dvips/public/* texmf/fonts/enc/dvips/$(PKGNAME)/
	-rm -r texmf/fonts/enc/dvips/public
	mkdir -p texmf/tex/latex/$(PKGNAME)
	mkdir -p texmf/fonts/map/dvips/$(PKGNAME)
	mv *$(FAMILY)-TLF.fd texmf/tex/latex/$(PKGNAME)/
	mv $(FAMILY).sty texmf/tex/latex/$(PKGNAME)/$(PKGNAME).sty
	mv $(FAMILY).map texmf/fonts/map/dvips/$(PKGNAME)/$(PKGNAME).map
	mkdir -p texmf/dvips/$(PKGNAME)
	echo "p +$(PKGNAME).map" > texmf/dvips/$(PKGNAME)/config.$(PKGNAME)
	mkdir -p texmf/doc/fonts/$(PKGNAME)
	cp -p $(DOCUMENTS) texmf/doc/fonts/$(PKGNAME)/

dist-src:
	tar -cvf $(PKGNAME)-src-$(VERSION).tar $(XGFFILES) $(SFDFILES) \
	Makefile $(DOCUMENTS) $(FFSCRIPTS)
	$(COMPRESS) $(PKGNAME)-src-$(VERSION).tar

dist-ttf: all
	tar -cvf $(PKGNAME)-ttf-$(VERSION).tar \
	$(TTFFILES) $(DOCUMENTS)
	$(COMPRESS) $(PKGNAME)-ttf-$(VERSION).tar

dist-tex:
	( cd ./texmf ;\
	tar -cvf ../$(PKGNAME)-tex-$(VERSION).tar \
	doc dvips fonts tex )
	$(COMPRESS) $(PKGNAME)-tex-$(VERSION).tar

dist: dist-src dist-ttf

update-version:
	sed -e "s/^Version: .*$$/Version: $(VERSION)/" -i $(SFDFILES) \
	-e 's/"Version [0-9\.]*"/"Version $(VERSION)"/' -i $(SFDFILES)

clean :
	rm *.gen.ttx *.gen.xgf *.tmp.xgf *.gen.ttf 

distclean :
	-rm $(OTFFILES) $(TTFFILES) $(PFBFILES) $(AFMFILES) $(FAMILY)-*_.sfd $(FAMILY)-*_acc.xgf

install:
	mkdir -p $(DESTDIR)$(fontdir)
	$(INSTALL) -p --mode=644 $(TTFFILES) $(DESTDIR)$(fontdir)/
	mkdir -p $(DESTDIR)$(docdir)
	$(INSTALL) -p --mode=644 $(DOCUMENTS) $(DESTDIR)$(docdir)/

%.pe-dist:
	$(XGRIDFIT) -p 25 -G no -l ff -i $*_.sfd -o $*.ttf -S pe/$* $*.xgf

