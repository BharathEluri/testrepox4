//********************************************************************
//*
//*-------------------------------------------------------------------
//CTLEXEC  IF RC = 00 THEN
//IF_TST1  IF &COB3DYN = N    THEN
//*        -> PRECOMPILE DYNAMIQUE  = NON                            .
//IF_TST2  IF &@DB2 = Y THEN
//*        -> SOURCE DB2 = OUI                                       .
//SQL      EXEC PGM=DSNHPC,MAXRC=4,
//         PARM='&DB2OPT'
//STEPLIB  DD DSN=&DB2EXIT,DISP=SHR
//         DD DSN=&DB2LOAD,DISP=SHR
//SYSPRINT DD DSN=&&SQLLIST,DISP=(OLD,PASS)
//SYSTERM  DD DUMMY
//SYSUT1   DD UNIT=VIO,SPACE=(TRK,(15,15)),DCB=BUFNO=1
//SYSUT2   DD UNIT=VIO,SPACE=(TRK,(15,15)),DCB=BUFNO=1
//SYSLIB   DD MONITOR=COMPONENTS,DISP=SHR,DSN=&DB2DCLG
//DBRMLIB  DD DSN=&&DBRM(&C1ELEMENT),DISP=(,PASS),
//            UNIT=WORK,SPACE=(CYL,(1,1,1)),
//            DCB=(RECFM=FB,BLKSIZE=80)
//SYSIN    DD DSN=&&ELMOUT,DISP=(OLD,DELETE)
//SYSCIN   DD DSN=&&SYSCIN,DISP=(,PASS),
//            UNIT=VIO,SPACE=(TRK,(15,15)),
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=8080,BUFNO=1)
//ND-TST2  ENDIF
//ND-TST1  ENDIF
//ENDCTL   ENDIF
//*


//*
//*-------------------------------------------------------------------
//CTLEXEC  IF RC  LE  04  THEN
//IF_TST1  IF &COB3DYN = N    THEN
//*        -> PRECOMPILE DYNAMIQUE  = NON                            .
//IF_TST2  IF &@CIC = Y OR
//            &@XDL = Y THEN
//*        -> SOURCE CICS = OUI                                      .
//TRN      EXEC PGM=DFHECP1$,MAXRC=4,
//         PARM='&CITRNOPT'
//STEPLIB  DD DISP=SHR,DSN=&CICSLOAD
//SYSPRINT DD DSN=&&TRNLIST,DISP=(OLD,PASS)
//*        ...........................................................
//*        . LOCALISATION SYSIN CONTENANT LE SOURCE                  .
//*        -> PRECOMPILE DYNAMIQUE  = NON DB2=N       : SYSIN=ELMOUT .
//*        -> PRECOMPILE DYNAMIQUE  = NON DB2=Y       : SYSIN=SYSCIN .
//*        ...........................................................
//IF_TST3  IF &@DB2 = N THEN    (SOURCE FROM ENDEVOR)
//*        -> PRECOMPILE DYNAMIQUE  = NON DB2=N       : SYSIN=ELMOUT .
//SYSIN    DD DSN=&&ELMOUT,DISP=(OLD,DELETE)
//EL-TST3  ELSE                 (SOURCE FROM DSNHPC DB2)
//*        -> PRECOMPILE DYNAMIQUE  = NON DB2=Y       : SYSIN=SYSCIN .
//SYSIN    DD DSN=&&SYSCIN,DISP=(OLD,DELETE)
//ND-TST3  ENDIF
//SYSPUNCH DD DSN=&&SYSPUNCH,DISP=(,PASS),
//            UNIT=VIO,SPACE=(TRK,(15,5)),
//            DCB=(RECFM=FB,BLKSIZE=8080,LRECL=80,BUFNO=1)
//ND-TST2  ENDIF
//ND-TST1  ENDIF
//ENDCTL   ENDIF
//*


//*
//*-------------------------------------------------------------------
//CTLEXEC  IF RC LT 05 THEN
//COMPIL   EXEC PGM=&COMPILER,MAXRC=4,
//         PARM='&COBOPT1,&COBOPT2,&COBODEV'
//*        ...........................................................
//*        . LOCALISATION SYSIN CONTENANT LE SOURCE                  .
//*        -> PRECOMPILE DYNAMIQUE  = NON ET CICS : SYSIN=SYSPUNCH   .
//*        -> PRECOMPILE DYNAMIQUE  = NON ET DB2  : SYSIN=SYSCIN     .
//*        -> PRECOMPILE DYNAMIQUE  = NON         : SYSIN=ELMOUT     .
//*        -> PRECOMPILE DYNAMIQUE  = OUI ET CICS/DB2 : SYSIN=ELMNEW .
//*        -> PRECOMPILE DYNAMIQUE  = OUI NOT CICS/DB2: SYSIN=ELMOUT .
//*        ...........................................................
//*        -> PRECOMPILE DYNAMIQUE  = NON => SELECTION DSN DU SOURCE
//IF_TST1  IF &COB3DYN = N  AND
//            (&@CIC = Y OR &@XDL = Y) AND
//            (&@DB2 = Y OR &@DB2 = N) THEN
//*        -> PRECOMPILE DYNAMIQUE  = NON ET CICS : SYSIN=SYSPUNCH   .
//SYSIN    DD DSN=&&SYSPUNCH,DISP=(OLD,PASS)
//ND-TST1       ENDIF
//IF_TST1  IF &COB3DYN = N  AND
//            (&@CIC = N AND &@XDL = N) AND
//            (&@DB2 = Y)  THEN
//*        -> PRECOMPILE DYNAMIQUE  = NON ET DB2 : SYSIN=SYSCIN      .
//SYSIN    DD DSN=&&SYSCIN,DISP=(OLD,PASS)
//ND-TST1       ENDIF
//IF_TST1  IF &COB3DYN = N  AND
//            (&@CIC = N AND &@XDL = N) AND
//            (&@DB2 = N)  THEN
//*        -> PRECOMPILE DYNAMIQUE  = NON       : SYSIN=ELMOUT       .
//SYSIN    DD DSN=&&ELMOUT,DISP=(OLD,PASS)
//ND-TST1       ENDIF
//*        -> PRECOMPILE DYNAMIQUE  = OUI => SELECTION DSN DU SOURCE
//IF_TST1  IF &COB3DYN = Y  AND
//            (&@CIC = Y OR &@XDL = Y  OR
//             &@DB2 = Y)  THEN
//*        -> PRECOMPILE DYNAMIQUE  = OUI ET CICS/DB2 : SYSIN=ELMNEW .
//SYSIN    DD DSN=&&ELMNEW,DISP=(OLD,PASS)
//ND-TST1  ENDIF
//IF_TST1  IF &COB3DYN = Y  AND
//            (&@CIC = N AND &@XDL = N  AND
//             &@DB2 = N)  THEN
//*        -> PRECOMPILE DYNAMIQUE  = OUI NOT CICS/DB2: SYSIN=ELMOUT .
//SYSIN    DD DSN=&&ELMOUT,DISP=(OLD,PASS)
//ND-TST1  ENDIF
//*        ...........................................................
//*        . ALLOCATION DBRMLIB                                      .
//*        -> PRECOMPILE DYNAMIQUE = OUI ET DB2 : ALLOCATION=OUI     .
//*        -> AUTRES CAS                        : ALLOCATION=NON     .
//*        ...........................................................
//IF_TST1  IF &COB3DYN = Y AND &@DB2 = Y THEN
//DBRMLIB  DD DSN=&&DBRM(&C1ELEMENT),DISP=(,PASS),
//            UNIT=WORK,SPACE=(CYL,(1,1,40)),
//            DCB=(RECFM=FB,BLKSIZE=80)
//ND-TST1  ENDIF
//*        ...........................................................
//*        . CONCATENATION SYSLIB                                    .
//*        -> ALL                : SHADOW, ODM                       .
//*        -> CIC=Y              : MACLIB CICS, ASF                  .
//*        -> BTC=Y              : MACLIB PRINT MANAGER              .
//*        -> DB2=Y              : DCLGEN                            .
//*        ...........................................................
//SYSLIB   DD DISP=SHR,DSN=SYS1.VIDE.BSCOS39S
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&COCPUSR1
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&COCPUSR2
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&COCPUSR3
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&COBSHDM
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&COBODMM
//IF_TST1  IF &@CIC = Y  THEN
//*        -> CIC=Y              : MACLIB CICS, ASF                  .
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&COBCICM
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&COBASFM
//ND-TST1  ENDIF
//IF_TST1  IF &@BTC = Y THEN
//*        -> BTC=Y              : MACLIB PRINT MANAGER              .
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&COBPRNTM
//ND-TST1  ENDIF
//IF_TST1  IF &@DB2 = Y THEN
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&DB2DCLG
//ND-TST1  ENDIF
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&COCPSTG1
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&COCPSTG2
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&COSTGRCP
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&COSTGPCP
//*        ...........................................................
//*        . ALLOCATION SANS CONDITION                               .
//*        ...........................................................
//SYSLIN   DD DSN=&&SYSLIN,DISP=(,PASS),
//            UNIT=VIO,SPACE=(CYL,(1,1),RLSE),
//            DCB=(BLKSIZE=3200,BUFNO=1),FOOTPRNT=CREATE
//SYSPRINT DD DSN=&&COB0LST,DISP=(OLD,PASS)
//STEPLIB  DD DISP=SHR,DSN=&COBLIB      *** COBOL ENTERPRISE
//         DD DISP=SHR,DSN=&ABNLIB      *** CSS COMPUWARE
//         DD DISP=SHR,DSN=&CICSLOAD    *** CICS TS (EXEC CICS + DLI)
//IF_TST1  IF &@DB2 = Y THEN
//         DD DISP=SHR,DSN=&DB2EXIT     *** DB2
//***      DD DISP=SHR,DSN=&DB2PTFS     *** TEMP PTFS DB2
//         DD DISP=SHR,DSN=&DB2LOAD     *** DB2
//ND-TST1  ENDIF
//SYSUT1   DD UNIT=VIO,SPACE=(CYL,(1,1))
//SYSUT2   DD UNIT=VIO,SPACE=(CYL,(1,1))
//SYSUT3   DD UNIT=VIO,SPACE=(CYL,(1,1))
//SYSUT4   DD UNIT=VIO,SPACE=(CYL,(1,1))
//SYSUT5   DD UNIT=VIO,SPACE=(CYL,(1,1))
//SYSUT6   DD UNIT=VIO,SPACE=(CYL,(1,1))
//SYSUT7   DD UNIT=VIO,SPACE=(CYL,(1,1))
//*        ...........................................................
//*        . ACTIVATION COMPUWARE                                    .
//*        -> COMPILATEUR = CWPCMAIN (COMPUWARE) (IGYCRCTL=COBOL3)   .
//*        ...........................................................
//IF_TST1  IF &COMPILER = CWPCMAIN THEN
//*        -> COMPILATEUR = CWPCMAIN (COMPUWARE) (IGYCRCTL=COBOL3)   .
//CWPDDIO  DD DISP=SHR,DSN=&ABNDDIOF
//CWPERRM  DD DSN=&&CWPERRM,DISP=(OLD,PASS)
//CWPWBNV  DD SYSOUT=Z
//SYSOUT   DD SYSOUT=Z  *** SYSOUT DU SORT ***
//*        ...........................................................
//*        . ALLOCATION CWPPRMO POUR COMPUWARE                       .
//*        -> CIC=Y                : DD CWPPRMO SPECIFIQUE CICS      .
//*        -> BTC=Y                : DD CWPPRMO SPECIFIQUE BATCH     .
//*        ...........................................................
//IF_TST2  IF &@CIC = Y  THEN
//*        -> CIC=Y                : DD CWPPRMO SPECIFIQUE CICS      .
//CWPPRMO  DD *
LANGUAGE(COBOLZ/OS)
COBOL(OUTPUT(NOPRINT,NODDIO))
PROCESSOR(OUTPUT(PRINT,DDIO))
PROCESSOR(TEXT(NONE))
PROCESSOR(NOBYPASS)
PROCESSOR(ERRORS(MIXED-CASE))
DDIO(OUTPUT(FIND,COMPRESS,NOLIST))
PRINT(OUTPUT(SOURCE,NOLIST))
CICSTEST(OPTIONS(WARNING))
//ND-TST2  ENDIF
//IF_TST2  IF &@BTC = Y THEN
//*        -> BTC=Y              : DD CWPPRMO SPECIFIQUE BATCH       .
//CWPPRMO  DD *
LANGUAGE(COBOLZ/OS)
COBOL(OUTPUT(NOPRINT,NODDIO))
PROCESSOR(OUTPUT(PRINT,DDIO))
PROCESSOR(TEXT(NONE))
PROCESSOR(NOBYPASS)
PROCESSOR(ERRORS(MIXED-CASE))
DDIO(OUTPUT(FIND,COMPRESS,NOLIST))
PRINT(OUTPUT(SOURCE,NOLIST))
//ND-TST2  ENDIF
//ND-TST1  ENDIF
//ENDCTL   ENDIF
//*



//*------------------------------------------------------------------
//CTLEXEC  IF RC  LE  04  THEN
//LKD1     EXEC PGM=IEWL,MAXRC=4,
//         PARM='&LKDOPT'
//SYSLMOD  DD DISP=SHR,DSN=&LOADLIB(&C1ELEMENT),
//            MONITOR=COMPONENTS,FOOTPRNT=CREATE
//SYSPRINT DD DSN=&&LKD1LST,DISP=(OLD,PASS)
//SYSUT1   DD UNIT=VIO,SPACE=(TRK,(15,15)),DCB=BUFNO=1
//*        ...........................................................
//*        . COMPLEMENT DES OPTIONS DE LKD BATCH/CICS                .
//*        -> CICS=Y             : LKDCIC='RENT,CALL,RES',           .
//*        -> BTCH=Y             : LKDBTC='LET(08),REUS',            .
//*        ...........................................................
//IF_TST1  IF &@CIC = Y THEN
//*        -> CICS=Y             : LKDCIC='RENT,CALL,RES',           .
//DDLKDOPT DD *,DCB=BLKSIZE=80
 &LKDCIC
/*
//ND-TST1  ENDIF
//IF_TST1  IF &@BTC = Y THEN
//*        -> BTCH=Y             : LKDBTC='LET(08),REUS',            .
//DDLKDOPT DD *,DCB=BLKSIZE=80
 &LKDBTC
/*
//ND-TST1  ENDIF
//*        ...........................................................
//*        . CONCATENATION SYSLIB                                    .
//*        -> COBOL3 INUTILE                                         .
//*        -> LANGAGE ENVIRONNEMENT OBLIGATOIRE ET UNIQUE BATCH/CICS .
//*        -> DB2=Y              : SDSNLOAD (AVANT RESLIB HISTORIQUE).
//*        -> CICS=Y OU XDLI=Y   : SDFHLOAD                          .
//*        -> BTCH=Y             : RESLIB                            .
//*        -> BTCH=Y             : EANSRC                            .
//*        -> AUTRES DSN EN OVERRIDE PROCESSEUR GROUPE               .
//*        -> ALLOCATION SANS CONDITION (AUTRES STAGES ENDEVOR)      .
//*        ...........................................................
//*        -> LANGAGE ENVIRONNEMENT OBLIGATOIRE ET UNIQUE BATCH/CICS .
//SYSLIB   DD MONITOR=COMPONENTS,DISP=SHR,DSN=&CEELKED
//IF_TST1  IF &@DB2 = Y THEN
//*        -> DB2=Y              : SDSNLOAD (AVANT RESLIB HISTORIQUE).
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&DB2LOAD
//ND-TST1  ENDIF
//IF_TST1  IF &@CIC = Y OR &@XDL=Y THEN
//*        -> CICS=Y OU XDLI=Y   : SDFHLOAD                          .
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&CICSLOAD
//ND-TST1  ENDIF
//IF_TST1  IF &@BTC=Y THEN
//*        -> BTCH=Y             : RESLIB                            .
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&LKDSIMS
//ND-TST1  ENDIF
//*        ...........................................................
//*        . AUTRES DSN EN OVERRIDE PROCESSEUR GROUPE                .
//*        ...........................................................
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&LKDSLIB1
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&LKDSLIB2
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&LKDSLIB3
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&LKDSLIB4
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&LKDSLIB5
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&LKDSLIB6
//*        ...........................................................
//*        . ALLOCATION SANS CONDITION (AUTRES STAGES ENDEVOR)       .
//*        ...........................................................
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&LOADLIB
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&LSTG2LD
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&LSTGRLD
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&LSTGPLD
//*        ...........................................................
//*        . CONCATENATION SYSLIN                                    .
//*        DANS TOUS LES CAS COMPLEMENT AVEC SYSLIN OVERRIDE PROCGRP .
//*        -> BATCH ET XDLI      : RESLIB + &&SYSLIN+INCLUDE DFSLI000.
//*                                EX GBC2I, GBC2X, GBC2Z(LK2)       .
//*        -> BATCH ET NON XDLI  : &&SYSLIN ONLY                     .
//*                                EX GBC2N, GBC2D, GBC2Z(LK1)       .
//*        -> CICS ET DB2        : DFHELII  +&&SYSLIN+ INCLUDE DSNCLI.
//*                                EX GKC2X                          .
//*        -> CICS ET NON DB2    : DFHELII  + &&SYSLIN               .
//*                                EX GKC2I                          .
//*        -> COBPSTK (FUTURE USE: &&SYSLIN + INCLUDE DSNRLI         .
//*        ...........................................................
//*        -> BATCH ET XDLI      : RESLIB + &&SYSLIN+INCLUDE DFSLI000.
//IF_TST1  IF &@BTC = Y AND &@XDL=Y THEN
//RESLIB   DD MONITOR=COMPONENTS,DISP=SHR,DSN=&LKDSIMS
//SYSLIN   DD DSN=&&SYSLIN,DISP=(OLD,PASS)
//         DD *,DCB=BLKSIZE=80
 INCLUDE RESLIB(DFSLI000)
&LKDSLIN1
&LKDSLIN2
&LKDSLIN3
&LKDSLIN4
&LKDSLIN5
&LKDSLIN6
/*
//ND-TST1  ENDIF
//*        ...........................................................
//*        -> BATCH ET NON XDLI  : &&SYSLIN ONLY                     .
//IF_TST1  IF &@BTC = Y AND &@XDL=N THEN
//SYSLIN   DD DSN=&&SYSLIN,DISP=(OLD,PASS)
//         DD *,DCB=BLKSIZE=80
&LKDSLIN1
&LKDSLIN2
&LKDSLIN3
&LKDSLIN4
&LKDSLIN5
&LKDSLIN6
/*
//ND-TST1  ENDIF
//*        ...........................................................
//*        -> CICS ET DB2        : DFHELII  +&&SYSLIN+ INCLUDE DSNCLI.
//IF_TST1  IF &@CIC = Y AND &@DB2 = Y THEN
//SYSLIN   DD DSN=&CICLKINC(&CICLKMBR),DISP=SHR
//         DD DSN=&&SYSLIN,DISP=(OLD,PASS)
//         DD *,DCB=BLKSIZE=80
 INCLUDE SYSLIB(DSNCLI)
&LKDSLIN1
&LKDSLIN2
&LKDSLIN3
&LKDSLIN4
&LKDSLIN5
&LKDSLIN6
/*
//ND-TST1  ENDIF
//*        ...........................................................
//*        -> CICS ET NON DB2    : DFHELII  + &&SYSLIN               .
//IF_TST1  IF &@CIC = Y AND &@DB2=N THEN
//SYSLIN   DD DSN=&CICLKINC(&CICLKMBR),DISP=SHR
//         DD DSN=&&SYSLIN,DISP=(OLD,PASS)
//         DD *,DCB=BLKSIZE=80
&LKDSLIN1
&LKDSLIN2
&LKDSLIN3
&LKDSLIN4
&LKDSLIN5
&LKDSLIN6
/*
//ND-TST1  ENDIF
//ENDCTL   ENDIF
//*
//*
//*-------------------------------------------------------------------
//CTLEXEC  IF RC  LE  04  THEN
//IF_TST1  IF &@LK2 = Y THEN
//LKD2     EXEC PGM=IEWL,MAXRC=4,
//         PARM='&LKDOPT'
//SYSLMOD  DD DISP=SHR,DSN=&LOADLIB2(&C1ELEMENT), *** BTCHLOA2 ***
//            MONITOR=COMPONENTS,FOOTPRNT=CREATE
//SYSPRINT DD DSN=&&LKD2LST,DISP=(OLD,PASS)
//SYSUT1   DD UNIT=VIO,SPACE=(TRK,(15,15)),DCB=BUFNO=1
//*        ...........................................................
//*        . COMPLEMENT DES OPTIONS DE LKD BATCH                     .
//*        -> BTCH=Y             : LKDBTC='LET(08),REUS',            .
//*        ...........................................................
//IF_TST2  IF &@BTC = Y THEN
//*        -> BTCH=Y             : LKDBTC='LET(08),REUS',            .
//DDLKDOPT DD *,DCB=BLKSIZE=80
 &LKDBTC
/*
//ND-TST2  ENDIF
//*        ...........................................................
//*        . CONCATENATION SYSLIB                                    .
//*        -> 1 LANGAGE ENVIRONNEMENT OBLIGATOIRE + UNIQUE BATCH/CICS.
//*        -> 2 RESLIB (IMS POUR INCLUDE DFSLI000)                   .
//*        -> 3 SDSNLOAD (DB2)                                       .
//*        -> 4 SDFHLOAD (CICS POUR XDLI)                            .
//*        -> 5 AUTRES DSN EN OVERRIDE PROCESSEUR GROUPE             .
//*        -> 6 AUTRES STAGES ENDEVOR                                .
//*        ...........................................................
//SYSLIB   DD MONITOR=COMPONENTS,DISP=SHR,DSN=&CEELKED
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&LKDSIMS
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&DB2LOAD
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&CICSLOAD
//*        ...........................................................
//*        . AUTRES DSN EN OVERRIDE PROCESSEUR GROUPE                .
//*        ...........................................................
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&LKDSLIB1
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&LKDSLIB2
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&LKDSLIB3
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&LKDSLIB4
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&LKDSLIB5
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&LKDSLIB6
//*        ...........................................................
//*        . ALLOCATION SANS CONDITION (AUTRES STAGES ENDEVOR)       .
//*        ...........................................................
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&LOADLIB
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&LOADLIB2
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&LSTG2LD
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&LSTG2LD2
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&LSTGRLD
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&LSTGRLD2
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&LSTGPLD
//         DD MONITOR=COMPONENTS,DISP=SHR,DSN=&LSTGPLD2
//*        ...........................................................
//*        . CONCATENATION SYSLIN                                    .
//*        DANS TOUS LES CAS COMPLEMENT AVEC SYSLIN OVERRIDE PROCGRP .
//*        -> &&SYSLIN + INCLUDE DFSLI000 DE IMS ET NON DE DB2       .
//*        ...........................................................
//SYSLIN   DD DSN=&&SYSLIN,DISP=(OLD,PASS)
//         DD *,DCB=BLKSIZE=80
 INCLUDE SYSLIB(DFSLI000)
&LKDSLIN1
&LKDSLIN2
&LKDSLIN3
&LKDSLIN4
&LKDSLIN5
&LKDSLIN6
/*
//ND-TST1  ENDIF
//ENDCTL   ENDIF
//*

//*
//*-------------------------------------------------------------------
//CTLEXEC  IF RC  LE  04  THEN
//IF_TST1  IF &@DB2 = Y THEN
//DBRMCOPY EXEC PGM=CZX2PZQL,PARM='-IEBGENER-',MAXRC=0
//STEPLIB   DD DISP=SHR,DSN=&@@BASEC..CORTK.EXITLIB
//          DD DISP=SHR,DSN=&@@BASEB..CORTK.LINKLIB
//SYSUT1    DD DSN=&&DBRM(&C1ELEMENT),DISP=(OLD,DELETE)
//SYSUT2    DD DISP=SHR,DSN=&DB2RMLB(&C1ELEMENT),
//             MONITOR=COMPONENTS,FOOTPRNT=CREATE
//ISPFE001  DD DISP=SHR,DSN=&DB2RMLB
//SYSPRINT  DD DUMMY
//SYSIN     DD DUMMY
//ND-TST1  ENDIF
//ENDCTL   ENDIF
//**