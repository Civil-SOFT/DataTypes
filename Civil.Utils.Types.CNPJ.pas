(***
 * Civil.Utils.Types.CNPJ.pas;
 *
 * v1.0.1 (Alpha)
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
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *)

unit Civil.Utils.Types.CNPJ;

interface

uses
	SysUtils, Classes, Math, System.Variants, Generics.Collections,
  RegularExpressions, AnsiStrings, Winapi.Windows, Civil.Utils.Types;

type

  ECNPJ = class(Exception)
  public

  	type
    	TCNPJErrorEnum =
      (
      	ceStringCNPJInvalida
      );

    constructor Create(ACodigoErro: TCNPJErrorEnum);

  strict private

  	var
    	FCodigoErro: TCNPJErrorEnum;

  public

  	property CodigoErro: TCNPJErrorEnum read FCodigoErro;

  end; { ECNPJ }

  TCNPJ = packed record
  public

    constructor Create(ACNPJ: AnsiString);

  strict private

  	type
      TCNPJType = packed array[0..13] of TAnsiDigitoType;

      TCNPJNumeroType = packed array[0..7] of TAnsiDigitoType;
      TCNPJFilialType = packed array[0..3] of TAnsiDigitoType;
      TCNPJDigitoType = packed array[0..1] of TAnsiDigitoType;

  	class var
    	FDiag,
      FDiagExtracao: TRegEx;
      FNumeroVal: TCNPJNumeroType;
      FFilialVal: TCNPJFilialType;
      FDigitoVal: TCNPJDigitoType;

  strict private

    class constructor CreateClass;

    //class function ValidarComp(CNPJ: AnsiString; Digito: Boolean): Boolean; static;
    class procedure CalcularDigito(var ACNPJ: TCNPJType); static;

    // UpdateInternalData;
    //
    // Atualiza todas as informações internas da estrutura.
    // ----
    // *************************************************************************
    procedure UpdateInternalData;

    function GetNumero: TCNPJNumeroType;
    function GetFilial: TCNPJFilialType;
    function GetDigito: TCNPJDigitoType;

  public

  	property Numero: TCNPJNumeroType read GetNumero;
    property Filial: TCNPJFilialType read GetFilial;
    property Digito: TCNPJDigitoType read GetDigito;

    function Formatado: AnsiString;

    // Validate;
    //
    // Verifica se o número de CNPJ passado é válido;
    // ----
    // *************************************************************************
    class function ValidarCNPJ(ACNPJ: AnsiString): Boolean; static;

  	// Extrair;
    //
    // Realiza análise no texto passado ao método e extrai todos os números de
    // ---- CNPJ que forem encontrados.
    // *************************************************************************
  	class function Extrair(ATexto: AnsiString; out AResultado: TDadosExtraidosArray): Integer; static;

    class operator Implicit(ACNPJ: TCNPJ): AnsiString; overload; inline;
    class operator Implicit(ACNPJ: AnsiString): TCNPJ; overload; inline;
    class operator Implicit(ACNPJ: TCNPJ): Variant; overload; inline;

    class operator Equal(ACNPJ1, ACNPJ2: TCNPJ): Boolean; inline;
    class operator NotEqual(ACNPJ1, ACNPJ2: TCNPJ): Boolean; inline;

  strict private

  	var
      case Boolean of
      	True: (FCNPJ: TCNPJType);
        False:
        	(FNumero: TCNPJNumeroType;
			     FFilial: TCNPJFilialType;
      		 FDigito: TCNPJDigitoType);

  end; { TCNPJ }
  TCNPJArray = array of TCNPJ;

  function VarCNPJCreate(ACNPJ: AnsiString): Variant;

const

	NULL_CNPJ: TCNPJ = (FCNPJ: '00000000000000');

implementation

uses
	Civil.Utils.VariantIds;

(*
 * ECNPJ.
 * -----------------------------------------------------------------------------
 *)

constructor ECNPJ.Create(ACodigoErro: TCNPJErrorEnum);
const

	MENSAGENS: array[TCNPJErrorEnum] of String =
  (
  	'A string contém um número do CNPJ inválido'
  );

begin
	FCodigoErro := ACodigoErro;

  inherited Create(MENSAGENS[ACodigoErro]);
end;

(*
 * TCNPJ.
 * -----------------------------------------------------------------------------
 *)

constructor TCNPJ.Create(ACNPJ: AnsiString);
begin
  if not ValidarCNPJ(ACNPJ) then
  	raise ECNPJ.Create(ceStringCNPJInvalida);

  FNumero := FNumeroVal;
  FFilial := FFilialVal;
  FDigito := FDigitoVal;
  //AnsiStrings.StrPCopy(FCNPJ, ACNPJ);
end;

class constructor TCNPJ.CreateClass;
const
	PRODUCAO = '(?<numero>[0-9]{2}\.?[0-9]{3}\.?[0-9]{3})/?(?<filial>[0-9]{4})(-?(?<digito>[0-9]{2}))?';
begin
	FDiag := TRegEx.Create('^' + PRODUCAO + '$', [roExplicitCapture, roCompiled]);
  FDiagExtracao := TRegEx.Create(PRODUCAO, [roExplicitCapture, roCompiled]);
end;

{class function TCNPJ.ValidarComp(CNPJ: AnsiString; Digito: Boolean): Boolean;
var
	bytComp: Byte;
begin
	Result := False;
  bytComp := 12;
  if Digito then Inc(bytComp, 2);
	if Length(CNPJ) <> bytComp then Exit;
  Result := True;
end;}

class procedure TCNPJ.CalcularDigito(var ACNPJ: TCNPJType);
const

	DIGITOS_1: array[0..11] of Byte = (5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2);
  DIGITOS_2: array[0..12] of Byte = (6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2);

var
	abytCNPJ: array[0..13] of Byte;
  i: Byte;
  siDigito1, siDigito2: SmallInt;
begin
 	for i := 0 to 11 do
   	abytCNPJ[i] := Byte(StrToInt(ACNPJ[i]));

  siDigito1 := 0;
  for i := 0 to 11 do
    Inc(siDigito1, abytCNPJ[i] * DIGITOS_1[i]);
  siDigito1 := siDigito1 mod 11;

  if siDigito1 < 2 then
  	abytCNPJ[12] := 0
  else
  	abytCNPJ[12] := 11 - siDigito1;

  siDigito2 := 0;
  for i := 0 to 12 do
   	Inc(siDigito2, abytCNPJ[i] * DIGITOS_2[i]);
  siDigito2 := siDigito2 mod 11;

	if siDigito2 < 2 then
  	abytCNPJ[13] := 0
  else
  	abytCNPJ[13] := 11 - siDigito2;

  ACNPJ[12] := AnsiChar(IntToStr(abytCNPJ[12])[1]);
  ACNPJ[13] := AnsiChar(IntToStr(abytCNPJ[13])[1]);
end;

procedure TCNPJ.UpdateInternalData;
begin
	CalcularDigito(FCNPJ);
end;

function TCNPJ.GetNumero: TCNPJNumeroType;
begin
	Result := FNumero;
end;

function TCNPJ.GetFilial: TCNPJFilialType;
begin
	Result := FFilial;
end;

function TCNPJ.GetDigito: TCNPJDigitoType;
begin
	Result := FDigito;
end;

function TCNPJ.Formatado: AnsiString;
begin
 	UpdateInternalData;
  Result := Copy(FCNPJ, 0, 2) + '.' + Copy(FCNPJ, 3, 3) + '.' + Copy(FCNPJ, 6, 3) +
								 '/' + Copy(FCNPJ, 9, 4) + '-' + Copy(FCNPJ, 13, 2);
end;

class function TCNPJ.ValidarCNPJ(ACNPJ: AnsiString): Boolean;

	procedure RemoverPontos(var ANumero: AnsiString);
  begin
  	ANumero := AnsiReplaceStr(ANumero, '.', '');
  end;

var
	tmp: AnsiString;
  tmp2: TCNPJType;
	match: TMatch;
  i: Integer;
begin
	RemoverPontos(ACNPJ);
	match := FDiag.Match(ACNPJ);
  Result := match.Success;

  if Result then
  begin
  	AnsiStrings.StrPCopy(FNumeroVal, match.Groups.Item[1].Value);
    AnsiStrings.StrPCopy(FFilialVal, match.Groups.Item[2].Value);
    AnsiStrings.StrPCopy(FDigitoVal, match.Groups.Item[3].Value);

  	tmp := AnsiString(FNumeroVal) + AnsiString(FFilialVal) + AnsiString(FDigitoVal);

    // Obs.: Por um motivo que não fui capaz de determinar, usando a função
    //			 AnsiString.StrPCopy ocorre um erro no código que usa esta classe.
    //			 Portanto, a cópia do conteúdo de tmp para tmp2 deve ser feita manu-
    //			 almente.
    for i := 1 to Length(tmp) do
    	tmp2[i - 1] := tmp[i];
    CalcularDigito(tmp2);

    Result := AnsiCompareStr(AnsiString(tmp2), tmp) = 0;
  end;
end;

class function TCNPJ.Extrair(ATexto: AnsiString; out AResultado: TDadosExtraidosArray): Integer;
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
    Valido := ValidarCNPJ(Dados);
  end;
  Result := matches.Count;
end;

class operator TCNPJ.Implicit(ACNPJ: TCNPJ): AnsiString;
begin
	Result := AnsiString(ACNPJ.FCNPJ);
end;

class operator TCNPJ.Implicit(ACNPJ: AnsiString): TCNPJ;
begin
	Result := TCNPJ.Create(ACNPJ);
end;

class operator TCNPJ.Implicit(ACNPJ: TCNPJ): Variant;
begin
	Result := VarCNPJCreate(ACNPJ);
end;

class operator TCNPJ.Equal(ACNPJ1, ACNPJ2: TCNPJ): Boolean;
begin
	Result := AnsiCompareStr(AnsiString(ACNPJ1), AnsiString(ACNPJ2)) = 0;
end;

class operator TCNPJ.NotEqual(ACNPJ1, ACNPJ2: TCNPJ): Boolean;
begin
	Result := AnsiCompareStr(AnsiString(ACNPJ1), AnsiString(ACNPJ2)) <> 0;
end;

(*
 * TCNPJVariant.
 * -----------------------------------------------------------------------------
 *)

type

	PCNPJDataRec = ^TCNPJDataRec;
	TCNPJDataRec = packed record // Deve conter 16 bytes.
  	VType: TVarType;        	 // 2 bytes;
    VCNPJ: TCNPJ;       			 // 14 bytes;
  end; { TCEPDataRec }

  TCNPJVariant = class(TInvokeableVariantType)
  public

  	procedure Cast(var Dest: TVarData; const Source: TVarData); override;
    procedure CastTo(var Dest: TVarData; const Source: TVarData; const AVarType: TVarType); override;

    procedure Compare(const Left, Right: TVarData; var Relationship: TVarCompareResult); override;
    function IsClear(const Data: TVarData): Boolean; override;

    procedure Clear(var Data: TVarData); override;
    procedure Copy(var Dest: TVarData; const Source: TVarData; const Indirect: Boolean); override;

    function GetProperty(var Dest: TVarData; const Value: TVarData; const Name: String): Boolean; override;

  end; { TCNPJVariant }

var
	__cnpjVar: TCNPJVariant;

function VarCNPJCreate(ACNPJ: AnsiString): Variant;
begin
	VarClear(Result);
  with TCNPJDataRec(Result) do
  begin
  	VType := __cnpjVar.VarType;
    VCNPJ := ACNPJ;
  end;
end;

procedure TCNPJVariant.Cast(var Dest: TVarData; const Source: TVarData);
begin
	case Source.VType of
  	varUString, varString:
    begin
    	Dest.VType := VarType;
      TCNPJDataRec(Dest).VCNPJ := VarDataToStr(Source);
    end;
    varCNPJ:
    	Dest := Source;
  	else
			RaiseCastError;
  end;
end;

procedure TCNPJVariant.CastTo(var Dest: TVarData; const Source: TVarData; const AVarType: TVarType);
begin
	if Source.VType = VarType then
  begin

		case AVarType of
      varUString, varString:
      	VarDataFromStr(Dest, AnsiString(TCNPJDataRec(Source).VCNPJ));
      else
      	RaiseCastError;
    end;

  end
  else
  	RaiseCastError;
end;

procedure TCNPJVariant.Compare(const Left, Right: TVarData; var Relationship: TVarCompareResult);
begin
	{if TVersionDataRec(Left).VVersion > TVersionDataRec(Right).VVersion then
    Relationship := crGreaterThan
  else if TVersionDataRec(Left).VVersion = TVersionDataRec(Right).VVersion then
  	Relationship := crEqual
  else
  	Relationship := crLessThan;}

  case AnsiCompareStr(AnsiString(TCNPJDataRec(Left).VCNPJ), AnsiString(TCNPJDataRec(Right).VCNPJ)) of
		-1: Relationship := crLessThan;
    0: Relationship := crEqual;
    1: Relationship := crGreaterThan;
  end;
end;

function TCNPJVariant.IsClear(const Data: TVarData): Boolean;
begin
	Result := (Data.VType = varEmpty);
end;

procedure TCNPJVariant.Clear(var Data: TVarData);
begin
	Data.VType := varEmpty;
end;

procedure TCNPJVariant.Copy(var Dest: TVarData; const Source: TVarData; const Indirect: Boolean);
begin
	with TCNPJDataRec(Dest) do
  begin
  	VType := VarType;
    VCNPJ := TCNPJDataRec(Source).VCNPJ;
  end;
end;

function TCNPJVariant.GetProperty(var Dest: TVarData; const Value: TVarData; const Name: String): Boolean;
begin
	Result := True;

  with TCNPJDataRec(Value).VCNPJ do
	  if CompareStr(Name, 'FORMATADO') = 0 then
  		Variant(Dest) := Formatado
	  else if CompareStr(Name, 'NUMERO') = 0 then
  		Variant(Dest) := AnsiString(Numero)
    else if CompareStr(Name, 'FILIAL') = 0 then
    	Variant(Dest) := AnsiString(Filial)
	  else if CompareStr(Name, 'DIGITO') = 0 then
  		Variant(Dest) := AnsiString(Digito)
	  else
  		Result := False;
end;

initialization

  __cnpjVar := TCNPJVariant.Create(varCNPJ);

finalization

  __cnpjVar.Free;

end.
