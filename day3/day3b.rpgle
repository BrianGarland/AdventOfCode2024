**FREE

CTL-OPT MAIN(Main) DFTACTGRP(*NO) ACTGRP(*NEW);

/INCLUDE './builds/AdventOfCode2024/ifs_io.rpgle'
/INCLUDE './builds/AdventOfCode2024/my_stuff.rpgle'

DCL-PR Main EXTPGM('DAY3A');
    pfilename CHAR(32);
END-PR;



DCL-PROC Main;
    DCL-PI *N;
        pfilename CHAR(32);
    END-PI;

    DCL-S answer        INT(20);
    DCL-S buffer        CHAR(65536);
    DCL-S bufferlen     INT(10);
    DCL-S filename      VARCHAR(100);
    DCL-S options       VARCHAR(100);
    DCL-S readbuffer    CHAR(65536);
    DCL-S stream        LIKE(pfile);
    DCL-S success       POINTER;
    DCL-S tail          CHAR(1024);


    filename = './builds/AdventOfCode2024/day3/' + %TRIM(pfilename);
    options = 'r, crln=N';
    stream = fopen(filename:options);
    CLEAR readbuffer;
    success = fgets(%ADDR(readbuffer):%SIZE(readbuffer):stream);
    DOU success = *NULL;
        buffer = %TRIMR(buffer) + readbuffer;
        CLEAR readbuffer;
        success = fgets(%ADDR(readbuffer):%SIZE(readbuffer):stream);
    ENDDO;
    bufferlen = %LEN(%TRIMR(buffer));
    fclose(stream);

    answer += Compute(buffer:bufferlen);

    DSPLY %CHAR(answer);

    RETURN;

END-PROC;



DCL-PROC Compute;
    DCL-PI *N INT(20);
        buffer    CHAR(65536);
        bufferlen INT(10);
    END-PI;

    DCL-C valid '0123456789,';

    DCL-S a       PACKED(5);
    DCL-S active  IND INZ(TRUE);
    DCL-S answer  PACKED(15);
    DCL-S b       PACKED(5);
    DCL-S dopos   PACKED(5);
    DCL-S dontpos PACKED(5);
    DCL-S end     PACKED(5);
    DCL-S parms   CHAR(5) DIM(*AUTO:5);
    DCL-S parmx   CHAR(7);
    DCL-S pos1    PACKED(5);
    DCL-S pos2    PACKED(5);
    DCL-S q       PACKED(5) STATIC;
    DCL-S start   PACKED(5);


    start = 1;

    DOW start < bufferlen;

        pos1 = %SCAN('mul(':buffer:start);
        IF pos1 = 0;
            LEAVE;
        ENDIF;

        dopos = %SCAN('do()':buffer:start);
        dontpos = %SCAN('don''t()':buffer:start);

        SELECT;
            WHEN dopos = 0 AND dontpos = 0;
                // do nothing
            WHEN NOT(active) AND dopos > 0 AND dopos < pos1
                AND (dopos > dontpos OR dontpos > pos1);
                active = TRUE;
            WHEN active AND dontpos > 0 AND dontpos < pos1
                AND (dontpos > dopos OR dopos > pos1);
                active = FALSE;
        ENDSL;

        pos2 = %SCAN(')':buffer:pos1+4);
        IF pos2 = 0;
            // no ending paren
            LEAVE;
        ENDIF;

        // 123456789012
        // mul(xxx,xxx)
        IF (pos2-pos1) > 11;
            // too long
            start = pos1+1;
            ITER;
        ENDIF;

        start = pos1 + 4;
        EVAL end = pos2 - 1;
        parmx = %SUBST(buffer:start:end-start+1);

        IF %CHECK(valid:%TRIM(parmx)) > 0;
            // invalid characters
            start = pos1+1;
            ITER;
        ENDIF;

        CLEAR parms;
        %ELEM(parms) = 0;
        parms = %SPLIT(parmx:',':*ALLSEP);
        IF %ELEM(parms) <> 2;
            // either not enough or too many commas
            start = pos1+1;
            ITER;
        ENDIF;

        IF %INT(parms(1)) < 1 OR %INT(parms(1)) > 999
            OR %INT(parms(2)) < 1 OR %INT(parms(2)) > 999;
            // an individual number is out of range
            start = pos1+1;
            ITER;
        ENDIF;

        a = %INT(parms(1));
        b = %INT(parms(2));

        q += 1;
        DSPLY (%EDITC(q:'X') + ' ' + active + ' '
               + %EDITC(a:'X') + ' ' + %EDITC(b:'X'));

        IF active;
            answer += (a * b);
        ENDIF;

        start = pos2;

    ENDDO;

    RETURN answer;

END-PROC;
