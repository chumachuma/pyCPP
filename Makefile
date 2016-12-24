PROJECT_NAME = $(TYPE_PREFIX)$(notdir $(shell pwd))$(TYPE_SUFFIX)

PROJECT_DIR = $(shell pwd)
IDIR = include
SDIR = src
ODIR = obj
DDIR = $(ODIR)/dependecies
SRC  = $(wildcard $(SDIR)/*.cpp)
OBJ  = $(subst $(SDIR)/, $(ODIR)/Release/, $(SRC:.cpp=.o))
OBJD = $(subst $(SDIR)/, $(ODIR)/Debug/, $(SRC:.cpp=.o))
EXE  = $(BDIR)/$(PROJECT_NAME)
LDIR = lib
BDIR = bin

LIBS = $(addprefix -l, $(_LIBS)) 
LIBS_DIR = $(addprefix -L, $(_LIBS_DIR)) 
INC_DIR = $(addprefix -I, $(_INC_DIR)) 
DEFINES = $(addprefix -D, $(_DEFINES))

CC = g++
CFLAGS=-I$(IDIR) -Wall -Wextra $(INC_DIR) $(LIBS_DIR) $(LIBS) $(DEFINES)
DEPFLAGS = -MT $@ -MMD -MP -MF $(DDIR)/$*.td

SHELL = /bin/sh
.SUFFIXES:
.SUFFIXES: .cpp .o .d .td

TEST_EXE = $(EXE)
TEST_ARG = 

-include MakeSpec.mk

.PHONY: all
all: $(EXE)
#TODO all should be debug

.PHONY: install
install: $(EXE)
install: check 
	echo TODO install application in right places and if exists run a test

.PHONY: debug
debug: COMPILE_FLAGS = -D_DEBUG -g
debug: LINK_FLAGS = -D_DEBUG -g
debug: $(EXE)D

.PHONY: sharedArchive
sharedArchive: BDIR = $(LDIR)
sharedArchive: TYPE_PREFIX ::=lib
sharedArchive: TYPE_SUFFIX ::=.a
sharedArchive: $(OBJ) | $(BDIR)
	ar rcs $(EXE) $^

.PHONY: sharedObject
sharedObject: COMPILE_FLAGS = -fPIC
sharedObject: LINK_FLAGS = -shared
sharedObject: BDIR = $(LDIR)
sharedObject: TYPE_PREFIX ::=lib
sharedObject: TYPE_SUFFIX ::=.so
sharedObject: $(EXE)

$(EXE): $(OBJ) | $(BDIR) 
	$(CC) -o $(EXE) $^ $(LINK_FLAGS) $(CFLAGS)

$(EXE)D: $(OBJD) | $(BDIR) 
	$(CC) -o $(EXE)D $^ $(LINK_FLAGS) $(CFLAGS)

$(ODIR)/Release/%.o: src/%.cpp $(DDIR)/%.d | $(ODIR)/Release $(DDIR)
	$(CC) -c -o $@ $< $(DEPFLAGS) $(COMPILE_FLAGS) $(CFLAGS)
	mv -f $(DDIR)/$*.td $(DDIR)/$*.d

$(ODIR)/Debug/%.o: src/%.cpp $(DDIR)/%.d | $(ODIR)/Debug $(DDIR)
	$(CC) -c -o $@ $< $(DEPFLAGS) $(COMPILE_FLAGS) $(CFLAGS)
	mv -f $(DDIR)/$*.td $(DDIR)/$*.d

$(BDIR) $(ODIR):
	mkdir -p $@

$(DDIR) $(ODIR)/Release $(ODIR)/Debug: | $(ODIR)
	mkdir -p $@

$(DDIR)/%.d: ;
.PRECIOUS: $(DDIR)/%.d

-include $(subst $(SDIR)/, $(DDIR)/, $(SRC:.cpp=.d))

.PHONY: TAGS
TAGS:
	ctags -R

.PHONY: info
info:
	echo TODO: generate infofile read MAKEINFO

.PHONY:dist
dist:
	echo TODO: generate tar file

.PHONY: check
check:
	$(TEST_EXE) $(TEST_ARG)

.PHONY: clean
clean:
	-rm -f -v $(ODIR)/Release/*.o $(ODIR)/Debug/*.o $(EXE)* 
	#TODO remove lib

.PHONY: cleandep
cleandep:
	-rm -f $(DDIR)/*.d $(DDIR)/*.td

.PHONY: distclean
distclean: clean cleandep

.PHONY: help
help:
	@echo "all:                 Build all"
	@echo "debug:               Build project with debug information"
	@echo "dist:                Generate .tar file"
	@echo "check:               Run available test"
	@echo "TAGS:                Generate tags file. Requires ctags"
	@echo "info:                Generate info file"
	@echo "clean:               Clean project"
	@echo "cleandep:            Clean dependencies files"
	@echo "distclean:           Clean all generated files"
	@echo "help:                Show this help message. Make  <space> <tab>: shows all targets"
	@echo "maketest:            Used for Debug Makefile"

.PHONY: maketest
maketest:
	echo $(PROJECT_NAME)
	echo $(BSD)
