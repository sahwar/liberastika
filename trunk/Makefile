FONTFORGE:=/usr/bin/env fontforge
XGRIDFIT:=/usr/bin/env xgridfit
VERSION:=$(shell date +"%Y%m%d")
FAMILY=Liberastika
PACKNAME=Liberastika
XGFFILES=$(FAMILY)-Regular.xgf $(FAMILY)-Bold.xgf $(FAMILY)-Italic.xgf $(FAMILY)-BoldItalic.xgf upr_*.xgf it_*.xgf
SFDFILES=$(FAMILY)-Regular.sfd $(FAMILY)-Bold.sfd $(FAMILY)-Italic.sfd $(FAMILY)-BoldItalic.sfd
DOCUMENTS=AUTHORS ChangeLog COPYING README
TTFFILES=$(FAMILY)-Regular.ttf $(FAMILY)-Bold.ttf $(FAMILY)-Italic.ttf $(FAMILY)-BoldItalic.ttf
XGRIDFITFLAGS=-p 25 -G no
FFSCRIPTS=generate.ff make_dup_vertshift.pe new_glyph.ff add_anchor_ext.ff \
	add_anchor_y.ff add_anchor_med.ff anchors.ff combining.ff make_comb.ff \
	dub_glyph.pe spaces_dashes.ff case_sub.ff add_ipa.ff hflip_glyph.ff \
	make_dup_rot.ff add_accented.ff dub_glyph_ch.ff same_cyrext.ff \
	make_cap_accent.ff make_superscript.ff dub_aligned.ff \
	cop_kern.ff cop_kern_acc.ff copy_anchors_acc.ff

INSTALL=install
DESTDIR=
fontdir=/usr/share/fonts/TTF
docdir=/usr/doc/$(PACKNAME)


all: $(TTFFILES)

$(FAMILY)-Regular_.sfd: $(FAMILY)-Regular.sfd $(FFSCRIPTS)
	$(FONTFORGE) -lang=ff -script generate.ff $(FAMILY)-Regular

$(FAMILY)-Regular.ttf: $(FAMILY)-Regular.pe $(FAMILY)-Regular_.sfd
	$(FONTFORGE) -lang=ff -script $(FAMILY)-Regular.pe

$(FAMILY)-Regular.pe: $(FAMILY)-Regular.xgf upr_*.xgf
	$(XGRIDFIT) $(XGRIDFITFLAGS) $(FAMILY)-Regular.xgf

$(FAMILY)-Bold_.sfd: $(FAMILY)-Bold.sfd $(FFSCRIPTS)
	$(FONTFORGE) -lang=ff -script generate.ff $(FAMILY)-Bold

$(FAMILY)-Bold.ttf: $(FAMILY)-Bold.pe $(FAMILY)-Bold_.sfd
	$(FONTFORGE) -lang=ff -script $(FAMILY)-Bold.pe

$(FAMILY)-Bold.pe: $(FAMILY)-Bold.xgf upr_*.xgf
	$(XGRIDFIT) $(XGRIDFITFLAGS) $(FAMILY)-Bold.xgf

$(FAMILY)-Italic_.sfd: $(FAMILY)-Italic.sfd $(FFSCRIPTS)
	$(FONTFORGE) -lang=ff -script generate.ff $(FAMILY)-Italic

$(FAMILY)-Italic.ttf: $(FAMILY)-Italic.pe $(FAMILY)-Italic_.sfd
	$(FONTFORGE) -lang=ff -script $(FAMILY)-Italic.pe

$(FAMILY)-Italic.pe: $(FAMILY)-Italic.xgf upr_*.xgf it_*.xgf
	$(XGRIDFIT) $(XGRIDFITFLAGS) $(FAMILY)-Italic.xgf

$(FAMILY)-BoldItalic_.sfd: $(FAMILY)-BoldItalic.sfd $(FFSCRIPTS)
	$(FONTFORGE) -lang=ff -script generate.ff $(FAMILY)-BoldItalic

$(FAMILY)-BoldItalic.ttf: $(FAMILY)-BoldItalic.pe $(FAMILY)-BoldItalic_.sfd
	$(FONTFORGE) -lang=ff -script $(FAMILY)-BoldItalic.pe

$(FAMILY)-BoldItalic.pe: $(FAMILY)-BoldItalic.xgf upr_*.xgf it_*.xgf
	$(XGRIDFIT) $(XGRIDFITFLAGS) $(FAMILY)-BoldItalic.xgf

dist-src:
	tar -cvf $(PACKNAME)-src-$(VERSION).tar $(XGFFILES) $(SFDFILES) \
	Makefile $(DOCUMENTS) $(FFSCRIPTS)
	xz -9 $(PACKNAME)-src-$(VERSION).tar

dist-ttf: all
	tar -cvf $(PACKNAME)-ttf-$(VERSION).tar \
	$(TTFFILES) $(DOCUMENTS)
	xz -9 $(PACKNAME)-ttf-$(VERSION).tar

dist: dist-src dist-ttf

update-version:
	sed -e "s/^Version: .*$$/Version: $(VERSION)/" -i $(SFDFILES) \
	-e 's/"Version [0-9\.]*"/"Version $(VERSION)"/' -i $(SFDFILES)

install:
	mkdir -p $(DESTDIR)$(fontdir)
	$(INSTALL) -p --mode=644 $(TTFFILES) $(DESTDIR)$(fontdir)/
	mkdir -p $(DESTDIR)$(docdir)
	$(INSTALL) -p --mode=644 $(DOCUMENTS) $(DESTDIR)$(docdir)/

