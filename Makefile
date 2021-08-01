#GHC_FLAGS=-dynamic -O2 -H16m -threaded
ELM_FLAGS=--optimize
#EXE_NAME=web

.PHONY = build_all

HS_SRCS := $(wildcard ./haskell/src/*.hs)
ELM_SRCS := $(wildcard ./elm/src/*.elm)

build_all: build_haskell build_elm
	@echo Build done!

build_haskell: $(HS_SRCS)
	#ghc -outputdir ./out -o $(EXE_NAME) $(HS_SRCS) $(GHC_FLAGS)
	cd haskell && cabal build
	cp ./haskell/dist-newstyle/build/*/*/*/*/web/build/web/web ./

build_elm: $(ELM_SRCS)
	cd elm && elm make --output=./webapp.js $(ELM_SRCS:./elm/%=%) $(ELM_FLAGS)
	cp ./elm/webapp.js ./static/

clean:
	#rm -r ./out
	# TODO add haskell
	rm -r ./haskell/dist-newstyle
	rm -r ./elm/elm-stuff
