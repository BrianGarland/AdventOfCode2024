**FREE

CTL-OPT MAIN('main');

/INCLUDE './ifs_io.rpgle'


DCL-PROC main;
    DCL-PI *N;
        pfilename CHAR(32);
    END-PI;

    DCL-S answer    INT(20);
    DCL-S buffer    CHAR(2048);
    DCL-S bufferlen INT(10);
    DCL-S filename  VARCHAR(100);
    DCL-S options   VARCHAR(100);


    filename = './' + %TRIM(pfilename);
    options = 'r, crln=N';
    stream = fopen(filename:options);
    CLEAR buffer;
    success = fgets(%ADDR(buffer):%SIZE(buffer):stream);
    DOW succes <> *NULL;
        bufferlen = %LEN(%TRIMR(buffer));

        answer += compute(buffer);

        tail = %SUBST(buffer:bufferlen-20);
        CLEAR buffer;
        success = fgets(%ADDR(buffer):%SIZE(buffer):stream);
        buffer = %TRIM(tail) + buffer;
    ENDDO;

    fclose(stream);

    DSPLY %CHAR(answer);

    RETURN;

END-PROC;


DCL-PROC compute;
    DCL-PI *N INT(20);
        buffer    CHAR(2048);
        bufferlen INT(10);
    END-PI;

    DCL-C valid '0123456789,';

    DCL-S list CHAR(100) DIM(*CTDATA);

    DCL-S answer PACKED(15);
    DCL-S end    PACKED(5);
    DCL-S parms  CHAR(3) DIM(*AUTO:5);
    DCL-S parmx  CHAR(7);
    DCL-S pos1   PACKED(5);
    DCL-S pos2   PACKED(5);
    DCL-S start  PACKED(5);
    DCL-S string CHAR(200);


    start = 1;

    DOW start < %LEN(string);

        pos1 = %SCAN('mul(':string:start);
        IF pos1 = 0;
            LEAVE;
        ENDIF;
        pos2 = %SCAN(')':string:pos1+4);
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
        parmx = %SUBST(string:start:end-start+1);

        IF %CHECK(valid:%TRIM(parmx)) > 0;
            // invalid characters
            start = pos1+1;
            ITER;
        ENDIF;

        parms = %SPLIT(parmx:',':*ALLSEP);
        IF %ELEM(parms) > 2;
            // too many commas
            start = pos1+1;
            ITER;
        ENDIF;

        answer +=  %INT(parms(1)) * %INT(parms(2));
        start = pos2;

    ENDDO;


    RETURN answer;

END-PROC;
