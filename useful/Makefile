# makefile to update the RCS record of the useful toolbox
#
# USAGE:
#	make
#	make all
#	make revision	: check in and check out all .m files
#
#	make tarball	: does make revision and does a tar package of the
#			  scripts
#
#	make rcs	: makes a tarball of the RCS subdirectory (creating an
#			  archive of the revision record)
#
#	make docs	: refresh the m2html documentation
#
# CREATED BY: CMDR 2008/01/02 
# 
# $Revision: 1.1 $
# $Date: 2008-04-15 00:20:19 $
# $Id: Makefile,v 1.1 2008-04-15 00:20:19 duncombe Exp $
# 
# 

REVISION:=$(shell date "+v%Y%m%d%H%M")
# beckman:=$(shell cd beckman && ls *.m) 
# NON_MFILES:= Makefile notes.txt salt-txt2dat

.DEFAULT_GOAL	:=	revision
.PHONY : FORCE
.PHONY : 
.PHONY : docs
.PHONY : rcs
.PHONY : tarball
.PHONY : revision
.PHONY : all

all:	revision

revision:	
	# @ -mv -i beckman/*.m .
	@ -ci -d -M -l *.m $(NON_MFILES)
	# @ -mv -i ${beckman} beckman/  
	@#

tarball :	
	# @ -mv -i beckman/*.m .
	@ -ci -d -M -l -n${REVISION}  *.m $(NON_MFILES)
	@ -tar czf useful_package_${REVISION}.tgz *.m $(NON_MFILES)
	# @ -mv -i ${beckman} beckman/    
	@#

rcs :	revision
	@ -tar czf useful_rcs_${REVISION}.tgz RCS


docs :	
	@ tar czf html-backup.tgz html/ && rm -r html/
	@ (cd ..; matlab -nojvm -nodisplay -r "	\
		more off; \
		m2html( 'mfiles','ctdcal', \
			'htmldir','ctdcal/html', \
			'recursive','on', \
			'source','on', \
			'graph','on');	\
		exit;")

% : FORCE
	ci -d -M -l $@ 

FORCE : ;

