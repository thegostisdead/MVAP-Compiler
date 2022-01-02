
SHELL := /bin/bash

JFLAGS = -g
JC = javac
JA = java
MVAP_SOURCES = /home/ghost/Bureau/sources-MVaP-2.1/
MVAP_DEBUG_FLAGS = -d



mvap:
	$(JC) $(MVAP_SOURCES)MVaPAssembler add.mvap
	@echo antlr4 *.g4 && javac Calculette*.java && echo "compile done" && grun Calculette_22101674 'start' -gui > test.mvap

mvap-debug:
	$(JA) $(MVAP_SOURCES)MVaPAssembler $(MVAP_DEBUG_FLAGS) add.mvap
	$(JA) CBaP $(MVAP_DEBUG_FLAGS) add.mvap.cbap

