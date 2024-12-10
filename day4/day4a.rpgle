**FREE

CTL-OPT MAIN(Main) DFTACTGRP(*NO) ACTGRP(*NEW);

/INCLUDE './builds/AdventOfCode2024/ifs_io.rpgle'
/INCLUDE './builds/AdventOfCode2024/my_stuff.rpgle'

DCL-PR Main EXTPGM('DAY4A');
    pfilename CHAR(32);
END-PR;

DCL-DS row DIM(140) QUALIFIED;
    col CHAR(1) DIM(140);
END-DS;

DCL-S find    CHAR(1) DIM(4);
DCL-S numcols INT(10);
DCL-S numrows INT(10);



DCL-PROC Main;
    DCL-PI *N;
        pfilename CHAR(32);
    END-PI;

    DCL-S answer        INT(20);
    DCL-S buffer        CHAR(150);
    DCL-S bufferlen     INT(10);
    DCL-S c             INT(10);
    DCL-S filename      VARCHAR(100);
    DCL-S options       VARCHAR(100);
    DCL-S r             INT(10);
    DCL-S stream        LIKE(pfile);
    DCL-S success       POINTER;


    find(1) = 'X';
    find(2) = 'M';
    find(3) = 'A';
    find(4) = 'S';

    // Read file into 2-d array
    filename = './builds/AdventOfCode2024/day4/' + %TRIM(pfilename);
    options = 'r, crln=N';
    stream = fopen(filename:options);
    CLEAR buffer;
    success = fgets(%ADDR(buffer):%SIZE(buffer):stream);
    DOW success <> *NULL;
        bufferlen = %LEN(%TRIMR(buffer));

        r += 1;
        FOR c = 1 TO bufferlen;
            IF %LOOKUP(%SUBST(buffer:c:1):find) = 0;
                LEAVE;
            ENDIF;
            SetGrid(r:c:%SUBST(buffer:c:1));
        ENDFOR;

        CLEAR buffer;
        success = fgets(%ADDR(buffer):%SIZE(buffer):stream);
    ENDDO;

    fclose(stream);

    numrows = r;
    numcols = c-1;

    // search each position in 2-d array
    FOR r = 1 TO numrows;
        FOR c = 1 TO numcols;

            answer += Search(r:c);

        ENDFOR;
    ENDFOR;

    DSPLY %CHAR(answer);

    RETURN;

END-PROC;



DCL-PROC SetGrid;
    DCL-PI *N;
        x INT(10) CONST;
        y INT(10) CONST;
        C CHAR(1) CONST;
    END-PI;

    row(x).col(y) = C;

    RETURN;

END-PROC;



DCL-PROC GetGrid;
    DCL-PI *N CHAR(1);
        x INT(10) CONST;
        y INT(10) CONST;
    END-PI;

    RETURN row(x).col(y);

END-PROC;



DCL-PROC Search;
    DCL-PI *N INT(10);
        x INT(10) CONST;
        y INT(10) CONST;
    END-PI;

    DCL-S i        INT(10);
    DCL-S numfound INT(10);


    // Shortcut if this is not the first character
    IF GetGrid(x:y) <> find(1);
        RETURN 0;
    ENDIF;

    // Search each of the 8 directions
    IF CheckCell(x:y:-1:-1:2);
        numfound += 1;
    ENDIF;
    IF CheckCell(x:y:-1:0:2);
        numfound += 1;
    ENDIF;
    IF CheckCell(x:y:-1:1:2);
        numfound += 1;
    ENDIF;
    IF CheckCell(x:y:0:-1:2);
        numfound += 1;
    ENDIF;
    IF CheckCell(x:y:0:1:2);
        numfound += 1;
    ENDIF;
    IF CheckCell(x:y:1:-1:2);
        numfound += 1;
    ENDIF;
    IF CheckCell(x:y:1:0:2);
        numfound += 1;
    ENDIF;
    IF CheckCell(x:y:1:1:2);
        numfound += 1;
    ENDIF;

    RETURN numfound;

END-PROC;



DCL-PROC CheckCell;
    DCL-PI *N IND;
        x    INT(10) CONST;
        y    INT(10) CONST;
        dirx INT(10) CONST;
        diry INT(10) CONST;
        idx  INT(10) CONST;
    END-PI;

    DCL-S numfound INT(10);
    DCL-S newx     INT(10);
    DCL-S newy     INT(10);


    newx = x + dirx;
    newy = y + diry;

    // If out of bounds stop searching
    IF newx < 1 OR newx > numrows OR newy < 1 OR newy > numcols;
        RETURN FALSE;
    ENDIF;

    // If this cell is wrong exit
    IF GetGrid(newx:newy) <> find(idx);
        RETURN FALSE;
    ENDIF;

    IF idx = %ELEM(find);
        // if this is the last char we must have found it.
        RETURN TRUE;
    ELSE;
        // keep looking and return that value
        RETURN CheckCell(newx:newy:dirx:diry:idx+1);
    ENDIF;

END-PROC;
