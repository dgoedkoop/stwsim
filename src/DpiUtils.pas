unit DpiUtils;

interface

uses Windows, Forms, Classes, Controls, StdCtrls, Buttons, ComCtrls;

function SetProcessDPIAware: boolean;
function GetVDPI: integer;
function GetHDPI: integer;
procedure ResizeFormForDPI(Form: TControl);

implementation

const
  LOGPIXELSX = 88;
  LOGPIXELSY = 90;

type
  TSetProcessDPIAware = function: boolean; stdcall;
  TGetDeviceCaps = function(HDC: HDC; nIndex: integer): integer; stdcall;

function SetProcessDPIAware;
var
  dllhandle: cardinal;
  dllfunction: TSetProcessDPIAware;
begin
  dllhandle := LoadLibrary('user32.dll');
  @dllfunction := GetProcAddress(dllhandle, 'SetProcessDPIAware');
  if assigned(dllfunction) then
    result := dllfunction()
  else
    result := false;
  FreeLibrary(dllhandle);
end;

function GetVDPI;
var
  dllhandle: cardinal;
  dllfunction: TGetDeviceCaps;
  Handle: HDC;
begin
  Handle := GetDC(GetDesktopWindow());
  dllhandle := LoadLibrary('gdi32.dll');
  @dllfunction := GetProcAddress(dllhandle, 'GetDeviceCaps');
  if assigned(dllfunction) then
    result := dllfunction(Handle, LOGPIXELSY)
  else
    result := 96;
  FreeLibrary(dllhandle);
  ReleaseDC(GetDesktopWindow(), Handle);
end;

function GetHDPI;
var
  dllhandle: cardinal;
  dllfunction: TGetDeviceCaps;
  Handle: HDC;
begin
  Handle := GetDC(GetDesktopWindow());
  dllhandle := LoadLibrary('gdi32.dll');
  @dllfunction := GetProcAddress(dllhandle, 'GetDeviceCaps');
  if assigned(dllfunction) then
    result := dllfunction(Handle, LOGPIXELSX)
  else
    result := 96;
  FreeLibrary(dllhandle);
  ReleaseDC(GetDesktopWindow(), Handle);
end;

procedure ResizeFormForDPI;
var
   i: integer;
   component: TComponent;
   control: TControl;
   vscale, hscale: double;
begin
   vscale := GetVDPI / 96;
   hscale := GetHDPI / 96;
   for i := 0 to Form.ComponentCount - 1 do begin
      component := Form.Components[i];
      if component.ClassType.InheritsFrom(TControl) then begin
         control := TControl(component);
         control.Width := round(control.Width * hscale);
         control.Height := round(control.Height * vscale);
         control.Left := round(control.Left * hscale);
         control.Top := round(control.Top * vscale);
         if control.ClassType.InheritsFrom(TButton) then
            TButton(control).Font.Size := round(TButton(control).Font.Size * (hscale + vscale) / 2);
         if control.ClassType.InheritsFrom(TSpeedButton) then
            TSpeedButton(control).Font.Size := round(TSpeedButton(control).Font.Size * (hscale + vscale) / 2);
         if control.ClassType.InheritsFrom(TEdit) then
            TEdit(control).Font.Size := round(TEdit(control).Font.Size * (hscale + vscale) / 2);
         if control.ClassType.InheritsFrom(TMemo) then
            TMemo(control).Font.Size := round(TMemo(control).Font.Size * (hscale + vscale) / 2);
         if control.ClassType.InheritsFrom(TLabel) then
            TLabel(control).Font.Size := round(TLabel(control).Font.Size * (hscale + vscale) / 2);
         if control.ClassType.InheritsFrom(TListBox) then
            TListBox(control).Font.Size := round(TListBox(control).Font.Size * (hscale + vscale) / 2);
         if control.ClassType.InheritsFrom(TTabControl) then
            TTabControl(control).Font.Size := round(TTabControl(control).Font.Size * (hscale + vscale) / 2);
         if control.ClassType.InheritsFrom(TCheckBox) then
            TCheckBox(control).Font.Size := round(TCheckBox(control).Font.Size * (hscale + vscale) / 2);
         if control.ClassType.InheritsFrom(TComboBox) then
            TComboBox(control).Font.Size := round(TComboBox(control).Font.Size * (hscale + vscale) / 2);
      end;
   end;
   if Form.ClassType.InheritsFrom(TForm) then begin
      if ((TForm(Form).BorderStyle = bsDialog) or (TForm(Form).BorderStyle = bsSingle))
         and (TForm(Form).BorderIcons <= [biSystemMenu]) then begin
         TForm(Form).Width := round(TForm(Form).Width * hscale);
         TForm(Form).Height := round(TForm(Form).Height * hscale);
      end;
   end;
end;

end.
