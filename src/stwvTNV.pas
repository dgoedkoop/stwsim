unit stwvTNV;

interface

type
	pTNVVolgeenheid = ^tTNVVolgeenheid;
	tTNVVolgeenheid = record
		Vensters: 		array of string;
	end;

	tTNVPositie = class
		Naam:				string;
		Volgeenheid:	pTNVVolgeenheid;
		Omgekeerd:		boolean;
	private
		procedure Push;
		procedure Pull;
	public
		procedure PlaatsNr(nr: string);
		function RemoveNr: string;
	end;

implementation

procedure tTNVPositie.Push;
var
	eersteleeg, eerstebezet: integer;
begin
	while true do begin
		// Zoek het eerste lege TNV-nummer
		if not omgekeerd then begin
			eersteleeg := length(Volgeenheid^.Vensters)-1;
			while (eersteleeg > 0) and (Volgeenheid^.Vensters[eersteleeg] <> '') do
				dec(eersteleeg);
			if Volgeenheid^.Vensters[eersteleeg] <> '' then exit;
		end else begin
			eersteleeg := 0;
			while (eersteleeg < length(Volgeenheid^.Vensters)-1) and (Volgeenheid^.Vensters[eersteleeg] <> '') do
				inc(eersteleeg);
			if Volgeenheid^.Vensters[eersteleeg] <> '' then exit;
		end;
		// Zoek het daaropvolgende eerste bezette TNV-nummer
		if not omgekeerd then begin
			eerstebezet := eersteleeg;
			while (eerstebezet > 0) and (Volgeenheid^.Vensters[eersteleeg] = '') do
				dec(eerstebezet);
			if Volgeenheid^.Vensters[eerstebezet] = '' then exit;
		end else begin
			eerstebezet := eersteleeg;
			while (eerstebezet < length(Volgeenheid^.Vensters)-1) and (Volgeenheid^.Vensters[eersteleeg] = '') do
				inc(eerstebezet);
			if Volgeenheid^.Vensters[eerstebezet] = '' then exit;
		end;
		// Omwisselen.
		Volgeenheid^.Vensters[eersteleeg] := Volgeenheid^.Vensters[eerstebezet];
		Volgeenheid^.Vensters[eerstebezet] := '';
	end;
end;

procedure tTNVPositie.Pull;
begin
	Omgekeerd := not Omgekeerd;
	Push;
	Omgekeerd := not Omgekeerd;
end;

procedure tTNVPositie.PlaatsNr;
var
	eersteleeg: integer;
begin
	// Alle treinnummers doorschuiven
	Push;
	// Zoek het eerste lege TNV-nummer
	if not omgekeerd then begin
		eersteleeg := 0;
		while (eersteleeg < length(Volgeenheid^.Vensters)-1) and (Volgeenheid^.Vensters[eersteleeg] <> '') do
			inc(eersteleeg);
		if Volgeenheid^.Vensters[eersteleeg] <> '' then exit;
	end else begin
		eersteleeg := length(Volgeenheid^.Vensters)-1;
		while (eersteleeg > 0) and (Volgeenheid^.Vensters[eersteleeg] <> '') do
			dec(eersteleeg);
		if Volgeenheid^.Vensters[eersteleeg] <> '' then exit;
	end;
	// TNV-nummer plaatsen.
	Volgeenheid^.Vensters[eersteleeg] := nr;
end;

function tTNVPositie.RemoveNr;
begin
	Pull;
	if not omgekeerd then begin
		result := Volgeenheid^.Vensters[0];
		Volgeenheid^.Vensters[0] := '';
	end else begin
		result := Volgeenheid^.Vensters[length(Volgeenheid^.Vensters)-1];
		Volgeenheid^.Vensters[length(Volgeenheid^.Vensters)-1] := '';
	end;
	Pull;
end;

end.
