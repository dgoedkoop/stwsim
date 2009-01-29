unit stwpMonteur;

interface

type
	TpMonteurStatus = (msWachten, msOnderweg, msRepareren);

	TpMonteurRepareerWat = (mrwWissel);
	TpMonteurOpdracht = record
		Wat:		TpMonteurRepareerWat;
		ID:		string;
	end;

	PpMonteur = ^TpMonteur;
	TpMonteur = class
		Status: TpMonteurStatus;
		VolgendeStatusTijd: integer;
		Opdracht: TpMonteurOpdracht;
		constructor Create;
	end;

implementation

constructor TpMonteur.Create;
begin
	status := msWachten;
end;

end.
