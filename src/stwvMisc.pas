unit stwvMisc;

interface

uses Messages, Windows, MMSystem;

const
	WM_CMD_RESPONSE = WM_USER + 1;

type
	TVoorOfAchter = (vaVoor, vaAchter);
	TSaveWhat	  = (swBasis, swStatus);

procedure stringwrite(var f: file; s: string);
procedure stringread(var f: file; var s: string);

procedure doublewrite(var f: file; x: double);
procedure doubleread(var f: file; var x: double);

procedure boolwrite(var f: file; x: boolean);
procedure boolread(var f: file; var x: boolean);

procedure intwrite(var f: file; x: integer);
procedure intread(var f: file; var x: integer);

procedure bytewrite(var f: file; x: byte);
procedure byteread(var f: file; var x: byte);

function Pad(s: string; lengte: integer; waarmee: char; voorofachter: TVoorOfAchter): string;

function LoadSound(naam: string): THandle;
procedure PlaySound(hRes: THandle; loop: boolean);

function StringToNato(s: string): string;

implementation

function StringToNato;
var
	i: integer;
begin
	result := '';
   for i := 1 to length(s) do begin
   	if result <> '' then
      	result := result + ' ';
      case upcase(s[i]) of
      '0': result := result + 'nul';
      '1': result := result + 'één';
      '2': result := result + 'twee';
      '3': result := result + 'drie';
      '4': result := result + 'vier';
      '5': result := result + 'vijf';
      '6': result := result + 'zes';
      '7': result := result + 'zeven';
      '8': result := result + 'acht';
      '9': result := result + 'negen';
      'A': result := result + 'Alfa';
      'B': result := result + 'Bravo';
      'C': result := result + 'Charlie';
      'D': result := result + 'Delta';
      'E': result := result + 'Echo';
      'F': result := result + 'Foxtrot';
      'G': result := result + 'Golf';
      'H': result := result + 'Hotel';
      'I': result := result + 'India';
      'J': result := result + 'Juliett';
      'K': result := result + 'Kilo';
      'L': result := result + 'Lima';
      'M': result := result + 'Mike';
      'N': result := result + 'November';
      'O': result := result + 'Oscar';
      'P': result := result + 'Papa';
      'Q': result := result + 'Quebec';
      'R': result := result + 'Romeo';
      'S': result := result + 'Sierra';
      'T': result := result + 'Tango';
      'U': result := result + 'Uniform';
      'V': result := result + 'Victor';
      'W': result := result + 'Whisky';
      'X': result := result + 'X-ray';
      'Y': result := result + 'Yankee';
      'Z': result := result + 'Zulu';
      end;
   end;
end;

function LoadSound;
var
	hFind: THandle;
begin
	result := 0;
	hFind := FindResource(HInstance, pchar(naam), 'WAVE') ;
	if hFind <> 0 then begin
		result:=LoadResource(HInstance, hFind);
	end;
end;

procedure PlaySound;
var
	Song: PChar;
begin
	if hRes <> 0 then begin
		Song:=LockResource(hRes);
		if Assigned(Song) then
			if loop then
				SndPlaySound(Song, snd_ASync or snd_Memory or snd_Loop)
			else
				SndPlaySound(Song, snd_ASync or snd_Memory);
		UnlockResource(hRes);
	end else
		SndPlaySound(nil, snd_ASync);
end;

function Pad;
begin
	result := s;
	while length(result) < lengte do
		if voorofachter = vaVoor then
			result := waarmee + result
		else
			result := result + waarmee;
end;

procedure stringwrite;
const
	x: char = #0;
begin
	if length(s)>0 then
		blockwrite(f, s[1], length(s));
	blockwrite(f, x, 1);
end;

procedure stringread;
var
	x: char;
begin
	s := '';
	repeat
		blockread(f, x, 1);
		if x <> #0 then
			s := s + x;
	until (x = #0) or eof(f);
end;

procedure boolwrite;
var
	y: byte;
begin
	if x then y := 1 else y := 0;
	blockwrite(f, y, sizeof(y));
end;

procedure boolread;
var
	y: byte;
begin
	blockread(f, y, sizeof(y));
	x := y=1;
end;

procedure doublewrite;
begin
	blockwrite(f, x, sizeof(x));
end;

procedure doubleread;
begin
	blockread(f, x, sizeof(x));
end;

procedure intwrite;
begin
	blockwrite(f, x, sizeof(x));
end;

procedure intread;
begin
	blockread(f, x, sizeof(x));
end;

procedure bytewrite;
begin
	blockwrite(f, x, sizeof(x));
end;

procedure byteread;
begin
	blockread(f, x, sizeof(x));
end;

end.
