(* created by  GEB Automation IDE v3.2.15.107, 2021-04-16 *)
//Damian Rozlach AGH 2021
//Systemy Mikrokomputerowe
PROGRAM zad10
	TYPE
S5BOOL : ARRAY[1..5] OF BOOL;
S5BYTE1 : ARRAY[1..5] OF BYTE := [11,8,19,15,29]; // ceny towarów
S5BYTE2 : ARRAY[1..5] OF BYTE := [0,0,10,10,10]; // ilość nominałów
S5BYTE3 : ARRAY[1..5] OF BYTE := [20,10,5,2,1]; // nominały
S5BYTE4 : ARRAY[1..5] OF BYTE := [10,10,15,20,25]; // max liczba nominałów
S5BYTE : ARRAY[1..5] OF BYTE;

END_TYPE


VAR_GLOBAL
// WEJSCIA
// wybór towaru
WE_towar1 AT %IXWE01 : BOOL; // Towar1
WE_towar2 AT %IXWE02 : BOOL; // Towar2
WE_towar3 AT %IXWE03 : BOOL; // Towar3
WE_towar4 AT %IXWE04 : BOOL; // Towar4
WE_towar5 AT %IXWE05 : BOOL; // Towar5

// wpłata gotówki
WE_dwudziestki AT %IXWE06 : BOOL; // Gotówka 20zł
WE_dziesiatki AT %IXWE07 : BOOL; // Gotówka 10zł
WE_piatki AT %IXWE08 : BOOL; // Gotówka 5zł
WE_dwojki AT %IXWE09 : BOOL; // Gotówka 2zł
WE_jedynki AT %IXWE10 : BOOL; // Gotówka 1zł

// przerwanie transakcji
WE_BRK_ACK AT %IXWE11 : BOOL; // przerwanie transakcji lub potwierdzenie z czujnika
END_VAR



VAR_GLOBAL
// WYJŚCIA
// wybrany towar
WY_towar1 AT %QXWY01 : BOOL; // wybrano Towar1
WY_towar2 AT %QXWY02 : BOOL; // wybrano Towar2
WY_towar3 AT %QXWY03 : BOOL; // wybrano Towar3
WY_towar4 AT %QXWY04 : BOOL; // wybrano Towar4
WY_towar5 AT %QXWY05 : BOOL; // wybrano Towar5

// brak miejsca
WY_brak_miejsca_20 AT %QXWY06 : BOOL; // brak miejsca na 20zł
WY_brak_miejsca_10 AT %QXWY07 : BOOL; // brak miejsca na 10zł
WY_brak_miejsca_5 AT %QXWY08 : BOOL; // brak miejsca na 5zł
WY_brak_miejsca_2 AT %QXWY09 : BOOL; // brak miejsca na 2zł
WY_brak_miejsca_1 AT %QXWY10 : BOOL; // brak miejsca na 1zł

// brak mozliwości wydana reszty
WY_brak_reszty AT %QXWY11 : BOOL; // brak mozliwości wydania reszty

//ilość gotówki w automacie
WYA_ilosc_20 AT %QB01 : BYTE; // ilość banknotów 20zł
WYA_ilosc_10 AT %QB02 : BYTE; // ilość banknotów 10zł
WYA_ilosc_5 AT %QB03 : BYTE; // ilość monet 5zł
WYA_ilosc_2 AT %QB04 : BYTE; // ilość monet 2zł
WYA_ilosc_1 AT %QB05 : BYTE; // ilość monet 1zł

// zapłata i reszta
WYA_cena AT %QB06 : BYTE; // cena wybranego towaru w zł
WYA_wplata AT %QB07 : BYTE; // kwota wpłaty zł
WYA_reszta AT %QB08 : BYTE; // kwota reszty w zł

WYA_reszta_5 AT %QB09 : BYTE; // ilość sztuk monet w reszcie 5zł
WYA_reszta_2 AT %QB10 : BYTE; // reeszta ilość sztuk monet 2zł
WYA_reszta_1 AT %QB11 : BYTE; // reeszta ilość sztuk monet 1zł

WYA_stan AT %QB12 : BYTE;

END_VAR




VAR
(* local vars *)
Wybierz_towar : fb_WYBOR_TOWARU;
Wplata_gotowki : fb_WPLATA;
Wybrano_towar : S5BOOL;
Wybrano_towar_1 : S5BOOL; //znacznik
Wybrano_towar_2 : S5BOOL; //znacznik
WE_Towar : S5BOOL;
WE_Gotowka : S5BOOL;
WE_Gotowka_1 : S5BOOL; //znacznik
Przerwanie_transakcji : BOOL;
Sygnal_z_czujnika : BOOL;
Przerwanie_marker : BOOL;
Wplacona_gotowka : BYTE;
Cena_towaru : BYTE;
Reszta : BYTE;
Reszta_nominaly : S5BYTE;
Ilosc_nominalow : S5BYTE2;
Ilosc_nominalow_1 : S5BYTE;
Brak_miejsca : S5BOOL;
Brak_nominalow : BOOL;
Steruj_wydaniem : S5BOOL;
Oblicz_nominaly_reszty : fb_RESZTA;
//koniec : BOOL;
licz: INT;
i : INT;
Step : INT;
Alarm : BOOL;
TFala : BOOL;
Miganie : fb_FALA;
END_VAR

// przypisanie wartości wejść dwustanowych do odpowiednich miejsc w tablicach

    WE_Towar[1] := WE_towar1;
	WE_Towar[2] := WE_towar2;
	WE_Towar[3] := WE_towar3;
	WE_Towar[4] := WE_towar4;
	WE_Towar[5] := WE_towar5;
	
	WE_Gotowka[1] := WE_dwudziestki;
	WE_Gotowka[2] := WE_dziesiatki;
	WE_Gotowka[3] := WE_piatki;
	WE_Gotowka[4] := WE_dwojki;
	WE_Gotowka[5] := WE_jedynki;

    Przerwanie_transakcji := WE_BRK_ACK;
	Sygnal_z_czujnika := WE_BRK_ACK;
	
	// Etapy działania etap 0 wybor towaru etap 1 mozliwosc zmiany decyzji 2 wplata 3 wydanie reszty i towaru 4 Prawidlowy koniec cyklu-oczekiwanie na potwierdzenie wypadniecia 5 przerwany cykl
    CASE Step OF
		0: //wybor towaru
		IF WE_Towar[1] OR WE_Towar[2] OR WE_Towar[3] OR WE_Towar[4] OR WE_Towar[5] THEN
		FOR i := 1 TO 5 DO
				Reszta_nominaly[i] := 0;
	    END_FOR;
	    Wplacona_gotowka := 0;
		Reszta := 0;
		
		END_IF;
		Wybierz_towar(WE := WE_Towar, PRZERWANIE_WE := Przerwanie_transakcji, WYBRANO_WY => Wybrano_towar, CENA => Cena_towaru);
		
		IF Wybrano_towar[1] OR Wybrano_towar[2] OR Wybrano_towar[3] OR Wybrano_towar[4] OR Wybrano_towar[5] THEN
			Step := 1;
			
			FOR i := 1 TO 5 DO
				Reszta_nominaly[i] := 0;
			END_FOR;
			FOR i := 1 TO 5 DO
				Wybrano_towar_1[i] := Wybrano_towar[i];
			END_FOR;
		END_IF;
		1: // mozliwość zmiany wyboru
		
		
		IF  WE_Gotowka[1] OR  WE_Gotowka[2] OR WE_Gotowka[3] OR WE_Gotowka[4] OR WE_Gotowka[5] THEN
		Wplata_gotowki(WE := WE_Gotowka, WE_1 := WE_Gotowka_1, WE_KWOTA := Wplacona_gotowka, WE_IL_NOM := Ilosc_nominalow, WE_BRAK_MIEJSCA := Brak_miejsca,
		WY_KWOTA => Wplacona_gotowka, WY_IL_NOM => Ilosc_nominalow, WY_BRAK_MIEJSCA => Brak_miejsca);
		
		Step := 2;
		ELSE
		Wybierz_towar(WE := WE_Towar, PRZERWANIE_WE := Przerwanie_transakcji, WYBRANO_WY => Wybrano_towar, CENA => Cena_towaru);
		IF NOT Wybrano_towar_1[1] = Wybrano_towar[1] OR NOT Wybrano_towar_1[2] = Wybrano_towar[2] OR NOT Wybrano_towar_1[3] = Wybrano_towar[3] OR NOT Wybrano_towar_1[4] = Wybrano_towar[4] OR NOT Wybrano_towar_1[5] = Wybrano_towar[5] THEN //sprawdzenie czy wybor wejscia sie nie zmienil
		FOR i := 1 TO 5 DO
				Wybrano_towar[i] := 0;
	    END_FOR;
	    Step := 0;
		END_IF;
		END_IF;
		
		IF Przerwanie_transakcji THEN //  przerwania cyklu 
			Step := 5;
		END_IF;
		
		2:
		IF Wplacona_gotowka < Cena_towaru THEN
		
		IF Przerwanie_transakcji THEN //  przerwania cyklu 
			
			Step := 5;
		END_IF;
		
		Wplata_gotowki(WE := WE_Gotowka, WE_1 := WE_Gotowka_1, WE_KWOTA := Wplacona_gotowka, WE_IL_NOM := Ilosc_nominalow, WE_BRAK_MIEJSCA := Brak_miejsca,
		WY_KWOTA => Wplacona_gotowka, WY_IL_NOM => Ilosc_nominalow, WY_BRAK_MIEJSCA => Brak_miejsca);
		ELSE 
		Step := 3;
		Reszta := Wplacona_gotowka - Cena_towaru;
		Oblicz_nominaly_reszty(WE_RESZTA := Reszta, WE_IL_NOM := Ilosc_nominalow, WE_WPLATA := Wplacona_gotowka, WE_BRAK_MIEJSCA := Brak_miejsca, 
			WY_IL_NOM_DO_WYD=>Reszta_nominaly, WY_IL_NOM=>Ilosc_nominalow, WY_BRAK_RESZTY=>Alarm, WY_BRAK_MIEJSCA=>Brak_miejsca);
		END_IF;
		
		
		
		3:
		IF NOT Alarm THEN // zapis na kolejne wplaty i wybor towarow, jesli trzeba bedzie zwrocic dane nominaly
			Step := 4;
			FOR i := 1 TO 5 DO
				Ilosc_nominalow_1[i] := Ilosc_nominalow[i] - Ilosc_nominalow_1[i]; // przypisanie, ktore nominaly ewentualnie jako wydanie, gdy brak reszty
				CASE Wybrano_towar_2[i] OF
					1:
					Miganie(STAN_WY => Wybrano_towar_2[i]);
					licz := licz + 1;
					IF licz = 3 THEN
						TFala := true;
					END_IF;
				END_CASE;
			END_FOR;
		END_IF;
		
		IF Alarm AND NOT TFala THEN
			Step := 3; // powrot do tego samego miejsca
			Miganie(STAN_WY => Brak_nominalow); // wywolanie funkcji, ktora umozliwia miganie wyjsciem 0/1 WY_brak_reszty
		END_IF;
		
		IF TFala THEN
			Step := 4;
			Alarm := false;
			TFala := false;
			FOR i := 1 TO 5 DO
				Ilosc_nominalow_1[i] := Ilosc_nominalow[i] - Ilosc_nominalow_1[i]; 
			END_FOR;
			
			FOR i := 1 TO 5 DO // zwrot wplaconej gotowki 
				Ilosc_nominalow[i] := Ilosc_nominalow[i] + Ilosc_nominalow_1[i];
			END_FOR;
			
			Wplacona_gotowka := 0;
			Cena_towaru := 0;
			Reszta := 0;
		
			FOR i := 1 TO 5 DO
				Reszta_nominaly[i] := 0;
			END_FOR;
		END_IF;
		4: // udana akcja czekanie na sygnal z czujnika
		IF Sygnal_z_czujnika AND NOT Przerwanie_marker THEN
		Step := 0 ;
		
		END_IF;
		5: //  przerwanie akcji i zwrot pieniedzy
		Reszta := Wplacona_gotowka ;
		Oblicz_nominaly_reszty(WE_RESZTA := Reszta, WE_IL_NOM := Ilosc_nominalow, WE_WPLATA := Wplacona_gotowka, WE_BRAK_MIEJSCA := Brak_miejsca, 
			WY_IL_NOM_DO_WYD=>Reszta_nominaly, WY_IL_NOM=>Ilosc_nominalow, WY_BRAK_RESZTY=>Alarm, WY_BRAK_MIEJSCA=>Brak_miejsca);
		Step := 0;
		
	END_CASE;	

    WYA_cena := Cena_towaru;
	WYA_wplata := Wplacona_gotowka;
	WYA_reszta := Reszta; 
	WY_brak_reszty := Brak_nominalow;

    WY_towar1 := Wybrano_towar[1];
	WY_towar2 := Wybrano_towar[2];
	WY_towar3 := Wybrano_towar[3];
	WY_towar4 := Wybrano_towar[4];
	WY_towar5 := Wybrano_towar[5];
	
	WYA_ilosc_20 := Ilosc_nominalow[1];
	WYA_ilosc_10 := Ilosc_nominalow[2];
	WYA_ilosc_5 := Ilosc_nominalow[3];
	WYA_ilosc_2 := Ilosc_nominalow[4];
	WYA_ilosc_1 := Ilosc_nominalow[5];
	
	WY_brak_miejsca_20 := Brak_miejsca[1];
	WY_brak_miejsca_10 := Brak_miejsca[2];
	WY_brak_miejsca_5 := Brak_miejsca[3];
	WY_brak_miejsca_2 := Brak_miejsca[4];
	WY_brak_miejsca_1 := Brak_miejsca[5];
	
	WYA_reszta_5 := Reszta_nominaly[3];
	WYA_reszta_2 := Reszta_nominaly[4];
	WYA_reszta_1 := Reszta_nominaly[5];
	
	WE_Gotowka_1[1] := WE_Gotowka[1];
	WE_Gotowka_1[2] := WE_Gotowka[2];
	WE_Gotowka_1[3] := WE_Gotowka[3];
	WE_Gotowka_1[4] := WE_Gotowka[4];
	WE_Gotowka_1[5] := WE_Gotowka[5];
	
	WYA_stan := INT_TO_BYTE(Step);
	
	Przerwanie_marker := WE_BRK_ACK;
END_PROGRAM
