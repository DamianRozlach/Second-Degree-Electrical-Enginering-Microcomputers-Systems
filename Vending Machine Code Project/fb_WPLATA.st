(* created by  GEB Automation IDE v3.2.15.107, 2021-05-30 *)
// Damian Rozlach, AGH Kraków
// Systemy mikrokomputerowe
FUNCTION_BLOCK fb_WPLATA 
	VAR
		(* local vars *)
		i : INT;
		NOMINAL : S5BYTE3;
		MAX_LIMIT_NOM : S5BYTE4;
	END_VAR
	VAR_INPUT
		(* input vars *)
		WE : S5BOOL;
		WE_1 : S5BOOL;
		WE_KWOTA : BYTE;
		WE_IL_NOM : S5BYTE2;
		WE_BRAK_MIEJSCA : S5BOOL;
		AKCJA_PLAC : BOOL;
	END_VAR
	VAR_OUTPUT
		(* output vars *)
		WY_KWOTA : BYTE;
		WY_IL_NOM : S5BYTE2;
		WY_BRAK_MIEJSCA : S5BOOL;
	END_VAR
	
		(* Pou body: FUNCTION_BLOCK statements *)
		WY_KWOTA := WE_KWOTA; 
		
		FOR i := 1 TO 5 DO 
			IF WE[i] AND NOT WE_BRAK_MIEJSCA[i] AND NOT WE_1[i] THEN //zbocze narastajace oraz sprawdzenie czy jest miejsce
				WY_IL_NOM[i] := WE_IL_NOM[i] + 1; // zwiekszenie zasobu nominalu automatu
				WY_KWOTA := WY_KWOTA + (WE[i] * NOMINAL[i]); // obliczenie aktulnej wplaty
				
				IF WY_IL_NOM[i] >= MAX_LIMIT_NOM[i] THEN // sprawdzenie czy zostal osiagniety max limit miejsca nominalu
					WY_BRAK_MIEJSCA[i] := true;
				END_IF;
			ELSE
				;
			END_IF;
		END_FOR;
END_FUNCTION_BLOCK
