**FREE

CTL-OPT MAIN(Main) DFTACTGRP(*NO) ACTGRP(*NEW);

/INCLUDE './builds/AdventOfCode2024/ifs_io.rpgle'
/INCLUDE './builds/AdventOfCode2024/my_stuff.rpgle'

DCL-PR Main EXTPGM('DAY5A');
    pfilename CHAR(32);
END-PR;

// order rules
DCL-S orderrule CHAR(5) DIM(*AUTO:1200);

// page list for each update
DCL-DS pagelist_t QUALIFIED TEMPLATE;
    numpages INT(5) INZ;
    page# CHAR(2) DIM(99) INZ;
END-DS;

DCL-DS pagelist LIKEDS(pagelist_t) INZ(*LIKEDS) DIM(500);



DCL-PROC Main;
    DCL-PI *N;
        pfilename CHAR(32);
    END-PI;

    DCL-S answer        INT(20);
    DCL-S buffer        CHAR(150);
    DCL-S bufferlen     INT(10);
    DCL-S count         INT(10);
    DCL-S filename      VARCHAR(100);
    DCL-s job           INT(5);
    DCL-S mode          INT(5);
    DCL-S options       VARCHAR(100);
    DCL-S page#         CHAR(150);
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

        SELECT;
            WHEN bufferlen = 0;
                mode += 1;
            WHEN mode = 0;
                orderrule(*NEXT) = %SUBST(buffer:1:bufferlen);
            WHEN mode = 1;
                job += 1;
                FOR-EACH page# IN %SPLIT(%SUBST(buffer:1:bufferlen):',');
                    pagelist(job).numpages += 1;
                    pagelist(job).page#(pagelist(job).numpages) = page#;
                ENDFOR;
        ENDSL;

        CLEAR buffer;
        success = fgets(%ADDR(buffer):%SIZE(buffer):stream);
    ENDDO;

    fclose(stream);

    SORTA %SUBARR(orderrule:1:%ELEM(orderrule));



    // for each manual update
    FOR count = 1 TO %ELEM(pagelist);
        IF pagelist(count).numpages = 0;
            LEAVE;
        ENDIF;

        IF CheckUpdate(pagelist(count)) = 0;
            DOW CheckUpdate(pagelist(count)) = 0;
                SortUpdate(pagelist(count));
            ENDDO;
            answer += CheckUpdate(pagelist(count));
        ENDIF;

    ENDFOR;



    DSPLY %CHAR(answer);

    RETURN;

END-PROC;



DCL-PROC CheckUpdate;
    DCL-PI *N INT(5);
        pagelist LIKEDS(pagelist_t);
    END-PI;

    DCL-S i      INT(5);
    DCL-S j      INT(5);
    DCL-S middle INT(5);
    DCL-S search CHAR(5);


    FOR i = 1 TO (pagelist.numpages-1);
        FOR j = (i+1) TO pagelist.numpages;
            search = pagelist.page#(j) + '|' + pagelist.page#(i);
            IF %LOOKUP(search:orderrule:1:%ELEM(orderrule)) > 0;
                RETURN 0;
            ENDIF;
        ENDFOR;
    ENDFOR;

    middle = %INT(pagelist.page#(%INT(pagelist.numpages/2)+1));
    RETURN middle;

END-PROC;



DCL-PROC SortUpdate;
    DCL-PI *N;
        pagelist LIKEDS(pagelist_t);
    END-PI;

    DCL-S i        INT(5);
    DCL-S j        INT(5);
    DCL-S search   CHAR(5);
    DCL-S tmppage# CHAR(2);


    FOR i = 1 TO (pagelist.numpages-1);
        FOR j = (i+1) TO pagelist.numpages;
            search = pagelist.page#(j) + '|' + pagelist.page#(i);
            IF %LOOKUP(search:orderrule:1:%ELEM(orderrule)) > 0;
                tmppage# = pagelist.page#(j);
                pagelist.page#(j) = pagelist.page#(i);
                pagelist.page#(i) = tmppage#;
            ENDIF;
        ENDFOR;
    ENDFOR;

    RETURN;

END-PROC;
