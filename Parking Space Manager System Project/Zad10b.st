(* created by  GEB Automation IDE v3.2.15.107, 2021-04-16 *)
//Damian Rozlach AGH 2021
//Systemy Mikrokomputerowe
PROGRAM zad10
	TYPE
S8BOOL: ARRAY[1..8] OF BOOL;
END_TYPE

VAR_GLOBAL
WE1_odjazd AT %IXWE01 : BOOL;
WE2_odjazd AT %IXWE02 : BOOL;
WE3_odjazd AT %IXWE03 : BOOL;
WE4_odjazd AT %IXWE04 : BOOL;
WE5_odjazd AT %IXWE05 : BOOL;
WE6_odjazd AT %IXWE06 : BOOL;
WE7_odjazd AT %IXWE07 : BOOL;
WE8_odjazd AT %IXWE08 : BOOL;

WE9_trig AT %IXWE09 : BOOL;
END_VAR
VAR_GLOBAL
WY1_miejsce_1 AT %QXWY1 : BOOL ;
WY2_miejsce_2 AT %QXWY2 : BOOL ;
WY3_miejsce_3 AT %QXWY3 : BOOL ;
WY4_miejsce_4 AT %QXWY4 : BOOL ;



WY5_miejsce_5 AT %QXWY5 : BOOL ;
WY6_miejsce_6 AT %QXWY6 : BOOL ;
WY7_miejsce_7 AT %QXWY7 : BOOL ;
WY8_miejsce_8 AT %QXWY8 : BOOL ;

WYA1 AT %QB1 : BYTE;
END_VAR

VAR
(* local vars *)
miejsca : S8BOOL; // tablica zajętości miejsc parkingowych
reset : S8BOOL ;
i : INT;
//n : INT;
WE9_1 : BOOL; //WE9n-1
END_VAR





IF WE9_trig AND NOT WE9_1 THEN

i	:=	0;
	REPEAT
		i	:=	i+1;
	UNTIL	miejsca[i] = 0
	END_REPEAT;
	miejsca[i] := 1 ;
	WYA1 :=INT_TO_BYTE(i);
END_IF;		

reset[1] := WE1_odjazd;
reset[2] := WE2_odjazd;
reset[3] := WE3_odjazd;
reset[4] := WE4_odjazd;
reset[5] := WE5_odjazd;
reset[6] := WE6_odjazd;
reset[7] := WE7_odjazd;
reset[8] := WE8_odjazd;

i	:=	0;
FOR i:=1 TO 8 BY 1 DO
	IF reset[i] THEN
	miejsca[i] := 0;
	
	END_IF;
END_FOR;

WY1_miejsce_1:=miejsca[1];
WY2_miejsce_2:=miejsca[2];
WY3_miejsce_3:=miejsca[3];
WY4_miejsce_4:=miejsca[4];

WY5_miejsce_5:=miejsca[5];
WY6_miejsce_6:=miejsca[6];
WY7_miejsce_7:=miejsca[7];
WY8_miejsce_8:=miejsca[8];

WE9_1:=WE9_trig;

END_PROGRAM
