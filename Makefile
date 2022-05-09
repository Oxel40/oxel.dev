HEAD_TMPL = ./tmpl/head.html
FOOT_TMPL = ./tmpl/foot.html
TMPLS := $(HEAD_TMPL) $(FOOT_TMPL)

.PHONY = all clean 


findfiles = $(shell find $(1) -type f -name '$(2)' -print0 | xargs -0)


DIR_SRC := $(shell find ./static/ -type d -print0 | xargs -0)
STC_SRC := $(call findfiles,./static/,*)
STC_SRC := $(STC_SRC:%.md=%.html)
STC_SRC := $(STC_SRC:%.htm=%.html)

DIR_DIST := $(DIR_SRC:./static/%=./dist/%)
STC_DIST := $(STC_SRC:./static/%=./dist/%)


all: $(DIR_DIST) $(STC_DIST) dist/post/index.html

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
dist/post/index.html: static/post/*.md
	@echo "$@ <- $?"
	@cat $(HEAD_TMPL) <(for p in $$(ls static/post/); do echo $$p; done) $(FOOT_TMPL) > $@
