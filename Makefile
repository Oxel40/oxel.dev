#GHC_FLAGS=-dynamic -O2 -H16m -threaded
ELM_FLAGS=--optimize
#EXE_NAME=web

.PHONY = all clean 

HEAD_TMPL = head.html
FOOT_TMPL = foot.html
TMPLS := $(HEAD_TMPL) $(FOOT_TMPL)


findfiles = $(shell find $(1) -type f -name '$(2)' -print0 | xargs -0)


DIR_SRC  := $(shell find ./static/ -type d -print0 | xargs -0)
MD_SRC   := $(call findfiles,./static/,*.md)
HTM_SRC  := $(call findfiles,./static/,*.htm)   # Will be used in templates
HTML_SRC := $(call findfiles,./static/,*.html)  # Will be copied raw

HS_SRC   := $(call findfiles,./haskell/,*)
ELM_SRC  := $(call findfiles,./elm/,*)

DIR_DIST  := $(DIR_SRC:./static/%=./dist/%)
MD_DIST   := $(MD_SRC:./static/%.md=./dist/%.html)
HTM_DIST  := $(HTM_SRC:./static/%.htm=./dist/%.html)
HTML_DIST := $(HTML_SRC:./static/%=./dist/%)


all: $(DIR_DIST) $(MD_DIST) $(HTM_DIST) $(HTML_DIST)

clean:
	@# TODO add haskell and elm
	@rm -rf dist


$(DIR_DIST):
	mkdir -p $@

# Markdown
dist/%.html: static/%.md $(TMPLS)
	@echo "$@ <- $?"
	@cat $(HEAD_TMPL) <(pandoc -f markdown -t html $<) $(FOOT_TMPL) > $@

# HTM used with template
dist/%.html: static/%.htm $(TMPLS)
	@echo "$@ <- $?"
	@cat $(HEAD_TMPL) $< $(FOOT_TMPL) > $@

# Other required files will be copied
dist/%: static/% 
	@echo "$@ <- $?"
	@cp $< $@


build_haskell: $(HS_SRC)
	#ghc -outputdir ./out -o $(EXE_NAME) $(HS_SRC) $(GHC_FLAGS)
	cd haskell && cabal build
	cp ./haskell/dist-newstyle/build/*/*/*/*/web/build/web/web ./

build_elm: $(ELM_SRC)
	cd elm && elm make --output=./webapp.js $(ELM_SRC:./elm/%=%) $(ELM_FLAGS)
	cp ./elm/webapp.js ./static/
