NAME=AdventOfCode2024
BIN_LIB=BJGARLAND2
DBGVIEW=*SOURCE
TGTRLS=V7R4M0
SHELL=/QOpenSys/usr/bin/qsh

#----------

all: day1.rpgle
	@echo "Built all"

#----------

*.rpgle:
	system -s "CHGATR OBJ('./builds/AdventOfCode2024/$*/$*.rpgle') ATR(*CCSID) VALUE(819)"
	liblist -a $(BIN_LIB);\
	system "CRTBNDRPG PGM($(BIN_LIB)/$*) SRCSTMF('./builds/AdventOfCode2024/$*/$*.rpgle') TEXT('$(NAME) $*') REPLACE(*YES) DBGVIEW($(DBGVIEW)) TGTRLS($(TGTRLS)) TGTCCSID(*SRC)"
