unit stwpTelefoongesprek;

interface

uses stwpTijd, stwpDatatypes;

type
	TpTelefoongesprekType = (tgtBellen, tgtGebeldWorden);
	TpTelefoongesprekStatus = (tgsSS, tgsSS2, tgsSS3, tgsSB, tgsSB2,
		tgsG1, tgsG2, tgsWachtOpAntwoord, tgsG4, tgsG5, tgsH, tgsE);

	TSender = ^TObject;

	PpTelefoongesprek = ^TpTelefoongesprek;
	TpTelefoongesprek = class
		VolgendeStatusTijd:	integer;	// Voor een wacht-status
		Owner: 			TSender;
		Status:			TpTelefoongesprekStatus;
		tekstX:			string;
		tekstXsoort:	TpMsgSoort;
		tekstOK:			string;
		OphangenErg:	boolean;			// Opnieuw bellen als de trdl ophangt?
		WachtMetBellen:	integer;
		// Voor meer info
		userdata:		pointer;

		volgende:		PpTelefoongesprek;
		// Initialisatie
		constructor Create(Owner: TSender; Soort: TpTelefoongesprekType; Meteen: boolean);
	end;

implementation

const
	mintijd_wachtmetbellen	= 2;
	maxtijd_wachtmetbellen	= 4;
	mintijd_opnemen			= 1/60;
	maxtijd_opnemen			= 20/60;
	tekst_ok						= 'Begrepen!';

constructor TpTelefoongesprek.Create;
begin
	tekstOK := tekst_ok;
	OphangenErg := false;
	Userdata := nil;
	Self.Owner := Owner;
	WachtMetBellen := RandomWachtTijd(mintijd_wachtmetbellen, maxtijd_wachtmetbellen);
	case Soort of
	tgtBellen: begin
		Status := tgsSS;
		if not meteen then
			VolgendeStatusTijd := WachtMetBellen
		else
			VolgendeStatusTijd := GetTijd;
	end;
	tgtGebeldWorden: begin
		Status := tgsSB;
		VolgendeStatusTijd := RandomWachtTijd(mintijd_opnemen, maxtijd_opnemen);
	end;
	end;
end;

end.
