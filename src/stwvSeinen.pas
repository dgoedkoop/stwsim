unit stwvSeinen;

interface

uses stwvSporen, stwvMeetpunt;

type
	PvSein = ^TvSein;
	TvSein = record
		// Vaste gegevens
		Naam:			string;
		Stand:		string;
		Stand_wens:	string;
		HerroepMeetpunten:PvMeetpuntLijst;	// Welk meetpunten moet vrij zijn om een rijweg
														// direct te kunnen herroepen? (dus
														// zonder approach locking
		Van				: string;
		VanTNVMeetpunt : PvMeetpunt;
		TriggerMeetpunt: PvMeetpunt;
		Aank_Erlaubnis : PvErlaubnis;
		Aank_Erlaubnisstand:	byte;
		// Berekende gegevens
		RijwegenNaarSeinBestaan:	boolean;
		// Dynamische gegevens
		RijwegOnderdeel: pointer;
		DoelVanRijweg  : pointer;
		registered		: boolean;
		changed			: boolean;
		herroepen		: boolean;
		Volgende			: PvSein;
	end;

function SeinZoekHerroepMeetpunt(Sein: PvSein; Meetpunt: PvMeetpunt): boolean;
procedure SeinVoegHerroepMeetpuntToe(Sein: PvSein; Meetpunt: PvMeetpunt);
procedure SeinVerwijderHerroepMeetpunt(Sein: PvSein; Meetpunt: PvMeetpunt);

implementation

procedure SeinVoegHerroepMeetpuntToe;
var
	Punt, NieuwMeetpunt: PvMeetpuntLijst;
begin
	Punt := Sein.HerroepMeetpunten;
	while assigned(Punt) do begin
		if Punt.Meetpunt = Meetpunt then
			exit;
		Punt := Punt^.Volgende;
	end;
	new(NieuwMeetpunt);
	NieuwMeetpunt^.Meetpunt := Meetpunt;
	NieuwMeetpunt^.Volgende := Sein.HerroepMeetpunten;
	Sein.HerroepMeetpunten := NieuwMeetpunt;
end;

function SeinZoekHerroepMeetpunt;
var
	Punt: PvMeetpuntLijst;
begin
	Punt := Sein.HerroepMeetpunten;
	while assigned(Punt) do begin
		if Punt.Meetpunt = Meetpunt then begin
			result := true;
			exit;
		end;
		Punt := Punt^.Volgende;
	end;
	result := false;
end;

procedure SeinVerwijderHerroepMeetpunt;
var
	vorigePunt, Punt: PvMeetpuntLijst;
begin
	vorigePunt := nil;
	Punt := Sein.HerroepMeetpunten;
	while assigned(Punt) do begin
		if Punt.Meetpunt = Meetpunt then begin
			if assigned(vorigePunt) then
				vorigePunt.volgende := Punt.volgende
			else
				Sein.HerroepMeetpunten := Punt.volgende;
			dispose(Punt);
			exit;
		end;
		vorigePunt := Punt;
		Punt := Punt^.Volgende;
	end;
end;

end.
