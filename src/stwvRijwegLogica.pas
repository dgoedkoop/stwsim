unit stwvRijwegLogica;

interface

{$UNDEF LogOverweg}

uses Windows, Forms, clientSendMsg, stwvGleisplan, stwvRijwegen,
	stwvRijveiligheid, stwvCore, stwvLog, stwvHokjes, stwvMeetpunt, stwvSporen,
	stwpTijd, stwvSternummer, stwvSeinen, stwvMisc;

type
	PTablist = ^TTablist;
	TTablist = record
		Gleisplan:	TvGleisplan;
		Scrollbox:	TScrollBox;
		Titel:		string;
		ID:			integer;
		Volgende: 	PTablist;
		Details:		boolean;
	end;

	TWatMetActief = (wmaError, wmaOK);

	TRijwegLogica = class
	private
		AankSound:	THandle;
		procedure HerroepRijwegNu(ActieveRijweg: PvActieveRijwegLijst);
		function MoetApproachLock(ActieveRijweg: PvActieveRijwegLijst): boolean;
		procedure StelRijwegInNu(Rijweg: PvRijweg; ROZ, Auto: boolean);
		function RijwegVrij(Rijweg: PvRijweg): boolean;
		function RijwegAlActief(Rijweg: PvRijweg): boolean;
		procedure DoeKruisHokjes(Meetpunt: PvMeetpunt; Rijweg: PvRijweg);
		function ControleerDubbelSubroute(Meetpunt: PvMeetpunt; Wisselstanden: PvWisselStand;
			KruisingHokjes: PvKruisingHokje; strikt: boolean): boolean;
		function ControleerTerecht(Meetpunt: PvMeetpunt): boolean;
		procedure SetMeetpuntKnipperen(Meetpunt: PvMeetpunt; waarde: boolean);
		procedure SetAankondigingKnipperen(Rijweg: PvRijweg; waarde: boolean);
		procedure DeactiveerVoorgaandeAankondiging(Rijweg: PvRijweg);
		procedure HeractiveerVoorgaandeAankondiging(Rijweg: PvRijweg);
		procedure ControleerAankondigingKnipperen(Rijweg: PvRijweg); overload;
		procedure ControleerAankondigingKnipperen(Meetpunt: PvMeetpunt); overload;
	public
		// Hulpmiddelen
		Tabs:		PTabList;
		Core:		PvCore;
		Log:		TLog;
		SendMsg:	TvSendMsg;
		// Teruggave
		Prl_IngesteldTot: string;

		constructor Create;
		// Overwegen
		function OverwegMoetDicht(Overweg: PvOverweg): boolean;
		function OverwegMoetDichtVoorRijweg(Overweg: PvOverweg; ActieveRijweg: PvActieveRijwegLijst): boolean;
		procedure DoeOverwegen;
		// Instellen van rijwegen
		function DoeRijweg(van, naar: string; ROZ, Auto: boolean): boolean;
		function StelRijwegIn(Rijweg: PvRijweg; ROZ, Auto: boolean; WatMetActief: TWatMetActief): boolean;
		function StelPrlRijwegIn(PrlRijweg: PvPrlRijweg; ROZ, gefaseerd: Boolean; Dwang: byte): boolean;
		// Herroepen van rijwegen
		procedure DeclaimRijweg(ActieveRijweg: PvActieveRijwegLijst);
		function HerroepRijweg(seinnaam: string): boolean;
		// Periodieke check
		procedure DoeActieveRijwegen;
		// Save-load
		procedure SaveActieveRijwegen(var f: file);
		procedure LoadActieveRijwegen(var f: file);
		// Gebeurtenissen
		procedure Aankondigen(Meetpunt: PvMeetpunt);
		procedure MarkeerBezet(Meetpunt: PvMeetpunt);
		procedure MarkeerVrij(Meetpunt: PvMeetpunt);
		procedure WisselOm(Wissel: PvWissel);
		// Voor de editor
		function CreateSubrouteFrom(Meetpunt: PvMeetpunt):PvSubroute;
		function ZoekSubroute(Meetpunt: PvMeetpunt; strikt: boolean):PvSubroute;
		procedure DoeHokjes(Meetpunt: PvMeetpunt; strikt: boolean);
	end;

implementation

procedure TRijwegLogica.SetMeetpuntKnipperen;
var
	Tab: PTabList;
begin
	if Meetpunt^.Knipperen = waarde then exit;
	Meetpunt^.Knipperen := waarde;
	// We moeten het meetpunt opnieuw painten, anders blijft een voorheen
	// knipperend meetpunt misschien zwart achter.
	Tab := Tabs;
	while assigned(Tab) do begin
		Tab^.Gleisplan.PaintMeetpunt(Meetpunt);
		Tab := Tab^.Volgende;
	end;
end;

procedure TRijwegLogica.SetAankondigingKnipperen;
var
	MeetpuntL: PvMeetpuntLijst;
begin
	if not assigned(Rijweg^.NaarSein) then exit;
	MeetpuntL := Rijweg^.Meetpunten;
	if not assigned(MeetpuntL) then exit;
	while assigned(MeetpuntL^.Volgende) do
		MeetpuntL := MeetpuntL^.Volgende;
	if not MeetpuntL^.Meetpunt^.Bezet then
		SetMeetpuntKnipperen(MeetpuntL^.Meetpunt, waarde);
end;

procedure TRijwegLogica.HeractiveerVoorgaandeAankondiging;
var
	ActieveRijweg: PvActieveRijwegLijst;
begin
	if not Rijweg^.Sein^.RijwegenNaarSeinBestaan then exit;

	ActieveRijweg := Core.vActieveRijwegen;
	while assigned(ActieveRijweg) do begin
		if ActieveRijweg^.Rijweg^.NaarSein = Rijweg^.Sein then begin
			ControleerAankondigingKnipperen(ActieveRijweg^.Rijweg);
			break;
		end;
		ActieveRijweg := ActieveRijweg^.Volgende;
	end;
end;

procedure TRijwegLogica.DeactiveerVoorgaandeAankondiging;
var
	ActieveRijweg: PvActieveRijwegLijst;
begin
	if not Rijweg^.Sein^.RijwegenNaarSeinBestaan then exit;

	ActieveRijweg := Core.vActieveRijwegen;
	while assigned(ActieveRijweg) do begin
		if ActieveRijweg^.Rijweg^.NaarSein = Rijweg^.Sein then begin
			SetAankondigingKnipperen(ActieveRijweg^.Rijweg, false);
			break;
		end;
		ActieveRijweg := ActieveRijweg^.Volgende;
	end;
end;

// Deze functie is om te laten knipperen als een rijweg wordt geactiveerd.
procedure TRijwegLogica.ControleerAankondigingKnipperen(Rijweg: PvRijweg);
var
	// Plan A
	ActieveRijweg: PvActieveRijwegLijst;
	// Plan B
	Gevonden:	boolean;
	MeetpuntL:	PvMeetpuntLijst;
begin
	// De laatste sectie van deze rijweg moet gaan knipperen indien voor deze
	// rijweg een andere rijweg of vrije baan ligt die bezet is.
	if Rijweg^.Sein^.RijwegenNaarSeinBestaan then begin
		ActieveRijweg := Core.vActieveRijwegen;
		while assigned(ActieveRijweg) do begin
			if ActieveRijweg^.Rijweg^.NaarSein = Rijweg^.Sein then begin
				if ActieveRijweg^.Pending = 3 then
					SetAankondigingKnipperen(Rijweg, true);
				break;
			end;
			ActieveRijweg := ActieveRijweg^.Volgende;
		end;
	end else begin
		MeetpuntL := Rijweg^.Sein^.HerroepMeetpunten;
		Gevonden := false;
		while assigned(MeetpuntL) do begin
			if MeetpuntL^.Meetpunt^.bezet then
				Gevonden := true;
			MeetpuntL := MeetpuntL^.Volgende;
		end;
		if Gevonden then
			SetAankondigingKnipperen(Rijweg, true);
	end;
end;

// Deze functie is om te laten knipperen als een meetpunt bezet wordt gemeld.
procedure TRijwegLogica.ControleerAankondigingKnipperen(Meetpunt: PvMeetpunt);
var
	// Plan A
	ActieveRijweg: PvActieveRijwegLijst;
	// Plan B
	Sein			: PvSein;
	MeetpuntL	: PvMeetpuntLijst;
	Gevonden		: boolean;
begin
	if assigned(Meetpunt^.RijwegOnderdeel) then begin
		// Plan A: dit meetpunt hoort bij een actieve rijweg.
		ActieveRijweg := Meetpunt^.RijwegOnderdeel;
		// Als we geen naar-sein hebben zijn we klaar.
		if not assigned(ActieveRijweg^.Rijweg^.NaarSein) then
			exit;
		if not assigned(ActieveRijweg^.Rijweg^.NaarSein^.RijwegOnderdeel) then
			// Bij het volgende sein is geen rijweg ingesteld dus moeten we bij de
			// huidige rijweg de aankondigingssectie laten knipperen!
			SetAankondigingKnipperen(ActieveRijweg^.Rijweg, true)
		else begin
			// Bij het volgende sein is een rijweg ingesteld. Als die doodloopt
			// moeten we daar de aankondigingssectie laten knipperen.
			ActieveRijweg := ActieveRijweg^.Rijweg^.NaarSein^.RijwegOnderdeel;
			if not assigned(ActieveRijweg^.Rijweg^.NaarSein) then
				exit;
			if not assigned(ActieveRijweg^.Rijweg^.NaarSein^.RijwegOnderdeel) then
				// Bij het volgende sein is geen rijweg ingesteld dus moeten we bij
				// deze rijweg de aankondigingssectie laten knipperen!
				SetAankondigingKnipperen(ActieveRijweg^.Rijweg, true)
		end;
	end else begin
		// Plan B: dit meetpunt hoort niet bij een actieve rijweg. Vrije baan?
		// We gaan nu kijken of we een sein vinden, binnen wiens approach locking
		// gebied we zitten. En het mag niet mogelijk zijn om een rijweg naar dat
		// sein in te stellen.
		Sein := Core.vAlleSeinen;
		while assigned(Sein) do begin
			if not Sein^.RijwegenNaarSeinBestaan then begin
				MeetpuntL := Sein^.HerroepMeetpunten;
				Gevonden := false;
				while assigned(MeetpuntL) do begin
					if MeetpuntL^.Meetpunt = Meetpunt then
						Gevonden := true;
					MeetpuntL := MeetpuntL^.Volgende;
				end;
				if Gevonden and assigned(Sein^.RijwegOnderdeel) then begin
					// Er is bij dit sein een rijweg ingesteld.
					ActieveRijweg := Sein^.RijwegOnderdeel;
					if not assigned(ActieveRijweg^.Rijweg^.NaarSein) then
						exit;
					if not assigned(ActieveRijweg^.Rijweg^.NaarSein^.RijwegOnderdeel) then
						// Bij het volgende sein is geen rijweg ingesteld dus moeten we bij
						// deze rijweg de aankondigingssectie laten knipperen!
						SetAankondigingKnipperen(ActieveRijweg^.Rijweg, true);
					exit;
				end;
			end;
			Sein := Sein^.Volgende;
		end;
	end;
end;

function TRijwegLogica.ControleerTerecht;
var
	ActieveRijweg: PvActieveRijwegLijst;
	vMeetpunt, zoekMeetpunt: PvMeetpuntLijst;
begin
	result := true;

	ActieveRijweg := Meetpunt^.RijwegOnderdeel;
	if not assigned(ActieveRijweg) then
		exit;
	vMeetpunt := nil;
	zoekMeetpunt := ActieveRijweg^.Rijweg^.Meetpunten;
	while assigned(zoekMeetpunt) do begin
		if zoekMeetpunt^.Meetpunt = Meetpunt then
			break;
		vMeetpunt := zoekMeetpunt;
		zoekMeetpunt := zoekMeetpunt^.Volgende;
	end;
	if not assigned(zoekMeetpunt) then begin
		result := false;
		exit;
	end;
	if not assigned(vMeetpunt) then
		exit;
	// We gaan ervan uit dat Meetpunt^.bezet veranderd is. De waarde daarvan
	// zou dezelfde als vMeetpunt^.Meetpunt^.bezet moeten zijn.
	if vMeetpunt^.Meetpunt.RijwegOnderdeel = ActieveRijweg then
		result := result and (Meetpunt^.bezet = vMeetpunt^.Meetpunt.bezet);
	// En het volgende meetpunt, als dat bij de rijweg hoort, moet net het
	// omgekeerde zijn.
	if assigned(zoekMeetpunt^.Volgende) then
		if zoekMeetpunt^.Volgende^.Meetpunt^.RijwegOnderdeel = ActieveRijweg then
			result := result and (Meetpunt^.bezet <> zoekMeetpunt^.Volgende^.Meetpunt^.bezet);
end;

function TRijwegLogica.ControleerDubbelSubroute;
var
	Subroute:	PvSubroute;
	OK:					boolean;
begin
	result := false;

	// Als er geen inactieve hokjes (kunnen) zijn hoeven we ook niks toe te
	// voegen.
	if not assigned(Wisselstanden) and not assigned(Kruisinghokjes) then begin
		result := true;
		exit;
	end;

	Subroute := Core.vAlleSubroutes;
	while assigned(Subroute) do begin
		// We gaan ervan uit dat dit een duplicaat is.
		OK := true;

		if Subroute^.Meetpunt <> Meetpunt then
			OK := false;

		if OK then
			OK := OK and CmpWisselstanden(Subroute^.Wisselstanden, Wisselstanden, strikt);

		if OK then
			OK := OK and CmpKruisingHokjes(Subroute^.KruisingHokjes, KruisingHokjes, strikt);

		// OK?
		if OK then begin
			result := true;
			exit;
		end;

		Subroute := Subroute^.Volgende;
	end;
end;

function TRijwegLogica.ZoekSubroute;
var
	Tab:					PTablist;
	Hokje:				TvHokje;
	KruisingHokje:		PvKruisingHokje;
	Subroute:			PvSubroute;
	OK:					boolean;
	WisselStand:		PvWisselstand;
	// Voor strikt
	Gevonden:			boolean;
	Wissel:				PvWissel;
	x,y:					integer;
	HokjeMeetpunt:		PvMeetpunt;
	rechtsonderkruis:	integer;
begin
	result := nil;
	Subroute := Core.vAlleSubroutes;
	while assigned(Subroute) do begin
		OK := true;
		// Meetpunt controleren
		if Subroute^.Meetpunt <> Meetpunt then
			OK := false;
		// Wisselstanden controleren
		if OK then begin
			WisselStand := Subroute^.Wisselstanden;
			while assigned(Wisselstand) do begin
				if Wisselstand^.Rechtdoor then
					OK := OK and (Wisselstand^.Wissel^.Stand = wsRechtdoor)
				else
					OK := OK and (Wisselstand^.Wissel^.Stand = wsAftakkend);
				Wisselstand := Wisselstand^.Volgende;
			end;
		end;
		// Kruisingen controleren
		if OK then begin
			KruisingHokje := Subroute^.KruisingHokjes;
			while assigned(KruisingHokje) do begin
				Tab := Tabs;
				while assigned(Tab) do begin
					if KruisingHokje.schermID = Tab^.ID then begin
						Hokje := Tab^.Gleisplan.GetHokje(KruisingHokje.x, KruisingHokje.y);
						case Hokje.Soort of
						1: if KruisingHokje.RechtsonderKruisRijweg then
								OK := OK and (PvHokjeSpoor(Hokje.grdata).RechtsonderKruisRijweg = 1)
							else
								OK := OK and (PvHokjeSpoor(Hokje.grdata).RechtsonderKruisRijweg = 2);
						end;
					end;
					Tab := Tab^.Volgende;
				end;
				KruisingHokje := KruisingHokje^.volgende;
			end;
		end;
		// Bij strikt moeten we kijken of niet meer is ingesteld dan deze
		// InactiefHokjeDescr zegt.
		if OK and strikt then begin
			Wissel := EersteWissel(Core);
			while assigned(Wissel) do begin
				if Wissel^.Meetpunt = Meetpunt then begin
					// Kijk of dit wissel in de InactiefHokjeDescr zit.
					WisselStand := Subroute^.Wisselstanden;
					gevonden := false;
					while assigned(Wisselstand) do begin
						if (Wisselstand^.Wissel = Wissel) then begin
							gevonden := true;
							break;
						end;
						Wisselstand := Wisselstand^.Volgende;
					end;
					if (not gevonden) and (Wissel^.Stand <> wsOnbekend) then begin
						OK := false;
						break;
					end;
				end;
				Wissel := VolgendeWissel(Wissel);
			end;
		end;
		if OK and strikt then begin
			Tab := Tabs;
			while assigned(Tab) do begin
				for x := 0 to Tab^.Gleisplan.MaxX-1 do
					for y := 0 to Tab^.Gleisplan.MaxY-1 do begin
						HokjeMeetpunt := nil;
						Rechtsonderkruis := 0;
						Hokje := Tab^.Gleisplan.GetHokje(x, y);
						case Hokje.Soort of
						1: begin
							if (PvHokjeSpoor(Hokje.grdata).GrX >= 7) and
								(PvHokjeSpoor(Hokje.grdata).GrX <= 14) and
								(PvHokjeSpoor(Hokje.grdata).GrY >= 0) and
								(PvHokjeSpoor(Hokje.grdata).GrY <= 1) then begin
								// Dit is een kruising-hokje
								HokjeMeetpunt := PvHokjeSpoor(Hokje.grdata).Meetpunt;
								Rechtsonderkruis := PvHokjeSpoor(Hokje.grdata).RechtsonderKruisRijweg;
							end;
						end;
						end;
						if Meetpunt = HokjeMeetpunt then begin
							gevonden := false;
							KruisingHokje := Subroute^.KruisingHokjes;
							while assigned(KruisingHokje) do begin
								if (KruisingHokje^.schermID = Tab^.ID) and
									(KruisingHokje^.x = x) and
									(KruisingHokje^.y = y) then begin
									gevonden := true;
									break;
								end;
								KruisingHokje := KruisingHokje^.Volgende;
							end;
							if (not gevonden) and (rechtsonderkruis > 0) then begin
								OK := false;
								// break; heeft geen zin hier omdat we in 3 lussen zitten.
							end;
						end;
					end;
				Tab := Tab^.Volgende;
			end;
		end;
		// OK?
		if OK then begin
			result := Subroute;
			exit;
		end;

		Subroute := Subroute^.Volgende;
	end;
end;

function TRijwegLogica.CreateSubrouteFrom(Meetpunt: PvMeetpunt):PvSubroute;
var
	Wissel:					PvWissel;
	WisselStanden:			PvWisselStand;
	NieuweWisselstand:	PvWisselStand;
	KruisingHokjes:		PvKruisingHokje;
	NieuwKruisingHokje:	PvKruisingHokje;
	Tab:						PTabList;
	Hokje:					TvHokje;
	x,y:					integer;
	HokjeMeetpunt:		PvMeetpunt;
	rechtsonderkruis:	integer;
begin
	result := nil;
	// Zoek alle wissels die bij dit meetpunt horen
	WisselStanden := nil;
	Wissel := EersteWissel(Core);
	while assigned(Wissel) do begin
		if (Wissel^.Meetpunt = Meetpunt) and
			(Wissel^.Stand in [wsRechtdoor, wsAftakkend]) then begin
			new(NieuweWisselStand);
			NieuweWisselstand^.Wissel := Wissel;
			NieuweWisselstand^.Rechtdoor := Wissel^.Stand = wsRechtdoor;
			NieuweWisselstand^.Volgende := WisselStanden;
			WisselStanden := NieuweWisselstand;
		end;
		Wissel := VolgendeWissel(Wissel);
	end;
	// Zoek alle kruisinghokjes die bij dit meetpunt horen
	KruisingHokjes := nil;
	Tab := Tabs;
	while assigned(Tab) do begin
		for x := 0 to Tab^.Gleisplan.MaxX-1 do
			for y := 0 to Tab^.Gleisplan.MaxY-1 do begin
				HokjeMeetpunt := nil;
				Rechtsonderkruis := 0;
				Hokje := Tab^.Gleisplan.GetHokje(x, y);
				case Hokje.Soort of
				1: begin
					if (PvHokjeSpoor(Hokje.grdata).GrX >= 7) and
						(PvHokjeSpoor(Hokje.grdata).GrX <= 14) and
						(PvHokjeSpoor(Hokje.grdata).GrY >= 0) and
						(PvHokjeSpoor(Hokje.grdata).GrY <= 1) then begin
						// Dit is een kruising-hokje
						HokjeMeetpunt := PvHokjeSpoor(Hokje.grdata).Meetpunt;
						Rechtsonderkruis := PvHokjeSpoor(Hokje.grdata).RechtsonderKruisRijweg;
					end;
				end;
				end;
				if assigned(HokjeMeetpunt) then begin
					new(NieuwKruisingHokje);
					NieuwKruisingHokje^.schermID := Tab^.ID;
					NieuwKruisingHokje^.x := x;
					NieuwKruisingHokje^.y := y;
					NieuwKruisingHokje^.Meetpunt := HokjeMeetpunt;
					NieuwKruisingHokje^.RechtsonderKruisRijweg := rechtsonderkruis = 1;
					NieuwKruisingHokje^.volgende := KruisingHokjes;
					KruisingHokjes := NieuwKruisingHokje;
				end;
			end;
		Tab := Tab^.Volgende;
	end;

	// Zo. Nu hebben we alle gegevens die de inactieve hokjes eenduidig
	// bepalen.

	// We gaan een nieuwe subroute maken, dus inactieve hokjes zijn er nog niet.

	// Nu hebben we alles => toevoegen
	if not ControleerDubbelSubroute(Meetpunt, WisselStanden, KruisingHokjes, true) then
		result := AddSubroute(Core, Meetpunt, WisselStanden, KruisingHokjes, nil);
end;

constructor TRijwegLogica.Create;
begin
	AankSound := LoadSound('snd_aank');
end;

procedure TRijwegLogica.SaveActieveRijwegen;
var
	Tab: PTabList;
	ActieveRijweg: PvActieveRijwegLijst;
	ActieveRijwegCount: integer;
	i: integer;
	WisselCount, MeetpuntCount, SeinCount: integer;
	Wissel:  	PvWissel;
	Meetpunt: 	PvMeetpunt;
	Sein: 	 	PvSein;
begin
	// Eerst slaan we de hokjes-gegevens op.
	Tab := Tabs;
	while assigned(Tab) do begin
		Tab^.Gleisplan.SaveInactieveEnKruisingHokjes(f);
		Tab := Tab^.Volgende;
	end;
	// Daarna de actieve rijwegen zelf.
	ActieveRijwegCount := 0;
	ActieveRijweg := Core^.vActieveRijwegen;
	while assigned(ActieveRijweg) do begin
		inc(ActieveRijwegCount);
		ActieveRijweg := ActieveRijweg^.Volgende;
	end;
	intwrite(f, ActieveRijwegCount);
	ActieveRijweg := Core^.vActieveRijwegen;
	for i := 1 to ActieveRijwegCount do begin
		// Eerst schrijven we de gegevens van de rijweg.
		stringwrite(f, ActieveRijweg^.Rijweg^.Sein^.Van);
		stringwrite(f, ActieveRijweg^.Rijweg^.Naar);
		boolwrite  (f, ActieveRijweg^.ROZ);
		boolwrite  (f, ActieveRijweg^.Autorijweg);
		bytewrite  (f, ActieveRijweg^.Pending);
		boolwrite  (f, ActieveRijweg^.Herroep.herroep);
		boolwrite  (f, ActieveRijweg^.Herroep.seinwacht);
		intwrite   (f, ActieveRijweg^.Herroep.t);
		// Dan slaan we op welke wissels en meetpunten al/nog door deze rijweg
		// geclaimd zijn.
		WisselCount := 0;
		Wissel := EersteWissel(Core);
		while assigned(Wissel) do begin
			if Wissel^.RijwegOnderdeel = ActieveRijweg then
				inc(WisselCount);
			Wissel := VolgendeWissel(Wissel);
		end;
		intwrite(f, WisselCount);
		Wissel := EersteWissel(Core);
		while assigned(Wissel) do begin
			if Wissel^.RijwegOnderdeel = ActieveRijweg then
				stringwrite(f, Wissel^.WisselID);
			Wissel := VolgendeWissel(Wissel);
		end;
		MeetpuntCount := 0;
		Meetpunt := Core^.vAlleMeetpunten;
		while assigned(Meetpunt) do begin
			if Meetpunt^.RijwegOnderdeel = ActieveRijweg then
				inc(MeetpuntCount);
			Meetpunt := Meetpunt^.Volgende;
		end;
		intwrite(f, MeetpuntCount);
		Meetpunt := Core^.vAlleMeetpunten;
		while assigned(Meetpunt) do begin
			if Meetpunt^.RijwegOnderdeel = ActieveRijweg then begin
				stringwrite(f, Meetpunt^.meetpuntID);
{				boolwrite  (f, Meetpunt^.OnterechtBezet);
				boolwrite  (f, Meetpunt^.Knipperen);}
			end;
			Meetpunt := Meetpunt^.Volgende;
		end;
		SeinCount := 0;
		Sein := Core^.vAlleSeinen;
		while assigned(Sein) do begin
			if Sein^.RijwegOnderdeel = ActieveRijweg then
				inc(SeinCount);
			Sein := Sein^.Volgende;
		end;
		intwrite(f, SeinCount);
		Sein := Core^.vAlleSeinen;
		while assigned(Sein) do begin
			if Sein^.RijwegOnderdeel = ActieveRijweg then
				stringwrite(f, Sein^.Naam);
			Sein := Sein^.Volgende;
		end;
		ActieveRijweg := ActieveRijweg^.Volgende;
	end;
end;

procedure TRijwegLogica.LoadActieveRijwegen;
var
	Tab: PTabList;
	ActieveRijweg: PvActieveRijwegLijst;
	ActieveRijwegCount: integer;
	i,j: integer;
	WisselCount, MeetpuntCount, SeinCount: integer;
	// Voor het toevoegen van een actieve rijweg
	Van, Naar: string;
	ROZ, Auto: boolean;
	// Voor het markeren als geclaimd
	WisselID, MeetpuntID, SeinID: string;
	Meetpunt: PvMeetpunt;
begin
	// Eerst laden we de hokjes-gegevens.
	Tab := Tabs;
	while assigned(Tab) do begin
		Tab^.Gleisplan.LoadInactieveEnKruisingHokjes(f);
		Tab := Tab^.Volgende;
	end;
	// Daarna de actieve rijwegen zelf.
	intread(f, ActieveRijwegCount);
	for i := 1 to ActieveRijwegCount do begin
		// Eerst lezen we de gegevens van de rijwegn
		stringread(f, van);
		stringread(f, naar);
		boolread  (f, ROZ);
		boolread  (f, Auto);
		ActieveRijweg := AddActieveRijweg(Core, ZoekRijweg(Core, Van, Naar), ROZ, Auto);
		byteread  (f, ActieveRijweg^.Pending);
		boolread  (f, ActieveRijweg^.Herroep.herroep);
		boolread  (f, ActieveRijweg^.Herroep.seinwacht);
		intread   (f, ActieveRijweg^.Herroep.t);
		ActieveRijweg^.Rijweg^.Sein^.herroepen := ActieveRijweg^.Herroep.herroep;
		// Dan lezen we welke wissels en meetpunten al/nog door deze rijweg
		// geclaimd zijn.
		intread(f, WisselCount);
		for j := 1 to WisselCount do begin
			stringread(f, WisselID);
			ZoekWissel(Core, WisselID)^.RijwegOnderdeel := ActieveRijweg;
		end;
		intread(f, MeetpuntCount);
		for j := 1 to MeetpuntCount do begin
			stringread(f, MeetpuntID);
			Meetpunt := ZoekMeetpunt(Core, MeetpuntID);
			Meetpunt^.RijwegOnderdeel := ActieveRijweg;
{			boolread  (f, Meetpunt^.OnterechtBezet);
			boolread  (f, Meetpunt^.Knipperen);}
		end;
		intread(f, SeinCount);
		for j := 1 to SeinCount do begin
			stringread(f, SeinID);
			ZoekSein(Core, SeinID)^.RijwegOnderdeel := ActieveRijweg;
		end;
	end;
end;

procedure TRijwegLogica.Aankondigen;
begin
	if not Meetpunt^.Aankondiging then exit;

	if assigned(Meetpunt^.Aank_Erlaubnis) then
		if Meetpunt^.Aank_Erlaubnis^.richting <> Meetpunt^.Aank_Erlaubnisstand then
			exit;

	Log.Log('Aankondiging trein '+Meetpunt^.treinnummer+' op '+
		KlikpuntTekst(Meetpunt^.Aank_Spoor, false)+'.');
	PlaySound(AankSound);
end;

function TRijwegLogica.OverwegMoetDicht;
var
	AankMeetpuntL: PvMeetpuntLijst;
	MeetpuntL: 		PvMeetpuntLijst;
	ActieveRijweg: PvActieveRijwegLijst;
	ZoekActRijweg: PvActieveRijwegLijst;
begin
	result := false;
	// Eerst de simpele strategie: is er een trein op de overweg, dan is dat
	// duidelijk genoeg.
	MeetpuntL := Overweg^.Meetpunten;
	while assigned(MeetpuntL) do begin
		if MeetpuntL^.Meetpunt^.Bezet then begin
			result := true;
			exit;
		end;
		MeetpuntL := MeetpuntL^.Volgende;
	end;
	// Is de overweg zelf vrij? Dan kijken we naar de aankondiging.
	AankMeetpuntL := Overweg^.AankMeetpunten;
	while assigned(AankMeetpuntL) do begin
		if AankMeetpuntL^.Meetpunt^.bezet then
			// Een trein staat binnen de aankondiging, maar we weten niet wat die
			// gaat doen. Voor de zekerheid de overweg maar sluiten.
			if not assigned(AankMeetpuntL^.Meetpunt^.RijwegOnderdeel) then begin
				result := true;
				exit;
			end else begin
				// We hebben een trein gevonden. Nu moeten we gaan kijken of de rijweg
				// van deze trein over de overweg gaat. Is dat zo, dan is dat duidelijk
				// genoeg.
				ActieveRijweg := AankMeetpuntL^.Meetpunt^.RijwegOnderdeel;
				MeetpuntL := Overweg^.Meetpunten;
				while assigned(MeetpuntL) do begin
					if MeetpuntL^.Meetpunt^.RijwegOnderdeel = ActieveRijweg then begin
						result := true;
						exit;
					end;
					MeetpuntL := MeetpuntL^.Volgende;
				end;
				// De rijweg van de trein gaat niet direct over de overweg.
				// Maar nu kan de rijweg nog net voor de overweg ophouden. Daarom
				// moeten we kijken naar een vervolgrijweg.
				ZoekActRijweg := Core^.vActieveRijwegen;
				while assigned(ZoekActRijweg) do begin
					if (ActieveRijweg^.Rijweg^.Naar = ZoekActRijweg^.Rijweg^.Sein^.Van) and
						(ZoekActRijweg^.Pending in [1,2]) then begin
						MeetpuntL := Overweg^.Meetpunten;
						while assigned(MeetpuntL) do begin
							if MeetpuntL^.Meetpunt^.RijwegOnderdeel = ZoekActRijweg then begin
								result := true;
								exit;
							end;
							MeetpuntL := MeetpuntL^.Volgende;
						end;
					end;
					ZoekActRijweg := ZoekActRijweg^.Volgende;
				end;
			end;
		AankMeetpuntL := AankMeetpuntL^.Volgende;
	end;
end;

function TRijwegLogica.OverwegMoetDichtVoorRijweg;
var
	AankMeetpuntL: PvMeetpuntLijst;
	MeetpuntL: 		PvMeetpuntLijst;
	TreinActRijweg:PvActieveRijwegLijst;
	Gevonden:		boolean;
begin
	result := false;
	// Is de rijweg niet in de fase dat de overwegen dicht moeten, dan is dat
	// duidelijk genoeg.
	if ActieveRijweg^.Pending <> 1 then exit;
	// Als de rijweg niet over de overweg gaat, dan is dat duidelijk genoeg.
	Gevonden := false;
	MeetpuntL := Overweg^.Meetpunten;
	while assigned(MeetpuntL) do begin
		if MeetpuntL^.Meetpunt^.RijwegOnderdeel = ActieveRijweg then begin
			Gevonden := true;
			break;
		end;
		MeetpuntL := MeetpuntL^.Volgende;
	end;
	if not gevonden then exit;

	// Nu kijken we naar de aankondiging.
	AankMeetpuntL := Overweg^.AankMeetpunten;
	while assigned(AankMeetpuntL) do begin
		if AankMeetpuntL^.Meetpunt^.bezet and
		assigned(AankMeetpuntL^.Meetpunt^.RijwegOnderdeel) then
			// We hebben een trein gevonden die een rijweg heeft. Nu gaan we kijken
			// of dat de gezochte rijweg is en of deze rijweg wel over de overweg
			// gaat. Is dat allemaal zo, dan is dat duidelijk genoeg.
			if	(ActieveRijweg = AankMeetpuntL^.Meetpunt^.RijwegOnderdeel) then begin
				result := true;
				exit;
			end else begin
				// De rijweg van de trein is niet de gezochte rijweg. Maar nu kan de
				// rijweg van de trein nog net voor de overweg ophouden. Daarom
				// moeten we kijken of de gezochte rijweg misschien de vervolgrijweg
				// van de gevonden trein is.
				TreinActRijweg := AankMeetpuntL^.Meetpunt^.RijwegOnderdeel;
				if (TreinActRijweg^.Rijweg^.Naar = ActieveRijweg^.Rijweg^.Sein^.Van) then begin
					result := true;
					exit;
				end;
			end;
		AankMeetpuntL := AankMeetpuntL^.Volgende;
	end;
end;

procedure TRijwegLogica.DoeOverwegen;
var
	Overweg:			PvOverweg;
	Moetdicht:		boolean;
begin
	Overweg := Core.vAlleOverwegen;
	while assigned(Overweg) do begin
		Moetdicht := OverwegMoetDicht(Overweg);
		if (not Overweg^.Gesloten_Wens) and Moetdicht then begin
			SendMsg.SendSetOverweg(Overweg, true);
			{$IFDEF LogOverweg}
			Log.Log('Overweg wordt gesloten.');
			{$ENDIF}
		end;
		if Overweg^.Gesloten_Wens and (not Moetdicht) then begin
			SendMsg.SendSetOverweg(Overweg, false);
			{$IFDEF LogOverweg}
			Log.Log('Overweg wordt geopend.');
			{$ENDIF}
		end;
		Overweg := Overweg^.Volgende;
	end;
end;

procedure TRijwegLogica.DoeHokjes;
var
	Tab:				PTablist;
	Hokje:			TvHokje;
	InactiefHokje:	PvInactiefHokje;
	Subroute:		PvSubroute;
begin
	Subroute := ZoekSubroute(Meetpunt, strikt);
	if assigned(Subroute) then begin
		// Deze hokjes markeren
		InactiefHokje := Subroute^.EersteHokje;
		while assigned(InactiefHokje) do begin
			Tab := Tabs;
			while assigned(Tab) do begin
				if InactiefHokje.schermID = Tab^.ID then begin
					Hokje := Tab^.Gleisplan.GetHokje(InactiefHokje.x, InactiefHokje.y);
					case Hokje.Soort of
						1: if (PvHokjeSpoor(Hokje.grdata).Meetpunt = Meetpunt) and
							not PvHokjeSpoor(Hokje.grdata).InactiefWegensRijweg then begin
							PvHokjeSpoor(Hokje.grdata).InactiefWegensRijweg := true;
							Tab^.Gleisplan.PaintHokje(InactiefHokje.x, InactiefHokje.y);
						end;
						5: if (PvHokjeWissel(Hokje.grdata).Meetpunt = Meetpunt) and
							not PvHokjeWissel(Hokje.grdata).InactiefWegensRijweg then begin
							PvHokjeWissel(Hokje.grdata).InactiefWegensRijweg := true;
							Tab^.Gleisplan.PaintHokje(InactiefHokje.x, InactiefHokje.y);
						end;
					end;
				end;
				Tab := Tab^.Volgende;
			end;
			InactiefHokje := InactiefHokje.Volgende;
		end;
	end;
end;

procedure TRijwegLogica.DoeKruisHokjes;
var
	Tab:					PTablist;
	Hokje:				TvHokje;
	KruisingHokje:		PvKruisingHokje;
begin
	Tab := Tabs;
	while assigned(Tab) do begin
		// Weergave-finetuning
		KruisingHokje := Rijweg.KruisingHokjes;
		while assigned(KruisingHokje) do begin
			if KruisingHokje.schermID = Tab^.ID then begin
				Hokje := Tab^.Gleisplan.GetHokje(KruisingHokje.x, KruisingHokje.y);
				if PvHokjeSpoor(Hokje.grdata).Meetpunt = Meetpunt then
					case Hokje.Soort of
						1: if KruisingHokje.RechtsonderKruisRijweg then begin
								if PvHokjeSpoor(Hokje.grdata).RechtsonderKruisRijweg <> 1 then begin
									PvHokjeSpoor(Hokje.grdata).RechtsonderKruisRijweg := 1;
									Tab^.Gleisplan.PaintHokje(KruisingHokje.x, KruisingHokje.y);
								end;
							end else begin
								if PvHokjeSpoor(Hokje.grdata).RechtsonderKruisRijweg <> 2 then begin
									PvHokjeSpoor(Hokje.grdata).RechtsonderKruisRijweg := 2;
									Tab^.Gleisplan.PaintHokje(KruisingHokje.x, KruisingHokje.y);
								end;
							end;
					end;
			end;
			KruisingHokje := KruisingHokje.Volgende;
		end;

		Tab := Tab^.Volgende;
	end;
end;

procedure TRijwegLogica.MarkeerBezet;
var
	ActieveRijweg: PvActieveRijwegLijst;
	Tab: PTablist;
	Treinnr: string;
	VanMeetpunt, NaarMeetpunt: PvMeetpunt;
begin
	// Controleer of ergens een aankondigingssectie moet gaan knipperen
	ControleerAankondigingKnipperen(Meetpunt);

	// Bezette secties mogen niet knipperen
	SetMeetpuntKnipperen(Meetpunt, false);

	// Als het meetpunt niet bij een rijweg hoort hoeven we verder niks te
	// doen.
	ActieveRijweg := PvActieveRijwegLijst(Meetpunt^.Rijwegonderdeel);
	if not assigned(ActieveRijweg) then exit;

	// Kijk of de bezetmelding terecht is
	if not ControleerTerecht(Meetpunt) then begin
		Meetpunt^.OnterechtBezet := true;
		Log.Log('Onverwachte bezetmelding in rijweg van '+
			KlikpuntTekst(ActieveRijweg^.Rijweg^.Sein^.Van, false)+' naar '+
			KlikpuntTekst(ActieveRijweg^.Rijweg^.Naar, false)+'.');
	end else
		Meetpunt^.OnterechtBezet := false;

	// Sein op rood zetten en pending-status bijwerken.
	if (ActieveRijweg^.Pending = 2) then begin
		// Zet het sein op rood
		SendMsg.SendSetSein(ActieveRijweg^.Rijweg^.Sein, 'r');
		// En de-registreer het.
		ActieveRijweg^.Rijweg^.Sein^.RijwegOnderdeel := nil;
		// Verplaats het treinnummer
		VanMeetpunt := ActieveRijweg^.Rijweg^.Sein^.VanTNVMeetpunt;
		NaarMeetpunt := ActieveRijweg^.Rijweg^.NaarTNVMeetpunt;
		if assigned(VanMeetpunt) then begin
			TreinNr := VanMeetpunt^.treinnummer;
			if TreinNr <> '' then
				SendMsg.SendSetTreinnr(VanMeetpunt, '');
		end else
			TreinNr := '';
		if assigned(NaarMeetpunt) then begin
			if TreinNr = '' then
				TreinNr := Sternummer;
			SendMsg.SendSetTreinnr(NaarMeetpunt, Treinnr);
		end;
		// Stel de pending-status in
		ActieveRijweg^.Pending := 3;
		// Bij auto-rijweg opnieuw instellen.
		if ActieveRijweg^.Autorijweg then
			// Dit werkt gegarandeerd, want de rijweg is immers al ingesteld.
			// Alle wissels staan al goed en zojuist is enkel een trein
			// het eerste meetpunt binnengereden.
			StelRijwegInNu(ActieveRijweg^.Rijweg, ActieveRijweg^.ROZ, true);
	end;
	// Als het een approach-locking-rijweg is, moeten we die status
	// ongedaan maken.
	if ActieveRijweg^.Herroep.herroep then begin
		ActieveRijweg^.Herroep.herroep := false;
		Log.Log('Herroepen van rijweg gedeactiveerd.');
		// Sein weer normaal tonen
		ActieveRijweg^.Rijweg^.Sein^.herroepen := false;
		Tab := Tabs;
		while assigned(Tab) do begin
			Tab^.Gleisplan.PaintSein(ActieveRijweg^.Rijweg^.Sein);
			Tab := Tab^.Volgende;
		end;
	end;

	// Tenslotte sluiten we overwegen als dat moet.
	DoeOverwegen;
end;

procedure TRijwegLogica.MarkeerVrij;
var
	ActieveRijweg: PvActieveRijwegLijst;
	Wissel: PvWissel;
	MeetpuntL, vMeetpuntL: PvMeetpuntLijst;
	Tab: PTablist;
begin
	// Kijk of de bezet- en vrijmelding terecht was
	if Meetpunt^.OnterechtBezet then
		exit;

	// Terecht-controle hoeft niet, want vanwege fail-safe is een vrijmelding
	// altijd terecht.

	// Registratie als rijwegonderdeel opheffen
	Meetpunt^.RijwegOnderdeel := nil;
	Meetpunt^.Knipperen := false;
	Wissel := EersteWissel(Core);
	while assigned(Wissel) do begin
		if Wissel^.Meetpunt = Meetpunt then
			Wissel^.RijwegOnderdeel := nil;
		Wissel := VolgendeWissel(Wissel);
	end;

	// Kijken of dit meetpunt misschien alsnog geclaimd moet worden voor een
	// voorliggende rijweg naar bezet spoor
	ActieveRijweg := Core.vActieveRijwegen;
	while assigned(ActieveRijweg) do begin
		if ActieveRijweg^.ROZ then begin
			vMeetpuntL := nil;
			MeetpuntL := ActieveRijweg^.Rijweg^.Meetpunten;
			while assigned(MeetpuntL) do begin
				if (MeetpuntL^.Meetpunt = Meetpunt) then begin
					if assigned(vMeetpuntL) and (vMeetpuntL^.Meetpunt^.RijwegOnderdeel = ActieveRijweg) then begin
						// Dit meetpunt moeten we claimen.
						MeetpuntL^.Meetpunt^.RijwegOnderdeel := ActieveRijweg;
						Wissel := EersteWissel(Core);
						while assigned(Wissel) do begin
							if Wissel^.Meetpunt = MeetpuntL^.Meetpunt then
								Wissel^.RijwegOnderdeel := ActieveRijweg;
							Wissel := VolgendeWissel(Wissel);
						end;
					end;
					break;
				end;
				vMeetpuntL := MeetpuntL;
				MeetpuntL := MeetpuntL^.Volgende;
			end;
		end;
		ActieveRijweg := ActieveRijweg^.Volgende;
	end;

	// Tekenen
	Tab := Tabs;
	while assigned(Tab) do begin
		Tab^.Gleisplan.PaintMeetpunt(Meetpunt);
		Tab := Tab^.Volgende;
	end;

	// Misschien kunnen we een pending-rijweg instellen
	DoeActieveRijwegen;

	// Tenslotte openen we overwegen als dat kan.
	DoeOverwegen;
end;

procedure TRijwegLogica.WisselOm;
var
	Tab: PTablist;
begin
	if assigned(Wissel^.Meetpunt) then begin
		// Inactief en kruisings-hokjes resetten
		Tab := Tabs;
		while assigned(Tab) do begin
			Tab^.Gleisplan.MeetpuntResetInactief(Wissel^.Meetpunt);
			Tab := Tab^.Volgende;
		end;
		// En opnieuw instellen
		DoeHokjes(Wissel^.Meetpunt, false);
	end;
end;

function TRijwegLogica.MoetApproachLock;
var
	HerroepMeetpunt: pvMeetpuntLijst;
begin
	result := false;
	HerroepMeetpunt := ActieveRijweg^.Rijweg^.Sein^.HerroepMeetpunten;
	while assigned(HerroepMeetpunt) do begin
		result := result or HerroepMeetpunt^.Meetpunt^.bezet;
		HerroepMeetpunt := HerroepMeetpunt^.volgende;
	end;
end;

procedure TRijwegLogica.HerroepRijwegNu;
var
	Tab:				PTabList;
begin
	// Sein de-registreren
	ActieveRijweg^.Rijweg^.Sein^.RijwegOnderdeel := nil;
	ActieveRijweg^.Rijweg^.Sein^.herroepen := false;
	Tab := Tabs;
	while assigned(Tab) do begin
		Tab^.Gleisplan.PaintSein(ActieveRijweg^.Rijweg^.Sein);
		Tab := Tab^.Volgende;
	end;

	// Eventueel een aankondiging van de voorgaande rijweg weer activeren
	HeractiveerVoorgaandeAankondiging(ActieveRijweg^.Rijweg);

	// Al het andere de-claimen komt als de rijweg wordt opgeruimd (delete).

	// Misschien kan een overweg weer open
	DoeOverwegen;
end;

function TRijwegLogica.HerroepRijweg;
var
	ActieveRijweg: 	PvActieveRijwegLijst;
	Sein:					PvSein;
begin
	if copy(seinnaam,1,1) <> 's' then begin
		result := false;
		Log.Log('Er is geen sein geselecteerd.');
		exit;
	end;
	seinnaam := copy(seinnaam, 2, length(seinnaam)-1);
	Sein := ZoekSein(Core, seinnaam);
	if not assigned(Sein) then begin
		result := false;
		exit;
	end;
	ActieveRijweg := Sein^.RijwegOnderdeel;
	if assigned(ActieveRijweg) then begin
		if ActieveRijweg^.Pending < 2 then begin
			// Het sein staat nog niet op groen -> meteen herroepen.
			HerroepRijwegNu(ActieveRijweg);
			DeclaimRijweg(ActieveRijweg);
			DeleteActieveRijweg(Core, ActieveRijweg);
		end;
		if ActieveRijweg^.Pending = 2 then begin
			// Het sein is op groen gezet.
			// Zet het sein dus op rood.
			SendMsg.SendSetSein(ActieveRijweg^.Rijweg^.Sein, 'r');
			// En herroepen. Approach-locking gebeurt automatisch, indien nodig.
			ActieveRijweg^.Herroep.herroep := true;
			ActieveRijweg^.Herroep.seinwacht := true;
			ActieveRijweg^.Herroep.t := -1;
			ActieveRijweg^.Rijweg^.Sein^.herroepen := true;
			DoeActieveRijwegen;
		end;
		result := true;
	end else begin
		Log.Log('Er is geen rijweg bij sein '+seinnaam+' ingesteld.');
		result := false;
	end;
end;

procedure TRijwegLogica.DeclaimRijweg;
var
	tmpActieveRijweg:	PvActieveRijwegLijst;
	Tab:					PTablist;
	MeetpuntLijst:		PvMeetpuntLijst;
	WisselStand: 		PvWisselstand;
	ReleaseRichtingMag: boolean;
begin
	// Van een eventuele rijrichting mag de voorvergrendeling nu worden
	// opgeheven. We mogen dit alleen doen als een andere rijweg niet
	// dezelfde rijrichting nodig heeft.
	if assigned(ActieveRijweg^.Rijweg^.Erlaubnis) then begin
		ReleaseRichtingMag := true;
		tmpActieveRijweg := Core.vActieveRijwegen;
		while assigned(tmpActieveRijweg) do begin
			if (tmpActieveRijweg <> ActieveRijweg) and
				(tmpActieveRijweg^.Rijweg^.Erlaubnis = ActieveRijweg^.Rijweg^.Erlaubnis) then
				ReleaseRichtingMag := false;
			tmpActieveRijweg := tmpActieveRijweg^.Volgende;
		end;
		if ReleaseRichtingMag then
			SendMsg.SendRichting(ActieveRijweg^.Rijweg^.Erlaubnis,
			ActieveRijweg^.Rijweg^.Erlaubnisstand, rwRelease);
	end;
	// Claims opheffen
	MeetpuntLijst := ActieveRijweg^.Rijweg^.Meetpunten;
	while assigned(MeetpuntLijst) do begin
		if MeetpuntLijst^.Meetpunt^.RijwegOnderdeel = ActieveRijweg then begin
			MeetpuntLijst^.Meetpunt^.RijwegOnderdeel := nil;
			MeetpuntLijst^.Meetpunt^.Knipperen := false;
			Tab := Tabs;
			while assigned(Tab) do begin
				Tab^.Gleisplan.MeetpuntResetKruis(MeetpuntLijst^.Meetpunt);
				Tab^.Gleisplan.PaintMeetpunt(MeetpuntLijst^.Meetpunt);
				Tab := Tab^.Volgende;
			end;
		end;
		MeetpuntLijst := MeetpuntLijst^.Volgende;
	end;
	WisselStand := ActieveRijweg^.Rijweg^.Wisselstanden;
	while assigned(WisselStand) do begin
		if WisselStand^.Wissel^.RijwegOnderdeel = ActieveRijweg then begin
			WisselStand^.Wissel^.RijwegOnderdeel := nil;
			Tab := Tabs;
			while assigned(Tab) do begin
				Tab^.Gleisplan.PaintWissel(WisselStand^.Wissel);
				Tab := Tab^.Volgende;
			end;
		end;
		WisselStand := WisselStand^.Volgende;
	end;
end;

// Deze functie doet alles met de actieve rijwegen.
// - De meetpunten worden gemarkeerd, indien mogelijk
// - De inactief-hokjes worden gekleurd
// - De kruising-hokjes worden ingesteld
// - Seinen worden op groen gezet, indien mogelijk.
procedure TRijwegLogica.DoeActieveRijwegen;
var
	ActieveRijweg:		PvActieveRijwegLijst;
	tmpActieveRijweg:	PvActieveRijwegLijst;
	delete: 				boolean;
	Rijweg:				PvRijweg;
	Tab:					PTablist;
	MeetpuntLijst:		PvMeetpuntLijst;
	meetpuntenvrij:	boolean;
	meetpuntenrozok:	boolean;
	WisselStand: 		PvWisselstand;
	wisselsgoed:		boolean;
	ErlaubnisGoed:		boolean;
	Overweg:				PvOverweg;
	OverwegenGoed:		boolean;
	DoelseinGoed:		boolean;
begin
	// EERST kijken we of misschien de ene of andere rijweg klaar is en verwijderd
	// kan worden.
	ActieveRijweg := Core.vActieveRijwegen;
	while assigned(ActieveRijweg) do begin
		delete := false;
		if ActieveRijweg^.Herroep.herroep then begin
			// De rijweg moeten we herroepen
			if ActieveRijweg^.Herroep.seinwacht and
				(ActieveRijweg^.Herroep.t = -1) then begin
				// Het sein is rood. Nog even wachten of de trein ook echt gestopt is.
				ActieveRijweg^.Herroep.t := GetTijd+MkTijd(0,0,5);
				delete := false;
			end else if ActieveRijweg^.Herroep.seinwacht and
				(GetTijd >= ActieveRijweg^.Herroep.t) then begin
				// Zo, de tijd is afgelopen. Even kijken of approach-locking nodig is.
				if MoetApproachLock(ActieveRijweg) then begin
					ActieveRijweg^.Herroep.herroep := true;
					ActieveRijweg^.Herroep.seinwacht := false;
					ActieveRijweg^.Herroep.t := GetTijd+MkTijd(0,2,0);
					ActieveRijweg^.Rijweg^.Sein^.herroepen := true;
					Log.Log('Rijweg blijft nog 120 seconden vergrendeld.');
					delete := false;
				end else begin
					HerroepRijwegNu(ActieveRijweg);
					delete := true;
				end;
			end else	if GetTijd >= ActieveRijweg^.Herroep.t then begin
				// Approach-locking-tijd afgelopen
				HerroepRijwegNu(ActieveRijweg);
				delete := true;
			end else
				delete := false;
		end else if ActieveRijweg^.Pending = 3 then begin
			// De rijweg is geactiveerd geweest; het sein is alweer op rood.
			// Ons doel is het opruimen van de rijweg als deze afgehandeld is.
			// Hij is afgehandeld als de trein de rijweg weer verlaten heeft
			// - alle meetpunten zijn vrij. Ze mogen nog wel geclaimd zijn. Een
			// trein kan immers ook halverwege de rijweg zijn omgedraaid.
			delete := true;
			MeetpuntLijst := ActieveRijweg^.Rijweg^.Meetpunten;
			while assigned(MeetpuntLijst) do begin
				delete := delete and ((MeetpuntLijst^.Meetpunt^.RijwegOnderdeel <>
					ActieveRijweg) or not MeetpuntLijst^.Meetpunt^.bezet);
				MeetpuntLijst := MeetpuntLijst^.Volgende;
			end;
		end;
		if delete then begin
			DeclaimRijweg(ActieveRijweg);

			// En vervolgens kunnen we de rijweg opruimen.
			tmpActieveRijweg := ActieveRijweg^.Volgende;
			DeleteActieveRijweg(Core, ActieveRijweg);
			ActieveRijweg := tmpActieveRijweg;
		end else
			ActieveRijweg := ActieveRijweg^.Volgende;
	end;

	// TENSLOTTE kijken we of een wens-rijweg inmiddels gereed is om op groen
	// geschakeld te worden.
	ActieveRijweg := Core.vActieveRijwegen;
	while assigned(ActieveRijweg) do begin
		if ActieveRijweg^.Pending=0 then begin
			// De rijweg is nog niet geheel geactiveerd. Ons doel is om
			// het sein op groen te krijgen.
			Rijweg := ActieveRijweg^.Rijweg;

			// Wissels weergeven - en kijken of ze in de goede stand staan.
			wisselsgoed := true;
			WisselStand := Rijweg^.Wisselstanden;
			while assigned(WisselStand) do begin
				if not assigned(WisselStand^.Wissel^.RijwegOnderdeel) then begin
					WisselStand^.Wissel^.RijwegOnderdeel := ActieveRijweg;
					Tab := Tabs;
					while assigned(Tab) do begin
						Tab^.Gleisplan.PaintWissel(WisselStand^.Wissel);
						Tab := Tab^.Volgende;
					end;
				end;
				if WisselStand^.Rechtdoor then
					wisselsgoed := wisselsgoed and WisselsLiggenGoed(WisselStand^.Wissel, wsRechtdoor)
				else
					wisselsgoed := wisselsgoed and WisselsLiggenGoed(WisselStand^.Wissel, wsAftakkend);
				WisselStand := WisselStand^.Volgende;
			end;

			// Erlaubnis controleren
			if assigned(Rijweg^.Erlaubnis) then
				ErlaubnisGoed := Rijweg^.Erlaubnis^.richting = Rijweg^.Erlaubnisstand
			else
				ErlaubnisGoed := true;

			// Kijken of alle meetpunten vrij zijn
			if wisselsgoed and ErlaubnisGoed then begin
				meetpuntenvrij := true;
				meetpuntenrozok := true;
				MeetpuntLijst := Rijweg^.Meetpunten;
				while assigned(MeetpuntLijst) do begin
					// Bezet vanwege aanwezigheid trein?
					if MeetpuntLijst^.Meetpunt^.bezet then begin
						meetpuntenvrij := false;
						// Bij een bezet meetpunt houden we meteen op. Het zou immers
						// kunnen zijn dat we een rijweg naar bezet spoor instellen,
						// dan moeten we niet na de al aanwezige trein verder claimen.
						break;
					end else begin
						if not assigned(MeetpuntLijst^.Meetpunt^.RijwegOnderdeel) then begin
							// Meetpunt is vrij. Claim het.
							MeetpuntLijst^.Meetpunt^.RijwegOnderdeel := ActieveRijweg;
							Tab := Tabs;
							while assigned(Tab) do begin
								DoeKruisHokjes(MeetpuntLijst^.Meetpunt, Rijweg);
								// Inactieve hokjes ook herberekenen, want die kunnen
								// nu na het instellen van de kruisinghokjes ineens
								// duidelijk zijn.
								DoeHokjes(MeetpuntLijst^.Meetpunt, false);
								Tab^.Gleisplan.PaintMeetpunt(MeetpuntLijst^.Meetpunt);
								Tab := Tab^.Volgende;
							end;
						end else
							// Bezet vanwege geclaimd door andere rijweg?
							if (MeetpuntLijst^.Meetpunt^.RijwegOnderdeel <> ActieveRijweg) then begin
								// Dan zijn de meetpunten niet vrij
								meetpuntenvrij := false;
								// Of rijden op zicht kan, hangt ervan af of die andere
								// rijweg al vrijgereden is.
								// Deze check is in elke situatie correct. Was de oude
								// rijweg in dezelfde richting, dan is de voorwaarde
								// per definitie vervuld. Is de oude rijweg in
								// tegenovergestelde richting, dan niet per definitie.
								tmpActieveRijweg := MeetpuntLijst^.Meetpunt^.RijwegOnderdeel;
								meetpuntenrozok := tmpActieveRijweg^.Pending = 3;
								break;
							end;
					end;
					MeetpuntLijst := MeetpuntLijst^.Volgende;
				end;
			end else begin
				meetpuntenvrij := false;
				meetpuntenrozok := false;
			end;

			// Als in principe alles OK is gaan we naar de volgende pending-status.
			if (meetpuntenvrij or (ActieveRijweg^.ROZ and meetpuntenrozok)) and
				wisselsgoed and ErlaubnisGoed then begin
            ControleerAankondigingKnipperen(ActieveRijweg^.Rijweg);
				ActieveRijweg.Pending := 1;
			end;
		end;
		if ActieveRijweg.Pending = 1 then begin
			// De rijweg is klaar en vergrendeld. Alleen moeten de overwegen nog
			// gesloten worden.
			Rijweg := ActieveRijweg^.Rijweg;

			// Als alle meetpunten vrij zijn, dan kunnen we de overwegen sluiten.
			OverwegenGoed := true;
			Overweg := Core.vAlleOverwegen;
			while assigned(Overweg) do begin
				if OverwegMoetDichtVoorRijweg(Overweg, ActieveRijweg) and (not Overweg^.Gesloten) then begin
					OverwegenGoed := false;
					break;
				end;
				Overweg := Overweg^.Volgende;
			end;

			// Kijken of het volgende sein goed werkt en dekking levert aan een
			// vooruitrijdende trein
			DoelseinGoed := false;
			if OverwegenGoed then
				if assigned(Rijweg^.NaarSein) then
					DoelseinGoed := (Rijweg^.NaarSein^.Stand_wens <> 'r') or
										 (Rijweg^.NaarSein^.Stand = 'r')
				else
					DoelseinGoed := true;

			// Alles OK? Dan kan het sein op groen.
			if OverwegenGoed and DoelseinGoed then begin
				if ActieveRijweg^.ROZ then
					SendMsg.SendSetSein(Rijweg^.Sein, 'gk')
				else
					SendMsg.SendSetSein(Rijweg^.Sein, 'g');
				ActieveRijweg^.Pending := 2;
			end;
		end;
		ActieveRijweg := ActieveRijweg^.Volgende;
	end;
end;

function TRijwegLogica.RijwegVrij;
var
	Meetpunt:  			PvMeetpuntLijst;
begin
	result := true;

	Meetpunt := Rijweg^.Meetpunten;
	if Meetpunt^.Meetpunt^.bezet then begin
		result := false;
		exit;
	end;
end;

function TRijwegLogica.RijwegAlActief;
var
	tmpActieveRijweg: PvActieveRijwegLijst;
	rijwegalactief: 	boolean;
begin
	// Eerst eens kijken of niet precies deze rijweg
	// al ingesteld is
	tmpActieveRijweg := Core^.vActieveRijwegen;
	rijwegalactief := false;
	while assigned(tmpActieveRijweg) do begin
		if (tmpActieveRijweg^.Rijweg = Rijweg) and
			(tmpActieveRijweg^.Pending<3) then
			rijwegalactief := true;
		tmpActieveRijweg := tmpActieveRijweg^.Volgende;
	end;
	result := rijwegalactief;
end;

function TRijwegLogica.StelRijwegIn;
var
	ActieveRijweg: PvActieveRijwegLijst;
	Tab: PTabList;
begin
	// Eens kijken of we al een betreffende rijweg hebben 'verbeterd' kan
	// worden. Dat is:
	// 1. Approach-Locking -> Rijweg / ROZ-rijweg / Autorijweg
	// 2. Rijweg           -> Autorijweg
	// De volgende optie is echter niet mogelijk, omdat dat een verslechtering
	// van het seinbeeld kan opleveren:
	// 3. ROZ-rijweg       -> Rijweg / Autorijweg
	ActieveRijweg := Core^.vActieveRijwegen;
	while assigned(ActieveRijweg) do begin
		if (ActieveRijweg^.Rijweg = Rijweg) then begin
			// 1. Approach-Locking -> Rijweg / Autorijweg
			if ActieveRijweg^.Herroep.herroep then begin
				ActieveRijweg^.Herroep.herroep := false;
				ActieveRijweg^.Herroep.seinwacht := false;
				ActieveRijweg^.Pending := 0;
				ActieveRijweg^.ROZ := ROZ;
				ActieveRijweg^.Autorijweg := Auto;

				// Sein weer normaal tonen
				ActieveRijweg^.Rijweg^.Sein^.herroepen := false;
				Tab := Tabs;
				while assigned(Tab) do begin
					Tab^.Gleisplan.PaintSein(ActieveRijweg^.Rijweg^.Sein);
					Tab := Tab^.Volgende;
				end;

				// En activeren indien mogelijk.
				DoeActieveRijwegen;

				break;
			end;
			// 2. Rijweg           -> Autorijweg
			if (ActieveRijweg^.ROZ = false) and (ActieveRijweg^.Autorijweg = false)
				and (ActieveRijweg^.Pending < 3) and Auto then begin
				ActieveRijweg^.Autorijweg := Auto;
				Log.Log('Bestaande rijweg automatisch gemaakt.');
				break;
			end;
		end;
		ActieveRijweg := ActieveRijweg^.Volgende;
	end;

	if assigned(ActieveRijweg) then begin
		result := true;
		exit;
	end;

	// Eerst eens kijken of deze rijweg echt ingesteld kan worden
	if not RijwegKan(Rijweg, ROZ) then begin
		case RijwegKanWaaromNiet of
		4: Log.Log('Deze rijweg gaat naar onbeveiligd spoor.');
		else
			Log.Log('Deze rijweg kan momenteel niet worden ingesteld.');
		end;
		result := false;
		exit;
	end;

	if RijwegAlActief(Rijweg) then begin
		if WatMetActief = wmaError then begin
			Log.Log('Deze rijweg is al ingesteld.');
			result := false;
		end else
			result := true;
		exit;
	end;

	// Nu stellen we de rijweg in, inclusief wissels en rijrichting
	StelRijwegInNu(Rijweg, ROZ, Auto);

	result := true;
end;

function TRijwegLogica.DoeRijweg;
var
	Rijweg: PvRijweg;
begin
	result := false;

	if (Van='') or (Naar='') then exit;

	// Eerst eens een rijweg zoeken.
	Rijweg := ZoekRijweg(Core, Van, Naar);
	if not assigned(Rijweg) then begin
		Log.Log('Er bestaat geen rijweg van '+KlikpuntTekst(Van, true)+' naar '+
			KlikpuntTekst(Naar, true)+'.');
		result := false;
		exit;
	end;

	result := StelRijwegIn(Rijweg, ROZ, Auto, wmaError);
end;

procedure TRijwegLogica.StelRijwegInNu;
var
	Wissel: PvWisselstand;
	ActieveRijweg: PvActieveRijwegLijst;
	Tab:	  PTablist;
begin
	ActieveRijweg := AddActieveRijweg(Core, Rijweg, ROZ, Auto);

	// Zet de wissels goed
	Wissel := Rijweg^.Wisselstanden;
	while assigned(Wissel) do begin
		if Wissel^.Rechtdoor then
			SendMsg.SendWissel(Wissel^.Wissel, wsRechtdoor)
		else
			SendMsg.SendWissel(Wissel^.Wissel, wsAftakkend);
		Wissel := Wissel^.volgende;
	end;

	// Claim de rijrichting
	if assigned(Rijweg^.Erlaubnis) then
		SendMsg.SendRichting(Rijweg^.Erlaubnis, Rijweg^.Erlaubnisstand, rwClaim);

	// Registreer (en herteken) het sein
	Rijweg^.Sein^.RijwegOnderdeel := ActieveRijweg;
	Tab := Tabs;
	while assigned(Tab) do begin
		Tab^.Gleisplan.PaintSein(Rijweg^.Sein);
		Tab := Tab^.Volgende;
	end;

	// Deactiveer knipperende aankondigingssecties die niet meer nodig zijn nu
	// deze rijweg ingesteld wordt
	DeactiveerVoorgaandeAankondiging(Rijweg);

	// En de meetpunten een eerste keertje proberen te claimen
	DoeActieveRijwegen;
end;

// De onderstaande functie stelt een samengestelde rijweg in.
// Daarvoor worden normale functies gebruikt, maar het hergebruiken van
// herroepen rijwegen wordt in deze functie niet gedaan.
function TRijwegLogica.StelPrlRijwegIn;
var
	KanInstellen: 					boolean;
	RijwegLijst: 					PvRijwegLijst;
	LaatstIngesteldeRijweg: 	PvRijweg;
begin
	if not gefaseerd then begin
		Prl_IngesteldTot := '';
		// We mogen geen deelrijwegen instellen.
		KanInstellen := true;
		RijwegLijst := PrlRijweg^.Rijwegen;
		while assigned(RijwegLijst) do begin
			KanInstellen := KanInstellen and RijwegKan(RijwegLijst^.Rijweg, ROZ) and
														RijwegVrij(RijwegLijst^.Rijweg);
			RijwegLijst := RijwegLijst^.Volgende;
		end;
		if KanInstellen then begin
			// Joepie! Het kan allemaal!
			RijwegLijst := PrlRijweg^.Rijwegen;
			while assigned(RijwegLijst) do begin
				if ROZ and (not assigned(RijwegLijst^.Volgende)) then
					StelRijwegIn(RijwegLijst^.Rijweg, true, false, wmaOK)
				else
					StelRijwegIn(RijwegLijst^.Rijweg, false, false, wmaOK);
				RijwegLijst := RijwegLijst^.Volgende;
			end;
			result := true;
		end else
			result := false;
	end else begin
		// We mogen deelrijwegen instellen
		LaatstIngesteldeRijweg := nil;
		RijwegLijst := PrlRijweg^.Rijwegen;
		while assigned(RijwegLijst) do begin
			if RijwegKan(RijwegLijst^.Rijweg, ROZ) and
				(RijwegVrij(RijwegLijst^.Rijweg) or
				 (ROZ and not assigned(RijwegLijst^.Volgende))) then begin
				if ROZ and not assigned(RijwegLijst^.Volgende) then
					StelRijwegIn(RijwegLijst^.Rijweg, true, false, wmaOK)
				else
					StelRijwegIn(RijwegLijst^.Rijweg, false, false, wmaOK);
				LaatstIngesteldeRijweg := RijwegLijst^.Rijweg;
			end else
				break;
			RijwegLijst := RijwegLijst^.Volgende;
		end;
		if not assigned(RijwegLijst) then
			result := true
		else begin
			result := false;
			if assigned(LaatstIngesteldeRijweg) then begin
				// Niet de hele rijweg kon worden ingesteld, maar een deel wel.
				Prl_IngesteldTot := KlikpuntSpoor(RijwegLijst^.Rijweg^.Sein^.Van);
			end else
				Prl_IngesteldTot := '';
		end;
	end;
end;

end.
