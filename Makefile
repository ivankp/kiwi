SHELL := /bin/bash
CPP := g++

DIRS := lib bin obj

CFLAGS := -Wall -O3 -Iinclude

ROOT_CFLAGS := $(shell root-config --cflags)
ROOT_LIBS   := $(shell root-config --libs)

.PHONY: all clean install

DYNM := lib/libmithhist.so
STAT := lib/libmithhist.a
TEST := bin/test_hist_css

all: $(DIRS) $(STAT) $(TEST)

install:
	cp $(LIBS) $(prefix)/lib/

# directories rule
$(DIRS):
	@mkdir -p $@

# class object rules
obj/hist_css.o: obj/%.o: src/%.cc include/%.h
	@echo -e "Compiling \E[0;49;96m"$@"\E[0;0m"
	@$(CPP) $(CFLAGS) $(ROOT_CFLAGS) -c $(filter %.cc,$^) -o $@

# static library rules
lib/libmithhist.a: lib/%.a: obj/hist_css.o
	ar rvs $@ $(filter %.o,$^)

# shared library rules
lib/libmithhist.so: lib/%.so: obj/hist_css.o
	@echo -e "Linking \E[0;49;96m"$@"\E[0;0m"
	@$(CPP) -shared $(filter %.o,$^) -o lib/$*.so

# main object rules
obj/test_hist_css.o: obj/%.o: test/%.cc
	@echo -e "Compiling \E[0;49;94m"$@"\E[0;0m"
	@$(CPP) $(CFLAGS) $(ROOT_CFLAGS) $(MAGIC_CFLAGS) -c $(filter %.cc,$^) -o $@

# executable rules
bin/test_hist_css: bin/%: obj/%.o
	@echo -e "Linking \E[0;49;92m"$@"\E[0;0m"
	@$(CPP) -Wl,--no-as-needed $(filter %.o,$^) -o $@ $(ROOT_LIBS) -Llib -lmithhist -lboost_regex

# OBJ dependencies

# EXE_OBJ dependencies
obj/test_hist_css.o: include/hist_css.h

# EXE dependencies
bin/test_hist_css  : lib/libmithhist.a

clean:
	rm -rf $(DIRS)
