#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License (the "License").
# You may not use this file except in compliance with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#

#
# Copyright (c) 2007, 2010, Oracle and/or its affiliates. All rights reserved.
# Copyright (c) 2012, OmniTI Computer Consulting, Inc. All rights reserved.
# Copyright 2022 OmniOS Community Edition (OmniOSce) Association.
#

include ../../Makefile.com

ROOT = ../../../proto/root_${MACH}
ROOTETC = $(ROOT)/etc
ROOTETCZONES = $(ROOT)/etc/zones
ROOTETCBRAND = $(ROOT)/etc/brand
ROOTUSRLIB = $(ROOT)/usr/lib
ROOTBRAND = $(ROOTUSRLIB)/brand

ROOTDIRS = \
	$(ROOT) \
	$(ROOTETC) \
	$(ROOTETCBRAND) \
	$(ROOTUSRLIB) \
	$(ROOTBRAND)

all:

install: $(ROOTDIRS) $(BRANDFILES)

clean:
	rm -f $(BINS) $(CLEANFILES)

clobber:
	rm -fr $(BINS) $(ROOTBRAND) $(ROOTETCZONES) $(ROOTETCBRAND)

$(ROOTDIRS) $(BRANDDIR):
	mkdir -p $@

$(BRANDDIR)/%: $(BRANDDIR) %
	rm -f $@; $(INSTALL) -f $(BRANDDIR) -m 0444 $<

INS.py= \
	{ \
		print "$(HASH)!/usr/bin/python$(PYVER) -Es"; \
		sed 1d $<; \
	} > $@; \
	chmod 755 $@

%: %.py
	$(INS.py)

