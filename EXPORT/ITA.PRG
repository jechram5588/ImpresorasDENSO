�
QMENSAJE$=""
QQRCODETXT$=""
QLABELFILEFOLDER$="/C/LABELS/"
QARRAYLIMIT%=1000
QDATEFILENAME$="C:DATECODES.TXT"
QWAIT%=100
QWAIT2%=25
QERRORES%=0
QTIEMPO%=0
QPANTMEN%=0
DO%=262
DOS%=277
RE%=294
RES%=311
MI%=330
FA%=349
FAS%=370
SOL%=392
SOLS%=411
LA%=440
LAS%=466
SI%=494
QDISPLAYOUT%=100
QDISPLAYIN%=110
INC%=0
QPORT%=5
GOSUB ZINICIO
ZINICIO: 
CHDIR "/c"
RUN "su -p pass admin"
OPEN "console:" FOR OUTPUT AS QDISPLAYOUT%
GOSUB ZCLEARARRAY
GOSUB ZMUSICA
GOSUB ZGETSERIALNUMBER
COMSET QPORT%,"",CHR$(13),"+",CHR$(13),50
ON COMSET QPORT% GOSUB ZESCUCHALAN
COMSET QPORT% ON
ON KEY 1 GOSUB ZETIQUITAS2
KEY 1 ON
ON KEY 2 GOSUB ZETIQUITAS9
KEY 2 ON
ON KEY 3 GOSUB ZETIQUITA4311
KEY 3 ON
ON KEY 4 GOSUB ZETIQUITA4671
KEY 4 ON
ON KEY 17 GOSUB ZFEED
KEY 17 ON
QMENSAJE$=STR$(INC%)+"1-S2 2-S9" : GOSUB ZPANTALLA
GOSUB ZMAINLOOP
RETURN
ZFEED: 
FORMFEED
RETURN
ZETIQUITAS2: 
A$="S2"
RETURN
ZETIQUITAS9: 
A$="S9"
RETURN
ZETIQUITA4311: 
A$="4311"
RETURN
ZETIQUITA4671: 
A$="4671"
RETURN
ZMAINLOOP: 
IF INC%>10 THEN INC%=0
IF QTIEMPO%>25 THEN QTIEMPO%=0 ELSE QTIEMPO%=QTIEMPO%+1
IF QTIEMPO%=0 THEN 
IF QPANTMEN%=0 THEN 
QMENSAJE$="3-4311 4-4671" : GOSUB ZPANTALLA
QPANTMEN%=1
ELSE
QMENSAJE$="1-S2 2-S9" : GOSUB ZPANTALLA
QPANTMEN%=0
END IF
END IF
IF A$="EXIT" THEN GOSUB ZEND
IF A$="S2" THEN GOSUB ZCREAETIQUETA
IF A$="S9" THEN GOSUB ZCREAETIQUETA
IF A$="4311" THEN GOSUB ZCREAETIQUETA
IF A$="4671" THEN GOSUB ZCREAETIQUETA
GOSUB ZWAIT2
GOSUB ZMAINLOOP
RETURN
ZDISPCLEAR: 
PRINT #QDISPLAYOUT%, CHR$(155)+"2J";
RETURN
ZESCUCHALAN: 
A$=COMBUF$(QPORT%)
QMENSAJE$=STR$(INC%)+"'"+A$+"'" : GOSUB ZPANTALLA
INC%=INC%+1
GOSUB ZWAIT
COMSET QPORT% ON
RETURN
ZGETSERIALNUMBER: 
OPEN "C:SERIAL.TXT" FOR INPUT AS 72
IF QERR% THEN 
QSERIALNUMBER%=1
ELSE
QTMP$=INPUT$(LOF(72),72)
QSERIALNUMBER%=VAL(QTMP$)
END IF
CLOSE 72
RETURN
ZSAVESERIALNUMBER: 
ON ERROR GOTO ZSAVESERIALNUMBER
IF QERRORES%>3 THEN RETURN ELSE QERRORES%=QERRORES%+1
OPEN "C:SERIAL.TXT" FOR OUTPUT AS 72
QMENSAJE$=STR$(QSERIALNUMBER%) : GOSUB ZPANTALLA
PRINT #72, STR$(QSERIALNUMBER%)
CLOSE 72
QMENSAJE$="File Updated" : GOSUB ZPANTALLA
QERRORES%=0
GOSUB ZWAIT
RETURN
ZPANTALLA: 
GOSUB ZDISPCLEAR
PRINT #QDISPLAYOUT%, "    ITA v1.0"
QL%=LEN(QMENSAJE$)
QL%=15-QL%
QSPACE$=""
IF QL%=1 THEN QSPACE$=""
IF QL%=2 THEN QSPACE$=" "
IF QL%=3 THEN QSPACE$=" "
IF QL%=4 THEN QSPACE$="  "
IF QL%=5 THEN QSPACE$="  "
IF QL%=6 THEN QSPACE$="   "
IF QL%=7 THEN QSPACE$="   "
IF QL%=8 THEN QSPACE$="    "
IF QL%=9 THEN QSPACE$="    "
PRINT #QDISPLAYOUT%, QSPACE$+QMENSAJE$;
RETURN
ZMUSICA: 
QMENSAJE$="INICIANDO" : GOSUB ZPANTALLA
SOUND DO%,10 : SOUND DO%,10 : SOUND DO%,10 : SOUND FA%,20 : SOUND LA%,20
SOUND DO%,10 : SOUND DO%,10 : SOUND DO%,10 : SOUND FA%,20 : SOUND LA%,20
SOUND FA%,10 : SOUND FA%,10 : SOUND MI%,10 : SOUND MI%,10 : SOUND RE%,10 : SOUND RE%,20 : SOUND DO%,20
RETURN
ZIMPRIMEARCHIVO: 
QMENSAJE$="IMPRIMIENDO" : GOSUB ZPANTALLA
CLL
CLIP ON
EXECUTE "TMP:PRINTFILE.FMT"
PRINTFEED
GOSUB ZWAIT
RETURN
ZEND: 
QMENSAJE$="EXIT ITA v1.0"
GOSUB ZPANTALLA
COMSET 5 OFF
CLOSE QDISPLAYOUT%
END
RETURN
ZWAIT: 
QWAITTIME%=TICKS+QWAIT%
WHILE TICKS<QWAITTIME% : WEND
RETURN
ZWAIT2: 
QWAITTIME2%=TICKS+QWAIT2%
WHILE TICKS<QWAITTIME2% : WEND
RETURN
ZCREAETIQUETA: 
QLFFILENAME$="C:"+A$+".TXT"
A$=""
QTIEMPO%=0
CLOSE 76
OPEN QLFFILENAME$ FOR INPUT AS 76
QFILEPRINTED%=0
QQRCODETXT$=""
WHILE NOT (EOF(76) OR QSTOPPRINTINGLABELS%)
LINE INPUT #76, QDATALINE$
IF INSTR(LEFT$(QDATALINE$,15),"LAYOUT INPUT") THEN 
QLINEFLAG%=1
QSTART%=0
END IF
IF INSTR(LEFT$(QDATALINE$,15),"LAYOUT END") THEN QLINEFLAG%=2
IF INSTR(LEFT$(QDATALINE$,15),"STORE") THEN 
GOSUB ZWRITETOARRAY
ELSE IF QLINEFLAG%=1 THEN 
IF QSTART%>0 THEN 
QSPECIAL%=0
IF INSTR(QDATALINE$,"@") THEN 
IF NOT QERR% THEN QSPECIAL%=1
END IF
IF QSPECIAL%>0 THEN GOSUB ZSPECIALDATA
GOSUB ZWRITETOARRAY
END IF
QSTART%=QSTART%+1
END IF
IF QLINEFLAG%=2 THEN 
GOSUB ZWRITETOFILE
GOSUB ZIMPRIMEARCHIVO
GOSUB ZCLEARARRAY
QFILEPRINTED%=1
QCOUNTER%=QCOUNTER%+1 : GOSUB ZINCREMENTSERIALNUMBER
END IF
WEND
CLOSE 76
IF NOT QFILEPRINTED% THEN 
QMENSAJE$="Error en Crear Etiqueta"
GOSUB ZPANTALLA
END IF
RETURN
ZSPECIALDATA: 
QSTART%=0
QERR%=0
QNEWDATALINE$=""
QLEN%=LEN(QDATALINE$)
FOR QI%=1 TO QLEN% STEP 1
QSINGLECHAR$=MID$(QDATALINE$,QI%,1)
QSPECIALCHAR$=MID$(QDATALINE$,QI%,2)
IF QSPECIALCHAR$="@T" THEN 
GOSUB ZGETTIME
QNEWDATALINE$=QNEWDATALINE$+QREPLACESTR$
QI%=QI%+1
ELSE IF QSPECIALCHAR$="@D" THEN 
GOSUB ZGETDATE
QNEWDATALINE$=QNEWDATALINE$+QREPLACESTR$
QI%=QI%+1
ELSE IF QSPECIALCHAR$="@S" THEN 
QNEWDATALINE$=QNEWDATALINE$+FORMAT$(STR$(QSERIALNUMBER%),"00000")
QI%=QI%+1
ELSE
QNEWDATALINE$=QNEWDATALINE$+QSINGLECHAR$
END IF
NEXT QI%
QDATALINE$=QNEWDATALINE$
RETURN
ZGETTIME: 
FORMAT TIME$ "HH:MM:SS"
ZGETTIMEFROMPRINTER: 
QERR%=0
QREPLACESTR$=TIME$("F")
IF QERR% THEN 
END IF
RETURN
ZGETDATE: 
FORMAT DATE$ QDATEFORMAT$
ZGETDATEFROMPRINTER: 
QERR%=0
QREPLACESTR$=DATE$("F")
IF QERR% THEN 
END IF
RETURN
ZWRITETOFILE: 
ON ERROR GOTO ZWRITETOFILE2
KILL "TMP:PRINTFILE.FMT"
ZWRITETOFILE2: 
OPEN "TMP:PRINTFILE.FMT" FOR OUTPUT AS 78
QQRCODE%=0
FOR I%=1 TO QARRAYINC% STEP 1
QTEMPLINE$=QDATAARRAY$(I%)
QERR%=0
QIDX%=INSTR(QTEMPLINE$,"QRCODE")
IF QIDX%>0 THEN 
IF NOT QERR% THEN QQRCODE%=1
END IF
IF QQRCODE%>=1 THEN GOSUB ZSETQRCODE
PRINT #78, QDATAARRAY$(I%)
NEXT I%
CLOSE 78
GOSUB ZWAIT
RETURN
ZSETQRCODE: 
QQRCODE%=QQRCODE%+1
QIDX%=INSTR(QDATAARRAY$(I%),"PB")
IF QIDX%=0 THEN QIDX%=INSTR(QDATAARRAY$(I%),"PRBAR")
IF QIDX%=0 THEN RETURN
QQRCODE%=0
QIDX%=LEN(QDATAARRAY$(I%))
QIDX%=QIDX%-INSTR(QDATAARRAY$(I%),CHR$(34))
QTEMPCODE$=RIGHT$(QDATAARRAY$(I%),QIDX%)
QIDX%=INSTR(QTEMPCODE$,CHR$(34))
QTEMPCODE$=LEFT$(QTEMPCODE$,QIDX%-1)
QQRCODETXT$=QQRCODETXT$+QTEMPCODE$
RETURN
ZWRITETOARRAY: 
IF QDIMARRAY%=0 THEN 
DIM QDATAARRAY$(QARRAYLIMIT%)
QDIMARRAY%=1
END IF
QARRAYINC%=QARRAYINC%+1
QDATAARRAY$(QARRAYINC%)=QDATALINE$
IF QARRAYINC%>=QARRAYLIMIT% THEN 
QLOGERROR$="Error: Label lines exceeds maximum. Increase program maximum." : GOSUB ZLOGERROR
QSTOPPRINTINGLABELS%=1
END IF
RETURN
ZCLEARARRAY: 
IF QDIMARRAY%=0 THEN 
DIM QDATAARRAY$(QARRAYLIMIT%)
QDIMARRAY%=1
END IF
FOR I%=1 TO QARRAYLIMIT% STEP 1
QDATAARRAY$(I%)=""
NEXT I%
QARRAYINC%=0
QLINEFLAG%=0
QSTART%=0
RETURN
ZCHECKFORFILE: 
QFILEFOUND%=0 : QFNAME$=QFILENAME$
RUN "su -p pass admin" : 'Default to admin rights when looking for files.
QFULLFOLDERFILENAME$=QLABELFILEFOLDER$+QFILENAME$
QFNAME$=FILENAME$(QFULLFOLDERFILENAME$)
IF QFNAME$=QFILENAME$ THEN QFILEFOUND%=1
RETURN
ZGETDATECODESFILE: 
CLOSE QDATEFILE%
QALLDATES$="" : QDATEFILE%=73
QERR%=0
OPEN QDATEFILENAME$ FOR INPUT AS QDATEFILE%
IF QERR% THEN 
QLOGERROR$="Error: "+STR$(QERR%)+". Was not able to open Datecodes file "+QDATEFILENAME$ : GOSUB ZLOGERROR
RETURN
END IF
QALLDATES$=INPUT$(LOF(QDATEFILE%),QDATEFILE%)
CLOSE QDATEFILE%
RETURN
ZLOGERROR: 
GOSUB ZPANTALLA
RETURN
ZINCREMENTSERIALNUMBER: 
QSERIALNUMBER%=QSERIALNUMBER%+1
IF QSERIALNUMBER%>99999 THEN 
QSERIALNUMBER%=1
END IF
GOSUB ZSAVESERIALNUMBER
RETURN
