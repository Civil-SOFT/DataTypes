(***
 * Civil.Utils.Types.CPF.pas;
 *
 * v1.1.0 (Alpha)
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2018 Eng.º Anderson Marques Ribeiro.
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
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *)
unit Civil.Utils.Types.CPF;

interface

uses
	SysUtils, Classes, Math, System.Variants, Generics.Collections, AnsiStrings,
  RegularExpressions, Winapi.Windows, Civil.Utils.Types, Civil.Utils.Types.Endereco;

type

  ECPF = class(Exception)
  public

  	type
    	TCPFErroEnum =
      (
      	ceStringCPFInvalida
      );

    constructor Create(ACodigoErro: TCPFErroEnum);

  strict private

  	var
    	FCodigoErro: TCPFErroEnum;

  public

  	property CodigoErro: TCPFErroEnum read FCodigoErro;

  end; { ECPF }

  TCPF = packed record
  public

  	constructor Create(ACPF: AnsiString);

  strict private

  	type
    	TCPFType = packed array[0..10] of TAnsiDigitoType;
    	TNumeroType = packed array[0..8] of TAnsiDigitoType;
      TDigitoVerifType = packed array[0..1] of TAnsiDigitoType;

    class var
    	FDiag,
      FDiagExtracao: TRegEx;
      FNumeroVal: TNumeroType;
      FDigitoVal: TDigitoVerifType;

  strict private

    class constructor CreateClass;

    function GetNumero: AnsiString;
    procedure SetNumero(AValor: AnsiString);

  public

  	property Numero: AnsiString read GetNumero write SetNumero;
    function Digito: AnsiString; inline;
    function Formatado: AnsiString;
    function Estado: TEstadoArray; inline;

  strict private

  	class function CalcularDigito(ACPF: AnsiString): SmallInt; overload; static;

  public

  	class function CalcularDigito(ACPF: AnsiString; out ADigito: AnsiString): Boolean; overload; static;
  	class function ValidarCPF(ACPF: AnsiString): Boolean; static;
  	class function Extrair(ATexto: AnsiString; out AResultado: TDadosExtraidosArray): Integer; static;

    class operator Implicit(ACPF: AnsiString): TCPF; overload;
    class operator Implicit(ACPF: TCPF): AnsiString; overload;
    class operator Implicit(ACPF: TCPF): Variant; overload;

  strict private

    var
    	case Byte of
	      0: (FCPF: TCPFType);
  	    1: (FNumero: TNumeroType; FDigito: TDigitoVerifType);

  end; { TCPF }
  TCPFArray = array of TCPF;

  function VarCPFCreate(ACPF: AnsiString): Variant;

const

	NULL_CPF: TCPF = (FCPF: '00000000000');

implementation

uses
	Civil.Utils.VariantIds;

(*
 * ECPF.
 * -----------------------------------------------------------------------------
 *)

constructor ECPF.Create(ACodigoErro: TCPFErroEnum);
const

	TABELA_MENSAGENS: array[TCPFErroEnum] of String =
  (
  	'String não contém um CPF válido'
  );

begin
	FCodigoErro := ACodigoErro;

  inherited Create(TABELA_MENSAGENS[ACodigoErro]);
end;

(*
 * TCPF.
 * -----------------------------------------------------------------------------
 *)

constructor TCPF.Create(ACPF: AnsiString);
begin
	Self := ACPF;
end;

class constructor TCPF.CreateClass;
const
	PRODUCAO = '(?<parte1>[0-9]{3})\.?(?<parte2>[0-9]{3})\.?(?<parte3>[0-9]{3})-?(?<digito>[0-9]{2})';
begin
	FDiag := TRegEx.Create('^' + PRODUCAO + '$', [roExplicitCapture, roCompiled]);
  FDiagExtracao := TRegEx.Create(PRODUCAO, [roExplicitCapture, roCompiled]);
end;

function TCPF.GetNumero: AnsiString;
begin
	Result := AnsiString(FNumero);
end;

procedure TCPF.SetNumero(AValor: AnsiString);
var
	intDigito: SmallInt;
begin
	intDigito := CalcularDigito(AValor);

  if intDigito = -1 then
  	raise ECPF.Create(ceStringCPFInvalida);

  AnsiStrings.StrPCopy(FNumero, AValor);
  AnsiStrings.strPCopy(FDigito, Format('%.2d', [intDigito]));
end;

function TCPF.Digito: AnsiString;
begin
	Result := AnsiString(FDigito);
end;

function TCPF.Formatado: AnsiString;
var
	strNumero: AnsiString;
begin
	strNumero := AnsiString(FNumero);
  Result := Copy(FNumero, 1, 3) + '.' + Copy(FNumero, 4, 3) + '.' + Copy(FNumero, 7, 3) + '-' + AnsiString(FDigito);
end;

function TCPF.Estado: TEstadoArray;
begin
	case StrToInt(FNumero[8]) of
		0:
    begin
			// 0 Rio Grande do Sul
    	SetLength(Result, 1);
      Result[0] := eRS;
    end;
    1:
    begin
			// 1	Distrito Federal, Goiás, Mato Grosso, Mato Grosso do Sul e Tocantins
    	SetLength(Result, 5);
      Result[0] := eDF;
      Result[1] := eGO;
      Result[2] := eMT;
      Result[3] := eMS;
      Result[4] := eTO;
    end;
    2:
    begin
			// 2 Amazonas, Pará, Roraima, Amapá, Acre e Rondônia
    	SetLength(Result, 6);
      Result[0] := eAM;
      Result[1] := ePR;
      Result[2] := eRR;
      Result[3] := eAP;
      Result[4] := eAC;
      Result[5] := eRO;
    end;
    3:
    begin
			// 3 Ceará, Maranhão e Piauí
      SetLength(Result, 3);
      Result[0] := eCE;
      Result[1] := eMA;
      Result[2] := ePI;
    end;
    4:
    begin
			// 4 Paraíba, Pernambuco, Alagoas e Rio Grande do Norte
      SetLength(Result, 4);
      Result[0] := ePB;
      Result[1] := ePE;
      Result[2] := eAL;
      Result[3] := eRN;
		end;
    5:
    begin
			// 5 Bahia e Sergipe
      SetLength(Result, 2);
      Result[0] := eBA;
      Result[1] := eSE;
    end;
    6:
    begin
			// 6 Minas Gerais
      SetLength(Result, 1);
      Result[0] := eMG;
    end;
    7:
    begin
			// 7 Rio de Janeiro e Espírito Santo
      SetLength(Result, 2);
      Result[0] := eRJ;
      Result[1] := eES;
    end;
    8:
		begin
    	// 8 São Paulo
      SetLength(Result, 1);
      Result[0] := eSP;
    end;
		9:
    begin
 			// 9 Paraná e Santa Catarina
      SetLength(Result, 2);
      Result[0] := ePR;
      Result[1] := eSC;
    end;
  end;
end;

class function TCPF.CalcularDigito(ACPF: AnsiString): SmallInt;
var
	i, int1, int2, intComp, intCoef: SmallInt;
begin
	Result := -1;
  intComp := Length(ACPF);

	if intComp <> 9 then	Exit;
  {for i := 1 to intComp do
  	if not (ACPF[i] in ['0'..'9']) then
    	Exit;}

  int1 := 0;
  intCoef := 10;
  for i := 1 to intComp do
  begin
  	Inc(int1, intCoef * StrToInt(ACPF[i]));
    Dec(intCoef);
  end;
  int1 := int1 mod 11;

  //if int1 = 10 then int1 := 0;
  if int1 in [0, 1] then
  	int1 := 0
  else
  	int1 := 11 - int1;

  ACPF := ACPF + IntToStr(int1);
  intComp := Length(ACPF);

  int2 := 0;
  intCoef := 11;
  for i := 1 to intComp do
  begin
  	Inc(int2, intCoef * StrToInt(ACPF[i]));
    Dec(intCoef);
  end;
  int2 := int2 mod 11;

  if int2 in [0, 1] then
  	int2 := 0
  else
  	int2 := 11 - int2;

  Result := StrToInt(IntToStr(int1) + IntToStr(int2));
end;

class function TCPF.CalcularDigito(ACPF: AnsiString; out ADigito: AnsiString): Boolean;
var
	intDigito: SmallInt;
begin
	intDigito := CalcularDigito(ACPF);
  Result := False;

  if intDigito = -1 then
    Exit;

  ADigito := Format('%.2d', [intDigito]);
  Result := True;
end;

class function TCPF.ValidarCPF(ACPF: AnsiString): Boolean;
var
	intDigito: SmallInt;
	match: TMatch;
  strTmp: AnsiString;
begin
  match := FDiag.Match(ACPF);
  Result := match.Success;

  if Result then
  with match.Groups do
  begin
  	strTmp := Item[1].Value + Item[2].Value + Item[3].Value;
  	intDigito := CalcularDigito(strTmp);

    if intDigito = -1 then
    begin
    	Result := False;
    	Exit;
    end;

    if intDigito <> StrToInt(Item[4].Value) then
    begin
    	Result := False;
      Exit;
    end;

  	AnsiStrings.StrPCopy(FNumeroVal, strTmp);
    AnsiStrings.StrPCopy(FDigitoVal, Item[4].Value);
  end;
end;

class function TCPF.Extrair(ATexto: AnsiString; out AResultado: TDadosExtraidosArray): Integer;
var
	matches: TMatchCollection;
  i: Integer;
begin
	matches := FDiagExtracao.Matches(ATexto);
  SetLength(AResultado, matches.Count);

  for i := 0 to matches.Count - 1 do
  with AResultado[i] do
  begin
  	Dados := matches.Item[i].Value;
    Posicao := matches.Item[i].Index;
    Valido := ValidarCPF(matches.Item[i].Value);
  end;

  Result := matches.Count;
end;

class operator TCPF.Implicit(ACPF: AnsiString): TCPF;
begin
	if not ValidarCPF(ACPF) then
  	raise ECPF.Create(ceStringCPFInvalida);

  with Result do
  begin
	  FNumero := FNumeroVal;
  	FDigito := FDigitoVal;
  end;
end;

class operator TCPF.Implicit(ACPF: TCPF): AnsiString;
begin
	with ACPF do
		Result := AnsiString(FCPF);
end;

class operator TCPF.Implicit(ACPF: TCPF): Variant;
begin
	Result := VarCPFCreate(ACPF);
end;

(*
 * TCPFVariant.
 * -----------------------------------------------------------------------------
 *)

type

	PCPFDataRec = ^TCPFDataRec;
	TCPFDataRec = packed record 	 // Deve conter 16 bytes.
  	VType: TVarType;        		 // 2 bytes;
    VCPF: TCPF;       			  	 // 11 bytes;
    Unused: array[0..2] of Byte; // 3 byte;
  end; { TCPFDataRec }

  TCPFVariant = class(TInvokeableVariantType)
  public

  	procedure Cast(var Dest: TVarData; const Source: TVarData); override;
    procedure CastTo(var Dest: TVarData; const Source: TVarData; const AVarType: TVarType); override;

    procedure Compare(const Left, Right: TVarData; var Relationship: TVarCompareResult); override;
    function IsClear(const Data: TVarData): Boolean; override;

    procedure Clear(var Data: TVarData); override;
    procedure Copy(var Dest: TVarData; const Source: TVarData; const Indirect: Boolean); override;

    function GetProperty(var Dest: TVarData; const Value: TVarData; const Name: String): Boolean; override;

  end; { TCPFVariant }

var
	__cpfVar: TCPFVariant;

function VarCPFCreate(ACPF: AnsiString): Variant;
begin
	VarClear(Result);
  with TCPFDataRec(Result) do
  begin
  	VType := __cpfVar.VarType;
    VCPF := ACPF;
  end;
end;

procedure TCPFVariant.Cast(var Dest: TVarData; const Source: TVarData);
begin
	case Source.VType of
  	varUString, varString:
    begin
    	Dest.VType := VarType;
      TCPFDataRec(Dest).VCPF := VarDataToStr(Source);
    end;
    varCPF:
    	Dest := Source;
  	else
			RaiseCastError;
  end;
end;

procedure TCPFVariant.CastTo(var Dest: TVarData; const Source: TVarData; const AVarType: TVarType);
begin
	if Source.VType = VarType then
  begin

		case AVarType of
      varUString, varString:
      	VarDataFromStr(Dest, String(TCPFDataRec(Source).VCPF));
      else
      	RaiseCastError;
    end;

  end
  else
  	RaiseCastError;
end;

procedure TCPFVariant.Compare(const Left, Right: TVarData; var Relationship: TVarCompareResult);
begin
	{if TVersionDataRec(Left).VVersion > TVersionDataRec(Right).VVersion then
    Relationship := crGreaterThan
  else if TVersionDataRec(Left).VVersion = TVersionDataRec(Right).VVersion then
  	Relationship := crEqual
  else
  	Relationship := crLessThan;}

  case AnsiCompareStr(AnsiString(TCPFDataRec(Left).VCPF), AnsiString(TCPFDataRec(Right).VCPF)) of
		-1: Relationship := crLessThan;
    0: Relationship := crEqual;
    1: Relationship := crGreaterThan;
  end;
end;

function TCPFVariant.IsClear(const Data: TVarData): Boolean;
begin
	Result := (Data.VType = varEmpty);
end;

procedure TCPFVariant.Clear(var Data: TVarData);
begin
	Data.VType := varEmpty;
end;

procedure TCPFVariant.Copy(var Dest: TVarData; const Source: TVarData; const Indirect: Boolean);
begin
	Dest := Source;
	{with TCPFDataRec(Dest) do
  begin
  	VType := VarType;
    VCPF := TCPFDataRec(Source).VCPF;
  end;}
end;

function TCPFVariant.GetProperty(var Dest: TVarData; const Value: TVarData; const Name: String): Boolean;
begin
	Result := True;

  with TCpfDataRec(Value).VCPF do
		if CompareStr(Name, 'FORMATADO') = 0 then
  		Variant(Dest) := Formatado
	  else if CompareStr(Name, 'NUMERO') = 0 then
  		Variant(Dest) := AnsiString(Numero)
	  else if CompareStr(Name, 'DIGITO') = 0 then
  		Variant(Dest) := Digito
	  else
  		Result := False;
end;

initialization

  __cpfVar := TCPFVariant.Create(varCPF);

finalization

  __cpfVar.Free;

end.
