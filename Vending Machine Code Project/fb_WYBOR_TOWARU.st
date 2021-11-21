(* created by  GEB Automation IDE v3.2.15.107, 2021-05-29 *)
// Damian Rozlach, AGH Kraków
// Systemy mikrokomputerowe
FUNCTION_BLOCK fb_WYBOR_TOWARU 
	VAR
		(* local vars *)
		i : INT;
		j : INT;
		k : INT;
		CENY : S5BYTE1;
		ZN_WE : S5BOOL;
	END_VAR
	VAR_INPUT
		(* input vars *)
		WE : S5BOOL;
		PRZERWANIE_WE : BOOL;
	END_VAR
	VAR_OUTPUT
		(* output vars *)
		WYBRANO_WY : S5BOOL;
		CENA : BYTE;
	END_VAR

		(* Pou body: FUNCTION_BLOCK statements *)
	 	FOR i := 1 TO 5 DO 
			IF WE[i] AND NOT ZN_WE[i] THEN
				ZN_WE[i] := true; 
				CENA := CENY[i];	// cena wybranego towaru
				WYBRANO_WY[i] := true; 
				j := j + 1;
				IF j >= 2 THEN
				FOR k := 1 TO 5 DO
					WYBRANO_WY[k] := false;
					ZN_WE[k] := false;
					END_FOR;
					j := 0;
				END_IF;
			END_IF;
			
			IF NOT WE[i] THEN
				ZN_WE[i] := false; 
			END_IF;
			
			IF PRZERWANIE_WE THEN 
				CENA := 0;
				WYBRANO_WY[i] := false;
			END_IF;
		END_FOR;
	
END_FUNCTION_BLOCK