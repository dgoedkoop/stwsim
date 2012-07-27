unit stwpMonteurPhysics;

interface

uses stwpCore, stwpTijd, stwpRails, stwpTelefoongesprek, stwpMonteur,
	stwpMeetpunt, stwpDatatypes;

type
	PpMonteurPhysics = ^TpMonteurPhysics;
	TpMonteurPhysics = class
	private
		Core: PpCore;
		procedure RepareerKlaar(Monteur: PpMonteur);
		procedure RepareerStart(Monteur: PpMonteur);
	public
		constructor Create(Core: PpCore);
		function StuurMonteur(Monteur: PpMonteur; Opdracht: TpMonteurOpdracht): boolean;
		procedure CheckWacht(Monteur: PpMonteur);
	end;

implementation

const
	mintijd_onderweg	= 10;
	maxtijd_onderweg	= 20;
	mintijd_repareren	= 3;
	maxtijd_repareren	= 10;

constructor TpMonteurPhysics.Create;
begin
	self.Core := Core;
end;

function TpMonteurPhysics.StuurMonteur;
begin
	result := false;
	if Monteur.Status <> msWachten then exit;

	Monteur.Status := msOnderweg;
	Monteur.VolgendeStatusTijd := RandomWachtTijd(mintijd_onderweg, maxtijd_onderweg);
	Monteur.Opdracht := Opdracht;
	result := true;
end;

procedure TpMonteurPhysics.RepareerKlaar;
var
	Wissel: PpWissel;
	Gesprek: PpTelefoongesprek;
begin
	case Monteur.Opdracht.Wat of
	mrwWissel: begin
		Wissel := Core.ZoekWissel(Monteur.Opdracht.ID);
		if not assigned(Wissel) then begin
			// XXX Dit mag niet voorkomen.
		end else begin
			if not PpMeetpunt(Wissel^.Meetpunt)^.kortsluitlansiswegensscenario then begin
				PpMeetpunt(Wissel^.Meetpunt)^.kortsluitlans := false;
				PpMeetpunt(Wissel^.Meetpunt)^.veranderd := true;
			end;
			if not (Wissel^.defect = wdDefect) then begin
				Gesprek := Core.NieuwTelefoongesprek(Monteur, tgtBellen, true);
				Gesprek^.tekstX := 'In wissel '+Monteur.Opdracht.ID+' kan ik geen defect ontdekken!';
				Gesprek^.tekstXsoort := pmsVraagOK;
			end else begin
				Wissel^.defect := wdEenmalig;
				Gesprek := Core.NieuwTelefoongesprek(Monteur, tgtBellen, true);
				Gesprek^.tekstX := 'Wissel '+Monteur.Opdracht.ID+' zou nu weer moeten werken!';
				Gesprek^.tekstXsoort := pmsVraagOK;
			end;
			Wissel^.Monteur := nil;
		end;
	end;
	end;
end;

procedure TpMonteurPhysics.RepareerStart;
var
	Wissel: PpWissel;
	Gesprek: PpTelefoongesprek;
begin
	case Monteur.Opdracht.Wat of
		mrwWissel: begin
			Wissel := Core.ZoekWissel(Monteur.Opdracht.ID);
			if not assigned(Wissel) then begin
				Gesprek := Core.NieuwTelefoongesprek(Monteur, tgtBellen, true);
				Gesprek^.tekstX := 'Het gevraagde wissel '+Monteur.Opdracht.ID+' kan ik niet vinden!';
				Gesprek^.tekstXsoort := pmsVraagOK;
				Monteur.Status := msWachten;
			end else begin
				if not PpMeetpunt(Wissel^.Meetpunt)^.kortsluitlansiswegensscenario then begin
					PpMeetpunt(Wissel^.Meetpunt)^.kortsluitlans := true;
					PpMeetpunt(Wissel^.Meetpunt)^.veranderd := true;
				end;
				Wissel^.Monteur := Monteur;
				Monteur.VolgendeStatusTijd := RandomWachtTijd(mintijd_repareren, maxtijd_repareren);
			end;
		end;
	end;
end;

procedure TpMonteurPhysics.CheckWacht;
begin
	if not (Monteur.Status in [msOnderweg, msRepareren]) then exit;
	if not TijdVerstreken(Monteur.VolgendeStatusTijd) then exit;

	case Monteur.Status of
	msOnderweg: begin
		Monteur.Status := msRepareren;
		RepareerStart(Monteur);
	end;
	msRepareren: begin
		Monteur.Status := msWachten;
		RepareerKlaar(Monteur);
	end;
	end;
end;

end.
