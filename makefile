NAME=AdventOfCode2024
BIN_LIB=BJGARLAND1
DBGVIEW=*SOURCE
TGTRLS=V7R4M0
SHELL=/QOpenSys/usr/bin/qsh
#
#----------
#
all: day1.rpgle
	@echo "Built all"
#
#----------
#
day1.rpgle:
	system -s "CHGATR OBJ('./builds/AdventOfCode2024/day1/day1a.rpgle') ATR(*CCSID) VALUE(819)"
	system -s "CHGATR OBJ('./builds/AdventOfCode2024/day1/day1b.rpgle') ATR(*CCSID) VALUE(819)"
	liblist -a $(BIN_LIB);\
	system "CRTBNDRPG PGM($(BIN_LIB)/day1a) SRCSTMF('./builds/AdventOfCode2024/day1/day1a.rpgle') TEXT('$(NAME) Day 1a') REPLACE(*YES) DBGVIEW($(DBGVIEW)) TGTRLS($(TGTRLS)) TGTCCSID(*SRC)"
	system "CRTBNDRPG PGM($(BIN_LIB)/day1b) SRCSTMF('./builds/AdventOfCode2024/day1/day1b.rpgle') TEXT('$(NAME) Day 1b') REPLACE(*YES) DBGVIEW($(DBGVIEW)) TGTRLS($(TGTRLS)) TGTCCSID(*SRC)"