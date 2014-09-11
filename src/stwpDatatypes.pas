unit stwpDatatypes;

interface

type
	TpTreinModus = (tmStilstaan, tmRijden, tmGecrasht);
	TWisselStand = (wsRechtdoor, wsAftakkend, wsOnbekend, wsEgal);
	TpWisselDefect = (wdHeel, wdEenmalig, wdDefect);
	TpMonteur = (mNiks, mOnderweg, mRepareren);
	TpMsgSoort = (pmsStoptonend, pmsSTSpassage, pmsVraagOK,
						pmsTreinOpdracht, pmsMonteurOpdracht, pmsInfo,
                  pmsKlaarmelding);

implementation

end.
