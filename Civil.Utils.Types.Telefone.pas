(***
 * Civil.Utils.Types.Telefone.pas;
 *
 * v1.1.0 (Beta)
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

unit Civil.Utils.Types.Telefone;

interface

uses
	SysUtils, Classes, Math, System.Variants, Generics.Collections, Winapi.Windows,
  RegularExpressions, AnsiStrings, Civil.Utils.Types, Civil.Utils.Types.Endereco;

type

  ETelefone = class(Exception)
  public

  	type
    	TTelefoneErroEnum =
      (
      	teStringTelefoneInvalida
      );

    constructor Create(ACodigoErro: TTelefoneErroEnum);

  strict private

  	var
    	FCodigoErro: TTelefoneErroEnum;

  public

  	property CodigoErro: TTelefoneErroEnum read FCodigoErro;

  end; { ETelefone }

  TDDDEnum =
  (
		ddd11,
		ddd12,
		ddd13,
		ddd14,
		ddd15,
		ddd16,
		ddd17,
		ddd18,
		ddd19,
		ddd21,
		ddd22,
		ddd24,
		ddd27,
		ddd28,
		ddd31,
		ddd32,
		ddd33,
		ddd34,
		ddd35,
		ddd37,
		ddd38,
		ddd41,
		ddd42,
		ddd43,
		ddd44,
		ddd45,
		ddd46,
		ddd47,
		ddd48,
		ddd49,
		ddd51,
		ddd53,
		ddd54,
		ddd55,
		ddd61,
		ddd62,
		ddd63,
		ddd64,
		ddd65,
		ddd66,
		ddd67,
		ddd68,
		ddd69,
		ddd71,
		ddd73,
		ddd74,
		ddd75,
		ddd77,
		ddd79,
		ddd81,
		ddd82,
		ddd83,
		ddd84,
		ddd85,
		ddd86,
		ddd87,
		ddd88,
		ddd89,
		ddd91,
		ddd92,
		ddd93,
		ddd94,
		ddd95,
		ddd96,
		ddd97,
		ddd98,
		ddd99
  );

  EDDD = class(Exception)
  public

  	type
	  	TDDDErroEnum =
      (
      	deStringDDDInvalida
      );

    constructor Create(ACodigoErro: TDDDErroEnum);

	strict private

  	var
    	FCodigoErro: TDDDErroEnum;

  public

  	property CodigoErro: TDDDErroEnum read FCodigoErro;

  end; { EDDD }

  TDDD = packed record
  private

		const

		  VALORES_DDD: array[TDDDEnum] of Byte =
		  (
				{ddd11} 11,
				{ddd12} 12,
				{ddd13} 13,
				{ddd14} 14,
				{ddd15} 15,
				{ddd16} 16,
				{ddd17} 17,
				{ddd18} 18,
				{ddd19} 19,
				{ddd21} 21,
				{ddd22} 22,
				{ddd24} 24,
				{ddd27} 27,
				{ddd28} 28,
				{ddd31} 31,
				{ddd32} 32,
				{ddd33} 33,
				{ddd34} 34,
				{ddd35} 35,
				{ddd37} 37,
				{ddd38} 38,
				{ddd41} 41,
				{ddd42} 42,
				{ddd43} 43,
				{ddd44} 44,
				{ddd45} 45,
				{ddd46} 46,
				{ddd47} 47,
				{ddd48} 48,
				{ddd49} 49,
				{ddd51} 51,
				{ddd53} 53,
				{ddd54} 54,
				{ddd55} 55,
				{ddd61} 61,
				{ddd62} 62,
				{ddd63} 63,
				{ddd64} 64,
				{ddd65} 65,
				{ddd66} 66,
				{ddd67} 67,
				{ddd68} 68,
				{ddd69} 69,
				{ddd71} 71,
				{ddd73} 73,
				{ddd74} 74,
				{ddd75} 75,
				{ddd77} 77,
				{ddd79} 79,
				{ddd81} 81,
				{ddd82} 82,
				{ddd83} 83,
				{ddd84} 84,
				{ddd85} 85,
				{ddd86} 86,
				{ddd87} 87,
				{ddd88} 88,
				{ddd89} 89,
				{ddd91} 91,
				{ddd92} 92,
				{ddd93} 93,
				{ddd94} 94,
				{ddd95} 95,
				{ddd96} 96,
				{ddd97} 97,
				{ddd98} 98,
				{ddd99} 99
		  );

			TABELA_ESTADOS: array[TDDDEnum] of TEstadoEnum =
		  (
				{ddd11}	eSP,
				{ddd12}	eSP,
				{ddd13}	eSP,
				{ddd14}	eSP,
				{ddd15}	eSP,
				{ddd16}	eSP,
				{ddd17}	eSP,
				{ddd18}	eSP,
				{ddd19}	eSP,
				{ddd21}	eRJ,
				{ddd22}	eRJ,
				{ddd24}	eRJ,
				{ddd27}	eES,
				{ddd28}	eES,
				{ddd31}	eMG,
				{ddd32}	eMG,
				{ddd33}	eMG,
				{ddd34}	eMG,
				{ddd35} eMG,
				{ddd37}	eMG,
				{ddd38}	eMG,
				{ddd41} ePR,
				{ddd42}	ePR,
				{ddd43}	ePR,
				{ddd44} ePR,
				{ddd45}	ePR,
				{ddd46} ePR,
				{ddd47} eSC,
				{ddd48}	eSC,
				{ddd49}	eSC,
				{ddd51}	eRS,
				{ddd53} eRS,
				{ddd54} eRS,
				{ddd55} eRS,
				{ddd61}	eGO,
				{ddd62}	eGO,
				{ddd63}	eTO,
				{ddd64}	eGO,
				{ddd65}	eMT,
				{ddd66}	eMT,
				{ddd67}	eMS,
				{ddd68}	eAC,
				{ddd69}	eRO,
				{ddd71}	eBA,
				{ddd73}	eBA,
				{ddd74}	eBA,
				{ddd75}	eBA,
				{ddd77}	eBA,
				{ddd79}	eSE,
				{ddd81}	ePE,
				{ddd82}	eAL,
				{ddd83}	ePB,
				{ddd84}	eRN,
				{ddd85} eCE,
				{ddd86} ePI,
				{ddd87} ePE,
				{ddd88} eCE,
				{ddd89} ePI,
				{ddd91} ePA,
				{ddd92}	eAM,
				{ddd93} ePA,
				{ddd94} ePA,
				{ddd95} eRR,
				{ddd96} eAP,
				{ddd97} eAM,
				{ddd98} eMA,
				{ddd99}	eMA
		  );

  public

  	constructor Create(ADDD: TDDDEnum);

  strict private

  	class constructor CreateClass;
    class destructor DestroyClass;

  	var
    	FDDD: TDDDEnum;

  private

		class var
  		FMapDDD: TDictionary<AnsiString, TDDDEnum>;

  public

  	function Estado: TEstado; inline;

  	class operator Implicit(ADDD: TDDD): TDDDEnum; overload; inline;
    class operator Implicit(ADDD: TDDDEnum): TDDD; overload; inline;
    class operator Implicit(ADDD: AnsiString): TDDD; overload; inline;
    class operator Implicit(ADDD: TDDD): AnsiString; overload; inline;
    class operator Implicit(ADDD: TDDD): Variant; overload; inline;

  end; { TDDD }

  function VarDDDCreate(ADDD: AnsiString): Variant; overload;
  function VarDDDCreate(ADDD: TDDDEnum): Variant; overload;

type

  TTipoTelefoneEnum =
  (
    ttFixo,
    ttMovel
  );

  TTelefone = packed record
  public

  	class var
    	DDDPadrao: TDDDEnum;

  	constructor Create(ATelefone: AnsiString);

	strict private

  	class constructor CreateClass;
    //class destructor DestroyClass;

  	type
      //TNumeroType = array[0..8] of TAnsiDigitoType;
      TParte1Type = array[0..4] of TAnsiDigitoType;
      TParte2Type = array[0..3] of TAnsiDigitoType;

		class var
    	FDiag,
      FDiagParte1,
      FDiagParte2: TRegEx;
      //FTokens: TTokenDecomposer;
      FDDDVal: TDDDEnum;
      FParte1Val: TParte1Type;
      FParte2Val: TParte2Type;

  private

  	class var
      FDiagExtracao: TRegEx;

	strict private

    var
    	//FNumero: TNumeroType;
      FParte1: TParte1Type;
      FParte2: TParte2Type;
      FTipo: TTipoTelefoneEnum;

    {function GetNumero: AnsiString;
    procedure SetNumero(AValor: AnsiString);}
    function GetParte1: AnsiString;
    procedure SetParte1(AValor: AnsiString);
    function GetParte2: AnsiString;
    procedure SetParte2(AValor: AnsiString);

  public

  	var
    	DDD: TDDD;

    class function ValidarNumero(ATelefone: AnsiString): Boolean; static;

    property Parte1: AnsiString read GetParte1 write SetParte1;
    property Parte2: AnsiString read GetParte2 write SetParte2;
    property Tipo: TTipoTelefoneEnum read FTipo;
    function Formatado: AnsiString;

  	class function Extrair(ATexto: AnsiString; out AResultado: TDadosExtraidosArray): Integer; static;

    class operator Implicit(ATelefone: AnsiString): TTelefone; overload; inline;
    class operator Implicit(ATelefone: TTelefone): AnsiString; overload; inline;
    class operator Implicit(ATelefone: TTelefone): Variant; overload; inline;

    class operator Equal(ATel1, ATel2: TTelefone): Boolean; inline;
    class operator NotEqual(ATel1, ATel2: TTelefone): Boolean; inline;

  end; { TTelefone }
  TTelefoneArray = array of TTelefone;

  function VarTelefoneCreate(ATelefone: AnsiString): Variant;

const

	NULL_TELEFONE: TTelefone =
  (
  	//FNumero: '000000000';
    FParte1: '00000';
    FParte2: '0000';
    FTipo: ttFixo;
    DDD:
    (
    	FDDD: ddd11
    )
  );

implementation

uses
	Civil.Utils.VariantIds;

(*
 * EDDD.
 * -----------------------------------------------------------------------------
 *)

constructor EDDD.Create(ACodigoErro: TDDDErroEnum);
const

	TABELA_MENSAGENS: array[TDDDErroEnum] of String =
  (
		{teNumeroInvalido} 'Número não corresponde a um DDD válido'
  );

begin
	FCodigoErro := ACodigoErro;

  inherited Create(TABELA_MENSAGENS[ACodigoErro]);
end;

(*
 * TDDD.
 * -----------------------------------------------------------------------------
 *)

constructor TDDD.Create(ADDD: TDDDEnum);
begin
	FDDD := ADDD;
end;

class constructor TDDD.CreateClass;
var
	i: TDDDEnum;
  ddd: TDDD;
begin
	FMapDDD := TDictionary<AnsiString, TDDDEnum>.Create;

  for i := Low(TDDDEnum) to High(TDDDEnum) do
  begin
  	ddd := TDDD.Create(i);
    FMapDDD.Add(AnsiString(ddd), i);
  end;
end;

class destructor TDDD.DestroyClass;
begin
	FMapDDD.Free;
end;

function TDDD.Estado: TEstado;
begin
	Result := TABELA_ESTADOS[FDDD];
end;

class operator TDDD.Implicit(ADDD: TDDD): TDDDEnum;
begin
	Result := ADDD.FDDD;
end;

class operator TDDD.Implicit(ADDD: {AnsiString}TDDDEnum): TDDD;
begin
	Result.FDDD := ADDD;
end;

class operator TDDD.Implicit(ADDD: AnsiString): TDDD;
var
	ddd: TDDDEnum;
begin
	if not FMapDDD.TryGetValue(ADDD, ddd) then
  	raise EDDD.Create(deStringDDDInvalida);

  Result := TDDD.Create(ddd);
end;

class operator TDDD.Implicit(ADDD: TDDD): AnsiString;
begin
	Result := Format('%2d', [ VALORES_DDD[ADDD.FDDD] ]);
end;

class operator TDDD.Implicit(ADDD: TDDD): Variant;
begin
	Result := VarDDDCreate(TDDDEnum(ADDD));
end;

(*
 * TDDDVariant.
 * -----------------------------------------------------------------------------
 *)

type

	PDDDDataRec = ^TDDDDataRec;
	TDDDDataRec = packed record 	  // Deve conter 16 bytes.
  	VType: TVarType;        		  // 2 bytes;
    VDDD: TDDD;       			  	  // 1 bytes;
    Unused: array[0..12] of Byte; // 13 bytes;
  end; { TCPFDataRec }

  TDDDVariant = class(TInvokeableVariantType)
  public

  	procedure Cast(var Dest: TVarData; const Source: TVarData); override;
    procedure CastTo(var Dest: TVarData; const Source: TVarData; const AVarType: TVarType); override;

    procedure Compare(const Left, Right: TVarData; var Relationship: TVarCompareResult); override;
    function IsClear(const Data: TVarData): Boolean; override;

    procedure Clear(var Data: TVarData); override;
    procedure Copy(var Dest: TVarData; const Source: TVarData; const Indirect: Boolean); override;

    function GetProperty(var Dest: TVarData; const Value: TVarData; const Name: String): Boolean; override;

  end; { TDDDVariant }

var
	__dddVar: TDDDVariant;

function VarDDDCreate(ADDD: AnsiString): Variant;
begin
	VarClear(Result);
  with TDDDDataRec(Result) do
  begin
  	VType := __dddVar.VarType;
    VDDD := ADDD;
  end;
end;

function VarDDDCreate(ADDD: TDDDEnum): Variant;
begin
	VarClear(Result);
  with TDDDDataRec(Result) do
  begin
  	VType := __dddVar.VarType;
    VDDD := ADDD;
  end;
end;

procedure TDDDVariant.Cast(var Dest: TVarData; const Source: TVarData);
begin
	case Source.VType of
  	varUString, varString:
    begin
    	Dest.VType := VarType;
      TDDDDataRec(Dest).VDDD := VarDataToStr(Source);
    end;
    varDDD:
    	Dest := Source;
  	else
			RaiseCastError;
  end;
end;

procedure TDDDVariant.CastTo(var Dest: TVarData; const Source: TVarData; const AVarType: TVarType);
begin
	if Source.VType = VarType then
  begin

		case AVarType of
      varUString, varString:
      	VarDataFromStr(Dest, String(TDDDDataRec(Source).VDDD));
      else
      	RaiseCastError;
    end;

  end
  else
  	RaiseCastError;
end;

procedure TDDDVariant.Compare(const Left, Right: TVarData; var Relationship: TVarCompareResult);
begin
	{if TVersionDataRec(Left).VVersion > TVersionDataRec(Right).VVersion then
    Relationship := crGreaterThan
  else if TVersionDataRec(Left).VVersion = TVersionDataRec(Right).VVersion then
  	Relationship := crEqual
  else
  	Relationship := crLessThan;}

  case AnsiCompareStr(AnsiString(TDDDDataRec(Left).VDDD), AnsiString(TDDDDataRec(Right).VDDD)) of
		-1: Relationship := crLessThan;
    0: Relationship := crEqual;
    1: Relationship := crGreaterThan;
  end;
end;

function TDDDVariant.IsClear(const Data: TVarData): Boolean;
begin
	Result := (Data.VType = varEmpty);
end;

procedure TDDDVariant.Clear(var Data: TVarData);
begin
	Data.VType := varEmpty;
end;

procedure TDDDVariant.Copy(var Dest: TVarData; const Source: TVarData; const Indirect: Boolean);
begin
	Dest := Source;
	with TDDDDataRec(Dest) do
  begin
  	VType := VarType;
    VDDD := TDDDDataRec(Source).VDDD;
  end;
end;

function TDDDVariant.GetProperty(var Dest: TVarData; const Value: TVarData; const Name: String): Boolean;
begin
	Result := True;

  with TDDDDataRec(Value).VDDD do
		if CompareStr(Name, 'ESTADO') = 0 then
  		Variant(Dest) := TEstadoEnum(Estado)
	  else
  		Result := False;
end;

(*
 * ETelefone.
 * -----------------------------------------------------------------------------
 *)

constructor ETelefone.Create(ACodigoErro: TTelefoneErroEnum);
const

	TABELA_MENSAGENS: array[TTelefoneErroEnum] of String =
  (
  	'Número de telefone inválido'
  );

begin
	FCodigoErro := ACodigoErro;

  inherited Create(TABELA_MENSAGENS[ACodigoErro]);
end;

(*
 * TTelefone.
 * -----------------------------------------------------------------------------
 *)

constructor TTelefone.Create(ATelefone: AnsiString);
begin
	{ATelefone := Trim(ATelefone);
	if not ValidarNumero(ATelefone) then
  	raise ETelefone.Create(teNumeroInvalido);

  DDD := FDDDVal;
  FNumero := FNumeroVal;

  if Length(ATelefone) in [8, 10] then
  	FTipo := ttFixo
  else
  	FTipo := ttCelular;}
  Self := ATelefone;
end;

class constructor TTelefone.CreateClass;
const

	PRODUCAO = '(((\((?<DDD1>0?[0-9]{2})\))|(?<DDD2>0?[0-9]{2}))\s*)?(?<Parte1>9?[0-9]{4})\s*-?\s*(?<Parte2>[0-9]{4})';

begin
	FDiag := TRegEx.Create('^' + PRODUCAO + '$', [roExplicitCapture, roCompiled]);
  FDiagParte1 := TRegEx.Create('^9?[0-9]{4}$', [roExplicitCapture, roCompiled]);
  FDiagParte2 := TRegEx.Create('^[0-9]{4}$', [roExplicitCapture, roCompiled]);
  FDiagExtracao := TRegEx.Create(PRODUCAO, [roExplicitCapture, roCompiled]);
	DDDPadrao := ddd11;
end;

class function TTelefone.ValidarNumero(ATelefone: AnsiString): Boolean;
var
	match: TMatch;
  strDDD: AnsiString;
begin
  match := FDiag.Match(ATelefone);
  Result := match.Success;

  with match.Groups do
  begin
	  if Result then
  	begin
    	if Length(Trim(Item[1].Value)) > 0 then
		  	strDDD := Item[1].Value
      else
      	strDDD := Item[2].Value;

      if Length(strDDD) > 2 then
      	strDDD := Copy(strDDD, 2, 2);

      if Length(strDDD) = 0 then
      	FDDDVal := DDDPadrao
      else
	      Result := TDDD.FMapDDD.TryGetValue(strDDD, FDDDVal);
  	end;

	  if Result then
  	begin
  		AnsiStrings.StrPLCopy(FParte1Val, Item[3].Value, Min(Length(Item[3].Value), 5));
      AnsiStrings.StrPLCopy(FParte2Val, Item[4].Value, 4);
    end;
  end;
end;

function TTelefone.GetParte1: AnsiString;
begin
	Result := AnsiString(FParte1);
end;

procedure TTelefone.SetParte1(AValor: AnsiString);
begin
	if not FDiagParte1.IsMatch(AValor) then
  	raise ETelefone.Create(teStringTelefoneInvalida);

	AnsiStrings.StrPLCopy(FParte1, AValor, Min(Length(AValor), 5));
end;

function TTelefone.GetParte2: AnsiString;
begin
	Result := AnsiString(FParte2);
end;

procedure TTelefone.SetParte2(AValor: AnsiString);
begin
	if not FDiagParte2.IsMatch(AValor) then
  	raise ETelefone.Create(teStringTelefoneInvalida);

	AnsiStrings.StrPLCopy(FParte2, AValor, 4);
end;

function TTelefone.Formatado: AnsiString;
var
	strParte1, strParte2: AnsiString;
begin
  strParte1 := AnsiString(FParte1);
  strParte2 := AnsiString(FParte2);

	Result := '(' + AnsiString(DDD) + ') ' + strParte1 + '-' + strParte2;
end;

class function TTelefone.Extrair(ATexto: AnsiString; out AResultado: TDadosExtraidosArray): Integer;
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
      Valido := ValidarNumero(matches.Item[i].Value);
    end;

  Result := matches.Count;
end;

class operator TTelefone.Implicit(ATelefone: AnsiString): TTelefone;
begin
	if not ValidarNumero(ATelefone) then
  	raise ETelefone.Create(teStringTelefoneInvalida);

  with Result do
  begin
  	DDD := FDDDVal;
    FParte1 := FParte1Val;
    FParte2 := FParte2Val;
  end;
end;

class operator TTelefone.Implicit(ATelefone: TTelefone): AnsiString;
begin
	with ATelefone do
		Result := AnsiString(DDD) + AnsiString(FParte1) + AnsiString(FParte2);

  if not ValidarNumero(Result) then
  	Result := '';
end;

class operator TTelefone.Implicit(ATelefone: TTelefone): Variant;
begin
	Result := VarTelefoneCreate(ATelefone);
end;

class operator TTelefone.Equal(ATel1, ATel2: TTelefone): Boolean;
begin
	Result := AnsiCompareStr(ATel1, ATel2) = 0;
end;

class operator TTelefone.NotEqual(ATel1, ATel2: TTelefone): Boolean;
begin
	Result := AnsiCompareStr(ATel1, ATel2) <> 0;
end;

(*
 * TTelefoneVariant.
 * -----------------------------------------------------------------------------
 *)

type

	PTelefoneDataRec = ^TTelefoneDataRec;
	TTelefoneDataRec = packed record // Deve conter 16 bytes.
  	VType: TVarType;        	 		 // 2 bytes;
    VTelefone: TTelefone; 			 	 // 11 bytes;
    Unused: packed array[0..2] of Byte; // 3 bytes;
  end; { TCEPDataRec }

  TTelefoneVariant = class(TInvokeableVariantType)
  public

  	procedure Cast(var Dest: TVarData; const Source: TVarData); override;
    procedure CastTo(var Dest: TVarData; const Source: TVarData; const AVarType: TVarType); override;

    procedure Compare(const Left, Right: TVarData; var Relationship: TVarCompareResult); override;
    function IsClear(const Data: TVarData): Boolean; override;

    procedure Clear(var Data: TVarData); override;
    procedure Copy(var Dest: TVarData; const Source: TVarData; const Indirect: Boolean); override;

    function GetProperty(var Dest: TVarData; const Value: TVarData; const Name: String): Boolean; override;

  end; { TTelefoneVariant }

var
	__telefoneVar: TTelefoneVariant;

function VarTelefoneCreate(ATelefone: AnsiString): Variant;
begin
	VarClear(Result);
  with TTelefoneDataRec(Result) do
  begin
  	VType := __telefoneVar.VarType;
    VTelefone := ATelefone;
  end;
end;

procedure TTelefoneVariant.Cast(var Dest: TVarData; const Source: TVarData);
begin
	case Source.VType of
  	varUString, varString:
    begin
    	Dest.VType := VarType;
      TTelefoneDataRec(Dest).VTelefone := VarDataToStr(Source);
    end;
    varTelefone:
    	Dest := Source;
  	else
			RaiseCastError;
  end;
end;

procedure TTelefoneVariant.CastTo(var Dest: TVarData; const Source: TVarData; const AVarType: TVarType);
begin
	if Source.VType = VarType then
  begin

		case AVarType of
      varUString, varString:
      	VarDataFromStr(Dest, AnsiString(TTelefoneDataRec(Source).VTelefone));
      else
      	RaiseCastError;
    end;

  end
  else
  	RaiseCastError;
end;

procedure TTelefoneVariant.Compare(const Left, Right: TVarData; var Relationship: TVarCompareResult);
begin
	{if TVersionDataRec(Left).VVersion > TVersionDataRec(Right).VVersion then
    Relationship := crGreaterThan
  else if TVersionDataRec(Left).VVersion = TVersionDataRec(Right).VVersion then
  	Relationship := crEqual
  else
  	Relationship := crLessThan;}

  case AnsiCompareStr(AnsiString(TTelefoneDataRec(Left).VTelefone), AnsiString(TTelefoneDataRec(Right).VTelefone)) of
		-1: Relationship := crLessThan;
   	0: Relationship := crEqual;
    1: Relationship := crGreaterThan;
 	end
end;

function TTelefoneVariant.IsClear(const Data: TVarData): Boolean;
begin
	Result := (Data.VType = varEmpty);
end;

procedure TTelefoneVariant.Clear(var Data: TVarData);
begin
	Data.VType := varEmpty;
end;

procedure TTelefoneVariant.Copy(var Dest: TVarData; const Source: TVarData; const Indirect: Boolean);
begin
	Dest := Source;
	with TTelefoneDataRec(Dest) do
  begin
  	VType := VarType;
    VTelefone := TTelefoneDataRec(Source).VTelefone;
  end;
end;

function TTelefoneVariant.GetProperty(var Dest: TVarData; const Value: TVarData; const Name: String): Boolean;
begin
	Result := True;

  if CompareStr(Name, 'NUMERO') = 0 then
  with TTelefoneDataRec(Value).VTelefone do
  	Variant(Dest) := Parte1 + Parte2
  else if CompareStr(Name, 'DDD') = 0 then
  	Variant(Dest) := VarDDDCreate(TDDDEnum(TTelefoneDataRec(Value).VTelefone.DDD))
  else if CompareStr(Name, 'PARTE1') = 0 then
  	Variant(Dest) := TTelefoneDataRec(Value).VTelefone.Parte1
  else if CompareStr(Name, 'PARTE2') = 0 then
  	Variant(Dest) := TTelefoneDataRec(Value).VTelefone.Parte2
  else if CompareStr(Name, 'FORMATADO') = 0 then
  	Variant(Dest) := TTelefoneDataRec(Value).VTelefone.Formatado
  else
  	Result := False;
end;

initialization

  __dddVar := TDDDVariant.Create(varDDD);
  __telefoneVar := TTelefoneVariant.Create(varTelefone);

finalization

  __telefoneVar.Free;
  __dddVar.Free;

end.
