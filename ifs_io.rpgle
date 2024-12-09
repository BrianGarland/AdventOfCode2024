**FREE
DCL-S pfile POINTER TEMPLATE;

DCL-S stdin  LIKE(pfile) IMPORT('_C_IFS_stdin');
DCL-S stdout LIKE(pfile) IMPORT('_C_IFS_stdout');
DCL-S stderr LIKE(pfile) IMPORT('_C_IFS_stderr');

DCL-PR fopen EXTPROC('_C_IFS_fopen') LIKE(pfile);
    filename POINTER VALUE OPTIONS(*STRING);
    mode     POINTER VALUE OPTIONS(*STRING);
END-PR;

DCL-PR fgets POINTER EXTPROC('_C_IFS_fgets');
    string POINTER VALUE;
    size   INT(10) VALUE;
    stream LIKE(pfile) VALUE;
END-PR;

DCL-PR fputs INT(10) EXTPROC('_C_IFS_fputs');
    string POINTER VALUE OPTIONS(*STRING);
    stream LIKE(pfile) VALUE;
END-PR;

DCL-PR fread UNS(10) EXTPROC('_C_IFS_fread');
    data   POINTER VALUE;
    size   UNS(10) VALUE;
    count  UNS(10) VALUE;
    stream LIKE(pfile) VALUE;
END-PR;

DCL-PR fwrite UNS(10) EXTPROC('_C_IFS_fwrite');
    data   POINTER VALUE;
    size   UNS(10) VALUE;
    count  UNS(10) VALUE;
    stream LIKE(pfile) VALUE;
END-PR;

DCL-PR fflush UNS(10) EXTPROC('_C_IFS_fflush');
    stream LIKE(pfile) VALUE;
END-PR;

DCL-PR fclose INT(10) EXTPROC('_C_IFS_fclose');
    stream LIKE(pfile) VALUE;
END-PR;

DCL-PR fseek INT(10) EXTPROC('_C_IFS_fseek');
    stream LIKE(pfile) VALUE;
    offset INT(10) VALUE;
    whence INT(10) VALUE;
END-PR;
