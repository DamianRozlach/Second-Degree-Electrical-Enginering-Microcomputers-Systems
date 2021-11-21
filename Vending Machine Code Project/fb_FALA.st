(* created by  GEB Automation IDE v3.2.15.107, 2021-06-10 *)
// Damian Rozlach, AGH Kraków
// Systemy mikrokomputerowe
FUNCTION_BLOCK fb_FALA 
	VAR
		(* local vars *)
		timer : TON;
		T1 : BOOL;
	END_VAR
	VAR_INPUT
		(* input vars *)
		WE : BOOL;
	END_VAR
	VAR_OUTPUT
		(* output vars *)
		STAN_WY : BOOL;
		PO_CZASIE : BOOL;
	END_VAR
	
	 (* Pou body: FUNCTION_BLOCK statements *)
		timer.PT := T#500ms;
		timer();
		
	IF timer.Q THEN
		timer.IN := FALSE;
		T1 := NOT T1;
	ELSE
		timer.IN := TRUE;
	END_IF;
	
	timer(PT := T#500ms);
	
	STAN_WY := T1;

END_FUNCTION_BLOCK
