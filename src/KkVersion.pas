unit KkVersion;

// Source: http://stackoverflow.com/questions/1717844/how-to-determine-delphi-application-version

interface

function FileDescription: String;
function LegalCopyright: String;
function DateOfRelease: String; // Proprietary
function ProductVersion: String;
function FileVersion: String;

implementation

uses
  Windows, SysUtils, Classes, Math;

function GetVersionInfo(AIdent: String): String;

type
  TLang = packed record
    Lng, Page: WORD;
  end;

  TLangs = array [0 .. 10000] of TLang;

  PLangs = ^TLangs;

var
  BLngs: PLangs;
  BLngsCnt: Cardinal;
  BLangId: String;
  RM: TMemoryStream;
  RS: TResourceStream;
  BP: PChar;
  BL: Cardinal;
  BId: String;

begin
  // Assume error
  Result := '';

  RM := TMemoryStream.Create;
  try
    // Load the version resource into memory
    RS := TResourceStream.CreateFromID(HInstance, 1, RT_VERSION);
    try
      RM.CopyFrom(RS, RS.Size);
    finally
      FreeAndNil(RS);
    end;

    // Extract the translations list
    if not VerQueryValue(RM.Memory, '\\VarFileInfo\\Translation', Pointer(BLngs), BL) then
      Exit; // Failed to parse the translations table
    BLngsCnt := BL div sizeof(TLang);
    if BLngsCnt <= 0 then
      Exit; // No translations available

    // Use the first translation from the table (in most cases will be OK)
    with BLngs[0] do
      BLangId := IntToHex(Lng, 4) + IntToHex(Page, 4);

    // Extract field by parameter
    BId := '\\StringFileInfo\\' + BLangId + '\\' + AIdent;
    if not VerQueryValue(RM.Memory, PChar(BId), Pointer(BP), BL) then
      Exit; // No such field

    // Prepare result
    Result := BP;
  finally
    FreeAndNil(RM);
  end;
end;

function FileDescription: String;
begin
  Result := GetVersionInfo('FileDescription');
end;

function LegalCopyright: String;
begin
  Result := GetVersionInfo('LegalCopyright');
end;

function DateOfRelease: String;
begin
  Result := GetVersionInfo('DateOfRelease');
end;

function ProductVersion: String;
begin
  Result := GetVersionInfo('ProductVersion');
end;

function FileVersion: String;
begin
  Result := GetVersionInfo('FileVersion');
end;

end.
