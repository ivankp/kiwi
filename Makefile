SHELL := /bin/bash
CPP := g++

DIRS := lib bin obj

CFLAGS := -Wall -O3 -Iinclude

ROOT_CFLAGS := $(shell root-config --cflags)
ROOT_LIBS   := $(shell root-config --libs)

.PHONY: all clean install

DYNM := lib/libkiwihist.so
STAT := lib/libkiwihist.a
TEST := bin/test_csshists bin/test_propmap

all: $(DIRS) $(STAT) $(TEST)

install:
	cp $(STAT) $(prefix)/lib/
	mkdir -p $(prefix)/include/kiwi
	cp -r include/* $(prefix)/include/kiwi/

# directories rule
$(DIRS):
	@mkdir -p $@

# class object rules
obj/csshists.o: obj/%.o: src/%.cc include/%.h
	@echo -e "Compiling \E[0;49;96m"$@"\E[0;0m"
	@$(CPP) $(CFLAGS) $(ROOT_CFLAGS) -c $(filter %.cc,$^) -o $@

# static library rules
lib/libkiwihist.a: lib/%.a: obj/csshists.o
	ar rvs $@ $(filter %.o,$^)

# shared library rules
lib/libkiwihist.so: lib/%.so: obj/csshists.o
	@echo -e "Linking \E[0;49;96m"$@"\E[0;0m"
	@$(CPP) -shared $(filter %.o,$^) -o lib/$*.so

# main object rules
obj/test_csshists.o: obj/%.o: test/%.cc
	@echo -e "Compiling \E[0;49;94m"$@"\E[0;0m"
	@$(CPP) $(CFLAGS) $(ROOT_CFLAGS) -c $(filter %.cc,$^) -o $@

obj/test_propmap.o: obj/%.o: test/%.cc
	@echo -e "Compiling \E[0;49;94m"$@"\E[0;0m"
	@$(CPP) $(CFLAGS) $(ROOT_CFLAGS) -c $(filter %.cc,$^) -o $@

# executable rules
bin/test_csshists: bin/%: obj/%.o
	@echo -e "Linking \E[0;49;92m"$@"\E[0;0m"
	@$(CPP) -Wl,--no-as-needed $(filter %.o,$^) -o $@ $(ROOT_LIBS) -Llib -lkiwihist -lboost_regex

bin/test_propmap: bin/%: obj/%.o
	@echo -e "Linking \E[0;49;92m"$@"\E[0;0m"
	@$(CPP) $(filter %.o,$^) -o $@

# OBJ dependencies

# EXE_OBJ dependencies
obj/test_csshists.o: include/csshists.h
obj/test_propmap.o : include/propmap.h

# EXE dependencies
bin/test_csshists  : lib/libkiwihist.a

clean:
	rm -rf $(DIRS)
