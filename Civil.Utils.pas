(***
 * Civil.Utils.pas;
 *
 * v1.0.0 (Alpha)
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2018 Eng.º Anderson Marques Ribeiro (anderson.marques.ribeiro@gmail.com).
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.

 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *)
unit Civil.Utils;

interface

uses
	SysUtils, Classes, System.Variants, TypInfo, Civil.Utils.Types.Version,
  Winapi.Windows;

type

	TInterfaceAdapter<T: IUnknown> = class
  public

  	constructor Create(AReference: T);

  strict private

  	var
    	FReference: T;

  public

  	property Reference: T read FReference;

  end; { TInterfaceAdapter }

	function Hash_djb2a(AData: Pointer; ADataLength: Integer): Cardinal;

  function SetParaString(Info: PTypeInfo; const SetParam; Brackets: Boolean): AnsiString;
	procedure StringParaSet(Info: PTypeInfo; var SetParam; const Value: AnsiString);

  //function GetVersao: TVersion;
  function GetModuleFileName: TFileName;

type

  TEXEVersionData = record
    CompanyName,
    FileDescription: AnsiString;
    FileVersion: TVersion;
    InternalName,
    LegalCopyright,
    LegalTrademarks,
    OriginalFileName,
    ProductName: AnsiString;
    ProductVersion: TVersion;
    Comments,
    PrivateBuild,
    SpecialBuild: AnsiString;
  end;

	function GetEXEVersionData(const FileName: string): TEXEVersionData;
type

	TStreamHelper = class helper for TStream
  public

  	procedure WriteString(AString: AnsiString);
    procedure ReadString(out AString: AnsiString);

  end; { TStreamHelper }

	function Converter(AData: _FILETIME): TDateTime;

implementation

uses
	Civil.Constants, StrUtils;

function Hash_djb2a(AData: Pointer; ADataLength: Integer): Cardinal;
var
  i: integer;
begin
  Result := 5381;
  for i := 1 to ADataLength do
  begin
    Result := ((Result shl 5) xor Result) xor PByte(AData)^;
    AData  := Pointer(NativeUInt(AData) + 1);
  end;
end;
function GetOrdValue(Info: PTypeInfo; const SetParam): Integer;
begin
  Result := 0;

  case GetTypeData(Info)^.OrdType of
    otSByte, otUByte:
      Result := Byte(SetParam);
    otSWord, otUWord:
      Result := Word(SetParam);
    otSLong, otULong:
      Result := Integer(SetParam);
  end;
end;

procedure SetOrdValue(Info: PTypeInfo; var SetParam; Value: Integer);
begin
  case GetTypeData(Info)^.OrdType of
    otSByte, otUByte:
      Byte(SetParam) := Value;
    otSWord, otUWord:
      Word(SetParam) := Value;
    otSLong, otULong:
      Integer(SetParam) := Value;
  end;
end;

function SetParaString(Info: PTypeInfo; const SetParam; Brackets: Boolean): AnsiString;
var
  S: TIntegerSet;
  TypeInfo: PTypeInfo;
  I: Integer;
begin
  Result := '';

  Integer(S) := GetOrdValue(Info, SetParam);
  TypeInfo := GetTypeData(Info)^.CompType^;
  for I := 0 to SizeOf(Integer) * 8 - 1 do
    if I in S then
    begin
      if Result <> '' then
        Result := Result + ',';
      Result := Result + GetEnumName(TypeInfo, I);
    end;
  if Brackets then
    Result := '[' + Result + ']';
end;

procedure StringParaSet(Info: PTypeInfo; var SetParam; const Value: AnsiString);
var
  P: PAnsiChar;
  EnumInfo: PTypeInfo;
  EnumName: AnsiString;
  EnumValue, SetValue: Longint;

  function NextWord(var P: PAnsiChar): AnsiString;
  var
    I: Integer;
  begin
    I := 0;
    // scan til whitespace
    while not (P[I] in [',', ' ', #0,']']) do
      Inc(I);
    SetString(Result, P, I);
    // skip whitespace
    while P[I] in [',', ' ',']'] do
      Inc(I);
    Inc(P, I);
  end;

begin
  SetOrdValue(Info, SetParam, 0);
  if Value = '' then
    Exit;

  SetValue := 0;
  P := PAnsiChar(Value);
  // skip leading bracket and whitespace
  while P^ in ['[',' '] do
    Inc(P);
  EnumInfo := GetTypeData(Info)^.CompType^;
  EnumName := NextWord(P);
  while EnumName <> '' do
  begin
    EnumValue := GetEnumValue(EnumInfo, EnumName);
    if EnumValue < 0 then
    begin
      SetOrdValue(Info, SetParam, 0);
      Exit;
    end;
    Include(TIntegerSet(SetValue), EnumValue);
    EnumName := NextWord(P);
  end;
  SetOrdValue(Info, SetParam, SetValue);
end;

{function __GetVersao(ANomeArq: TFileName): TVersion;
type
	PFFI = ^vs_FixedFileInfo;
var
	F       : PFFI;
  Handle  : Dword;
  Len     : Longint;
  Data    : PChar;
  Buffer  : Pointer;
  Tamanho : Dword;
  pArquivo: PChar;
begin
  Parquivo := StrAlloc(Length(ANomeArq) + 1);
  StrPcopy(pArquivo, ANomeArq);
  Len := GetFileVersionInfoSize(pArquivo, Handle);

	try
	  if Len > 0 then
  	begin
    	Data := StrAlloc(Len + 1);

	    if GetFileVersionInfo(pArquivo, Handle, Len, Data) then
  	  begin
    	  VerQueryValue(Data, '', Buffer, Tamanho);
      	F := PFFI(Buffer);
	      Result := TVersion.Create(HiWord(F^.dwFileVersionMs),
  	                      					 LoWord(F^.dwFileVersionMs),
    	                    					 HiWord(F^.dwFileVersionLs));
	    end;

  	  StrDispose(Data);
	  end;
  finally
	  StrDispose(pArquivo);
  end;
end;

function GetVersao: TVersion;
var
	achr: array[0..MAX_PATH] of Char;
begin
	FillChar(achr, SizeOf(achr), 0);
  GetModuleFileName(hInstance, achr, MAX_PATH);
	Result := __GetVersao(TFileName(achr));
end;}

function GetModuleFileName: TFileName;
{var
	achr: array[0..MAX_PATH] of Char;}
begin
	//FillChar(achr, SizeOf(achr), 0);
  Result := GetModuleName(hInstance{, achr, MAX_PATH});
	//Result := TFileName(achr);
end;

function GetEXEVersionData(const FileName: string): TEXEVersionData;
type
  PLandCodepage = ^TLandCodepage;
  TLandCodepage = record
    wLanguage,
    wCodePage: word;
  end;
var
  dummy,
  len: cardinal;
  buf, pntr: Pointer;
  lang: string;
  str: AnsiString;
begin
  len := GetFileVersionInfoSize(PChar(FileName), dummy);
  if len = 0 then
    RaiseLastOSError;
  GetMem(buf, len);
  try
    if not GetFileVersionInfo(PChar(FileName), 0, len, buf) then
      RaiseLastOSError;

    if not VerQueryValue(buf, '\VarFileInfo\Translation\', pntr, len) then
      RaiseLastOSError;

    lang := Format('%.4x%.4x', [PLandCodepage(pntr)^.wLanguage, PLandCodepage(pntr)^.wCodePage]);

    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\CompanyName'), pntr, len){ and (@len <> nil)} then
      result.CompanyName := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\FileDescription'), pntr, len){ and (@len <> nil)} then
      result.FileDescription := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\FileVersion'), pntr, len){ and (@len <> nil)} then
    begin
    	str := AnsiReverseString(AnsiString( PChar(pntr) ));
      str := Copy(str, Pos('.', str) + 1, Length(str));
      str := AnsiReverseString(str);

      result.FileVersion := str;
    end;
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\InternalName'), pntr, len){ and (@len <> nil)} then
      result.InternalName := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\LegalCopyright'), pntr, len){ and (@len <> nil)} then
      result.LegalCopyright := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\LegalTrademarks'), pntr, len){ and (@len <> nil)} then
      result.LegalTrademarks := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\OriginalFileName'), pntr, len){ and (@len <> nil)} then
      result.OriginalFileName := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\ProductName'), pntr, len){ and (@len <> nil)} then
      result.ProductName := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\ProductVersion'), pntr, len){ and (@len <> nil)} then
		begin
    	str := AnsiReverseString(AnsiString( PChar(pntr) ));
      str := Copy(str, Pos('.', str) + 1, Length(str));
      str := AnsiReverseString(str);

      result.ProductVersion := str;
    end;
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\Comments'), pntr, len){ and (@len <> nil)} then
      result.Comments := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\PrivateBuild'), pntr, len){ and (@len <> nil)} then
      result.PrivateBuild := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\SpecialBuild'), pntr, len){ and (@len <> nil)} then
      result.SpecialBuild := PChar(pntr);
  finally
    FreeMem(buf);
  end;
end;

function Converter(AData: _FILETIME): TDateTime;
var
  SystemTime, LocalTime: TSystemTime;
begin
  if not FileTimeToSystemTime(AData, SystemTime) then
    RaiseLastOSError;
  if not SystemTimeToTzSpecificLocalTime(nil, SystemTime, LocalTime) then
    RaiseLastOSError;

  Result := SystemTimeToDateTime(LocalTime);
end;

(*
 * TInterfaceAdapter.
 * -----------------------------------------------------------------------------
 *)

constructor TInterfaceAdapter<T>.Create(AReference: T);
begin
	inherited Create;

  FReference := AReference;
end;

(*
 * TStreamHelper.
 * -----------------------------------------------------------------------------
 *)

procedure TStreamHelper.WriteString(AString: AnsiString);
var
	i, intComp: Integer;
begin
	intComp := Length(AString);
	Write(intComp, SizeOf(Integer));

	for i := 1 to intComp do
  	Write(AString[i], SizeOf(AnsiChar));
end;

procedure TStreamHelper.ReadString(out AString: AnsiString);
var
	i, intComp: Integer;
  char: AnsiChar;
begin
	AString := '';
	Read(intComp, SizeOf(Integer));
  for i := 0 to intComp - 1 do
	begin
  	Read(char, SizeOf(AnsiChar));
    AString := AString + char;
  end;
end;

end.
