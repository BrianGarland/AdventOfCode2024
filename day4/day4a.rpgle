**FREE

CTL-OPT MAIN(Main) DFTACTGRP(*NO) ACTGRP(*NEW);

/INCLUDE './builds/AdventOfCode2024/ifs_io.rpgle'

DCL-PR Main EXTPGM('DAY4A');
    pfilename CHAR(32);
END-PR;



DCL-PROC Main;
    DCL-PI *N;
        pfilename CHAR(32);
    END-PI;

    DCL-S answer        INT(20);
    DCL-S buffer        CHAR(4096);
    DCL-S bufferlen     INT(10);
    DCL-S filename      VARCHAR(100);
    DCL-S options       VARCHAR(100);
    DCL-S readbuffer    CHAR(150);
    DCL-S stream        LIKE(pfile);
    DCL-S success       POINTER;


    filename = './builds/AdventOfCode2024/day4/' + %TRIM(pfilename);
    options = 'r, crln=N';
    stream = fopen(filename:options);
    CLEAR readbuffer;
    success = fgets(%ADDR(readbuffer):%SIZE(readbuffer):stream);
    buffer = readbuffer;
    DOW success <> *NULL;
        bufferlen = %LEN(%TRIMR(buffer));


        CLEAR readbuffer;
        success = fgets(%ADDR(readbuffer):%SIZE(readbuffer):stream);
        buffer = %TRIMR(tail) + readbuffer;
    ENDDO;

    fclose(stream);

    DSPLY %CHAR(answer);

    RETURN;

END-PROC;
