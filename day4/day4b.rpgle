**FREE

CTL-OPT MAIN(Main) DFTACTGRP(*NO) ACTGRP(*NEW);

/INCLUDE './builds/AdventOfCode2024/ifs_io.rpgle'
/INCLUDE './builds/AdventOfCode2024/my_stuff.rpgle'

DCL-PR Main EXTPGM('DAY4B');
    pfilename CHAR(32);
END-PR;

DCL-DS row DIM(140) QUALIFIED;
    col CHAR(1) DIM(140);
END-DS;

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
            IF %SCAN(%SUBST(buffer:c:1):'AMSX') = 0;
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
    FOR r = 2 TO numrows-1;
        FOR c = 2 TO numcols-1;

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

    DCL-S test1 CHAR(3);
    DCL-S test2 CHAR(3);

    // Shortcut if this is not the first character
    IF GetGrid(x:y) <> 'A';
        RETURN 0;
    ENDIF;

    // Search each of the 8 directions
    test1 = GetGrid(x-1:y-1) + 'A' + GetGrid(x+1:y+1);
    test2 = GetGrid(x-1:y+1) + 'A' + GetGrid(x+1:y-1);

    IF (test1 = 'MAS' OR test1 = 'SAM')
        AND (test2 = 'MAS' OR test2 = 'SAM');
        RETURN 1;
    ELSE;
        RETURN 0;
    ENDIF;

END-PROC;
