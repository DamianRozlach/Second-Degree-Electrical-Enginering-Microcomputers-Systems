(* created by  GEB Automation IDE v3.2.15.107, 2021-05-29 *)
// Damian Rozlach, AGH Kraków
// Systemy mikrokomputerowe
FUNCTION_BLOCK fb_RESZTA 
	VAR
		(* local vars *)
		i : INT;
		j : BYTE;
		stan_monet : BYTE; // zmienna do sygnalizacji przepelnienia
		reszta : BYTE;
	END_VAR
	VAR_INPUT
		(* input vars *)
		WE_RESZTA : BYTE; 
		WE_IL_NOM : S5BYTE2; 
		WE_WPLATA : BYTE; 
		WE_BRAK_MIEJSCA : S5BOOL; 
	END_VAR
	VAR_OUTPUT
		(* output vars *)
		WY_IL_NOM_DO_WYD : S5BYTE; 
		WY_IL_NOM : S5BYTE2; 
		WY_BRAK_RESZTY : BOOL; // brak reszty: alarm i wyplata wplaty
		WY_BRAK_MIEJSCA : S5BOOL; // uaktualnienie czy brak miejsca na danym nominale 5 zl, 2 zl, 1 zl
	END_VAR
	
		(* Pou body: FUNCTION_BLOCK statements *)
		
		stan_monet := WE_IL_NOM[3] * 5 + WE_IL_NOM[4] * 2 + WE_IL_NOM[5] * 1; // ile jeszcze posiadamy monet do wydawania

		reszta := WE_RESZTA;
		
		IF reszta > stan_monet THEN
			WY_BRAK_RESZTY := true;	
			FOR i := 1 TO 5 DO
				WY_IL_NOM_DO_WYD[i] := 0;
				WY_IL_NOM[i] := WE_IL_NOM[i];
			END_FOR;
		END_IF;
		
		IF BYTE_TO_BOOL(WE_WPLATA) THEN // 
			
			FOR i := 1 TO 5 DO
				WY_IL_NOM[i] := WE_IL_NOM[i];
			END_FOR;
			
			
			FOR i := 3 TO 5 DO
			CASE i OF 
				3:
				j := 5; 
				4:
				j := 2; 
				5:
				j := 1; 
			END_CASE;
				WHILE reszta >= j AND WY_IL_NOM[i] >= 1  DO 
					reszta := reszta - j;
					WY_IL_NOM_DO_WYD[i] := WY_IL_NOM_DO_WYD[i] + 1; 
					WY_IL_NOM[i] := WY_IL_NOM[i] - 1; 
		
					IF WE_BRAK_MIEJSCA[i] THEN 
						WY_BRAK_MIEJSCA[i] := NOT WE_BRAK_MIEJSCA[i];
					END_IF;
				END_WHILE;
			END_FOR;
			
		ELSE 
			FOR i := 1 TO 5 DO
				WY_IL_NOM_DO_WYD[i] := 0;
				WY_IL_NOM[i] := WE_IL_NOM[i];
			END_FOR;
		END_IF;
END_FUNCTION_BLOCK