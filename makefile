NAME=AdventOfCode2024
BIN_LIB=BJGARLAND2
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
	system -s "CHGATR OBJ('./builds/AdventOfCode2024/day1/day1.rpgle') ATR(*CCSID) VALUE(819)"
	liblist -a $(BIN_LIB);\
	system "CRTBNDRPG PGM($(BIN_LIB)/day1) SRCSTMF('./builds/AdventOfCode2024/day1/day1.rpgle') TEXT('$(NAME) Day 1') REPLACE(*YES) DBGVIEW($(DBGVIEW)) TGTRLS($(TGTRLS)) TGTCCSID(*SRC)"