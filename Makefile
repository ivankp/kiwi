SHELL := /bin/bash
CPP := g++

DIRS := lib bin obj

CFLAGS := -Wall -O3 -Iinclude

ROOT_CFLAGS := $(shell root-config --cflags)
ROOT_LIBS   := $(shell root-config --libs)

.PHONY: all clean install

DYNM := lib/libflockhist.so
STAT := lib/libflockhist.a
TEST := bin/test_csshists

all: $(DIRS) $(STAT) $(TEST)

install:
	cp $(STAT) $(prefix)/lib/
	cp -r include $(prefix)/include/flock

# directories rule
$(DIRS):
	@mkdir -p $@

# class object rules
obj/csshists.o: obj/%.o: src/%.cc include/%.h
	@echo -e "Compiling \E[0;49;96m"$@"\E[0;0m"
	@$(CPP) $(CFLAGS) $(ROOT_CFLAGS) -c $(filter %.cc,$^) -o $@

# static library rules
lib/libflockhist.a: lib/%.a: obj/csshists.o
	ar rvs $@ $(filter %.o,$^)

# shared library rules
lib/libflockhist.so: lib/%.so: obj/csshists.o
	@echo -e "Linking \E[0;49;96m"$@"\E[0;0m"
	@$(CPP) -shared $(filter %.o,$^) -o lib/$*.so

# main object rules
obj/test_csshists.o: obj/%.o: test/%.cc
	@echo -e "Compiling \E[0;49;94m"$@"\E[0;0m"
	@$(CPP) $(CFLAGS) $(ROOT_CFLAGS) $(MAGIC_CFLAGS) -c $(filter %.cc,$^) -o $@

# executable rules
bin/test_csshists: bin/%: obj/%.o
	@echo -e "Linking \E[0;49;92m"$@"\E[0;0m"
	@$(CPP) -Wl,--no-as-needed $(filter %.o,$^) -o $@ $(ROOT_LIBS) -Llib -lflockhist -lboost_regex

# OBJ dependencies

# EXE_OBJ dependencies
obj/test_csshists.o: include/csshists.h

# EXE dependencies
bin/test_csshists  : lib/libflockhist.a

clean:
	rm -rf $(DIRS)
