**FREE

CTL-OPT MAIN(Main) DFTACTGRP(*NO) ACTGRP(*NEW);

/INCLUDE './builds/AdventOfCode2024/ifs_io.rpgle'
/INCLUDE './builds/AdventOfCode2024/my_stuff.rpgle'

DCL-PR Main EXTPGM('DAY6A');
    pfilename CHAR(32);
END-PR;




DCL-PROC Main;
    DCL-PI *N;
        pfilename CHAR(32);
    END-PI;

    DCL-S answer        INT(20);
    DCL-S buffer        CHAR(150);
    DCL-S bufferlen     INT(10);
    DCL-S filename      VARCHAR(100);
    DCL-S options       VARCHAR(100);
    DCL-S stream        LIKE(pfile);
    DCL-S success       POINTER;


    // Read the input
    filename = './builds/AdventOfCode2024/day5/' + %TRIM(pfilename);
    options = 'r, crln=N';
    stream = fopen(filename:options);
    CLEAR buffer;
    success = fgets(%ADDR(buffer):%SIZE(buffer):stream);
    DOW success <> *NULL;
        bufferlen = %LEN(%TRIMR(buffer));
        DOW bufferlen > 0
            AND (%SUBST(buffer:bufferlen:1) = x'00'
                 OR %SUBST(buffer:bufferlen:1) = x'0D'
                 OR %SUBST(buffer:bufferlen:1) = x'25');
            bufferlen -= 1;
        ENDDO;





        CLEAR buffer;
        success = fgets(%ADDR(buffer):%SIZE(buffer):stream);
    ENDDO;

    fclose(stream);





    DSPLY %CHAR(answer);

    RETURN;

END-PROC;
