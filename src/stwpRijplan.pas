unit stwpRijplan;

interface

uses sysutils, stwpSternummer, stwpTijd, stwvMisc;

const
	rlsEditHeading = 'STATION        SPOOR AANKOMST VERTREK WACHTTIJD STOP KOPPELEN KEREN BIJZONDERHEDEN';
	rlsStatusHeading = 'STATION        SPOOR AANKOMST VERTREK KOPPELEN KEREN BIJZONDERHEDEN';

type
	TRijplanLijstSoort = (rlsEdit, rlsStatus);

	PpRijplanPunt = ^TpRijplanPunt;
	TpRijplanPunt = record
		Station:			string;	// Naam van het station waar we moeten stoppen.
		Perron:			string;	// Perron.
		Aankomst,
		Vertrek:			integer;	// Tijden. Vertrek = -1 voor niet-van-toepassing.
		minwachttijd:	integer;	// in seconden. -1 voor niet-van-toepassing.
		stoppen:			boolean;	// Moeten we hier uberhaupt stoppen?
		keren:			boolean;
		nieuwetrein:	boolean;	// Worden we een nieuwe trein?
		nieuwetrein_w:	string;	// Zo ja, welke?
		loskoppelen:	integer;	// Hoeveel wagons van achteren loskoppelen?
		loskoppelen_w:	string;	// Welk treinnummer krijgen die wagons?
		loskoppelen_keren: boolean;	// Afgekoppeld deel omkeren?
		samenvoegen:	boolean;	// Voor / bij aankomstpunt met een staande trein
										// koppelen?
		// Dynamische gegevens
		spc_gedaan:		boolean;	// Onderstaande speciale acties uitgevoerd?
		volgende: 		PpRijplanPunt;
	end;

	// Deze lijst bevat alle vooraf ingeprogrammeerde dienstregelingen.
	PpTreindienst = ^TpTreindienst;
	TpTreindienst = record
		Treinnummer:	string;
		Planpunten:		PpRijplanPunt;
		Volgende:		PpTreinDienst;
	end;

function RijpuntLijstStr(Punt: PpRijplanPunt; Soort: TRijplanLijstSoort): string;

procedure LaadRijpunt(var f: file; wat: TSaveWhat; Punt: PpRijplanPunt);
procedure SaveRijpunt(var f: file; wat: TSaveWhat; Punt: PpRijplanPunt);

function LaadTreindienst(var f: file; wat: TSaveWhat): PpRijplanPunt;
procedure SaveTreindienst(var f: file; wat: TSaveWhat; Punten: PpRijplanPunt);

function LaadTreindiensten(var f: file; wat: TSaveWhat): PpTreindienst;
procedure SaveTreindiensten(var f: file; wat: TSaveWhat; Dienst: PpTreindienst);

implementation

function jnStr(x: boolean): string;
begin
	if x then
		result := 'j'
	else
		result := 'n';
end;

function RijpuntLijstStr;
begin
	result :=	Pad(copy(Punt^.Station, 1, 14), 16, #32, vaAchter)+
					Pad(Punt^.Perron, 6, #32, vaAchter)+
					Pad(TijdStr(Punt^.Aankomst,false),5, #32, vaVoor)+
					Pad(TijdStr(Punt^.Vertrek, false),9, #32, vaVoor);

	if Soort = rlsEdit then
		result := result +
					Pad(MinSecStr(Punt^.minwachttijd),9, #32, vaVoor)+
					'    '+
					Pad(jnStr(Punt^.stoppen), 2, #32, vaAchter);

	result := result + '     '+
					Pad(jnStr(Punt^.samenvoegen), 8, #32, vaAchter)+
					Pad(jnStr(Punt^.keren), 4, #32, vaAchter);
	if Punt^.nieuwetrein then
		result := result + 'N:'+Punt^.nieuwetrein_w+#32;
	if Punt^.loskoppelen <> 0 then begin
		if Soort = rlsEdit then
			result := result + 'L:'+inttostr(Punt^.loskoppelen)+','+Punt^.loskoppelen_w
		else
			result := result + 'L:'+Punt^.loskoppelen_w;
		if Punt^.loskoppelen_keren and (Soort = rlsEdit) then
			result := result + ',K';
	end;
end;

procedure LaadRijpunt;
begin
	stringread(f, Punt^.Station);
	stringread(f, Punt^.Perron);
	intread(f, Punt^.Aankomst);
	intread(f, Punt^.Vertrek);
	intread(f, Punt^.minwachttijd);
	boolread(f, Punt^.stoppen);
	boolread(f, Punt^.keren);
	stringread(f, Punt^.nieuwetrein_w);
	Punt^.nieuwetrein := Punt^.nieuwetrein_w <> '';
	intread(f, Punt^.loskoppelen);
	stringread(f, Punt^.loskoppelen_w);
	boolread(f, Punt^.loskoppelen_keren);
	boolread(f, Punt^.samenvoegen);
	if wat = swStatus then
		boolread(f, Punt^.spc_gedaan)
	else
		Punt^.spc_gedaan := false;
end;

function LaadTreindienst;
var
	j, puntcount:	integer;
	Punt:				PpRijplanPunt;
begin
	result := nil;
	Punt := nil;
	intread(f, puntcount);
	for j := 1 to puntcount do begin
		if not assigned(Punt) then begin
			new(Punt);
			result := Punt;
		end else begin
			new(Punt^.Volgende);
			Punt := Punt^.Volgende;
		end;
		Punt^.volgende := nil;
		LaadRijpunt(f, wat, Punt);
	end;
end;

function LaadTreindiensten;
var
	i, treincount:	integer;
	TD: 				PpTreindienst;
begin
	result := nil;
	TD := nil;	// Voor de compiler
	intread(f, treincount);
	for i := 1 to treincount do begin
		if not assigned(TD) then begin
			new(TD);
			result := TD;
		end else begin
			new(TD^.Volgende);
			TD := TD^.Volgende;
		end;
		stringread(f, TD^.Treinnummer);
		TD^.Planpunten := LaadTreindienst(f, wat);
		TD^.Volgende := nil;
	end;
end;

procedure SaveRijpunt;
begin
	stringwrite(f, Punt^.Station);
	stringwrite(f, Punt^.Perron);
	intwrite(f, Punt^.Aankomst);
	intwrite(f, Punt^.Vertrek);
	intwrite(f, Punt^.minwachttijd);
	boolwrite(f, Punt^.stoppen);
	boolwrite(f, Punt^.keren);
	if Punt^.nieuwetrein then
		stringwrite(f, Punt^.nieuwetrein_w)
	else
		stringwrite(f, '');
	intwrite(f, Punt^.loskoppelen);
	stringwrite(f, Punt^.loskoppelen_w);
	boolwrite(f, Punt^.loskoppelen_keren);
	boolwrite(f, Punt^.samenvoegen);
	if wat = swStatus then
		boolwrite(f, Punt^.spc_gedaan);
end;

procedure SaveTreindienst;
var
	puntcount:		integer;
	Punt:				PpRijplanPunt;
begin
	puntcount := 0;
	Punt := Punten;
	while assigned(Punt) do begin
		inc(puntcount);
		Punt := Punt^.Volgende;
	end;
	intwrite(f, puntcount);
	Punt := Punten;
	while assigned(Punt) do begin
		SaveRijpunt(f, wat, Punt);
		Punt := Punt^.Volgende;
	end;
end;

procedure SaveTreindiensten;
var
	treincount:		integer;
	TD: 				PpTreindienst;
begin
	treincount := 0;
	TD := Dienst;
	while assigned(TD) do begin
		inc(treincount);
		TD := TD^.Volgende;
	end;
	intwrite(f, treincount);
	TD := Dienst;
	while assigned(TD) do begin
		stringwrite(f, TD^.Treinnummer);
		SaveTreindienst(f, wat, TD^.Planpunten);
		TD := TD^.Volgende;
	end;
end;

end.
