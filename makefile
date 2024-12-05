NAME=AdventOfCode2024
BIN_LIB=BJGARLAND2
DBGVIEW=*SOURCE
TGTRLS=V7R4M0
SHELL=/QOpenSys/usr/bin/qsh

#----------

all: day1.pgm
	@echo "Built all"

day1.pgm: day1.rpgle

#----------

%.rpgle:
	system -s "CHGATR OBJ('./qrpglesrc/$*.rpgle') ATR(*CCSID) VALUE(819)"
	liblist -a $(BIN_LIB);\
	system "CRTRPGMOD MODULE($(BIN_LIB)/$*) SRCSTMF('./qrpglesrc/$*.rpgle') TEXT('$(NAME)') REPLACE(*YES) DBGVIEW($(DBGVIEW)) TGTRLS($(TGTRLS)) TGTCCSID(*SRC)"

%.pgm:
	liblist -a $(BIN_LIB);\
	system "CRTPGM PGM($(BIN_LIB)/$*) ENTMOD($*) MODULE($*) TEXT('$(NAME)') REPLACE(*YES) ACTGRP(*NEW) TGTRLS($(TGTRLS))"
