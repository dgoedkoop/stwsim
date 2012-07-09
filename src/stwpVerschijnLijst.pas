unit stwpVerschijnlijst;

interface

uses stwpRails, stwpTreinen, stwvMisc;

type
	PpVerschijnPunt = ^TpVerschijnPunt;
	TpVerschijnPunt = record
		Naam:					string;
		Rail:		 			PpRail;
		vertragingmag:    boolean;	// Mag de trein vertraging hebben?
		afstand:				double;
		achteruit:			boolean;
		modus:				integer;
		startsnelheid:		integer;
		baanvaksnelheid:  integer;
		erlaubnis:			string;
		erlaubnisstand:	byte;
		Volgende:			PpVerschijnPunt;
	end;

	PpVerschijnItem = ^TpVerschijnItem;
	TpVerschijnItem = record
		// Opgegeven informatie
		Treinnummer:		string;
		Tijd:					integer;
		Plaats:				PpVerschijnPunt;
		vanafstation: 		string;
		wagons:				PpWagonConn;	// Dit bereiden we van te voren voor!
		treinweg_naam:		string;	// Welke trein moet verdwenen zijn alvorens
		treinweg_wachten:	integer;	// deze verschijnt, en hoe lang moet minimaal
											// gewacht worden?
		// Berekende informatie
		gedaan:				boolean;
		treinweg_voldaan:	boolean;
		treinweg_tijd:		integer;	// Wanneer verdween de trein?

		volgende:			PpVerschijnItem;
	end;

	PpVerdwijnPunt = ^TpVerdwijnPunt;
	TpVerdwijnPunt = record
		railnaam: 			string;
		achteruit:			boolean;
		volgende:			PpVerdwijnPunt;
	end;

function LaadVerschijnitems(var f: file; wat: TSaveWhat; pMaterieel: PpMaterieelFile; pAlleVerschijnpunten:PpVerschijnPunt): PpVerschijnItem;
procedure SaveVerschijnitems(var f: file; wat: TSaveWhat; VerschijnItems: PpVerschijnItem);

implementation

function ZoekVerschijnpunt(pAlleVerschijnpunten:PpVerschijnPunt; naam: string): PpVerschijnPunt;
var
	tmpVP : PpVerschijnPunt;
begin
	result := nil;
	tmpVP := pAlleVerschijnpunten;
	while assigned(tmpVP) do begin
		if tmpVP^.Naam = Naam then begin
			result := tmpVP;
			exit;
		end;
		tmpVP := tmpVP^.Volgende;
	end;
end;

function LaadVerschijnitems;
var
	i, puntcount: 	integer;
	VI:				PpVerschijnItem;
	PlaatsStr:		string;
begin
	result := nil;
	VI := nil;
	intread(f, puntcount);
	for i := 1 to puntcount do begin
		if not assigned(VI) then begin
			new(VI);
			result := VI;
		end else begin
			new(VI^.Volgende);
			VI := VI^.Volgende;
		end;
		VI^.wagons := nil;
		VI^.gedaan := false;
		VI^.treinweg_voldaan := false;
		VI^.Volgende := nil;
		stringread(f, VI^.Treinnummer);
		intread(f, VI^.Tijd);
		stringread(f, PlaatsStr);
		VI^.Plaats := ZoekVerschijnpunt(pAlleVerschijnpunten, PlaatsStr);
//		if not assigned(VI^.Plaats) then
//			halt;
		stringread(f, VI^.vanafstation);

		VI^.Wagons := LoadWagons(f, pMaterieel);

		stringread(f, VI^.treinweg_naam);
		intread(f, VI^.treinweg_wachten);
		if wat = swStatus then begin
			boolread(f, VI^.gedaan);
			boolread(f, VI^.treinweg_voldaan);
			intread(f, VI^.treinweg_tijd);
		end;
	end;
end;

procedure SaveVerschijnitems;
var
	puntcount: 	integer;
	VI:				PpVerschijnItem;
begin
	puntcount := 0;
	VI := VerschijnItems;
	while assigned(VI) do begin
		inc(puntcount);
		VI := VI^.Volgende;
	end;
	intwrite(f, puntcount);
	VI := VerschijnItems;
	while assigned(VI) do begin
		stringwrite(f, VI^.Treinnummer);
		intwrite(f, VI^.Tijd);
		if assigned(VI^.Plaats) then
			stringwrite(f, VI^.Plaats^.Naam)
		else
			stringwrite(f, '');
		stringwrite(f, VI^.vanafstation);

		SaveWagons(f, VI^.wagons);

		stringwrite(f, VI^.treinweg_naam);
		intwrite(f, VI^.treinweg_wachten);

		if wat = swStatus then begin
			boolwrite(f, VI^.gedaan);
			boolwrite(f, VI^.treinweg_voldaan);
			intwrite(f, VI^.treinweg_tijd);
		end;

		VI := VI^.Volgende;
	end;
end;

end.
