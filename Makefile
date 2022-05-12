HEAD_TMPL = ./tmpl/head.html
FOOT_TMPL = ./tmpl/foot.html
TMPLS := $(HEAD_TMPL) $(FOOT_TMPL)

.PHONY = all clean install clean-remote


DIR_SRC := $(shell find ./static/ -type d -print0 | xargs -0)
STC_SRC := $(shell find ./static/ -type f -print0 | xargs -0)
STC_SRC := $(STC_SRC:%.md=%.html)
STC_SRC := $(STC_SRC:%.t.html=%.html)

DIR_DIST := $(DIR_SRC:./static/%=./dist/%)
STC_DIST := $(STC_SRC:./static/%=./dist/%)


all: $(DIR_DIST) $(STC_DIST) dist/post/index.html

clean:
	@rm -rf dist

install:
	@rsync -ruvhP -e ssh dist/* drop:/var/www/html/

clean-remote:
	@ssh drop 'rm -r /var/www/html/*'


$(DIR_DIST):
	mkdir -p $@

# Markdown
dist/%.html: static/%.md $(TMPLS)
	@echo "$@ <- $?"
	@cat <(sed "s/|TITLE|/$$(grep '^# .*$$' $< | head -1 | cut -c 3-)/" $(HEAD_TMPL)) \
	     <(pandoc -f markdown -t html5 $<) \
	     $(FOOT_TMPL) > $@

# HTM used with template
dist/%.html: static/%.t.html $(TMPLS)
	@echo "$@ <- $?"
	@cat <(sed "s/|TITLE|/$$(grep --only-matching '>.*</h1>' $< | head -1 | cut -c 2- | cut -d'<' -f1)/" $(HEAD_TMPL)) \
	     $< $(FOOT_TMPL) > $@

# Other required files will be copied
dist/%: static/%
	@echo "$@ <- $?"
	@cp $< $@

# Posts index page
dist/post/index.html: static/post/*.md $(TMPLS)
	@echo "$@ <- $?"
	@cat <(sed "s/|TITLE|/Posts/" $(HEAD_TMPL)) \
	     <(for p in $$(ls static/post/); do echo $$p; done) \
	     $(FOOT_TMPL) > $@
