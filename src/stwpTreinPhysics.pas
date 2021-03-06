unit stwpTreinPhysics;

interface

uses stwpCore, stwpTreinen, stwpRails, stwpSeinen, stwpRijplan, stwpTijd,
	stwpDatatypes, stwpTelefoongesprek, stwpCommPhysics, stwpMeetpunt, stwvMisc;

type
	PpTreinTelefoonSoort = ^TpTreinTelefoonSoort;
	TpTreinTelefoonSoort = (ttsInfo, ttsStilstaan, ttsStilstaanStation, ttsKannietweg,
		ttsVertrekBevestiging);

	PpTreinPhysics = ^TpTreinPhysics;
	TpTreinPhysics = class
	private
		Core:	PpCore;
		CommPhysics: PpCommPhysics;
		function HalloTekst(Trein: PpTrein): string;
		procedure LeesSeinbeeld(Trein: PpTrein; Sein: PpSein);
		procedure HerkenFlankbotsingen(Trein: PpTrein);
		procedure BeweegTrein(Trein: PpTrein);
		procedure ActieKoppelen(Trein: PpTrein);
		procedure ActieLoskoppelen(Trein: PpTrein; AfkoppelenVanOmgekeerdeTrein: boolean);
		procedure ActiesAfhandelen(Trein: PpTrein);
		function MoetTreinStoppenBijPerronpunt(Trein: PpTrein; Punt: PpSein): boolean;
		procedure ControleerVertrektijd(Trein: PpTrein);
		procedure ControleerStoppen(Trein: PpTrein);
		function  ControleerKoppelTrein(Trein: PpTrein; Planpunt: PpRijplanpunt): boolean;
		procedure ZetStil(Trein: PpTrein);
		procedure WisPlanregelsDieTijdensRijdenNutteloosZijn(Trein: PpTrein);
		function ZoekTelefoongesprek(Trein: PpTrein; Soort: TpTreinTelefoonSoort): PpTelefoonGesprek;
		procedure RijTrein(Trein: PpTrein);
		procedure DestroyUserdata(userdata: pointer);
	public
		constructor Create(Core: PpCore; CommPhysics: PpCommPhysics);
		procedure DoeTreinen;
	end;

implementation

constructor TpTreinPhysics.Create;
begin
	Self.Core := Core;
	Self.CommPhysics := CommPhysics;
end;

function TpTreinPhysics.HalloTekst;
begin
	result := 'Hallo, met de machinist van trein ' +StringToNato(Trein^.Treinnummer)+'. ';
end;

procedure TpTreinPhysics.DestroyUserdata;
begin
	Dispose(PpTreinTelefoonSoort(userdata));
end;

procedure TpTreinPhysics.DoeTreinen;
var
	Trein:		PpTrein;
	tmpTrein:	PpTrein;
begin
	Trein := Core^.pAlleTreinen;
	while assigned(Trein) do begin
		Trein^.Update;
		RijTrein(Trein);
		Trein := Trein^.Volgende;
	end;

	Trein := Core^.pAlleTreinen;
	while assigned(Trein) do begin
		if Trein^.Wissen then begin
			tmpTrein := Trein^.Volgende;
			Core^.WisTrein(Trein);
			Trein := tmpTrein
		end else
			Trein := Trein^.Volgende;
	end;
end;

function TpTreinPhysics.ZoekTelefoongesprek(Trein: PpTrein; Soort: TpTreinTelefoonSoort): PpTelefoonGesprek;
var
	gesprek: PpTelefoongesprek;
begin
	gesprek := Core.pAlleGesprekken;
	result := nil;
	while assigned(gesprek) do begin
		if PpTrein(gesprek^.Owner) = Trein then
			if (assigned(Gesprek^.userdata) and (PpTreinTelefoonSoort(Gesprek^.userdata)^ = Soort)) or
				(not assigned(Gesprek^.userdata) and (Soort = ttsInfo)) then begin
				result := gesprek;
				exit;
			end;
		gesprek := gesprek^.Volgende;
	end;
end;

procedure TpTreinPhysics.LeesSeinbeeld;
begin
	// Snelheidsbordje?
	if Sein^.H_Baanmaxsnelheid >= 0 then begin
		if not Trein^.ROZ then
			Trein^.NieuweMaxsnelheid(Sein^.H_Baanmaxsnelheid, true);
		Trein^.B_Adviessnelheid := -1;
	end;

	// Hoofdsein?
	if (Sein^.Bediend or Sein^.Autosein) then begin
		// Hoofdsein
		if Sein^.H_MovementAuthority.HasAuthority then begin
			if Sein^.H_MovementAuthority.Baanvaksnelheid then
				Trein^.NieuweMaxsnelheid(-1, false)
			else
				Trein^.NieuweMaxsnelheid(Sein^.H_MovementAuthority.Snelheidsbeperking, false);
			Trein^.doorroodgereden := false;
			if Sein^.Bediend and (Sein^.Bediend_Stand=2) then
				Trein^.ROZ := true
			else
				Trein^.ROZ := false;
		end else begin
			Trein^.NieuweMaxsnelheid(0, false);
			Trein^.ROZ := true;
			if Trein^.doorroodopdracht and (Trein^.doorroodopd_sein = Sein) then
				Trein^.huidigemaxsnelheid := doorroodrozsnelheid
			else begin
				Trein^.doorroodgereden := true;
				Trein^.doorroodgereden_sein := Sein;
			end;
		end;
		// Zodra we langs een of ander hoofdsein zijn gereden,
		// deze variabelen weer op false zetten!
		Trein^.doorroodopdracht := false;
		Trein^.doorroodverderrijden := false;
		// Voorsein-adviessnelheid wissen.
		Trein^.V_Adviessnelheid := -1
	end;

	// Kijk of het een voorsein is.
	Trein^.ZieVoorsein(Sein);

	// Station? Als we er niet stoppen dan moeten we het volgende
	// rijplanpunt laden - tenslotte gebeurt dat anders op het moment
	// dat we vertrekken.
	if Sein^.Perronpunt and assigned(Trein^.Planpunten) then
		if (Trein^.Planpunten^.Station = Sein^.Stationsnaam) then
			if not Trein^.Planpunten^.stoppen then begin
				// Vertragingsinfo bijwerken
				Trein^.Vertraging := (GetTijd -
					Trein^.Planpunten^.Aankomst) div MkTijd(0,1,0);
				// Naar volgende planpunt springen
				dispose(Trein^.GetVolgendRijplanpunt);
			end;
		// Stationsaankondiging?
		if Sein^.Haltevoorsein and assigned(Trein^.Planpunten) then
			if (Trein^.Planpunten^.Station = Sein^.Stationsnaam) and
				Trein^.Planpunten^.stoppen then
				Trein^.S_Adviessnelheid := RemwegSnelheid;
end;

procedure TpTreinPhysics.HerkenFlankbotsingen;
var
	GevOmgekeerd:	boolean;
	GevRail:			PpRail;
	GevPos:			double;

	tmpTreinL :		PpTrein;
	Raillijst:		PpRailLijst;
	tmpRaill:		PpRailLijst;
begin
	// Flankbotsingen herkennen.
	tmpTreinL := Core.pAlleTreinen;
	while assigned(tmpTreinL) do begin
		if tmpTreinL <> Trein then begin
			RailLijst := tmpTreinl^.BezetteRails;
			tmpRaill := RailLijst;
			while assigned(tmpRaill) do begin
				if assigned(tmpRaill^.Volgende) and (TmpRaill <> RailLijst) then
					// Rail uit het midden van de trein-bezetting, dus de
					// rail wordt van begin tot eind ingenomen!
					if TmpRaill^.Rail = Trein^.pos_rail then begin
						// Botsing!
						Trein^.Modus := tmGecrasht;
						tmpTreinL^.Modus := tmGecrasht;
					end;
				if assigned(tmpRaill^.Volgende) and (TmpRaill = RailLijst) then
					// Eerste rail uit de trein-bezetting, dus rail wordt vanaf
					// een bepaald punt tot begin/eind ingenomen.
					if (TmpRaill^.Rail = Trein^.pos_rail) and
						(tmpTreinL^.achteruit = Trein^.achteruit) then begin
						// Botsing!
						Trein^.Modus := tmGecrasht;
						tmpTreinL^.Modus := tmGecrasht;
					end;
				if not assigned(tmpRaill^.Volgende) and (TmpRaill <> RailLijst) then
					// Laatste rail uit de trein-bezetting. Iets lastiger.
					if (TmpRaill^.Rail = Trein^.pos_rail) then begin
						TmpTreinL^.ZoekEinde(GevRail, GevOmgekeerd, GevPos);
						if GevOmgekeerd = Trein^.achteruit then begin
							// Botsing!
							Trein^.Modus := tmGecrasht;
							tmpTreinL^.Modus := tmGecrasht;
						end;
					end;
				tmpRaill := tmpRaill^.Volgende;
			end;
		end;
		tmpTreinL := tmpTreinL^.Volgende;
	end;
end;

procedure TpTreinPhysics.BeweegTrein;
var
	kracht:	integer;	// De trekkracht (>0) of remkracht (<0) die we momenteel
							// uitoefenen.
	remkrachtwens: integer;	// Hoe hard remmen voor wensmaxremvertraging?
	maxremvertraging: double;
	mssnelheid: double;	// snelheid in m/s
	rolwrijving: double;	// rolwrijving in N
	luchtwrijving: double;
	totaalwrijving: double;
	wenssnelheid: integer;
	toename: double;

	kijkafstand:	double;

	basisafstand:	double;

	tmpRail:			PpRail;
	tmpAchteruit:	boolean;
	tmpPos:			double;

	HSeinSnelheid: integer;
	MovementAuthority: THMovementAuthority;

	GevSein:			PpSein;
	GevTrein:		PpTrein;
	GevWissel:		PpWissel;
	GevTreinAfstand:	double;
	GevSeinAfstand:	double;
	GevWisselAfstand: double;
	GevOmgekeerd:	boolean;
	intAfstand:		double;
	remopdracht:	boolean;

	tmpConn:			PpRailConn;
	omgConn:			PpRailConn;
	oudeRail:		PpRail;
begin
	// Plan van aanpak:
	// We zoeken het meest restrictieve dat we moeten doen.
	// We beginnen dus met het minst restrictieve dat we kunnen doen: gassen!
	// Vervolgens gaan we dit met allerhande criteria bijschaven.
	kracht := Trein^.trekkracht;

	// Momentele status berekenen
	mssnelheid := Trein^.snelheid / 3.6;
	rolwrijving := Trein^.gewicht * 9.8 * cr;
	luchtwrijving := 0.5 * Trein^.cw * frontaal * dichtheid * mssnelheid
		* mssnelheid;
	totaalwrijving := rolwrijving + luchtwrijving;

	// Berekenen hoeveel remkracht we nodig hebben om een vertraging van
	// WensMaxRemvertraging te krijgen.
	remkrachtwens := trunc((WensMaxRemVertraging*Trein^.gewicht) - totaalwrijving);
	if remkrachtwens < 0 then remkrachtwens := 0;
	maxremvertraging := Trein^.remkracht / Trein^.gewicht;

	// CRITERIUM 1 - Het vermogen van de lokomotieven.
	if kracht*mssnelheid > Trein^.vermogen then
		kracht := round(Trein^.vermogen / mssnelheid);

	// CRITERIUM 2 - Maximumsnelheden enzo
	wenssnelheid := Trein^.maxsnelheid;
	if (Trein^.V_Adviessnelheid <> -1) and
		(Trein^.V_Adviessnelheid < wenssnelheid) then
		wenssnelheid := Trein^.V_Adviessnelheid;
	if (Trein^.B_Adviessnelheid <> -1) and
		(Trein^.B_Adviessnelheid < wenssnelheid) then
		wenssnelheid := Trein^.B_Adviessnelheid;
	if (Trein^.S_Adviessnelheid <> -1) and
		(Trein^.S_Adviessnelheid < wenssnelheid) then
		wenssnelheid := Trein^.S_Adviessnelheid;
	if Trein^.Snelheid > Trein^.maxsnelheid + 5 then
		// We rijden echt te hard, dus vol remmen.
		kracht := -Trein^.remkracht
	else
		if Trein^.Snelheid > wenssnelheid + (SnelheidTargetAfwijking/2) then
			// We rijden harder dan we willen. Voorzichtig remmen.
			kracht := -remkrachtwens
		else
			if Trein^.Snelheid >= wenssnelheid - (SnelheidTargetAfwijking/2) then
				// We rijden op de juiste snelheid. Lekker doortuffen dus.
				kracht := round(totaalwrijving);

	// CRITERIUM 3 - Wat zien we voor ons?
	// Een station? Een rood of andersoortig snelheidsverlagend sein?
	KijkAfstand := TreinVooruitblik;
	tmpRail := Trein^.pos_rail;
	tmpAchteruit := Trein^.achteruit;
	tmpPos := Trein^.pos_dist;
	basisAfstand := 0;
	repeat
		// Zoek zoek, zoek het sein!
		Core.ZoekVolgendSein(tmpRail, tmpAchteruit, tmpPos, KijkAfstand,
			GevSein, GevSeinAfstand);
		if assigned(GevSein) then begin
			MovementAuthority := GevSein^.H_MovementAuthority;
			if (GevSein^.Autosein or GevSein^.Bediend) then begin
				if (not MovementAuthority.HasAuthority) and
				Trein^.doorroodopdracht then
					if Trein^.doorroodopd_sein = GevSein then begin
						MovementAuthority.HasAuthority := true;
						MovementAuthority.Baanvaksnelheid := false;
						MovementAuthority.Snelheidsbeperking := doorroodrozsnelheid
					end else
						Trein^.doorroodopdracht := false
			end else begin
				MovementAuthority.HasAuthority := true;
				MovementAuthority.Baanvaksnelheid := true;
			end;
			// Is het een station? Dan kijken we naar de naam, of het geldig is.
			if MoetTreinStoppenBijPerronpunt(Trein, GevSein) then
				MovementAuthority.HasAuthority := false;
			// Is het een snelheidsopleggend sein?
			if (not MovementAuthority.HasAuthority) or
				((not MovementAuthority.Baanvaksnelheid) and
				 (MovementAuthority.Snelheidsbeperking < Trein^.snelheid )) then begin
				// Berekenen of we voor dit sein alvast moeten gaan afremmen
				if not MovementAuthority.HasAuthority then
					HSeinSnelheid := 0
				else
					HSeinSnelheid := MovementAuthority.Snelheidsbeperking;
				intAfstand := (((mssnelheid - (HSeinSnelheid / 3.6)) / WensMaxRemvertraging) *
				(mssnelheid + (HSeinSnelheid / 3.6)) / 2);
				if basisAfstand + GevSeinAfstand < IntAfstand + 10 then
					if kracht > -remkrachtwens then begin
						kracht := -remkrachtwens;	// Remmen met gewenste snelheid.
					end;
			end;
			// Is het een bordje waarvoor we moeten afremmen?
			if GevSein^.H_Baanmaxsnelheid > -1 then begin
				// Berekenen of we voor dit sein alvast moeten gaan afremmen
				HSeinSnelheid := GevSein^.H_Baanmaxsnelheid;
				intAfstand := (((mssnelheid - (HSeinSnelheid / 3.6)) / WensMaxRemvertraging) *
				(mssnelheid + (HSeinSnelheid / 3.6)) / 2);
				if basisAfstand + GevSeinAfstand < IntAfstand + 10 then
					if kracht > -remkrachtwens then begin
						kracht := -remkrachtwens;	// Remmen met gewenste snelheid.
					end;
			end;
			KijkAfstand := KijkAfstand - GevSeinAfstand;
			basisAfstand := basisAfstand + GevSeinAfstand;
		end;
	until (not assigned(GevSein)) or (not assigned(tmpRail));

	// CRITERIUM 3B - Een wissel dat niet goed ligt?
	KijkAfstand := TreinVooruitblik;
	tmpRail := Trein^.pos_rail;
	tmpAchteruit := Trein^.achteruit;
	tmpPos := Trein^.pos_dist;
	basisAfstand := 0;
	repeat
		// Zoek zoek, zoek de wissel!
		Core.ZoekVolgendeWissel(tmpRail, tmpAchteruit, tmpPos, KijkAfstand,
			GevWissel, GevWisselAfstand);
		if assigned(GevWissel) then begin
			if not (GevWissel^.stand in [wsRechtdoor, wsAftakkend]) then begin
				// Berekenen of we alvast moeten gaan afremmen
				intAfstand := ((mssnelheid / WensMaxRemvertraging) * mssnelheid / 2);
				if basisAfstand + GevSeinAfstand < IntAfstand + 10 then
					if kracht > -remkrachtwens then begin
						kracht := -remkrachtwens;	// Remmen met gewenste snelheid.
					end;
			end;
			KijkAfstand := KijkAfstand - GevSeinAfstand;
			basisAfstand := basisAfstand + GevSeinAfstand;
		end;
	until (not assigned(GevWissel)) or (not assigned(tmpRail));

	// CRITERIUM 4 - Een trein voor onze neus.
	Core.ZoekVolgendeTrein(Trein, TreinVooruitblik, GevTrein, GevTreinAfstand, GevOmgekeerd);
	if GevTrein <> nil then begin
		intAfstand := ((mssnelheid / WensMaxRemvertraging) * mssnelheid / 2);
		// Zitten we op dusdanige afstand dat we moeten remmen?
		if GevTreinAfstand < IntAfstand + koppelafstanddoel then
			if kracht > -remkrachtwens then
				kracht := -remkrachtwens;	// Remmen met gewenste snelheid.
		// Zitten we op dusdanige afstand dat noodremming noodzakelijk is?
		intAfstand := round((mssnelheid / MaxRemvertraging) * mssnelheid / 2);
		if GevTreinAfstand < IntAfstand + koppelafstanddoel then
			kracht := -Trein^.remkracht;	// Remmen met max. remkracht
		// Of is alle hoop verloren? Botsing!!!
		if GevTreinAfstand < IntAfstand then begin
			Trein^.modus := tmGecrasht;
			GevTrein^.modus := tmGecrasht;
		end;
	end;

	// CRITERIUM 5 - Kan de trein wel rijden?
	if Trein^.EersteWagon = nil then
		kracht := -trein^.remkracht
	else
		if (not Trein^.EersteWagon^.wagon^.bedienbaar) or
			(not Trein^.EersteWagon^.wagon^.twbedienbaar and Trein^.EersteWagon.omgekeerd) then
			kracht := -trein^.remkracht;

	// EN ACTIE!

	// Trein versnellen/vertragen
	toename := (kracht - totaalwrijving) / Trein^.gewicht;
	mssnelheid := mssnelheid + toename / tps;
	if mssnelheid < 0 then	// Als we heel hard remmen gaan we niet achteruit rijden!
		mssnelheid := 0;
	Trein^.snelheid := mssnelheid * 3.6;
	if Trein^.snelheid <= SnelheidTargetAfwijking then Trein^.snelheid := 0;

	// Trein verplaatsen
	tmpConn := nil;
	if Trein^.achteruit then
		Trein^.pos_dist := Trein^.pos_dist - (mssnelheid / tps)
	else
		Trein^.pos_dist := Trein^.pos_dist + (mssnelheid / tps);

	// Afstand sinds vorige snelheidswijziging bijwerken
	Trein^.afstandsindsvorige_h := Trein^.afstandsindsvorige_h + (mssnelheid / tps);
	Trein^.afstandsindsvorige_b := Trein^.afstandsindsvorige_b + (mssnelheid / tps);

	while (Trein^.pos_dist < 0) or (Trein^.pos_dist > Trein^.pos_rail^.Lengte) do begin
		OudeRail := Trein^.pos_rail;
		if Trein^.pos_dist < 0 then begin
			// positie normaliseren
			Trein^.pos_dist := -Trein^.pos_dist;
			// nieuwe rail en positie bepalen
			tmpConn := Trein^.pos_rail^.Vorige;
		end else if Trein^.pos_dist > trein^.pos_rail^.lengte then begin
				// positie normaliseren
				Trein^.pos_dist := trein.pos_dist - trein^.pos_rail^.lengte;
				// nieuwe rail en positie bepalen
				tmpConn := Trein^.pos_rail^.Volgende;
		end;

		// De trein crasht, want hij is op een werkzaamheden-ploeg gereden.
		if WisselWerkzaamheden(tmpConn) then
			Trein^.modus := tmGecrasht;

		WisselOpenrijden(tmpConn);
		VolgendeRail(tmpConn, tmpRail, tmpAchteruit);

		if assigned(tmpRail) then begin
			Trein^.pos_rail := tmpRail;
			Trein^.achteruit := tmpAchteruit;
			if Trein^.achteruit then
				Trein^.pos_dist := Trein^.pos_rail^.Lengte - Trein^.pos_dist
			else
				Trein^.pos_dist := Trein^.pos_dist
		end else begin
			// We zijn ontspoord.
			// Vermoedelijk op een wissel dat net omloopt.
			Trein^.Modus := tmGecrasht;
		end;

		// Dit is van toepassing bij doodlopende stukken spoor: die verwijzen
		// terug naar zichzelf.
		if (Trein^.pos_rail = oudeRail) and assigned(tmpRail) then begin
			// Botsing!
			Trein^.Modus := tmGecrasht;
			Trein^.Achteruit := not Trein^.Achteruit;
			exit;
		end;
		// De trein crasht, want hij is op werkzaamheden gereden.
		if assigned(Trein^.pos_rail^.meetpunt) then
			if PpMeetpunt(Trein^.pos_rail^.meetpunt)^.kortsluitlans then begin
			Trein^.Modus := tmGecrasht;
			exit;
		end;

		HerkenFlankbotsingen(Trein);

		// Zijn wij misschien over een sein gereden?
		if tmpConn^.sein <> nil then
			LeesSeinbeeld(Trein, tmpConn^.Sein);

		// Als we een nieuw meetpunt binnenrijden dan gaat dat eventueel
		// defect.
		if tmpConn^.isolatiepunt then
			Core.DoeMeetpuntDefect(Trein^.pos_rail^.meetpunt);

		// Als we een wissel op rijden dan raakt dat misschien uit de controle
		if tmpConn^.wissel then
			Core.DoeWisselDefect(tmpConn^.WisselData, false);
		omgConn := ZoekOmgekeerdeConnectie(tmpConn);
		if assigned(omgConn) then
			if omgConn^.wissel then
				Core.DoeWisselDefect(omgConn^.WisselData, false);
	end;
end;

function TpTreinPhysics.ControleerKoppelTrein;
var
	GevKoppelTrein:PpTrein;
	GevTreinAfstand:	double;
	GevOmgekeerd:	boolean;
begin
	Core.ZoekVolgendeTrein(Trein, maxkoppelkijkafstand, GevKoppelTrein, GevTreinAfstand, GevOmgekeerd);
	result := false;
	if assigned(Planpunt) and assigned(GevKoppelTrein) and assigned(GevKoppelTrein^.StationModusPlanpunt) then
		result := (GevTreinAfstand <= maxkoppelkijkafstand) and
					 (GevKoppelTrein^.modus = tmStilstaan) and
					 (GevKoppelTrein^.StationModusPlanpunt^.Station = Planpunt^.Station);
end;

procedure TpTreinPhysics.ActieKoppelen;
var
	tmpWagon:		PpWagonConn;
	tmpPlanpunten:	PpRijplanPunt;
	laatsteWagon: 	PpWagonConn;

	GevKoppelTrein:PpTrein;
	GevTreinAfstand:	double;
	GevOmgekeerd:	boolean;
begin
	Core.ZoekVolgendeTrein(Trein, maxkoppelkijkafstand, GevKoppelTrein, GevTreinAfstand, GevOmgekeerd);

	// Wij gaan koppelen! Wat gebeurt hier precies?
	// a) >>>WIJ>>> >>>HUN>>> -> >>>>>>WIJ>>>>>> (of hun)
	// b) >>>WIJ>>> <<<HUN<<< -> >>>>>>WIJ>>>>>> (of hun)

	// Geval b) vormen wij in geval a) om.
	if GevOmgekeerd then GevKoppelTrein^.DraaiOm(false);

	// Zo, nu hebben we gegarandeerd een geval a). Mooi.
	// Wij nemen de positie van de andere trein aan.
	Trein^.pos_rail := GevKoppelTrein^.pos_rail;
	Trein^.pos_dist := GevKoppelTrein^.pos_dist;
	Trein^.achteruit := GevKoppelTrein^.achteruit;
	// En de wagons van de andere trein plakken we voor de onze.
	tmpWagon := GevKoppelTrein^.EersteWagon;
	laatsteWagon := nil;
	while assigned(tmpWagon) do begin
		laatsteWagon := tmpWagon;
		tmpWagon := tmpWagon^.Volgende;
	end;
	// Als de voorste trein uberhaupt wagons heeft. Anders hoeven
	// we niks te doen.
	if assigned(laatsteWagon) then begin
		laatsteWagon^.Volgende := Trein^.EersteWagon;
		Trein^.EersteWagon^.Vorige := laatsteWagon;
		Trein^.EersteWagon := GevKoppelTrein^.EersteWagon;
	end;
	// Gegevens bijwerken
	Trein^.Update;
	// Als de trein waar we aan vastkoppelen een kleiner nummer heeft
	// dan wijzelf, dan nemen we van die trein het nummer en de
	// planpunten over.
	if TreinnummerGt(Trein^.Treinnummer, GevKoppelTrein^.Treinnummer) then begin
		Trein^.Treinnummer := GevKoppelTrein^.Treinnummer;
		tmpPlanpunten := GevKoppelTrein^.Planpunten;
		GevKoppelTrein^.Planpunten := Trein^.Planpunten;
		Trein^.Planpunten := tmpPlanpunten;
		// Het StationModusPlanPunt hoeven we niet over te nemen, want
		// dat is toch alleen maar een aankomst - wachten tot koppelende
		// trein komt.
		// Het StationModusPlanpunt van de huidige trein houden we echter,
		// omdat daar nog dingen als OMDRAAIEN in kunnen staan!
		// Maar de vertrektijd nemen we wel van de andere trein over!
		if assigned(GevKoppelTrein^.StationmodusPlanpunt) then
			Trein^.StationModusPlanpunt^.Vertrek :=
			GevKoppelTrein^.StationmodusPlanpunt^.Vertrek;
	end;
	// En wis de trein die nu niet meer bestaat.
	GevKoppelTrein^.EersteWagon := nil;
	GevKoppelTrein^.wissen := true;
end;

procedure TpTreinPhysics.ActieLoskoppelen;
var
	GevOmgekeerd:	boolean;
	tmpWagon:		PpWagonConn;
	tmpTrein:		PpTrein;
	wagonshouden:	integer;
	GevRail:			PpRail;
	GevPos:			double;
	i: 				integer;
begin
	Trein^.Update;
	wagonshouden := Trein^.StationModusPlanpunt^.loskoppelen;
	if wagonshouden < 0 then
		wagonshouden := Trein^.aantalwagons + wagonshouden;
	wagonshouden := Trein^.aantalwagons - wagonshouden;
	if (wagonshouden > 0) and (wagonshouden < trein^.AantalWagons) then begin
		tmpWagon := Trein^.EersteWagon;
		for i := 1 to wagonshouden do begin
			tmpWagon := tmpWagon^.Volgende;
		end;
		// De knip komt nu v��r tmpWagon.
		tmpWagon^.Vorige^.Volgende := nil;
		tmpWagon^.Vorige := nil;
		// TmpWagon is nu dus de eerste wagon van de nieuwe trein.
		// Dus nieuwe trein maken en wagons instellen.
		new(tmpTrein);
		tmpTrein^ := TpTrein.Create;
		tmpTrein^.Vorige := nil;
		tmpTrein^.Volgende := Core.pAlleTreinen;
		Core.pAlleTreinen^.Vorige := tmpTrein;
		Core.pAlleTreinen := tmpTrein;
		tmpTrein^.EersteWagon := TmpWagon;
		// Positie van de trein juist instellen.
		Trein^.ZoekEinde(GevRail, GevOmgekeerd, GevPos);
		tmpTrein^.pos_rail := GevRail;
		tmpTrein^.pos_dist := GevPos;
		tmpTrein^.achteruit := not GevOmgekeerd;
		// Rijplan laden.
		tmpTrein^.modus := tmStilstaan;
		tmpTrein^.Treinnummer := Trein^.StationModusPlanpunt^.loskoppelen_w;
		// We laden het rijplan vanaf precies dit station. Want dan
		// gaat het ook goed met treinen die aan twee kanten van de
		// route vleugelen.
		tmpTrein^.Planpunten := Core.CopyDienstFrom(tmpTrein^.Treinnummer, Trein^.StationModusPlanpunt^.Station);
		tmpTrein^.StationModusPlanpunt := tmpTrein^.GetVolgendRijplanpunt;
		tmpTrein^.StationModusPlanpunt^.spc_gedaan := false;
		// Af te wachten tijd instellen
		tmpTrein^.kannietwegvoor := Trein^.kannietwegvoor;
		// Dynamische gegevens overkopi�ren
		tmpTrein^.Update;
		tmpTrein^.baanvaksnelheid := Trein^.baanvaksnelheid;
		tmpTrein^.huidigemaxsnelheid := Trein^.huidigemaxsnelheid;
		tmpTrein^.V_Adviessnelheid := Trein^.V_Adviessnelheid;
		tmpTrein^.B_Adviessnelheid := Trein^.B_Adviessnelheid;
		tmpTrein^.vorigemaxhsnelheid := Trein^.vorigemaxhsnelheid;
		tmpTrein^.vorigebaanvaksnelheid := Trein^.vorigebaanvaksnelheid;
		tmpTrein^.afstandsindsvorige_h := Trein^.afstandsindsvorige_h - Trein^.lengte + tmpTrein^.lengte;
		tmpTrein^.afstandsindsvorige_b := Trein^.afstandsindsvorige_b - Trein^.lengte + tmpTrein^.lengte;
		// Afgekoppelde trein eventueel omkeren.
		if Trein^.StationModusPlanpunt^.loskoppelen_keren then
			tmpTrein^.DraaiOm(not AfkoppelenVanOmgekeerdeTrein);
	end;
end;

procedure TpTreinPhysics.ActiesAfhandelen;
begin
	// We moeten wachten zolang als e.e.a. duurt.
	// Ook als we gaan koppelen is dit juist, want de laatste trein
	// die aankomt (en aan de al gereedstaande trein vastkoppelt)
	// blijft bestaan inclusief moetwacht-tijd.
	if Trein^.StationModusPlanpunt^.minwachttijd > -1 then
		Trein^.Moetwachten(round(Trein^.StationModusPlanpunt^.minwachttijd * (1+(random/2))));
	Trein^.S_Adviessnelheid := -1;

	// 1. KOPPELEN
	if Trein^.StationModusPlanpunt^.samenvoegen then
		if ControleerKoppelTrein(Trein, Trein^.StationModusPlanpunt) then
			ActieKoppelen(Trein);

	// 2. OMDRAAIEN.
	if Trein^.StationModusPlanpunt^.keren then
		Trein^.DraaiOm(true);

	// 3. LOSKOPPELEN (en voor losgekoppeld deel rijplan laden)
	if Trein^.StationModusPlanpunt^.loskoppelen <> 0 then
		ActieLoskoppelen(Trein, Trein^.StationModusPlanpunt^.keren);

	// 4. EN LAATSTE: ONSZELF OMNUMMEREN (en nieuw rijplan laden)
	if Trein^.StationModusPlanpunt^.nieuwetrein then begin
		Trein^.Treinnummer := Trein^.StationModusPlanpunt^.nieuwetrein_w;
		Trein^.WisPlanpunten;
		// We laden het rijplan vanaf precies dit station. Want dan
		// gaat het ook goed met treinen die aan twee kanten van de
		// route vleugelen.
		Trein^.Planpunten := Core.CopyDienstFrom(Trein^.Treinnummer, Trein^.StationModusPlanpunt^.Station);
		dispose(Trein^.StationModusPlanpunt);
		Trein^.StationModusPlanpunt := Trein^.GetVolgendRijplanpunt;
	end;
end;

procedure TpTreinPhysics.ControleerVertrektijd;
type
	TProbleem = (tpOK, tpSein, tpTrein);
var
	vt, mt:		integer;
	gesprek:		PpTelefoongesprek;
	Vertreksein:boolean;
	Waaromstilstaan:	TWaaromStilstaan;
	// Sein zoeken
	tmpRail:		PpRail;
	tmpAchteruit:boolean;
	tmpPos:		double;
	GevSein:		PpSein;
	tmpAfstand: double;
	GevSeinAfstand:	double;
	// Trein zoeken
	GevTrein:	PpTrein;
	GevTreinAfstand: double;
begin
	// Als de vertrektijd bereikt is gaan we rijden.
	if assigned(Trein^.StationModusPlanpunt) and (Trein^.StationModusPlanpunt^.Vertrek <> -1) then
		vt := Trein^.StationModusPlanpunt^.Vertrek
	else
		vt := -1;
	mt := Trein^.kannietwegvoor;
	if Trein^.defect and (TijdVerstreken(Trein^.defecttot)) then begin
		Trein^.defect := false;
		// Kijk of we nog proberen te bellen hierover
		Gesprek := ZoekTelefoongesprek(Trein, ttsKannietweg);
		if assigned(Gesprek) then
			// Zo ja, dan is het probleem opgelost
			CommPhysics.ProbleemOpgelost(Gesprek)
		else
			Trein^.klaarmeldingvereist := true;
	end;
	if (GetTijd>=vt) and (vt <> -1) and ((GetTijd>=mt) or (mt=-1)) and (not Trein^.defect) and
		(Trein^.klaarmeldingvereist) then begin
		Gesprek := ZoekTelefoongesprek(Trein, ttsVertrekBevestiging);
		if not assigned(Gesprek) then begin
			// We moeten om bevestiging vragen voor we vertrekken.
			gesprek := Core.NieuwTelefoongesprek(Trein, tgtBellen, true);
			gesprek^.tekstX := treinklaarmeldingbericht;
			gesprek^.tekstXsoort := pmsKlaarmelding;
			new(PpTreinTelefoonSoort(gesprek^.userdata));
			PpTreinTelefoonSoort(gesprek^.userdata)^ := ttsVertrekBevestiging;
			Gesprek^.OnDestroyUserdata := DestroyUserdata;
		end;
	end;
	if (GetTijd>=vt) and (vt <> -1) and ((GetTijd>=mt) or (mt=-1)) and (not Trein^.defect) and
		(not Trein^.klaarmeldingvereist) then begin
		tmpRail := Trein^.pos_rail;
		tmpAchteruit := Trein^.achteruit;
		tmpPos := Trein^.pos_dist;
		GevSeinAfstand := 0;
		repeat
			Core.ZoekVolgendSein(tmpRail, tmpAchteruit, tmpPos, Treinvooruitblik-GevSeinAfstand, GevSein, tmpAfstand);
			GevSeinAfstand := GevSeinAfstand + tmpAfstand;
		until (not assigned(GevSein)) or IsHoofdsein(GevSein);
		Core.ZoekVolgendeTrein(Trein, Treinvooruitblik, GevTrein, GevTreinAfstand, tmpAchteruit);
		Waaromstilstaan := stWeetniet;
		if assigned(GevSein) and IsHoofdsein(GevSein) then
			if GevSein^.H_MovementAuthority.HasAuthority then
				Vertreksein := true
			else
				if Trein^.doorroodopdracht and (GevSein = trein^.doorroodopd_sein) then
					Vertreksein := true
				else begin
					Vertreksein := false;
					Waaromstilstaan := stSein
				end
		else
			Vertreksein := true;
		if assigned(GevTrein) and (GevTreinAfstand < GevSeinAfstand) then begin
			Vertreksein := false;
			Waaromstilstaan := stTrein
		end;
		if Vertreksein then begin
			// In principe komen we op deze plek maar ��n keer en wordt de modus
			// hier op tmRijden gezet. Tenzij er uiteraard iets mis gaat. Hoe
			// dan ook, eerst maar eens een evt. telefoongesprek wissen over dat
			// we nog geen vertreksein hebben.
			Gesprek := ZoekTelefoongesprek(Trein, ttsStilstaanStation);
			if assigned(Gesprek) then
				CommPhysics.ProbleemOpgelost(Gesprek);
			if Core.GaatDefect(Core.treindefectkans) then begin
				Trein^.defect := true;
				Trein^.defecttot := GetTijd + MkTijd(0,treindefectmintijd,0) +
					round(random * (treindefectmaxtijd-treindefectmintijd)*MkTijd(0,1,0));

				gesprek := Core.NieuwTelefoongesprek(Trein, tgtBellen, true);
				gesprek^.tekstXsoort := pmsVraagOK;
				new(PpTreinTelefoonSoort(gesprek^.userdata));
				PpTreinTelefoonSoort(gesprek^.userdata)^ := ttsKannietweg;
				Gesprek^.OnDestroyUserdata := DestroyUserdata;
				if assigned(Trein^.StationModusPlanpunt) and
					(Trein^.StationModusPlanpunt^.Perron <> '') and
					(Trein^.StationModusPlanpunt^.Perron <> '0') then
					gesprek^.tekstX := HalloTekst(Trein) + treindefectberichtstart +
						treindefectberichten[round(random*treindefectberichtaantal-1)+1]
						+ ' ' + tekstberichtover
				else
					// Als we niet bij een perron staan is 'hij doet het niet'
					// het enige zinvolle excuus.
					gesprek^.tekstX := HalloTekst(Trein) + treindefectberichtstart +
						treindefectberichten[1] + ' ' + tekstberichtover;
			end else begin
				// We kunnen echt echt vertrekken
				Trein^.modus := tmRijden;
				Trein^.Vertraging := (GetTijd - vt) div MkTijd(0,1,0);
				Trein^.kannietwegvoor := -1;
				dispose(Trein^.StationModusPlanpunt);
				Trein^.StationModusPlanpunt := nil;
			end
		end else
			if not assigned(Core.ZoekTelefoongesprek(Trein))
				and not ((waaromstilstaan = Trein^.vorigewaaromstilstaan) // En niet bellen als we hier al over hebben gebeld...
				and (waaromstilstaan = stTrein)) then begin	// ... en het iets is waar maar 1 keer over gebeld moet worden.
				// De uitrijder staat op rood en we hebben daar nog geen
				// telefoongesprek over lopen. Dus opbellen. En bij vertrek bellen
				// we ook echt meteen, want de machinist wil geen vertraging.
				Gesprek := Core.NieuwTelefoongesprek(Trein, tgtBellen, true);
				Gesprek^.OphangenErg := true;
				new(PpTreinTelefoonSoort(Gesprek^.userdata));
				PpTreinTelefoonSoort(Gesprek^.userdata)^ := ttsStilstaanStation;
				Gesprek^.OnDestroyUserdata := DestroyUserdata;
				case Waaromstilstaan of
					stSein: begin
						Gesprek^.tekstX := HalloTekst(Trein) + 'We kunnen vertrekken maar sein '+StringToNato(GevSein^.naam)+' toont nog steeds stop. ' + tekstberichtover;
						Gesprek^.tekstXsoort := pmsStoptonend;
					end;
					stTrein: begin
						Gesprek^.tekstX := HalloTekst(Trein) + 'We kunnen vertrekken maar er staat nog een trein voor ons. ' + tekstberichtover;
						Gesprek^.tekstXsoort := pmsVraagOK;
					end;
				end;
				Trein^.vorigewaaromstilstaan := waaromstilstaan;
			end;
	end;
end;

procedure TpTreinPhysics.WisPlanregelsDieTijdensRijdenNutteloosZijn;
begin
	// Eerst eventjes nutteloze rijplanregels weggooien.
	// Regels zonder aankomsttijd zijn nutteloos omdat we dan nooit verder
	// komen met het procesplan.
	while assigned(Trein^.Planpunten) do
		if (Trein^.Planpunten^.Aankomst = -1) and (Trein^.Planpunten^.stoppen) then
			dispose(Trein^.GetVolgendRijplanpunt)
		else
			break;
end;

procedure TpTreinPhysics.ZetStil;
var
	nieuwevertraging:	integer;
begin
	Trein^.Modus := tmStilstaan;	// We staan stil bij het station.
	// Vertragingsinformatie bijwerken
	nieuwevertraging := (GetTijd - Trein^.Planpunten^.Aankomst) div MkTijd(0,1,0);
	Core.ScoreAankomstVertraging(Trein, nieuwevertraging);
	Trein^.Vertraging := nieuwevertraging;
	// En het rijplanpunt inladen.
	Trein^.StationModusPlanpunt := Trein^.GetVolgendRijplanpunt;
end;

function TpTreinPhysics.MoetTreinStoppenBijPerronpunt;
var
	tmpRail:			PpRail;
	tmpAchteruit:	boolean;
	tmpPos:			double;
	tmpAfstand:		double;
	GevAfstand:		double;
	GevSein:			PpSein;
begin
	result := false;

	// Eerst de eenvoudige cases afhandelen
	if (not assigned(Trein^.Planpunten)) or
		(not Trein^.Planpunten^.stoppen) or
		(not Punt^.Perronpunt) then
		exit;
	if Trein^.Planpunten^.Station <> Punt^.Stationsnaam then
		exit;
	if (Trein^.Planpunten^.Perron = '-') or
		(Trein^.Planpunten^.Perron = '0') or
		(Trein^.Planpunten^.Perron = Punt^.Perronnummer) then begin
		result := true;
		exit;
	end;

	// Het is het juiste station maar het verkeerde perron. Dan wordt het wat
	// ingewikkelder. Tijd voor plan B.
	tmpRail := Trein^.pos_rail;
	tmpAchteruit := Trein^.achteruit;
	tmpPos := Trein^.pos_dist;
	GevAfstand := 0;
	repeat
		Core.ZoekVolgendSein(tmpRail, tmpAchteruit, tmpPos, JuistePerronVooruitblik-GevAfstand, GevSein, tmpAfstand);
		GevAfstand := GevAfstand + tmpAfstand;
		if assigned(GevSein) then begin
			if GevSein^.Perronpunt and
				(GevSein^.Stationsnaam = Trein^.Planpunten^.Station) and
				(GevSein^.Perronnummer = Trein^.Planpunten^.Perron) then
				exit;
			if IsHoofdsein(GevSein) then
				if not GevSein^.H_MovementAuthority.HasAuthority then begin
					result := true;
					exit;
				end;
		end;
	until (not assigned(tmpRail)) or (not assigned(GevSein));
	// Niks gevonden binnen de kijkafstand.
	result := true;
end;

procedure TpTreinPhysics.ControleerStoppen;
var
	kijkafstand:	double;
	tmpRail:			PpRail;
	tmpAchteruit:	boolean;
	tmpPos:			double;
	GevSein:			PpSein;
	GevSeinAfstand:	double;
begin
	// Nu moeten we nog de mogelijke modusovergangen afhandelen. Daarvan is er
	// maar ��n mogelijk, en dat is wanneer we stilstaan langs een perron.
	// Hoe weten we of dat het geval is? Snelheid=0 en verder is het volgende
	// sein een stationsbordje dat voor ons geschikt is.
	if (Trein^.snelheid = 0) and assigned(Trein^.Planpunten) then begin
		if Trein^.Planpunten^.stoppen then begin
			// Kijk of we bij een perronpunt staan.
			KijkAfstand := stationkijkafstand;
			tmpRail := Trein^.pos_rail;
			tmpAchteruit := Trein^.achteruit;
			tmpPos := Trein^.pos_dist;
			Core.ZoekVolgendSein(tmpRail, tmpAchteruit, tmpPos, KijkAfstand,
				GevSein, GevSeinAfstand);
			if (Trein^.Modus <> tmStilstaan) and assigned(GevSein) then
				if MoetTreinStoppenBijPerronpunt(Trein, GevSein) then begin
					// Correct perrongebruik registreren
					if (Trein^.Planpunten^.Perron = '') or
						(Trein^.Planpunten^.Perron = GevSein^.Perronnummer) then
						Core.ScorePerrongebruik(Trein, true)
					else
						Core.ScorePerrongebruik(Trein, false);
					If GevSein^.Perronnummer <> '' then
						// Correct
						ZetStil(Trein)
					else begin
						// Er is in feite geen perron
						// Vertragingsinfo bijwerken
						Trein^.Vertraging := (GetTijd -
							Trein^.Planpunten^.Aankomst) div MkTijd(0,1,0);
						// Naar volgende planpunt springen
						dispose(Trein^.GetVolgendRijplanpunt);
					end;
				end;
				
			// Kijk of we voor een trein staan en moeten gaan koppelen.
			if (Trein^.Modus <> tmStilstaan) and Trein^.Planpunten^.samenvoegen then
				if ControleerKoppelTrein(Trein, Trein^.Planpunten) then
					ZetStil(Trein);
		end;
	end;
end;

procedure TpTreinPhysics.RijTrein;
var
	tmpRail:			PpRail;
	tmpAchteruit:	boolean;
	tmpPos:			double;
	GevSein:			PpSein;
	GevTrein:		PpTrein;
	GevWissel:		PpWissel;
	GevTreinAfstand:	double;
	GevSeinAfstand:	double;
	GevWisselAfstand: double;
	GevAfstand:		double;
	GevOmgekeerd:	boolean;
	basisafstand:	double;
	kijkafstand:	double;
	waaromstilstaan:	TWaaromStilstaan;
	Gesprek:			PpTelefoongesprek;
begin
	// Kijken wat we moeten doen!
	case Trein.Modus of
	tmStilstaan: begin
		if assigned(Trein^.StationModusPlanpunt) then begin
			if not Trein^.StationModusPlanpunt^.spc_gedaan then begin
				ActiesAfhandelen(Trein);
				if assigned(Trein^.StationModusPlanpunt) then
					Trein^.StationModusPlanpunt^.spc_gedaan := true;
			end;
			ControleerVertrektijd(Trein);
		end;
	end;
	tmRijden: begin
		WisPlanregelsDieTijdensRijdenNutteloosZijn(Trein);
		BeweegTrein(Trein);
		ControleerStoppen(Trein);
	end;
	end;

	if (Trein^.snelheid = 0) and (Trein^.modus = tmRijden) then begin
		// We staan stil, maar niet omdat we bij een station staan of niks
		// willen doen. Dan moeten we eventueel de TRDL inlichten.

		// Een rood sein voor onze neus?
		KijkAfstand := TreinVooruitblik;
		tmpRail := Trein^.pos_rail;
		tmpAchteruit := Trein^.achteruit;
		tmpPos := Trein^.pos_dist;
		basisAfstand := 0;
		repeat
			Core.ZoekVolgendSein(tmpRail, tmpAchteruit, tmpPos, KijkAfstand,
				GevSein, GevSeinAfstand);
			if assigned(GevSein) then begin
				if ((not GevSein^.H_MovementAuthority.HasAuthority) and
					 (GevSein^.Autosein or GevSein^.Bediend)) or
					(GevSein^.H_Baanmaxsnelheid = 0) then
					break;
				KijkAfstand := KijkAfstand - GevSeinAfstand;
				basisAfstand := basisAfstand + GevSeinAfstand;
			end;
		until (not assigned(GevSein)) or (not assigned(tmpRail));
		// Een verkeerd ingesteld wissel misschien?
		KijkAfstand := TreinVooruitblik;
		tmpRail := Trein^.pos_rail;
		tmpAchteruit := Trein^.achteruit;
		tmpPos := Trein^.pos_dist;
		basisAfstand := 0;
		repeat
			Core.ZoekVolgendeWissel(tmpRail, tmpAchteruit, tmpPos, KijkAfstand,
				GevWissel, GevWisselAfstand);
			if assigned(GevWissel) then begin
				if not (GevWissel^.stand in [wsRechtdoor, wsAftakkend]) then
					break;
				KijkAfstand := KijkAfstand - GevSeinAfstand;
				basisAfstand := basisAfstand + GevSeinAfstand;
			end;
		until (not assigned(GevWissel)) or (not assigned(tmpRail));
		// Of misschien een trein?
		Core.ZoekVolgendeTrein(Trein, TreinVooruitblik, GevTrein, GevTreinAfstand, GevOmgekeerd);
		// Kijken wat het nu precies is.
		waaromstilstaan := stWeetniet;
		GevAfstand := -1;
		if assigned(GevSein) then begin
			waaromstilstaan := stSein;
			GevAfstand := GevSeinAfstand;
		end;
		if assigned(GevTrein) and ((GevTreinAfstand < GevAfstand) or (GevAfstand = -1)) then begin
			waaromstilstaan := stTrein;
			GevAfstand := GevTreinAfstand;
		end;
		if assigned(GevWissel) and ((GevWisselAfstand < GevAfstand) or (GevAfstand = -1)) then
			waaromstilstaan := stWissel;
		if not Trein^.el_ok then
			waaromstilstaan := stStroom;
		if not Trein^.bedienbaar then
			waaromstilstaan := stStuurstand;
		if Trein^.doorroodgereden and not Trein^.doorroodverderrijden then
			waaromstilstaan := stDoorrood;
		// Nu hebben we de reden. Kijk of we een bericht moeten sturen.
		if (waaromstilstaan <> stWeetniet) and (waaromstilstaan <> stStuurstand) then
			if (not assigned(Core.ZoekTelefoongesprek(Trein)))	// Niet bellen als we al in gesprek zijn
				and not ((waaromstilstaan = Trein^.vorigewaaromstilstaan) // En niet bellen als we hier al over hebben gebeld...
				 and (waaromstilstaan in [stTrein, stStroom, stWissel, stWeetniet])) then begin	// ... en het iets is waar maar 1 keer over gebeld moet worden.
				Gesprek := Core.NieuwTelefoongesprek(Trein, tgtBellen, Waaromstilstaan in [stStroom, stDoorrood, stWissel]);
				Gesprek^.OphangenErg := Waaromstilstaan in [stSein, stDoorrood];
				case Waaromstilstaan of
				stSein: begin
					Gesprek^.tekstX := HalloTekst(Trein) + 'Ik sta al even voor stoptonend sein '+StringToNato(GevSein^.naam)+'. Vergeet u mij niet? ' + tekstberichtover;
					Gesprek^.tekstXsoort := pmsStoptonend;
				end;
				stTrein: begin
					Gesprek^.tekstX := HalloTekst(Trein) + 'Er staat al even een trein voor mij. Vergeet u die niet? ' + tekstberichtover;
					Gesprek^.tekstXsoort := pmsVraagOK;
				end;
				stStroom: begin
					Gesprek^.tekstX := HalloTekst(Trein) + 'Ik sta hier met een elektrische trein zonder stroom! ' + tekstberichtover;
					Gesprek^.tekstXsoort := pmsVraagOK;
				end;
				stDoorrood: begin
					Gesprek^.tekstX := HalloTekst(Trein) + 'Ik ben door rood sein '+StringToNato(Trein^.doorroodgereden_sein^.naam)+' gereden! ' + tekstberichtover;
					Gesprek^.tekstXsoort := pmsSTSpassage;
				end;
				stWissel: begin
					Gesprek^.tekstX := HalloTekst(Trein) + 'Ik sta hier bij wissel '+StringToNato(GevWissel^.w_naam)+' dat niet in een veilige stand ligt. ' + tekstberichtover;
					Gesprek^.tekstXsoort := pmsVraagOK;
				end;
				stStuurstand: begin
					Gesprek^.tekstX := HalloTekst(Trein) + 'Ik kan niet rijden want aan de voorkant van de trein is geen stuurstand. ' + tekstberichtover;
					Gesprek^.tekstXsoort := pmsVraagOK;
				end
				else
					Gesprek^.tekstX := HalloTekst(Trein) + 'Ik bel u op omdat ik stil sta maar weet niet waarom!? ' + tekstberichtover;
					Gesprek^.tekstXsoort := pmsVraagOK;
				end;
				new(PpTreinTelefoonSoort(Gesprek^.userdata));
				PpTreinTelefoonSoort(Gesprek^.userdata)^ := ttsStilstaan;
				Gesprek^.OnDestroyUserdata := DestroyUserdata;
				Trein^.vorigewaaromstilstaan := waaromstilstaan;
			end;
	end else
		if Trein^.modus = tmRijden then begin
			Gesprek := ZoekTelefoongesprek(Trein, ttsStilstaan);
			if assigned(Gesprek) then
				CommPhysics.ProbleemOpgelost(Gesprek);
			Trein^.vorigewaaromstilstaan := stUndef;
		end;
end;

end.
