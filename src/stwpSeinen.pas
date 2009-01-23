unit stwpSeinen;

interface

uses stwpRails;

type
	TSeinbeeld = (sbGroen, sbGeel, sbRood);

	// De TpSein klasse is weloverwogen. Ook de verschillende boolean-dingen.

	// Zo kan een sein zowel PerronPunt als Autovoorsein zijn, in de vorm van
	// een Iyuandos-vertreksein bijvoorbeeld.

	PpSein = ^TpSein;
	TpSein = record
   	Plaats:				PpRailConn;	// Waar staat het sein?
      zichtbaar:			boolean;	// Zichtbaar sein, of AI-stuur-sein?
      naam:					string;
		// Dingen voor hoofdseinen
		Bediend:				boolean;	// Bediend sein?
		Bediend_Stand:		integer;	// 0=stop, 1=rij, 2=geel knipper
		Autosein:			boolean;	// Automatisch P-sein?
		A_Erlaubnis:		pointer;	// Welke Erlaubnis is nodig?
		A_Erlaubnisstand:	byte;		// En op welke stand moet deze staan?
		B_Meetpunt:			pointer;	// Het meetpunt vóór het sein. Automatisch
											// ingesteld door het meetpunt zelf.
      H_Maxsnelheid:		integer;	// km/u geldend vanaf dit sein. Evt. bediend.
											// -1 bij informatieve seinen.
      // Dingen voor voorseinen
   	Autovoorsein:		boolean;	// Is dit een automatisch voorsein?
      V_Adviessnelheid:	integer;	// De max.snelheid die na dit sein aangenomen
      									// moet worden.
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

implementation

end.
