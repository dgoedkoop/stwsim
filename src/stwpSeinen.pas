unit stwpSeinen;

interface

uses stwpRails, stwvMisc;

type
	TSeinbeeld = (sbGroen, sbGeel, sbRood);
	THMovementAuthority = record
		HasAuthority: boolean;
		Baanvaksnelheid: boolean;
		Snelheidsbeperking: integer;
	end;

	// De TpSein klasse is weloverwogen. Ook de verschillende boolean-dingen.

	// Zo kan een sein zowel PerronPunt als Autovoorsein zijn, in de vorm van
	// een Iyuandos-vertreksein bijvoorbeeld.

	PpSein = ^TpSein;
	TpSein = record
		Plaats:				PpRailConn;	// Waar staat het sein?
		zichtbaar:			boolean;	// Zichtbaar sein, of AI-stuur-sein?
		naam:					string;
		// Dingen voor een snelheidsbordje-aankondiging
		V_Baanmaxsnelheid:    integer; // -1 bij nvt.
		// Dingen voor een snelheidsbordje
		H_Baanmaxsnelheid:    integer; // -1 bij nvt.
		// Dingen voor hoofdseinen
		Bediend:				boolean;	// Bediend sein?
		Bediend_Stand:		integer;	// 0=stop, 1=rij, 2=geel knipper
		Autosein:			boolean;	// Automatisch P-sein?
		A_Erlaubnis:		pointer;	// Welke Erlaubnis is nodig?
		A_Erlaubnisstand:	byte;		// En op welke stand moet deze staan?
		B_Meetpunt:			pointer;	// Het meetpunt vóór het sein. Automatisch
											// ingesteld door het meetpunt zelf.
		H_MovementAuthority: THMovementAuthority;
		// Dingen voor voorseinen
   	Autovoorsein:		boolean;	// Is dit een automatisch voorsein?
		V_AdviesAuthority:	THMovementAuthority;
											// Een afspiegeling van het volgende sein.
		// Dingen voor haltes
		Haltevoorsein:		boolean;	// Is dit een aankondiging voor een halte?
		Perronpunt:			boolean;	// Is dit een H-bordje, dat aangeeft waar de
											// trein moet stoppen?
		Perronnummer:		string;	// 1 of 2 of 3a of 21b of zoiets.
		Stationsnaam:		string;	// Zo ja, bij welk station hoort het bord?

		// Defecten
		groendefect:		boolean;
		groendefecttot:	integer;
		geeldefect:			boolean;
		geeldefecttot:		integer;

		// OVERIG
		veranderd:			boolean;
		vanwie:				pointer;				// TClient

		volgende:			PpSein;
	end;

	PpSeinBeperking = ^TpSeinBeperking;
	TpSeinBeperking = record
		Vansein:				PpSein;
		Beperking:			integer;	// Maximum snelheid
		Naarsein:			PpSein;
		Triggersnelheid:	integer; // Geen beperking als naarsein >= triggersnelheid.
		volgende:			PpSeinBeperking;
	end;

function IsHoofdsein(Sein: PpSein): boolean;
function IsVoorsein(Sein: PpSein): boolean;
function IsSnelheidsbordje(Sein: PpSein): boolean;
function AuthorityIdentical(eerste, tweede: THMovementAuthority): boolean;
procedure SaveMA(var f: file; MA: THMovementAuthority);
function LoadMA(var f: file): THMovementAuthority;

implementation

procedure SaveMA;
begin
	boolwrite(f, MA.HasAuthority);
	boolwrite(f, MA.Baanvaksnelheid);
	intwrite(f, MA.Snelheidsbeperking);
end;

function LoadMA;
begin
	boolread(f, result.HasAuthority);
	boolread(f, result.Baanvaksnelheid);
	intread(f, result.Snelheidsbeperking);
end;

function AuthorityIdentical;
begin
	if not (eerste.HasAuthority or tweede.HasAuthority) then
		result := true
	else if (not eerste.HasAuthority) or (not tweede.HasAuthority) then
		result := false
	else if eerste.Baanvaksnelheid and tweede.Baanvaksnelheid then
		result := true
	else if eerste.Baanvaksnelheid or tweede.Baanvaksnelheid then
		result := false
	else
		result := eerste.Snelheidsbeperking = tweede.Snelheidsbeperking
end;

function IsHoofdsein;
begin
	if assigned(sein) then
		result := Sein^.Bediend or Sein^.Autosein or (Sein^.H_Baanmaxsnelheid = 0)
	else
		result := false;
end;

function IsVoorsein;
begin
	if assigned(sein) then
		result := Sein^.Autovoorsein
	else
		result := false;
end;

function IsSnelheidsbordje;
begin
	if assigned(sein) then
		result := Sein^.H_Baanmaxsnelheid > 0
	else
		result := false;
end;

end.
