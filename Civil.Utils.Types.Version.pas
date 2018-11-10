(***
 * Civil.Utils.Types.Version.pas;
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

unit Civil.Utils.Types.Version;

interface

uses
	SysUtils, Classes, Types, System.Variants, TypInfo;

type

	(***
   * TVersion;
   *
   * Armazena e gerencia informações de versões de sistemas.
   * ----
   *)
  PVersion = ^TVersion;
	TVersion = packed record
  public

  	type
    	TMajorVersionType = Byte;
      TMinorVersionType = Byte;
      TCorrectionType = Word;

    constructor Create(AMajor: TMajorVersionType; AMinor: TMinorVersionType; ACorrection: TCorrectionType); overload;
    constructor Create(Version: String); overload;

    var
	    Major: TMajorVersionType;
  	  Minor: TMinorVersionType;
    	Correction: TCorrectionType;

    {class operator Implicit(Version: Variant): TVersion;
    class operator Implicit(Version: TVersion): Variant;}

    class operator Implicit(Version: TVersion): String;
    class operator Implicit(Version: String): TVersion;
    class operator Implicit(Version: TVersion): AnsiString;
    class operator Implicit(Version: AnsiString): TVersion;

    class operator Equal(Ver1, Ver2: TVersion): Boolean;
    class operator LessThan(Ver1, Ver2: TVersion): Boolean;
    class operator LessThanOrEqual(Ver1, Ver2: TVersion): Boolean;
    class operator GreaterThan(Ver1, Ver2: TVersion): Boolean;
    class operator GreaterThanOrEqual(Ver1, Ver2: TVersion): Boolean;

  end; { TVersion }
  TVersionArray = array of TVersion;

	TVersionVariant = class(TInvokeableVariantType)
  public

  	procedure Cast(var Dest: TVarData; const Source: TVarData); override;
    procedure CastTo(var Dest: TVarData; const Source: TVarData; const AVarType: TVarType); override;

    procedure Compare(const Left, Right: TVarData; var Relationship: TVarCompareResult); override;
    function IsClear(const Data: TVarData): Boolean; override;

    procedure Clear(var Data: TVarData); override;
    procedure Copy(var Dest: TVarData; const Source: TVarData; const Indirect: Boolean); override;

    function GetProperty(var Dest: TVarData; const Value: TVarData; const Name: String): Boolean; override;
    function SetProperty(const Dest: TVarData; const Name: String; const Value: TVarData): Boolean; override;

  end; { TVersionVariant }

  function VarVersionCreate(Major: TVersion.TMajorVersionType; Minor: TVersion.TMinorVersionType; Correction: TVersion.TCorrectionType): Variant;

const

	NULL_VERSION: TVersion = (Major: 0; Minor: 0; Correction: 0);

implementation

uses
	Civil.Utils.VariantIds;

type

	PVersionDataRec = ^TVersionDataRec;
	TVersionDataRec = packed record // Deve conter 16 bytes.
  	VType: TVarType;        			// 2 bytes;
    VVersion: TVersion;        		// 4 bytes;
    Unused1: Word;                // 2 bytes;
    Unused2: Int64;								// 8 bytes;
  end; { TVersionDataRec }

var
	__versionVar: TVersionVariant;

(*
 * TVersion.
 * -----------------------------------------------------------------------------
 *)

constructor TVersion.Create(AMajor: TMajorVersionType; AMinor: TMinorVersionType; ACorrection: TCorrectionType);
begin
	Major := AMajor;
  Minor := AMinor;
  Correction := ACorrection;
end;

constructor TVersion.Create(Version: String);
begin
	Self := TVersion(Version);
end;

{class operator TVersion.Implicit(Version: Variant): TVersion;
begin
	Result := TVersionDataRec(Version).VVersion;
end;

class operator TVersion.Implicit(Version: TVersion): Variant;
begin
	with Version do
		Result := VarVersionCreate(Major, Minor, Correction);
end;}

class operator TVersion.Implicit(Version: TVersion): String;
begin
	with Version do
		Result := Format('%d.%d.%d', [Major, Minor, Correction]);
end;

class operator TVersion.Implicit(Version: String): TVersion;
var
	aStr: TArray<String>;
begin
	aStr := Version.Split(['.']);

  if Length(aStr) <> 3 then
  	raise EInvalidCast.Create('String não contém dados de versão');

  with Result do
  begin
  	Major := StrToInt(aStr[0]);
    Minor := StrToInt(aStr[1]);
    Correction := StrToInt(aStr[2]);
  end;
end;

class operator TVersion.Implicit(Version: TVersion): AnsiString;
begin
	with Version do
  	Result := Format('%d.%d.%d', [Major, Minor, Correction]);
end;

class operator TVersion.Implicit(Version: AnsiString): TVersion;
var
	str: String;
	aStr: TArray<String>;
begin
	str := Version;
	aStr := str.Split(['.']);

  if Length(aStr) <> 3 then
  	raise EInvalidCast.Create('String não contém dados de versão');

  with Result do
  begin
  	Major := StrToInt(aStr[0]);
    Minor := StrToInt(aStr[1]);
    Correction := StrToInt(aStr[2]);
  end;
end;

class operator TVersion.Equal(Ver1, Ver2: TVersion): Boolean;
begin
	Result := CompareMem(@Ver1, @Ver2, SizeOf(TVersion));
end;

class operator TVersion.LessThan(Ver1, Ver2: TVersion): Boolean;
begin
	Result := True;

  if Ver1.Major < Ver2.Major then Exit;
  if (Ver1.Major = Ver2.Major) and (Ver1.Minor < Ver2.Minor) then Exit;
  if (Ver1.Minor = Ver2.Minor) and (Ver1.Correction < Ver2.Correction) then Exit;

  Result := False;
end;

class operator TVersion.LessThanOrEqual(Ver1, Ver2: TVersion): Boolean;
begin
	Result := True;

  if Ver1.Major <= Ver2.Major then Exit;
  if (Ver1.Major = Ver2.Major) and (Ver1.Minor <= Ver2.Minor) then Exit;
  if (Ver1.Minor = Ver2.Minor) and (Ver1.Correction <= Ver2.Correction) then Exit;

  Result := False;
end;

class operator TVersion.GreaterThan(Ver1, Ver2: TVersion): Boolean;
begin
	Result := True;

  if Ver1.Major > Ver2.Major then Exit;
  if (Ver1.Major = Ver2.Major) and (Ver1.Minor > Ver2.Minor) then Exit;
  if (Ver1.Minor = Ver2.Minor) and (Ver1.Correction > Ver2.Correction) then Exit;

  Result := False;
end;

class operator TVersion.GreaterThanOrEqual(Ver1, Ver2: TVersion): Boolean;
begin
	Result := True;

  if Ver1.Major >= Ver2.Major then Exit;
  if (Ver1.Major = Ver2.Major) and (Ver1.Minor >= Ver2.Minor) then Exit;
  if (Ver1.Minor = Ver2.Minor) and (Ver1.Correction >= Ver2.Correction) then Exit;

  Result := False;
end;

(*
 * TVersionVariant.
 * -----------------------------------------------------------------------------
 *)

function VarVersionCreate(Major: TVersion.TMajorVersionType; Minor: TVersion.TMinorVersionType; Correction: TVersion.TCorrectionType): Variant;
begin
	VarClear(Result);
  with TVersionDataRec(Result) do
  begin
  	VType := __versionVar.VarType;
    VVersion := TVersion.Create(Major, Minor, Correction);
  end;
end;

procedure TVersionVariant.Cast(var Dest: TVarData; const Source: TVarData);
begin
	case Source.VType of
  	varUString, varString:
    begin
    	Dest.VType := VarType;
      TVersionDataRec(Dest).VVersion := TVersion(VarDataToStr(Source));
    end;
  	else
			RaiseCastError;
  end;
end;

procedure TVersionVariant.CastTo(var Dest: TVarData; const Source: TVarData; const AVarType: TVarType);
begin
	if Source.VType = VarType then
  begin

		case AVarType of
      varUString:
      	VarDataFromStr(Dest, String(TVersionDataRec(Source).VVersion));
      else
      	RaiseCastError;
    end;

  end
  else
  	RaiseCastError;
end;

procedure TVersionVariant.Compare(const Left, Right: TVarData; var Relationship: TVarCompareResult);
begin
	if TVersionDataRec(Left).VVersion > TVersionDataRec(Right).VVersion then
    Relationship := crGreaterThan
  else if TVersionDataRec(Left).VVersion = TVersionDataRec(Right).VVersion then
  	Relationship := crEqual
  else
  	Relationship := crLessThan;
end;

function TVersionVariant.IsClear(const Data: TVarData): Boolean;
begin
	Result := (Data.VType = varEmpty) or (TVersionDataRec(Data).VVersion = NULL_VERSION);
end;

procedure TVersionVariant.Clear(var Data: TVarData);
begin
	Data.VType := varEmpty;
end;

procedure TVersionVariant.Copy(var Dest: TVarData; const Source: TVarData; const Indirect: Boolean);
begin
	with TVersionDataRec(Dest) do
  begin
  	VType := VarType;
    VVersion := TVersionDataRec(Source).VVersion;
  end;
end;

function TVersionVariant.GetProperty(var Dest: TVarData; const Value: TVarData; const Name: String): Boolean;
begin
	Result := True;

	if Name = 'MAJOR' then
  	Variant(Dest) := TVersionDataRec(Value).VVersion.Major
  else if Name = 'MINOR' then
  	Variant(Dest) := TVersionDataRec(Value).VVersion.Minor
  else if Name = 'CORRECTION' then
  	Variant(Dest) := TVersionDataRec(Value).VVersion.Correction
  else
  	Result := False;
end;

function TVersionVariant.SetProperty(const Dest: TVarData; const Name: String; const Value: TVarData): Boolean;
begin
	Result := True;

  if Name = 'MAJOR' then
  	PVersionDataRec(@Dest).VVersion.Major := TVersion.TMajorVersionType(Variant(Value))
  else if Name = 'MINOR' then
  	PVersionDataRec(@Dest).VVersion.Minor := TVersion.TMinorVersionType(Variant(Value))
  else if Name = 'CORRECTION' then
  	PVersionDataRec(@Dest).VVersion.Correction := TVersion.TCorrectionType(Variant(Value))
  else
  	Result := False;
end;

initialization

	__versionVar := TVersionVariant.Create(varVersion);

finalization

  __versionVar.Free;

end.
