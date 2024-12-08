**FREE

DCL-C digits '0123456789';
DCL-C valid '0123456789,';

DCL-S list CHAR(200) DIM(*CTDATA);

DCL-S answer PACKED(10);
DCL-S end    PACKED(5);
DCL-S parms  CHAR(3) DIM(*AUTO);
DCL-S parmx  CHAR(7);
DCL-S pos1   PACKED(5);
DCL-S pos2   PACKED(5);
DCL-S start  PACKED(5);
DCL-S string CHAR(200);


FOR-EACH string IN list;


    start = 1;

    DOW start < %LEN(string);

        pos1 = %LOOKUP('mul(':string:start);
        IF pos1 = 0;
            LEAVE;
        ENDIF;
        pos2 = %LOOKUP(')':string:pos1+4);
        IF pos2 = 0;
            // no ending paren
            LEAVE;
        ENDIF;

        // 123456789012
        // mul(xxx,xxx)
        IF (pos2-pos1) > 11;
            // too long
            start = pos2;
            ITER;
        ENDIF;

        start = pos1 + 4;
        EVAL end = pos2 - 1;
        parmx = %SUBT(string:start:end-start+1);

        IF %CHECK(valid:parms) > 0;
            // invalid characters
            start = pos2;
            ITER;
        ENDIF;

        parms = %SPLIT(parmx:',':*ALLSEP);
        IF %ELEM(parms) > 2;
            // too many commas
            start = pos2;
            ITER;
        ENDIF;

        answer +=  %INT(parms(1)) * %INT(parms(2));
        start = pos2;

    ENDDO;

ENDFOR;


*INLR = *ON;
RETURN;


**CTDATA list
xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))