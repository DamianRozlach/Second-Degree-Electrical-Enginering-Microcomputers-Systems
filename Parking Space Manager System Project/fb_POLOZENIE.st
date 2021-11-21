(* created by  GEB Automation IDE v3.2.15.107, 2021-05-07 *)
FUNCTION_BLOCK fb_POLOZENIE 
	VAR
		(* local vars *)
		ZN_minus : BOOL ;
		ZN_plus : BOOL ;
		WEA_1 : BOOL ;
	END_VAR
	VAR_INPUT
		(* input vars *)
		WEA : BOOL;
		WEB : BOOL;
	END_VAR
	VAR_OUTPUT
		(* output vars *)
		polozenie : INT;
	END_VAR
	
	 (* Pou body: FUNCTION_BLOCK statements *)
IF WEA AND NOT WEA_1 AND NOT ZN_plus AND NOT WEB THEN
polozenie := polozenie +1;
ZN_plus := 1;
END_IF;

IF NOT WEA AND  WEA_1 AND  ZN_plus AND WEB THEN

ZN_plus := 0;
END_IF;


IF WEA AND NOT WEA_1 AND NOT ZN_minus AND  WEB THEN
polozenie := polozenie -1;
ZN_minus := 1;
END_IF;

IF  NOT WEA AND  WEA_1 AND ZN_minus AND NOT WEB THEN
ZN_minus := 0;
END_IF;	


WEA_1 := WEA;
polozenie := INT_TO_BYTE(polozenie);
END_FUNCTION_BLOCK
