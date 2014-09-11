unit stwsimClientScenario;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, stwpCore;

type
  TstwscScenarioForm = class(TForm)
    okBut: TButton;
    ScenList: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    ScenDescr: TMemo;
    cancelBut: TButton;
    procedure FormShow(Sender: TObject);
    procedure ScenListClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
	private
   	{ Private declarations }
   	ResultLines: TStringList;
      function CheckScenario(var f: Textfile): boolean;
	public
		Core: TpCore;
   	function GetScenarioLines: TStringList;
	end;

var
  stwscScenarioForm: TstwscScenarioForm;

implementation

{$R *.DFM}

function TstwscScenarioForm.GetScenarioLines;
begin
	result := ResultLines;
end;

function TstwscScenarioForm.CheckScenario;
var
   s: string;
   i, code: integer;
   ok: boolean;
begin
	readln(f, s);
   ok := false;
	if copy(s, 1, length(ScenIOMagic)) = ScenIOMagic then begin
     	val(copy(s, length(ScenIOMagic)+1, length(s)-length(ScenIOMagic)), i, code);
      if (code = 0) and (i >= 1) and (i <= CurrentScVersion) then
        	ok := true;
   end;
   if ok then begin
      readln(f, s);
      if (s <> '-') and (s <> Core.simnaam) then
       	ok := false
      else begin
        	readln(f, s);
         if (s <> '-') and (s <> Core.simversie) then
           	ok := false;
      end;
   end;
   result := ok;
end;

procedure TstwscScenarioForm.FormShow(Sender: TObject);
var
	Rec: TSearchRec;
   f: TextFile;
   naam: string;
begin
	ResultLines := TStringList.Create;
	ScenList.Items.Clear;
	ScenList.Items.Add('Standaard');
	if FindFirst(Core.Filedir+'\*.ssc', $2F, Rec) < 0 then exit;
	repeat
   	assignfile(f, Rec.Name);
		{$I-}reset(f);{$I+}
		if ioresult = 0 then begin
	      if CheckScenario(f) then begin
				Naam := ExtractFileName(Rec.Name);
				Naam := copy(Naam, 1, length(Naam)-length(ExtractFileExt(Naam)));
				ScenList.Items.Add(Naam);
	      end;
	      closefile(f);
   	end;
	until FindNext(Rec) <> 0;
   ScenList.ItemIndex := 0;
   ScenListClick(Sender);
end;

procedure TstwscScenarioForm.ScenListClick(Sender: TObject);
var
	f: textfile;
	s: string;
begin
	if ScenList.ItemIndex = -1 then exit;
   ScenDescr.Lines.Clear;
   ResultLines.Clear;
   if ScenList.ItemIndex = 0 then
   	ScenDescr.Lines.Add('Standaardscenario zonder bijzonderheden.')
   else begin
   	assignfile(f, Core.Filedir+'\'+ScenList.Items[ScenList.ItemIndex]+'.ssc');
		{$I-}reset(f);{$I+}
		if ioresult = 0 then begin
	   	if CheckScenario(f) then begin
	      	repeat
	         	readln(f, s);
	            if s <> 'EOT' then
	            	ScenDescr.Lines.Add(s);
	         until (s = 'EOT') or eof(f);
	         ScenDescr.SelStart := 0;
	         ScenDescr.SelLength := 0;
	         while not eof(f) do begin
	         	readln(f, s);
	            ResultLines.Add(s);
	         end;
         end else
	      	ScenDescr.Lines.Add('Scenariobestand is tussentijds gewijzigd! '+
            	'Scenario is nu niet meer geschikt voor deze simulatie.');
	      closefile(f);
      end else
      	ScenDescr.Lines.Add('Fout bij openen bestand!');
   end;
end;

procedure TstwscScenarioForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
	if ModalResult <> mrOk then
      ResultLines.Free;
end;

end.
