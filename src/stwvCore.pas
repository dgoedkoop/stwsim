unit stwvCore;

interface

uses stwvMeetpunt, stwvSeinen, stwvRijwegen, stwvSporen, stwvMisc,
	stwvTreinComm, stwvScore;

// Dit is eigenlijk heel slecht geprogrammeerd. Niet object-georienteerd, maar
// toch eigenlijk weer wel...

type
	PvCore = ^TvCore;
	TvCore = record
		vAlleWisselGroepen:	PvWisselGroep;
		vAlleMeetpunten:		PvMeetpunt;
		vAlleSeinen:			PvSein;
		vAlleRijwegen:			PvRijweg;
		vAlleOverwegen:		PvOverweg;
		vAlleErlaubnisse:		PvErlaubnis;
		vActieveRijwegen:		PvActieveRijwegLijst;
		vAllePrlRijwegen:		PvPrlRijweg;
		vAlleBinnenkomendeGesprekken:	PvBinnenkomendGesprek;
		vAlleSubroutes:		PvSubroute;
		vScore:					TScoreInfo;
		pauze:					boolean;
		Tijd_u, Tijd_m, Tijd_s: integer;
	end;

// moet weg!!!
procedure RijwegVoegInactiefHokjeToe(Rijweg: PvRijweg; schermID: integer; x,y: integer; meetpunt: PvMeetpunt);

procedure vCore_Create(core: PvCore);

function AddSubroute(core: PvCore; Meetpunt: PvMeetpunt; Wisselstanden: PvWisselStand;
	KruisingHokjes: PvKruisingHokje; InactieveHokjes: PvInactiefHokje): PvSubroute;

procedure AddBinnenkomendGesprek(core: PvCore; metwie: TvMessageWie);
procedure DeleteBinnenkomendGesprek(core: PvCore; metwie: TvMessageWie);

function ZoekMeetpunt(core: PvCore; naam: string): PvMeetpunt;
procedure AddMeetpunt(core: PvCore; naam: string);
function ZoekErlaubnis(core: PvCore; naam: string): PvErlaubnis;
procedure AddErlaubnis(core: PvCore; naam: string);
function NieuwSein(core: PvCore): PvSein;
function ZoekSein(core: PvCore; naam: string): PvSein;
function AddOverweg(core: PvCore; naam: string): PvOverweg;
function ZoekOverweg(core: PvCore; naam: string): PvOverweg;
procedure DeleteOverweg(core: PvCore; naam: string);

function AddWisselGroep(core: PvCore; naam: string): PvWisselGroep;
function ZoekWisselGroep(core: PvCore; naam: string): PvWisselGroep;

procedure AddWissel(core: PvCore; naam: string; meetpunt: string; groep: string; basisstandrecht: boolean);
function ZoekWissel(core: PvCore; naam: string): PvWissel;
procedure DeleteWissel(core: PvCore; naam: string);

function EersteWissel(core: PvCore): PvWissel;
function VolgendeWissel(wissel: PvWissel): PvWissel;

function NieuweRijweg(core: PvCore): PvRijweg;
function ZoekRijweg(core: PvCore; van, naar: string): PvRijweg;
function NieuwePrlRijweg(core: PvCore): PvPrlRijweg;
function ZoekPrlRijweg(core: PvCore; van, naar: string; dwang: byte): PvPrlRijweg;

function AddActieveRijweg(core: PvCore; Rijweg: PvRijweg; ROZ, Auto: boolean): PvActieveRijwegLijst;
procedure DeleteActieveRijweg(core: PvCore; ActieveRijweg: PvActieveRijwegLijst);

procedure SaveSein(var f: file; Sein: PvSein);
procedure LoadSein(var f: file; core: PvCore; Sein: PvSein);
procedure SaveRijweg(var f: file; Rijweg: PvRijweg);
procedure LoadRijweg(var f: file; core: PvCore; Rijweg: PvRijweg);
procedure SavePrlRijweg(var f: file; PrlRijweg: PvPrlRijweg);
procedure LoadPrlRijweg(var f: file; core: PvCore; PrlRijweg: PvPrlRijweg);

procedure SaveWisselStatus(var f: file; Core: PvCore);
procedure LoadWisselStatus(var f: file; Core: PvCore);

procedure LoadThings(Core: PvCore; var f: file);
procedure SaveThings(Core: PvCore; var f: file);

procedure BerekenAankondigingen(Core: PvCore);
procedure BerekenOnbekendAanwezig(Groep: PvWisselGroep);

implementation

procedure RijwegVoegInactiefHokjeToe;
var
	nInactiefHokje: PvInactiefHokje;
begin
	nInactiefHokje := Rijweg.InactieveHokjes;
	while assigned(nInactiefHokje) do begin
		if (nInactiefHokje^.schermID = schermID) and
			(nInactiefHokje^.x = x) and
			(nInactiefHokje^.y = y) then
			exit;
		nInactiefHokje := nInactiefHokje^.Volgende;
	end;
	new(nInactiefHokje);
	nInactiefHokje^.schermID := schermID;
	nInactiefHokje^.x := x;
	nInactiefHokje^.y := y;
	nInactiefHokje^.volgende := Rijweg.InactieveHokjes;
	Rijweg.InactieveHokjes := nInactiefHokje;
end;

procedure vCore_Create;
begin
	Core^.vAlleWisselGroepen := nil;
	Core^.vAlleMeetpunten := nil;
	Core^.vAlleSeinen := nil;
	Core^.vAlleRijwegen := nil;
	Core^.vAllePrlRijwegen := nil;
	Core^.vAlleErlaubnisse := nil;
	Core^.vActieveRijwegen := nil;
	Core^.vAlleOverwegen := nil;
	Core^.vAlleSubroutes := nil;
	Core^.vAlleBinnenkomendeGesprekken := nil;
end;

function AddSubroute;
var
	tmpSubroute: PvSubroute;
begin
	new(tmpSubroute);
	tmpSubroute^.Meetpunt := Meetpunt;
	tmpSubroute^.Wisselstanden := Wisselstanden;
	tmpSubroute^.KruisingHokjes := KruisingHokjes;
	tmpSubroute^.EersteHokje := InactieveHokjes;
	tmpSubroute^.Volgende := Core^.vAlleSubroutes;
	Core^.vAlleSubroutes := tmpSubroute;
	result := tmpSubroute;
end;

procedure AddBinnenkomendGesprek;
var
	bkg: PvBinnenkomendGesprek;
begin
	new(bkg);
	bkg^.MetWie := metwie;
	bkg^.volgende := Core.vAlleBinnenkomendeGesprekken;
	Core.vAlleBinnenkomendeGesprekken := bkg;
end;

procedure DeleteBinnenkomendGesprek;
var
	vbkg, bkg, nbkg: PvBinnenkomendGesprek;
begin
	bkg := Core.vAlleBinnenkomendeGesprekken;
	vbkg := nil;
	while assigned(bkg) do begin
		if CmpMessageWie(bkg^.MetWie, metwie) then begin
			nbkg := bkg^.volgende;
			if assigned(vbkg) then
				vbkg^.volgende := nbkg
			else
				Core.vAlleBinnenkomendeGesprekken := nbkg;
			dispose(bkg);
			bkg := nbkg;
		end else begin
			vbkg := bkg;
			bkg := bkg^.Volgende;
		end;
	end;
end;

function ZoekMeetpunt;
var
	mp: PvMeetpunt;
begin
	result := nil;
	mp := core.vAlleMeetpunten;
	while assigned(mp) do begin
		if mp^.meetpuntID = naam then begin
			result := mp;
			break;
		end;
		mp := mp^.Volgende;
	end;
end;

procedure AddMeetpunt;
var
	mp, l: PvMeetpunt;
begin
	if assigned(ZoekMeetpunt(Core, Naam)) then exit;
	new(mp);
	mp^.meetpuntID := naam;
	mp^.Aankondiging := false;
	mp^.Aank_Spoor := '';
	mp^.Aank_Erlaubnis := nil;
	mp^.Aank_Erlaubnisstand := 0;
	mp^.registered := false;
	mp^.bezet := false;
	mp^.RijwegOnderdeel := nil;
	mp^.Volgende := nil;
	l := core.vAlleMeetpunten;
	if not assigned(l) then
		core.vAlleMeetpunten := mp
	else begin
		while assigned(l^.Volgende) do
			l := l^.Volgende;
		l^.Volgende := mp;
	end;
end;

function ZoekOverweg;
var
	ov: PvOverweg;
begin
	result := nil;
	ov := core.vAlleOverwegen;
	while assigned(ov) do begin
		if ov^.Naam = naam then begin
			result := ov;
			break;
		end;
		ov := ov^.Volgende;
	end;
end;

function AddOverweg;
var
	ov, l: PvOverweg;
begin
	result := nil;
	if assigned(ZoekOverweg(Core, Naam)) then exit;
	new(ov);
	ov^.Naam := naam;
	ov^.registered := false;
	ov^.Gesloten := false;
	ov^.Gesloten_Wens := false;
	ov^.Meetpunten := nil;
	ov^.AankMeetpunten := nil;
	ov^.Volgende := nil;
	l := core.vAlleOverwegen;
	if not assigned(l) then
		core.vAlleOverwegen := ov
	else begin
		while assigned(l^.Volgende) do
			l := l^.Volgende;
		l^.Volgende := ov;
	end;
	result := ov;
end;

procedure DeleteOverweg;
var
	ov, vov: PvOverweg;
	tmpMeetpuntL: PvMeetpuntLijst;
begin
	ov := ZoekOverweg(Core, Naam);
	if not assigned(ov) then exit;
	while assigned(ov^.Meetpunten) do begin
		tmpMeetpuntL := ov^.Meetpunten;
		ov^.Meetpunten := tmpMeetpuntL^.Volgende;
		dispose(tmpMeetpuntL);
	end;

	ov := Core^.vAlleOverwegen;
	vov := nil;
	while assigned(ov) do begin
		if ov^.Naam = Naam then break;
		vov := ov;
		ov := ov^.Volgende;
	end;
	if assigned(vov) then
		vov^.Volgende := ov^.Volgende
	else
		Core^.vAlleOverwegen := ov^.Volgende;
	dispose(ov);
end;

function ZoekErlaubnis;
var
	e: PvErlaubnis;
begin
	result := nil;
	e := core.vAlleErlaubnisse;
	while assigned(e) do begin
		if e^.erlaubnisID = naam then begin
			result := e;
			break;
		end;
		e := e^.Volgende;
	end;
end;

procedure AddErlaubnis;
var
	e, l: PvErlaubnis;
begin
	if assigned(ZoekErlaubnis(Core, Naam)) then exit;
	new(e);
	e^.erlaubnisID := naam;
	e^.richting := 0;
	e^.vergrendeld := false;
	e^.registered := false;
	e^.Volgende := nil;
	l := core.vAlleErlaubnisse;
	if not assigned(l) then
		core.vAlleErlaubnisse := e
	else begin
		while assigned(l^.Volgende) do
			l := l^.Volgende;
		l^.Volgende := e;
	end;
end;

function ZoekSein;
var
	s: PvSein;
begin
	result := nil;
	s := core.vAlleSeinen;
	while assigned(s) do begin
		if s^.Naam = naam then begin
			result := s;
			exit;
		end;
		s := s^.Volgende;
	end;
end;

function NieuwSein;
var
	s, l: PvSein;
begin
	new(s);
	s^.Naam := '';
	s^.Van := '';
	s^.TriggerMeetpunt := nil;
	s^.VanTNVMeetpunt := nil;
	s^.HerroepMeetpunten := nil;
	s^.RijwegOnderdeel := nil;
	s^.registered := false;
	s^.herroepen := false;
	s^.Volgende := nil;
	l := core.vAlleSeinen;
	if not assigned(l) then
		core.vAlleSeinen := s
	else begin
		while assigned(l^.volgende) do
			l := l^.volgende;
		l^.volgende := s;
	end;
	result := s;
end;

function ZoekWisselGroep;
var
	w: PvWisselGroep;
begin
	result := nil;
	w := core.vAlleWisselGroepen;
	while assigned(w) do begin
		if w^.GroepID = naam then begin
			result := w;
			exit;
		end;
		w := w^.Volgende;
	end;
end;

function AddWisselGroep;
var
	w,l: PvWisselGroep;
begin
	result := ZoekWisselGroep(core,naam);
	if assigned(result) then exit;
	new(w);
	w^.GroepID := naam;
	w^.EersteWissel := nil;
	w^.OnbekendAanwezig := false;
	w^.bedienverh := false;
	w^.Volgende := nil;
	l := core.vAlleWisselGroepen;
	if not assigned(l) then
		core.vAlleWisselGroepen := w
	else begin
		while assigned(l^.volgende) do
			l := l^.volgende;
		l^.volgende := w;
	end;
	result := w;
end;

function ZoekWissel;
var
	wg: PvWisselGroep;
	w: PvWissel;
begin
	result := nil;
	wg := core.vAlleWisselgroepen;
	while assigned(wg) do begin
		w := wg^.EersteWissel;
		while assigned(w) do begin
			if w^.WisselID = naam then begin
				result := w;
				exit;
			end;
			w := w^.Volgende;
		end;
		wg := wg^.Volgende;
	end;
end;

procedure AddWissel;
var
	w,l: PvWissel;
begin
	if assigned(ZoekWissel(core,naam)) then exit;
	// Wissel maken!
	new(w);
	w^.WisselID := naam;
	w^.Meetpunt := zoekMeetpunt(core, meetpunt);
	w^.BasisstandRecht := basisstandrecht;
	w^.RijwegOnderdeel := nil;
	w^.rijwegverh := false;
	w^.registered := false;
	w^.Stand := wsOnbekend;
	w^.Wensstand := wsEgal;
	// Wissel in de wisselgroep plaatsen
	w^.Groep := ZoekWisselGroep(core, groep);
	if not assigned(w^.Groep) then
		w^.Groep := AddWisselGroep(core, groep);
	w^.Volgende := nil;
	l := w^.Groep^.EersteWissel;
	if not assigned(l) then
		w^.Groep^.EersteWissel := w
	else begin
		while assigned(l^.volgende) do
			l := l^.volgende;
		l^.volgende := w;
	end;
end;

procedure DeleteWissel;
var
	dw, w, vw, tw: PvWissel;
	dwg, wg, vwg, twg: PvWisselGroep;
begin
	dw := ZoekWissel(core, naam);
	if not assigned(dw) then exit;
	wg := dw^.Groep;
	// Wis de wissel uit de groep.
	vw := nil;
	w := wg^.EersteWissel;
	while assigned(w) do begin
		if (w = dw) then begin
			if assigned(vw) then
				vw^.volgende := w^.volgende
			else
				wg^.EersteWissel := w^.volgende;
			tw := w^.volgende;
			dispose(w);
			w := tw;
		end else begin
			vw := w;
			w := w^.volgende;
		end;
	end;
	// Wis de wisselgroep als die niet meer nodig is.
	if not assigned(wg^.EersteWissel) then begin
		dwg := wg;
		vwg := nil;
		wg := core^.vAlleWisselGroepen;
		while assigned(wg) do begin
			if (wg = dwg) then begin
				if assigned(vwg) then
					vwg^.volgende := wg^.volgende
				else
					core.vAlleWisselGroepen := wg^.volgende;
				twg := wg^.volgende;
				dispose(wg);
				wg := twg;
			end else begin
				vwg := wg;
				wg := wg^.volgende;
			end;
		end;
	end;
end;

function EersteWissel;
begin
	result := nil;
	if not assigned(Core^.vAlleWisselgroepen) then exit;
	result := Core^.vAlleWisselgroepen^.EersteWissel;
end;

function VolgendeWissel;
begin
	if assigned(Wissel^.Volgende) then
		result := Wissel^.Volgende
	else
		if assigned(Wissel^.Groep^.Volgende) then
			result := Wissel^.Groep^.Volgende^.EersteWissel
		else
			result := nil;
end;

function NieuweRijweg;
var
	l, Rijweg: PvRijweg;
begin
	new(Rijweg);
	Rijweg^.Meetpunten := nil;
	Rijweg^.Wisselstanden := nil;
	Rijweg^.Sein := nil;
	Rijweg^.NaarSein := nil;
	Rijweg^.NaarOnbeveiligd := false;
	Rijweg^.Erlaubnis := nil;
	Rijweg^.Erlaubnisstand := 0;
	Rijweg^.Naar := '';
	Rijweg^.NaarTNVMeetpunt := nil;
	Rijweg^.InactieveHokjes := nil;
	Rijweg^.KruisingHokjes := nil;
	Rijweg^.Volgende := nil;
	l := Core.vAlleRijwegen;
	if not assigned(l) then
		Core.vAlleRijwegen := Rijweg
	else begin
		while assigned(l^.volgende) do
			l := l^.volgende;
		l^.volgende := Rijweg;
	end;
	result := Rijweg;
end;

function NieuwePrlRijweg;
var
	l, PrlRijweg: PvPrlRijweg;
begin
	new(PrlRijweg);
	PrlRijweg^.van := '';
	PrlRijweg^.naar := '';
	PrlRijweg^.Rijwegen := nil;
	PrlRijweg^.Dwang := 0;
	PrlRijweg^.Volgende := nil;
	l := Core.vAllePrlRijwegen;
	if not assigned(l) then
		Core.vAllePrlRijwegen := PrlRijweg
	else begin
		while assigned(l^.volgende) do
			l := l^.volgende;
		l^.volgende := PrlRijweg;
	end;
	result := PrlRijweg;
end;

function ZoekRijweg;
var
	Rijweg: PvRijweg;
begin
	result := nil;
	Rijweg := Core^.vAlleRijwegen;
	while assigned(Rijweg) do begin
		if (Rijweg^.Sein^.Van = van) and (Rijweg^.Naar = naar) then begin
			result := Rijweg;
			break;
		end;
		Rijweg := Rijweg^.Volgende;
	end;
end;

function ZoekPrlRijweg;
var
	PrlRijweg: PvPrlRijweg;
begin
	result := nil;
	PrlRijweg := Core^.vAllePrlRijwegen;
	while assigned(PrlRijweg) do begin
		if (PrlRijweg^.Van = 'r'+van) and (PrlRijweg^.Naar = 'r'+naar) and
			(PrlRijweg^.Dwang = Dwang) then begin
			result := PrlRijweg;
			break;
		end;
		PrlRijweg := PrlRijweg^.Volgende;
	end;
end;

function AddActieveRijweg;
var
	a, l: PvActieveRijwegLijst;
begin
	new(a);
	a^.Rijweg := Rijweg;
	a^.ROZ := ROZ;
	a^.Autorijweg := Auto;
	a^.Pending := 0;
	a^.Herroep.herroep := false;
	a^.Volgende := nil;
	l := core.vActieveRijwegen;
	if not assigned(l) then
		core.vActieveRijwegen := a
	else begin
		while assigned(l^.Volgende) do
			l := l^.Volgende;
		l^.Volgende := a;
	end;
	result := a;
end;

procedure DeleteActieveRijweg;
var
	a, va: PvActieveRijwegLijst;
begin
	// Deze rijweg uit de lijst van actieve rijwegen weghalen.
	va := nil;
	a := Core^.vActieveRijwegen;
	while assigned(a) do begin
		if (a = ActieveRijweg) then begin
			if assigned(va) then
				va^.Volgende := a^.Volgende
			else
				Core^.vActieveRijwegen := a^.Volgende;
			a := a^.Volgende;
		end else begin
			va := a;
			a := a^.Volgende;
		end;
	end;
	// Geheugengebruik opruimen.
	dispose(ActieveRijweg);
end;

procedure SaveSein;
var
	wat: char;
	HerroepMeetpunt: PvMeetpuntLijst;
begin
	stringwrite(f, Sein^.Naam);
	stringwrite(f, Sein^.Van);
	if assigned(Sein^.TriggerMeetpunt) then
		stringwrite(f, Sein^.TriggerMeetpunt^.meetpuntID)
	else
		stringwrite(f, '');
	if assigned(Sein^.VanTNVMeetpunt) then
		stringwrite(f, Sein^.VanTNVMeetpunt^.meetpuntID)
	else
		stringwrite(f, '');
	wat := 'h';
	HerroepMeetpunt := Sein^.HerroepMeetpunten;
	while assigned(HerroepMeetpunt) do begin
		blockwrite(f, wat, sizeof(wat));
		stringwrite(f, HerroepMeetpunt^.Meetpunt^.meetpuntID);
		HerroepMeetpunt := HerroepMeetpunt^.Volgende;
	end;
	wat := 'p';
	blockwrite(f, wat, sizeof(wat));
end;

procedure LoadSein;
var
	wat: char;
	meetpuntnaam: string;
	vanmp, triggermp: string;
begin
	stringread(f, Sein^.Naam);
	stringread(f, Sein^.Van);
	stringread(f, triggermp);
	stringread(f, vanmp);
	Sein^.TriggerMeetpunt := ZoekMeetpunt(Core, triggermp);
	Sein^.VanTNVMeetpunt := ZoekMeetpunt(Core, vanmp);
	repeat
		blockread(f, wat, sizeof(wat));
		case wat of
			'h': begin
				stringread(f, meetpuntnaam);
				SeinVoegHerroepMeetpuntToe(Sein, ZoekMeetpunt(core, Meetpuntnaam));
			end;
			'p': // niks
			else
				halt;	// bork
		end;
	until wat = 'p';
end;

procedure SaveRijweg;
var
	wat: char;
	Meetpunt: PvMeetpuntLijst;
	Stand: PvWisselstand;
	InactiefHokje: PvInactiefHokje;
	KruisingHokje: PvKruisingHokje;
begin
	stringwrite(f, Rijweg^.Naar);
	if assigned(Rijweg^.NaarTNVMeetpunt) then
		stringwrite(f, Rijweg^.NaarTNVMeetpunt^.meetpuntID)
	else
		stringwrite(f, '');
	// Sein
	if assigned(Rijweg^.Sein) then
		stringwrite(f, Rijweg^.Sein^.Naam)
	else
		stringwrite(f, '');
	// Naar-Sein
	if assigned(Rijweg^.NaarSein) then
		stringwrite(f, Rijweg^.NaarSein^.Naam)
	else
		stringwrite(f, '');
	// Naar onbeveiligd spoor?
	boolwrite(f, Rijweg^.NaarOnbeveiligd);
	// Erlaubnis
	if assigned(Rijweg^.Erlaubnis) then
		stringwrite(f, Rijweg^.Erlaubnis^.erlaubnisID)
	else
		stringwrite(f, '');
	bytewrite(f, Rijweg^.Erlaubnisstand);
	// En de hele rest
	wat := 'm';
	Meetpunt := Rijweg^.Meetpunten;
	while assigned(Meetpunt) do begin
		blockwrite(f, wat, sizeof(wat));
		stringwrite(f, Meetpunt^.Meetpunt^.meetpuntID);
		Meetpunt := Meetpunt^.Volgende;
	end;
	wat := 'w';
	Stand := Rijweg^.Wisselstanden;
	while assigned(Stand) do begin
		blockwrite(f, wat, sizeof(wat));
		stringwrite(f, Stand^.Wissel^.WisselID);
		boolwrite(f, Stand^.Rechtdoor);
		Stand := Stand^.volgende;
	end;
	wat := 'k';
	KruisingHokje := Rijweg^.KruisingHokjes;
	while assigned(KruisingHokje) do begin
		blockwrite(f, wat, sizeof(wat));
		intwrite(f, KruisingHokje^.schermID);
		intwrite(f, KruisingHokje^.x);
		intwrite(f, KruisingHokje^.y);
		boolwrite(f, KruisingHokje^.RechtsonderKruisRijweg);
		if assigned(KruisingHokje^.Meetpunt) then
			stringwrite(f, KruisingHokje^.Meetpunt^.meetpuntID)
		else
			stringwrite(f, '');
		KruisingHokje := KruisingHokje^.Volgende;
	end;
	wat := 'p';
	blockwrite(f, wat, sizeof(wat));
end;

procedure LoadRijweg;
var
	wat: char;
	seinnaam, naarseinnaam: string;
	erlaubnisnaam: string;
	wisselnaam: string;
	rechtdoor: boolean;
	schermID: integer;
	x, y:	integer;
	RechtsonderKruisRijweg: boolean;
	meetpuntnaam: string;
	naarmp: string;
begin
	stringread(f, Rijweg^.Naar);

	stringread(f, naarmp);
	Rijweg^.NaarTNVMeetpunt := ZoekMeetpunt(Core, naarmp);

	stringread(f, seinnaam);
	stringread(f, naarseinnaam);
	boolread(f, Rijweg^.NaarOnbeveiligd);
	stringread(f, erlaubnisnaam);
	Rijweg^.Sein := ZoekSein(core, seinnaam);
	Rijweg^.NaarSein := ZoekSein(core, naarseinnaam);
	Rijweg^.Erlaubnis := ZoekErlaubnis(core, erlaubnisnaam);

	byteread(f, Rijweg^.Erlaubnisstand);
	repeat
		blockread(f, wat, sizeof(wat));
		case wat of
			'm': begin
				stringread(f, meetpuntnaam);
				RijwegVoegMeetpuntToe(Rijweg, ZoekMeetpunt(core, Meetpuntnaam));
			end;
			'w': begin
				stringread(f, wisselnaam);
				boolread(f, rechtdoor);
				RijwegVoegWisselToe(Rijweg, ZoekWissel(Core, wisselnaam), rechtdoor);
			end;
			'i': begin
				intread(f, schermID);
				intread(f, x);
				intread(f, y);
				stringread(f, meetpuntnaam);
				RijwegVoegInactiefHokjeToe(Rijweg, schermID, x, y,
					ZoekMeetpunt(core, meetpuntnaam));
			end;
			'k': begin
				intread(f, schermID);
				intread(f, x);
				intread(f, y);
				boolread(f, RechtsonderKruisRijweg);
				stringread(f, meetpuntnaam);
				RijwegVoegKruisingHokjeToe(Rijweg, schermID, x, y,
					ZoekMeetpunt(Core, meetpuntnaam), RechtsonderKruisRijweg);
			end;
			'p': // niks
			else
				halt;	// bork
		end;
	until wat = 'p';
end;

procedure SavePrlRijweg;
var
	RijwegLijst: PvRijwegLijst;
begin
	bytewrite(f, PrlRijweg^.Dwang);
	RijwegLijst := PrlRijweg^.Rijwegen;
	if assigned(RijwegLijst) then begin
		stringwrite(f, RijwegLijst^.Rijweg^.Sein^.Van);
		while assigned(RijwegLijst) do begin
			stringwrite(f, RijwegLijst^.Rijweg^.Naar);
			RijwegLijst := RijwegLijst^.Volgende;
		end;
	end;
	stringwrite(f, '');
end;

procedure LoadPrlRijweg;
var
	Rijweg: 	  PvRijweg;
	van, naar: string;
begin
	byteread(f, PrlRijweg^.Dwang);
	van := '';
	naar := '';
	stringread(f, naar);
	while naar <> '' do begin
		if van <> '' then begin
			Rijweg := ZoekRijweg(Core, van, naar);
			if not assigned(Rijweg) then halt;
			PrlRijwegVoegRijwegToe(PrlRijweg, Rijweg);
			if PrlRijweg^.Van = '' then
				PrlRijweg^.Van := Van;
			PrlRijweg^.Naar := Naar;
		end;
		van := naar;
		stringread(f, naar);
	end;
end;

procedure LoadThings;
var
	s, wm, wg: string;
	t: char;
	basisstandrechtdoor: boolean;
	klaar: boolean;
	Sein: PvSein;
	Rijweg: PvRijweg;
	PrlRijweg: PvPrlRijweg;
	Overweg: PvOverweg;
	MeetpuntL: PvMeetpuntLijst;
begin
	klaar := false;
	while not klaar do begin
		blockread(f, t, sizeof(t));
		if (t <> 'p') and (t <> 'r') and (t <> 'l') and (t <> 's') then
			stringread(f, s);
		case t of
			'm': AddMeetpunt(core, s);
			'e': AddErlaubnis(core, s);
			's': begin
				Sein := NieuwSein(core);
				LoadSein(f, Core, Sein);
			end;
			'w': begin
				stringread(f, wm);
				stringread(f, wg);
				boolread(f, basisstandrechtdoor);
				AddWissel(core, s, wm, wg, basisstandrechtdoor);
			end;
			'o': begin
				Overweg := AddOverweg(core, s);
				repeat
					blockread(f, t, sizeof(t));
					if t <> 'p' then begin
						stringread(f, s);
						new(MeetpuntL);
						MeetpuntL^.Meetpunt := ZoekMeetpunt(Core, s);
						if not assigned(MeetpuntL^.Meetpunt) then halt; // bork
						if t = 'm' then begin
							MeetpuntL^.Volgende := Overweg^.Meetpunten;
							Overweg^.Meetpunten := MeetpuntL;
						end else if t = 'a' then begin
							MeetpuntL^.Volgende := Overweg^.AankMeetpunten;
							Overweg^.AankMeetpunten := MeetpuntL;
						end else
							halt;	// bork
					end;
				until t = 'p';
			end;
			'r': begin
				Rijweg := NieuweRijweg(core);
				LoadRijweg(f, Core, Rijweg);
			end;
			'l': begin
				PrlRijweg := NieuwePrlRijweg(core);
				LoadPrlRijweg(f, Core, PrlRijweg);
			end;
			'p': klaar := true;
		end;
	end;
end;

procedure SaveThings;
var
	s, wm, wg: string;
	basisstandrechtdoor: boolean;
	t: char;
	zm: PvMeetpunt;
	ze: PvErlaubnis;
	zs: PvSein;
	zwg: PvWisselGroep;
	zw: PvWissel;
	zo: PvOverweg;
	zml: PvMeetpuntLijst;
	zr: PvRijweg;
	zprlr: PvPrlRijweg;
begin
	t := 'm';
	zm := core.vAlleMeetpunten;
	while assigned(zm) do begin
		s := zm^.meetpuntID;
		blockwrite(f, t, sizeof(t));
		stringwrite(f, s);
		zm := zm^.volgende;
	end;
	t := 'e';
	ze := core.vAlleErlaubnisse;
	while assigned(ze) do begin
		s := ze^.erlaubnisID;
		blockwrite(f, t, sizeof(t));
		stringwrite(f, s);
		ze := ze^.volgende;
	end;
	t := 's';
	zs := core.vAlleSeinen;
	while assigned(zs) do begin
		blockwrite(f, t, sizeof(t));
		SaveSein(f, zs);
		zs := zs^.volgende;
	end;
	t := 'w';
	zwg := core.vAlleWisselGroepen;
	while assigned(zwg) do begin
		zw := zwg.EersteWissel;
		while assigned(zw) do begin
			s := zw^.WisselID;
			if not assigned(zw^.Meetpunt) then halt; // bork
			wm := zw^.Meetpunt^.meetpuntID;
			if not assigned(zw^.Groep) then halt; // bork
			wg := zw^.Groep^.GroepID;
			basisstandrechtdoor := zw^.BasisstandRecht;
			blockwrite(f, t, sizeof(t));
			stringwrite(f, s);
			stringwrite(f, wm);
			stringwrite(f, wg);
			boolwrite(f, basisstandrechtdoor);
			zw := zw^.volgende;
		end;
		zwg := zwg^.volgende;
	end;
	zo := core.vAlleOverwegen;
	while assigned(zo) do begin
		t := 'o';
		blockwrite(f, t, sizeof(t));
		stringwrite(f, zo^.Naam);
		t := 'm';
		zml := zo^.Meetpunten;
		while assigned(zml) do begin
			blockwrite(f, t, sizeof(t));
			stringwrite(f, zml^.Meetpunt^.meetpuntID);
			zml := zml^.Volgende;
		end;
		t := 'a';
		zml := zo^.AankMeetpunten;
		while assigned(zml) do begin
			blockwrite(f, t, sizeof(t));
			stringwrite(f, zml^.Meetpunt^.meetpuntID);
			zml := zml^.Volgende;
		end;
		t := 'p';
		blockwrite(f, t, sizeof(t));
		zo := zo^.Volgende;
	end;
	t := 'r';
	zr := core.vAlleRijwegen;
	while assigned(zr) do begin
		blockwrite(f, t, sizeof(t));
		SaveRijweg(f, zr);
		zr := zr^.Volgende;
	end;
	t := 'l';
	zprlr := core.vAllePrlRijwegen;
	while assigned(zprlr) do begin
		blockwrite(f, t, sizeof(t));
		SavePrlRijweg(f, zprlr);
		zprlr := zprlr^.Volgende;
	end;
	t := 'p';
	blockwrite(f, t, sizeof(t));
end;

procedure SaveWisselStatus;
var
	WisselCount: integer;
	Wissel: PvWissel;
begin
	WisselCount := 0;
	Wissel := EersteWissel(core);
	while assigned(Wissel) do begin
		inc(WisselCount);
		Wissel := VolgendeWissel(Wissel);
	end;
	intwrite(f, WisselCount);
	Wissel := EersteWissel(core);
	while assigned(Wissel) do begin
		stringwrite(f, Wissel^.WisselID);
		bytewrite(f, StandNr(Wissel^.WensStand));
		Wissel := VolgendeWissel(Wissel);
	end;
end;

procedure LoadWisselStatus;
var
	WisselCount: integer;
	Wissel: PvWissel;
	i: integer;
	WisselID: string;
	wensstandnr: byte;
begin
	intread(f, WisselCount);
	for i := 1 to WisselCount do begin
		stringread(f, WisselID);
		Wissel := ZoekWissel(Core, WisselID);
		byteread(f, wensstandnr);
		Wissel^.WensStand := NrStand(wensstandnr);
	end;
end;

procedure BerekenAankondigingen;
var
	Sein						: PvSein;
	Rijweg					: PvRijweg;
	Aank_Error				: boolean;
	Aank_Erlaubnis			: PvErlaubnis;
	Aank_Erlaubnisstand	: byte;
	Aank_Meetpunt			: PvMeetpunt;
begin
	Sein := Core^.vAlleSeinen;
	while assigned(Sein) do begin
		if length(Sein^.Van)>=2 then
			if (Sein^.Van[1] = 'r') and (Sein^.Van[2] in ['A'..'Z','a'..'z']) and
				// We hebben een mogelijk punt van aankondiging. Eerst even kijken
				// om welk punt het nu precies gaat
				assigned(Sein^.VanTNVMeetpunt) then begin
				if assigned(Sein^.TriggerMeetpunt) then
					Aank_Meetpunt := Sein^.TriggerMeetpunt
				else
					Aank_Meetpunt := Sein^.VanTNVMeetpunt;
				// En de gegevens van dit punt ophalen.
				Aank_Erlaubnis := Aank_Meetpunt^.Aank_Erlaubnis;
				Aank_Erlaubnisstand := Aank_Meetpunt^.Aank_Erlaubnisstand;
				// Nu gaan we alle rijwegen bijlangs die omgekeerd aan dit sein zijn
				// en van die rijwegen bekijken we de rijrichting.
				Aank_Error := false;
				Rijweg := Core^.vAlleRijwegen;
				while assigned(Rijweg) do begin
					if (Rijweg^.NaarTNVMeetpunt = Sein^.VanTNVMeetpunt) and assigned(Rijweg^.Erlaubnis) then begin
						if not assigned(Aank_Erlaubnis) then begin
							Aank_Erlaubnis := Rijweg^.Erlaubnis;
							Aank_Erlaubnisstand := OmgekeerdeErlaubnisstand(Rijweg^.Erlaubnisstand);
						end else begin
							if Aank_Erlaubnis = Rijweg^.Erlaubnis then begin
								if Aank_Erlaubnisstand <> OmgekeerdeErlaubnisstand(Rijweg^.Erlaubnisstand) then begin
									// Twee kanten tegelijk. Dat is OK.
									Aank_Erlaubnis := nil;
									Aank_Erlaubnisstand := 0;
									break;
								end;
							end else begin
								// Fout. We breken af.
								Aank_Erlaubnis := nil;
								Aank_Erlaubnisstand := 0;
								Aank_Error := true;
								break;
							end;
						end;
					end;
					Rijweg := Rijweg^.Volgende;
				end;

				if not Aank_Error then begin
					Aank_Meetpunt^.Aankondiging := true;
					Aank_Meetpunt^.Aank_Spoor := Sein^.Van;
					Aank_Meetpunt^.Aank_Erlaubnis := Aank_Erlaubnis;
					Aank_Meetpunt^.Aank_Erlaubnisstand := Aank_Erlaubnisstand;
				end;
			end;
		Sein := Sein^.Volgende;
	end;
end;

procedure BerekenOnbekendAanwezig;
var
	Wissel: PvWissel;
begin
	Groep^.OnbekendAanwezig := false;
	Wissel := Groep^.EersteWissel;
	while assigned(Wissel) do begin
		if Wissel^.Stand = wsOnbekend then
			Groep^.OnbekendAanwezig := true;
		Wissel := Wissel^.Volgende;
	end;
end;

end.
