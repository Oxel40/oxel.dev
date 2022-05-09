HEAD_TMPL = ./tmpl/head.html
FOOT_TMPL = ./tmpl/foot.html
TMPLS := $(HEAD_TMPL) $(FOOT_TMPL)

.PHONY = all clean 


findfiles = $(shell find $(1) -type f -name '$(2)' -print0 | xargs -0)


DIR_SRC := $(shell find ./static/ -type d -print0 | xargs -0)
MD_SRC  := $(call findfiles,./static/,*.md)
HTM_SRC := $(call findfiles,./static/,*.htm)   # Will be used in templates
CPY_SRC := $(filter-out $(MD_SRC) $(HTM_SRC),$(call findfiles,./static/,*))

DIR_DIST  := $(DIR_SRC:./static/%=./dist/%)
MD_DIST   := $(MD_SRC:./static/%.md=./dist/%.html)
HTM_DIST  := $(HTM_SRC:./static/%.htm=./dist/%.html)
CPY_DIST := $(CPY_SRC:./static/%=./dist/%)


all: $(DIR_DIST) $(MD_DIST) $(HTM_DIST) $(CPY_DIST) dist/post/index.html

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

# Posts index page
dist/post/index.html: $(MD_SRC)
	@echo "$@"
	@cat $(HEAD_TMPL) <(for p in $$(ls static/post/); do echo $$p; done) $(FOOT_TMPL) > $@
