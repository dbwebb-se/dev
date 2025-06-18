#!/usr/bin/env make
#
# To develop for dbwebb.se, clone, pull & push all repos within a single
# directory structure, aided by this Makefile.
# One repo to rule them all.
# See organisation on GitHub: https://github.com/dbwebb-se


# ------------------------------------------------------------------------
#
# General stuff, reusable for all Makefiles.
#

# Detect OS
OS = $(shell uname -s)

# Defaults
ECHO = echo

# Make adjustments based on OS
# http://stackoverflow.com/questions/3466166/how-to-check-if-running-in-cygwin-mac-or-linux/27776822#27776822
ifneq (, $(findstring CYGWIN, $(OS)))
	ECHO = /bin/echo -e
endif

# Colors and helptext
NO_COLOR	= \033[0m
ACTION		= \033[32;01m
OK_COLOR	= \033[32;01m
ERROR_COLOR	= \033[31;01m
WARN_COLOR	= \033[33;01m

# Which makefile am I in?
WHERE-AM-I = $(CURDIR)/$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
THIS_MAKEFILE := $(call WHERE-AM-I)

# Echo some nice helptext based on the target comment
HELPTEXT = $(ECHO) "$(ACTION)--->" `egrep "^\# target: $(1) " $(THIS_MAKEFILE) | sed "s/\# target: $(1)[ ]*-[ ]* / /g"` "$(NO_COLOR)"

# Check version  and path to command and display on one line
CHECK_VERSION = printf "%-15s %-10s %s\n" "`basename $(1)`" "`$(1) --version $(2)`" "`which $(1)`"

# Print out colored action message
ACTION_MESSAGE = $(ECHO) "$(ACTION)---> $(1)$(NO_COLOR)"



# target: help               - Displays help.
.PHONY:  help
help:
	@$(call HELPTEXT,$@)
	@sed '/^$$/q' $(THIS_MAKEFILE) | tail +3 | sed 's/#\s*//g'
	@$(ECHO) "Usage:"
	@$(ECHO) " make [target] ..."
	@$(ECHO) "target:"
	@egrep "^# target:" $(THIS_MAKEFILE) | sed 's/# target: / /g'



# ------------------------------------------------------------------------
#
# Specifics for this project.
#
BIN        := .bin
NODEMODBIN := node_modules/.bin

ORG := git@github.com:dbwebb-se

REPOS := website website-11ty dbwebb-cli lab slides tomato docker ctf ctf-website inspect-gui # sstatic

COURSES := python htmlphp js-v2 javascript1 design linux oopython databas databas-v2  dbjs linux oophp ramverk1 ramverk2 exjobb matmod databas webgl webapp itsec vlinux design-v3 webtec mvc pattern owasp courserepo-v2 webtec2

WEB_ORG := git@github.com:Webbprogrammering
WEB := websoft websoft.wiki

GITLABMOS_ORG := git@gitlab.com:mosbth
GITLABMOS := pedagogic-portfolio





# # target: prepare            - Prepare for tests and build
# .PHONY:  prepare
# prepare:
# 	@$(call HELPTEXT,$@)
# 	[ -d .bin ] || mkdir .bin
# 	[ -d build ] || mkdir build
# 	rm -rf build/*
#
#
#
# target: clone              - Clone all repos
.PHONY:  clone
clone: clone-repos clone-courses clone-web clone-gitlabmos clone-2025
	@$(call HELPTEXT,$@)



# target: pull               - Pull latest from all repos
.PHONY:  pull
pull: pull-repos pull-courses pull-web pull-gitlabmos pull-2025
	@$(call HELPTEXT,$@)
	git pull



# target: status             - Check status on all repos
.PHONY:  status
status: status-repos status-courses status-web status-gitlabmos
	@$(call HELPTEXT,$@)
	git status



# # target: install            - Install all repos
# .PHONY:  install
# install:
# 	@$(call HELPTEXT,$@)
#
#
#
# target: update             - Update the repos and essentials.
.PHONY:  update
update:
	@$(call HELPTEXT,$@)
	git pull
	$(MAKE) pull
	# [ ! -f composer.json ] || composer update
	# [ ! -f package.json ] || npm update



# target: clean              - Removes generated files and directories.
.PHONY: clean
clean:
	@$(call HELPTEXT,$@)



# target: clean-cache        - Clean the cache.
.PHONY:  clean-cache
clean-cache:
	@$(call HELPTEXT,$@)

# target: clean-all          - Removes generated files and directories.
.PHONY:  clean-all
clean-all: clean clean-cache clean-repos clean-courses clean-web clean-gitlabmos
	@$(call HELPTEXT,$@)
	#rm -rf .bin vendor node_modules



# ------------------------------------------------------------------------
#
# Top level repos
#

# target: clone-web        - Clone all general web.
.PHONY: clone-web
clone-web:
	@$(call HELPTEXT,$@)
	@cd web;                              \
	for repo in $(WEB) ; do               \
		$(call ACTION_MESSAGE,$$repo);      \
		[ -d $$repo ]                       \
			&& $(ECHO) "Repo already there, skipping cloning it." \
			&& continue;                    \
		git clone $(WEB_ORG)/$$repo.git;        \
	done



# target: pull-web         - Pull latest for all general web.
.PHONY: pull-web
pull-web:
	@$(call HELPTEXT,$@)
	@cd web;                              \
	for repo in $(WEB) ; do               \
		$(call ACTION_MESSAGE,$$repo);      \
		(cd $$repo && git pull);            \
	done



# target: clean-web        - Remove all top general web.
.PHONY: clean-web
clean-web:
	@$(call HELPTEXT,$@)
	cd web && rm -rf $(WEB)



# target: status-web       - Check status of each general web repo.
.PHONY: status-web
status-web:
	@$(call HELPTEXT,$@)
	@cd web;                                   \
	for repo in $(WEB) ; do                    \
		$(call ACTION_MESSAGE,$$repo);           \
		(cd $$repo && git status);               \
	done



# target: check-web        - Check details of each general repo.
.PHONY: check-web
check-web:
	@$(call HELPTEXT,$@)
	@cd web;                                      \
	for repo in $(WEB) ; do                       \
		$(call ACTION_MESSAGE,$$repo);              \
		du -sk $$repo/.git;                         \
	done



# ------------------------------------------------------------------------
#
# Top level repos
#

# target: clone-gitlabmos        - Clone all general web.
.PHONY: clone-gitlabmos
clone-gitlabmos:
	@$(call HELPTEXT,$@)
	@cd gitlabmos;                              \
	for repo in $(GITLABMOS) ; do               \
		$(call ACTION_MESSAGE,$$repo);      \
		[ -d $$repo ]                       \
			&& $(ECHO) "Repo already there, skipping cloning it." \
			&& continue;                    \
		git clone $(GITLABMOS_ORG)/$$repo.git;        \
	done



# target: pull-gitlabmos         - Pull latest for all general web.
.PHONY: pull-gitlabmos
pull-gitlabmos:
	@$(call HELPTEXT,$@)
	@cd gitlabmos;                              \
	for repo in $(GITLABMOS) ; do               \
		$(call ACTION_MESSAGE,$$repo);      \
		(cd $$repo && git pull);            \
	done



# target: clean-gitlabmos        - Remove all top general web.
.PHONY: clean-gitlabmos
clean-gitlabmos:
	@$(call HELPTEXT,$@)
	cd gitlabmos && rm -rf $(GITLABMOS)



# target: status-gitlabmos       - Check status of each general web repo.
.PHONY: status-gitlabmos
status-gitlabmos:
	@$(call HELPTEXT,$@)
	@cd gitlabmos;                                   \
	for repo in $(GITLABMOS) ; do                    \
		$(call ACTION_MESSAGE,$$repo);           \
		(cd $$repo && git status);               \
	done



# target: check-gitlabmos        - Check details of each general repo.
.PHONY: check-gitlabmos
check-gitlabmos:
	@$(call HELPTEXT,$@)
	@cd gitlabmos;                                      \
	for repo in $(GITLABMOS) ; do                       \
		$(call ACTION_MESSAGE,$$repo);              \
		du -sk $$repo/.git;                         \
	done



# ------------------------------------------------------------------------
#
# Top level repos
#

# target: clone-repos        - Clone all general repos.
.PHONY: clone-repos
clone-repos:
	@$(call HELPTEXT,$@)
	@cd repos;                              \
	for repo in $(REPOS) ; do               \
		$(call ACTION_MESSAGE,$$repo);      \
		[ -d $$repo ]                       \
			&& $(ECHO) "Repo already there, skipping cloning it." \
			&& continue;                    \
		git clone $(ORG)/$$repo.git;        \
	done



# target: pull-repos         - Pull latest for all general repos.
.PHONY: pull-repos
pull-repos:
	@$(call HELPTEXT,$@)
	@cd repos;                              \
	for repo in $(REPOS) ; do               \
		$(call ACTION_MESSAGE,$$repo);      \
		(cd $$repo && git pull);            \
	done



# target: clean-repos        - Remove all top general repos.
.PHONY: clean-repos
clean-repos:
	@$(call HELPTEXT,$@)
	cd repos && rm -rf $(REPOS)



# target: status-repos       - Check status of each general repo.
.PHONY: status-repos
status-repos:
	@$(call HELPTEXT,$@)
	@cd repos;                                   \
	for repo in $(REPOS) ; do                    \
		$(call ACTION_MESSAGE,$$repo);           \
		(cd $$repo && git status);               \
	done



# target: check-repos        - Check details of each general repo.
.PHONY: check-repos
check-repos:
	@$(call HELPTEXT,$@)
	@cd repos;                                      \
	for repo in $(REPOS) ; do                       \
		$(call ACTION_MESSAGE,$$repo);              \
		du -sk $$repo/.git;                         \
	done



# ------------------------------------------------------------------------
#
# Courses
#

# target: clone-courses      - Clone all courses.
.PHONY: clone-courses
clone-courses:
	@$(call HELPTEXT,$@)
	@cd kurser;                             \
	for repo in $(COURSES) ; do             \
		$(call ACTION_MESSAGE,$$repo);      \
		[ -d $$repo ]                       \
			&& $(ECHO) "Repo already there, skipping cloning it." \
			&& continue;                    \
		git clone $(ORG)/$$repo.git;        \
	done



# target: pull-courses       - Pull latest for all courses.
.PHONY: pull-courses
pull-courses:
	@$(call HELPTEXT,$@)
	@cd kurser;                             \
	for repo in $(COURSES) ; do             \
		$(call ACTION_MESSAGE,$$repo);      \
		(cd $$repo && git pull);            \
	done



# target: clean-courses      - Remove all known courses.
.PHONY: clean-courses
clean-courses:
	@$(call HELPTEXT,$@)
	cd kurser && rm -rf $(COURSES)



# target: status-courses     - Check status of each course repo.
.PHONY: status-courses
status-courses:
	@$(call HELPTEXT,$@)
	@cd kurser;                                     \
	for repo in $(COURSES) ; do                     \
		$(call ACTION_MESSAGE,$$repo);              \
		(cd $$repo && git status);                  \
	done



# target: check-courses      - Check details of each course repo.
.PHONY: check-courses
check-courses:
	@$(call HELPTEXT,$@)
	@cd kurser;                                     \
	for repo in $(COURSES) ; do                     \
		$(call ACTION_MESSAGE,$$repo);              \
		du -sk $$repo/.git;                         \
	done



# ------------------------------------------------------------------------
#
# 2025
#

#20205_BASE := git@github.com
#2025 := 

# target: clone-2025          - Clone all 2025 repos
.PHONY:  clone-2025
clone-2025:
	@$(call HELPTEXT,$@)

# Kursen webtec organisation
	@dir="2025/webtec/owner"; \
	repo="git@github.com:bth-webtec/owner.git"; \
	[ -d $$dir ] || git clone $$repo $$dir;

	@dir="2025/webtec/student"; \
	repo="git@github.com:bth-webtec/student.git"; \
	[ -d $$dir ] || git clone $$repo $$dir;

# Demo organisation
	@dir="2025/webtec/website_"; \
	repo="git@github.com:webtec-2024/website.git"; \
	[ -d $$dir ] || git clone $$repo $$dir;

	@dir="2025/webtec/teacher_"; \
	repo="git@github.com:webtec-2024/teacher.git"; \
	[ -d $$dir ] || git clone $$repo $$dir;

	@dir="2025/webtec/student_"; \
	repo="git@github.com:webtec-2024/student.git"; \
	[ -d $$dir ] || git clone $$repo $$dir;

# New dbwebbse website
	@dir="2025/repo/website"; \
	repo="git@github.com:dbwebb-se/dbwebb.bth.se.git"; \
	[ -d $$dir ] || git clone $$repo $$dir;

# target: pull-2025           - Pull latest from all2025 repos
.PHONY: pull-2025
pull-2025:
	@$(call HELPTEXT,$@)
	@cd 2025;                            \
	for repo in `ls` ; do                \
		$(call ACTION_MESSAGE,$$repo);   \
		cd $$repo; git pull; cd ..;      \
	done

	for repo in `ls *` ; do                \
		$(call ACTION_MESSAGE,$$repo);   \
		cd $$repo; git pull; cd ..;      \
	done
