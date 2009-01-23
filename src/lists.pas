////////////////////////////////////////////////////////////////////////////////
//
// LISTS.PAS - Pascal unit for dynamic pointer lists
// Copyright (c) 2001, 2004, Daan Goedkoop
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//
// - Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
//
// - Redistributions in binary form must reproduce the above copyright
// notice, this list of conditions and the following disclaimer in the
// documentation and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
// IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

{***************************************************************************
The LISTS unit provides the tPointerList object, to store pointers
dynamically.
***************************************************************************}

unit lists;

interface

{$DEFINE DEBUG}

{$IFDEF DEBUG}
uses Dialogs, sysutils;
{$ENDIF}

type
	{VERY USEFULL FOR LISTS}
	tPointerListItem = pointer;
	tData = array[0..15] of tPointerListItem;
	pData = ^tData;
	tPointerList = class
	private
		{$IFDEF DEBUG}
		bin: longint;
		{$ENDIF}
		data: pData;		{the pointers}
		capacity: Longint;	{the assigned memory}
		function Realloc(cnt: Longint): tPointerList;
	public
		count: longint;		{the used pointers}
		constructor Create(cnt: Longint);
		procedure Add(adddata: pointer);
		function Get(item: Longint): pointer;
		function Remove(item: Longint): pointer;
		procedure Swap(item1, item2: longint);
		destructor Destroy; override;
	end;

implementation
{-------------------------------------------------------------------------------
COMMON THINGS
-------------------------------------------------------------------------------}
procedure giveError(msg: string);
begin
//	MessageDlg(msg, mtWarning, [mbOk], 0);
end;

{-------------------------------------------------------------------------------
THINGS WITH LISTS
-------------------------------------------------------------------------------}
{Create a new list}
constructor tPointerList.Create(cnt: Longint);
begin
	inherited Create;
	getMem(data, cnt*sizeof(tPointerListItem));
	capacity := cnt;
	count := 0;
	{$IFDEF DEBUG}
	bin := 0;
	{$ENDIF}
end;
{Reallocate the list}
function tPointerList.Realloc;
var
	newlist: pData;
begin
	if cnt < self.count then begin
		result := self;
		giveError('Realloc: new size too small to store old elements');
		exit;
	end;
	getMem(newlist, cnt*sizeof(tPointerListItem));
	move(data^[0], newlist^[0], (count)*sizeof(tPointerListItem));
	FreeMem(data, capacity*sizeof(tPointerListItem));
	capacity := cnt;
	data := newList;
	realloc := self;
end;
{Add something to the list}
procedure tPointerList.Add;
begin
	if count = capacity then begin {Enlarge list if necessary}
		Realloc(capacity+10);
	end;
	data^[count] := adddata;
	inc(count);
	{$IFDEF DEBUG}
	inc(bin);
	{$ENDIF}
end;
{Get something from the list}
function tPointerList.Get;
begin
	Get := nil;
	if item >= count then begin
		giveError('GetFromList: Index out of bounds');
		exit;
	end;
	Get := data^[item];
end;
{Remove something from the list}
function tPointerList.Remove;
begin
	remove := nil;
	if count = 0 then begin
		giveError('RemoveFromList: No more items to remove');
		exit;
	end;
	if item >= count then begin
		giveError('RemoveFromList: Index out of bounds');
		exit;
	end;
	dec(count);
	result := data^[item];
	data^[item] := data^[count];
//	move(data^[item+1], data^[item], (count-item)*4);
	if count <= capacity-10 then {Shrink list if nessessary}
		realloc(count);
	{$IFDEF DEBUG}
	dec(bin);
	{$ENDIF}
end;

{Swap two items in the list}
procedure tPointerList.Swap;
var
	s1, s2: pointer;
begin
	s1 := Data[item1];
	s2 := Data[item2];
	Data[item1] := s2;
	Data[item2] := s1;
end;

{Dispose list}
destructor tPointerList.Destroy;
begin
	FreeMem(data, capacity*sizeof(tPointerListItem));;
	{$IFDEF DEBUG}
	if bin > 0 then
		ShowMessage(inttostr(bin));
	{$ENDIF}
end;

end.
