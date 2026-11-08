help:
	@echo 'Usage: make [target]'
	@echo
	@echo 'Publish Targets:'
	@echo '  cc       Reset and publish this repository to origins'
	@echo '  push     Publish updates to origins without a full reset'
	@echo
	@echo 'Dependency Management Targets:'
	@echo '  js       Fetch KaTeX distribution'
	@echo '  rejs     Refetch KaTeX distribution'
	@echo '  cl       Fetch Common Lisp dependencies'
	@echo '  recl     Refetch Common Lisp dependencies'
	@echo
	@echo 'Development Targets:'
	@echo '  du       Show disk usage'
	@echo '  mp3tags  Show MP3 and Ogg metadata'
	@echo
	@echo 'Default Target:'
	@echo '  help     Show this help message'


# Publish Repo
# ------------

clean:
	find . -name ".DS_Store" -exec rm {} +

reset:
	rm -rf .git
	git init
	git config user.name "Susam Pal"
	git config user.email "susam@susam.net"
	git remote add gh git@github.com:susam/fs.git
	git remote add cb git@codeberg.org:susam/fs.git
	git add .
	git commit -m "Reset repository and add files"
	du -sh .git

push:
	git push -f cb main
	git push -f gh main

cc: clean reset push


# Bundle Dependencies
# -------------------

rejs: rmjs js

rmjs:
	rm -rf tree/js/

js:
	! [ -e tree/js/ ]
	mkdir -p tree/js/
	rm -f /tmp/katex.tar.gz
	curl -sSLo /tmp/katex.tar.gz https://github.com/KaTeX/KaTeX/releases/download/v0.19.1/katex.tar.gz
	tar -xvf /tmp/katex.tar.gz -C tree/js/

recl: rmcl cl

rmcl:
	rm -rf opt/cl/

cl:
	! [ -e opt/cl/ ]
	mkdir -p opt/cl/form/
	while read -r url; do \
	  echo "Fetching $$url" && curl -sSL "$$url" | tar -C opt/cl/form/ -xz; \
	done < opt/clform.txt


# Development Targets
# -------------------

du:
	du -sh -I .git . && du -sh .git

mp3tags:
	find . -iname '*.mp3' | while read -r file; do \
	  echo && echo "FILE: $$file" && echo; \
	  exiftool -a -G0:1:2:3:4:5:6:7:8:9 -s "$$file"; \
	done
