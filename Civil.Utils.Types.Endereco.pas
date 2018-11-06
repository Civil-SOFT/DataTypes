(***
 * Civil.Utils.Types.Endereco.pas;
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
unit Civil.Utils.Types.Endereco;

interface

uses
	SysUtils, Classes, Math, System.Variants, Generics.Collections,NativeXml,
  RegularExpressions, AnsiStrings, Winapi.Windows, Civil.Utils.Types{,
  TextToolsLib.TokenAnalysis};

type

  EEstado = class(Exception)
  public

  	type
    	TEstadoErroEnum =
      (
      	eeStringEstadoInvalida
      );

    constructor Create(ACodigoErro: TEstadoErroEnum);

  strict private

  	var
    	FCodigoErro: TEstadoErroEnum;

  public

  	property CodigoErro: TEstadoErroEnum read FCodigoErro;

  end; { EEstado }

  TEstadoEnum =
  (
		eAC,
		eAL,
		eAP,
		eAM,
		eBA,
		eCE,
		eDF,
		eES,
		eGO,
		eMA,
		eMT,
		eMS,
		eMG,
		ePA,
		ePB,
		ePR,
		ePE,
		ePI,
		eRJ,
		eRN,
		eRS,
		eRO,
		eRR,
		eSC,
		eSP,
		eSE,
		eTO
  );
  TEstadoEnumArray = array of TEstadoEnum;

  TEstado = packed record
  private

		const

			TABELA_NOMES: array[TEstadoEnum] of AnsiString =
		  (
				{eAC} 'Acre',
				{eAL} 'Alagoas',
				{eAP} 'Amapá',
				{eAM} 'Amazonas',
				{eBA} 'Bahia',
				{eCE} 'Ceará',
				{eDF} 'Distrito Federal',
				{eES} 'Espírito Santo',
				{eGO} 'Goiás',
				{eMA} 'Maranhão',
				{eMT} 'Mato Grosso',
				{eMS} 'Mato Grosso do Sul',
				{eMG} 'Minas Gerais',
				{ePA} 'Pará',
				{ePB} 'Paraíba',
				{ePR} 'Paraná',
				{ePE} 'Pernambuco',
				{ePI} 'Piauí',
				{eRJ} 'Rio de Janeiro',
				{eRN} 'Rio Grande do Norte',
				{eRS} 'Rio Grande do Sul',
				{eRO} 'Rondônia',
				{eRR} 'Roraima',
				{eSC} 'Santa Catarina',
				{eSP} 'São Paulo',
				{eSE} 'Sergipe',
				{eTO} 'Tocantins'
		  );

			TABELA_ABREV: array[TEstadoEnum] of AnsiString =
		  (
				{eAC} 'AC',
				{eAL} 'AL',
				{eAP} 'AP',
				{eAM} 'AM',
				{eBA} 'BA',
				{eCE} 'CE',
				{eDF} 'DF',
				{eES} 'ES',
				{eGO} 'GO',
				{eMA} 'MA',
				{eMT} 'MT',
				{eMS} 'MS',
				{eMG} 'MG',
				{ePA} 'PA',
				{ePB} 'PB',
				{ePR} 'PR',
				{ePE} 'PE',
				{ePI} 'PI',
				{eRJ} 'RJ',
				{eRN} 'RN',
				{eRS} 'RS',
				{eRO} 'RO',
				{eRR} 'RR',
				{eSC} 'SC',
				{eSP} 'SP',
				{eSE} 'SE',
				{eTO} 'TO'
		  );

  public

  	constructor Create(AEstado: TEstadoEnum);

  strict private

  	class constructor CreateClass;
    class destructor DestroyClass;

  	var
    	FEstado: TEstadoEnum;

    class var
			FMapEstados: TDictionary<AnsiString, TEstadoEnum>;

  public

  	function Nome: AnsiString; inline;

    procedure LerDeXML(ANode: TXmlNode);
    procedure GravarParaXML(ANode: TXmlNode);

    // ValidarString;
    //
    // Verifica se a string passada ao método contém uma abreviação de estado
    // ---- válida.
    // *************************************************************************
    class function ValidarString(AEstado: AnsiString): Boolean; static;

    class procedure ListaAbrevs(ALista: TStrings); static;

  	class operator Implicit(AEstado: TEstado): TEstadoEnum; overload; inline;
    class operator Implicit(AEstado: TEstadoEnum): TEstado; overload; inline;
    class operator Implicit(AEstado: AnsiString): TEstado; overload; inline;
    class operator Implicit(AEstado: TEstado): AnsiString; overload; inline;

  end; { TEstado }
  TEstadoArray = array of TEstado;

const

	ESTADO_ACRE: TEstado =
  	(FEstado: eAC);
  ESTADO_ALAGOAS: TEstado =
		(FEstado: eAL);
  ESTADO_AMAPA: TEstado =
		(FEstado: eAP);
  ESTADO_AMAZONAS: TEstado =
  	(FEstado: eAM);
  ESTADO_BAHIA: TEstado =
  	(FEstado: eBA);
  ESTADO_CEARA: TEstado =
  	(FEstado: eCE);
  ESTADO_DISTRITO_FEDERAL: TEstado =
  	(FEstado: eDF);
  ESTADO_ESPIRITO_SANTO: TEstado =
		(FEstado: eES);
  ESTADO_GOIAS: TEstado =
		(FEstado: eGO);
	ESTADO_MARANHAO: TEstado =
		(FEstado: eMA);
  ESTADO_MATO_GROSSO: TEstado =
  	(FEstado: eMT);
  ESTADO_MATRO_GROSSO_SUL: TEstado =
  	(FEstado: eMS);
  ESTADO_MINAS_GERAIS: TEstado =
  	(FEstado: eMG);
  ESTADO_PARA: TEstado =
  	(FEstado: ePA);
  ESTADO_PARAIBA: TEstado =
  	(FEstado: ePB);
  ESTADO_PARANA: TEstado =
  	(FEstado: ePR);
  ESTADO_PERNAMBUCO: TEstado =
  	(FEstado: ePE);
  ESTADO_PIAUI: TEstado =
  	(FEstado: ePI);
  ESTADO_RIO_JANEIRO: TEstado =
  	(FEstado: eRJ);
  ESTADO_RIO_GRANDE_NORTE: TEstado =
  	(FEstado: eRN);
  ESTADO_RIO_GRANDE_SUL: TEstado =
  	(FEstado: eRS);
  ESTADO_RONDONIA: TEstado =
  	(FEstado: eRO);
  ESTADO_RORAIMA: TEstado =
  	(FEstado: eRR);
  ESTADO_SANTA_CATARINA: TEstado =
  	(FEstado: eSC);
  ESTADO_SAO_PAULO: TEstado =
  	(FEstado: eSP);
  ESTADO_SERGIPE: TEstado =
  	(FEstado: eSE);
  ESTADO_TOCANTINS: TEstado =
  	(FEstado: eTO);

type

  ECEP = class(Exception)
  public

  	type
      TCEPErroEnum =
      (
      	ceStringCEPInvalida
      );

    constructor Create(ACodigoErro: TCEPErroEnum);

  strict private

  	var
    	FCodigoErro: TCEPErroEnum;

  public

  	property CodigoErro: TCEPErroEnum read FCodigoErro;

  end; { ECEP }

  TCEP = packed record
  public

  	constructor Create(ACEP: AnsiString);

	strict private

  	class constructor CreateClass;

  	class var
    	FDiag,
      FDiagExtracao: TRegEx;

  public

  	procedure LerDeXML(ANode: TXmlNode);
    procedure GravarParaXML(ANode: TXmlNode);

    function Parte1: AnsiString; inline;
    function Parte2: AnsiString; inline;
    function Formatado: AnsiString; inline;

  	class function ValidarCEP(ACEP: AnsiString): Boolean; static;
    class function Extrair(ATexto: AnsiString; out AResultado: TDadosExtraidosArray): Integer; static;

    class operator Implicit(ACEP: AnsiString): TCEP; overload; inline;
    class operator Implicit(ACEP: TCEP): AnsiString; overload; inline;
    class operator Implicit(ACEP: TCEP): Variant; overload; inline;
    class operator Equal(ACEP1, ACEP2: TCEP): Boolean; inline;
    class operator NotEqual(ACEP1, ACEP2: TCEP): Boolean; inline;

  private

  	case Boolean of
    	True: (FCEP: packed array[0..7] of TAnsiDigitoType);
      False: (FParte1: packed array[0..4] of TAnsiDigitoType; FParte2: packed array[0..2] of TAnsiDigitoType);

  end; { TCEP }
  TCEPArray = array of TCEP;

  function VarCEPCreate(ACEP: TCEP): Variant;

const

	NULL_CEP: TCEP = (FCEP: '00000000');

type

  ELogradouro = class(Exception)
  public

  	type
    	TLogradouroErroEnum =
      (
      	leStringLogradouroInvalida
      );

    constructor Create(ACodigoErro: TLogradouroErroEnum);

  strict private

  	var
    	FCodigoErro: TLogradouroErroEnum;

  public

  	property CodigoErro: TLogradouroErroEnum read FCodigoErro;

  end; { ELogradouro }

	TTipoLogradouroEnum =
  (
  	tlAER,
		tlAL,
		tlAP,
		tlAV,
		tlBC,
		tlBL,
		tlCAM,
		tlESCD,
		tlEST,
		tlETR,
		tlFAZ,
		tlFORT,
		tlGL,
		tlLD,
		tlLGO,
		tlPCA,
		tlPRQ,
		tlPR,
		tlQD,
		tlKM,
		tlQTA,
		tlROD,
		tlR,
		tlSQD,
		tlTRV,
		tlVD,
		tlVL
  );

  TLogradouro = packed record
  private

  	const
    	ABREVIATURAS: array[TTipoLogradouroEnum] of Ansistring =
      (
      	{tlAEF} 'AER',
				{tlAL} 'AL',
				{tlAP} 'AP',
				{tlAV} 'AV',
				{tlBC} 'BC',
				{tlBL} 'BL',
				{tlCAM} 'CAM',
				{tlESCD} 'ESCD',
				{tlEST} 'EST',
				{tlETR} 'ETR',
				{tlFAZ} 'FAZ',
				{tlFORT} 'FORT',
				{tlGL} 'GL',
				{tlLD} 'LD',
				{tlLGO} 'LGO',
				{tlPCA} 'PÇA',
				{tlPRQ} 'PRQ',
				{tlPR} 'PR',
				{tlQD} 'QD',
				{tlKM} 'KM',
				{tlQTA} 'QTA',
				{tlROD} 'ROD',
				{tlR} 'R',
				{tlSQD} 'SQD',
				{tlTRV} 'TRV',
				{tlVD} 'VD',
				{tlVL} 'VL'
    	);

    NOMES: array[TTipoLogradouroEnum] of AnsiString =
    (
    	{tlAER} 'AEROPORTO',
			{tlAL} 'ALAMEDA',
			{tlAP} 'APARTAMENTO',
			{tlAV} 'AVENIDA',
			{tlBC} 'BECO',
			{tlBL} 'BLOCO',
			{tlCAM} 'CAMINHO',
			{tlESCD} 'ESCADINHA',
			{tlEST} 'ESTAÇÃO',
			{tlETR} 'ESTRADA',
			{tlFAZ} 'FAZENDA',
			{tlFORT} 'FORTALEZA',
			{tlGL} 'GALERIA',
			{tlLD} 'LADEIRA',
			{tlLGO} 'LARGO',
			{tlPCA} 'PRAÇA',
			{tlPRQ} 'PARQUE',
			{tlPR} 'PRAIA',
			{tlQD} 'QUADRA',
			{tlKM} 'QUILÔMETRO',
			{tlQTA} 'QUINTA',
			{tlROD} 'RODOVIA',
			{tlR} 'RUA',
			{tlSQD} 'SUPER QUADRA',
			{tlTRV} 'TRAVESSA',
			{tlVD} 'VIADUTO',
			{tlVL} 'VILA'
    );

	public

  	const
		  COMPRIMENTO_MAXIMO = 250;

  	constructor Create(ALogradouro: AnsiString);

  strict private

  	class constructor CreateClass;
    class destructor DestroyClass;

    type
			TLogradouroType = packed array[0..COMPRIMENTO_MAXIMO - 1] of AnsiChar;

  	var
    	FLogradouro: TLogradouroType;

    class var
      FDiag: TRegEx;
      //FTokens: TTokenDecomposer;

  public

  	var
			Tipo: TTipoLogradouroEnum;

    function Comprimento: Integer; inline;

    procedure LerDeXML(ANode: TXmlNode);
    procedure GravarParaXML(ANode: TXmlNode);

    // Valido;
    //
    // Verifica se o conteúdo é um nome de logradouro válido.
    // ----
    // *************************************************************************
    function Valido: Boolean; inline;

  	class operator Implicit(ALogradouro: AnsiString): TLogradouro; overload;
    class operator Implicit(ALogradouro: TLogradouro): AnsiString; overload;
    class operator Equal(ALog1, ALog2: TLogradouro): Boolean; inline;
    class operator NotEqual(ALog1, ALog2: TLogradouro): Boolean; inline;

  end; { TLogradouro }

  TNumero = packed record
  public

  	const
		  COMPRIMENTO_MAXIMO = 10;

  	constructor Create(ANumero: AnsiString);

  strict private

  	type
		  TNumeroType = packed array[0..COMPRIMENTO_MAXIMO - 1] of AnsiChar;

  	var
    	FNumero: TNumeroType;

  public

    procedure LerDeXML(ANode: TXmlNode);
    procedure GravarParaXML(ANode: TXmlNode);

    // Valido;
    //
    // Verifica se conteúdo é um número de identificação de edificação válido.
    // ----
    // *************************************************************************
    function Valido: Boolean; inline;

  	class operator Implicit(ANumero: AnsiString): TNumero; overload; inline;
    class operator Implicit(ANumero: TNumero): AnsiString; overload; inline;
    class operator Equal(ANum1, ANum2: TNumero): Boolean; inline;
    class operator NotEqual(ANum1, ANum2: TNumero): Boolean; inline;

  end; { TNumero }

  ECidade = class(Exception)
	public

  	type
    	TCidadeErroEnum =
      (
      	ceStringCidadeInvalida
      );

    constructor Create(ACodigoErro: TCidadeErroEnum);

  strict private

  	var
    	FCodigoErro: TCidadeErroEnum;

  public

  	property CodigoErro: TCidadeErroEnum read FCodigoErro;

  end; { ECidade }

  TCidade = packed record
  public

  	const
    	COMPRIMENTO_MAXIMO = 100;

		constructor Create(ACidade: AnsiString);

  strict private

  	class constructor Createclass;

  	type
		  TCidadeType = packed array[0..COMPRIMENTO_MAXIMO + 1] of AnsiChar;

  	var
    	FCidade: TCidadeType;

    class var
    	FDiag: TRegEx;

  public

    procedure LerDeXML(ANode: TXmlNode);
    procedure GravarParaXML(ANode: TXmlNode);

    // Valido.
    //
    // Verifica se o conteúdo é um nome de cidade válido.
    // ----
    // *************************************************************************
    function Valido: Boolean;

  	class operator Implicit(ACidade: AnsiString): TCidade; overload; inline;
    class operator Implicit(ACidade: TCidade): AnsiString; overload; inline;
    class operator Equal(ACid1, ACid2: TCidade): Boolean; inline;
    class operator NotEqual(ACid1, ACid2: TCidade): Boolean; inline;

  end; { TCidade }

	TEnderecoEnum =
  (
  	endResidencial,
    endComercial
  );

	TEndereco = packed record
  public

  	constructor Create(ATipo: TEnderecoEnum; ALogradouro: TLogradouro; ANumero: TNumero; ACidade: TCidade; AEstado: TEstado; ACEP: TCEP);

  	var
    	Tipo: TEnderecoEnum;
    	Logradouro: TLogradouro;
      Numero: TNumero;
      Cidade: TCidade;
      Estado: TEstado;
      CEP: TCep;

    procedure LerDeXML(ANode: TXmlNode);
    procedure GravarParaXML(ANode: TXmlNode);

  end; { TEndereco }

const

	NULL_ENDERECO: TEndereco =
  (
  	Tipo: endResidencial; Logradouro: (FLogradouro: ''); Numero: (FNumero: '');
    Cidade: (FCidade: ''); Estado: (FEstado: eSP); CEP: (FCEP: '')
  );

implementation

uses
	Civil.Utils.VariantIds;

(*
 * EEstado.
 * -----------------------------------------------------------------------------
 *)

constructor EEstado.Create(ACodigoErro: TEstadoErroEnum);
const

	TABELA_MENSAGENS: array[TEstadoErroEnum] of String =
  (
		'O valor fornecido não corresponde a um estado'
  );

begin
	FCodigoErro := ACodigoErro;

  inherited Create(TABELA_MENSAGENS[ACodigoErro]);
end;

(*
 * TEstado.
 * -----------------------------------------------------------------------------
 *)

constructor TEstado.Create(AEstado: TEstadoEnum);
begin
	FEstado := AEstado;
end;

procedure TEstado.LerDeXML(ANode: TXmlNode);
begin
	Self := ANode.NodeByName('ESTADO').Value;
end;

procedure TEstado.GravarParaXML(ANode: TXmlNode);
var
	node: TXmlNode;
begin
	node := ANode.FindNode('ESTADO');
	if Assigned(node) then
  	node.Value := AnsiString(Self)
  else
		ANode.NodeNew('ESTADO').Value := AnsiString(Self);
end;

class constructor TEstado.CreateClass;
var
	i: TEstadoEnum;
  est: TEstado;
begin
	FMapEstados := TDictionary<AnsiString, TEstadoEnum>.Create;

	for i := Low(TEstadoEnum) to High(TEstadoEnum) do
  begin
  	est := TEstado.Create(i);
  	FMapEstados.Add(AnsiString(est), i);
  end;
end;

class destructor TEstado.DestroyClass;
begin
	FMapEstados.Free;
end;

function TEstado.Nome: AnsiString;
begin
	Result := TABELA_NOMES[FEstado];
end;

class function TEstado.ValidarString(AEstado: AnsiString): Boolean;
begin
	Result := FMapEstados.ContainsKey(AEstado);
end;

class procedure TEstado.ListaAbrevs(ALista: TStrings);
var
	i: TEstadoEnum;
begin
	for i := Low(TEstadoEnum) to High(TEstadoEnum) do
  	ALista.Add(TABELA_ABREV[i]);
end;

class operator TEstado.Implicit(AEstado: TEstado): TEstadoEnum;
begin
	Result := AEstado.FEstado;
end;

class operator TEstado.Implicit(AEstado: TEstadoEnum): TEstado;
begin
	Result.FEstado := AEstado;
end;

class operator TEstado.Implicit(AEstado: AnsiString): TEstado;
var
	est: TEstadoEnum;
begin
	if not FMapEstados.TryGetValue(AEstado, est) then
  	raise EEstado.Create(eeStringEstadoInvalida);

  Result.FEstado := est;
end;

class operator TEstado.Implicit(AEstado: TEstado): AnsiString;
begin
	Result := TABELA_ABREV[AEstado.FEstado];
end;

(*
 * ECEP.
 * -----------------------------------------------------------------------------
 *)

constructor ECEP.Create(ACodigoErro: TCEPErroEnum);
const

	TABELA_MENSAGENS: array[TCEPErroEnum] of String =
  (
  	'CEP inválido'
  );

begin
	FCodigoErro := ACodigoErro;

  inherited Create(TABELA_MENSAGENS[ACodigoErro]);
end;

(*
 * TCEP.
 * -----------------------------------------------------------------------------
 *)

constructor TCEP.Create(ACEP: AnsiString);
begin
	Self := ACEP;
end;

class constructor TCEP.CreateClass;
const

	PRODUCAO = '(?<Parte1>[0-9]{5})\-?(?<Parte2>[0-9]{3})';

begin
  FDiag := TRegEx.Create('^' + PRODUCAO + '$', [roExplicitCapture, roCompiled]);
  FDiagExtracao := TRegEx.Create(PRODUCAO, [roExplicitCapture, roCompiled]);
end;

procedure TCEP.LerDeXML(ANode: TXmlNode);
begin
	AnsiStrings.StrPCopy(FCEP, ANode.FindNode('CEP').Value);
end;

procedure TCEP.GravarParaXML(ANode: TXmlNode);
var
	node: TXmlNode;
begin
	node := ANode.FindNode('CEP');

  if not Assigned(node) then
  	node := ANode.NodeNew('CEP');

  node.Value := AnsiString( FCEP );
end;

function TCEP.Parte1: AnsiString;
begin
	Result := AnsiString(FParte1);
end;

function TCEP.Parte2: AnsiString;
begin
	Result := AnsiString(FParte2);
end;

function TCEP.Formatado: AnsiString;
begin
	Result := AnsiString(FParte1) + '-' + AnsiString(FParte2);
end;

class function TCEP.ValidarCEP(ACEP: AnsiString): Boolean;
begin
	Result := FDiag.IsMatch(ACEP);
end;

class function TCEP.Extrair(ATexto: AnsiString; out AResultado: TDadosExtraidosArray): Integer;
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
    Valido := ValidarCEP(Dados);
  end;

  Result := matches.Count;
end;

class operator TCEP.Implicit(ACEP: AnsiString): TCEP;
var
	match: TMatch;
begin
	match := FDiag.Match(ACEP);
	if not match.Success then
  	raise ECEP.Create(ceStringCEPInvalida);

  with Result do
  begin
	  AnsiStrings.StrPCopy(FParte1, match.Groups.Item[1].Value);
  	AnsiStrings.StrPCopy(FParte2, match.Groups.Item[2].Value);
  end;
end;

class operator TCEP.Implicit(ACEP: TCEP): AnsiString;
begin
	Result := AnsiString(ACEP.FCEP);
end;

class operator TCEP.Implicit(ACEP: TCEP): Variant;
begin
	Result := VarCEPCreate(ACEP);
end;

class operator TCEP.Equal(ACEP1, ACEP2: TCEP): Boolean;
begin
	Result := (AnsiCompareStr(AnsiString(ACEP1.FParte1), AnsiString(ACEP2.FParte1)) = 0)
  	and (AnsiCompareStr(AnsiString(ACEP1.FParte1), AnsiString(ACEP2.FParte2)) = 0);
end;

class operator TCEP.NotEqual(ACEP1, ACEP2: TCEP): Boolean;
begin
	Result := (AnsiCompareStr(AnsiString(ACEP1.FParte1), AnsiString(ACEP2.FParte1)) <> 0)
  	or (AnsiCompareStr(AnsiString(ACEP1.FParte1), AnsiString(ACEP2.FParte2)) <> 0);
end;

(*
 * TCEPVariant.
 * -----------------------------------------------------------------------------
 *)

type

	PCEPDataRec = ^TCEPDataRec;
	TCEPDataRec = packed record // Deve conter 16 bytes.
  	VType: TVarType;        	// 2 bytes;
    VCEP: TCEP;        				// 8 bytes;
    Unused1: Word;            // 2 bytes;
    Unused2: Integer;					// 4 bytes;
  end; { TCEPDataRec }

  TCEPVariant = class(TInvokeableVariantType)
  public

  	procedure Cast(var Dest: TVarData; const Source: TVarData); override;
    procedure CastTo(var Dest: TVarData; const Source: TVarData; const AVarType: TVarType); override;

    procedure Compare(const Left, Right: TVarData; var Relationship: TVarCompareResult); override;
    function IsClear(const Data: TVarData): Boolean; override;

    procedure Clear(var Data: TVarData); override;
    procedure Copy(var Dest: TVarData; const Source: TVarData; const Indirect: Boolean); override;

    function GetProperty(var Dest: TVarData; const Value: TVarData; const Name: String): Boolean; override;

  end; { TCEPVariant }

var
	__cepVar: TCEPVariant;

function VarCEPCreate(ACEP: TCEP): Variant;
begin
//	VarClear(Result);
  with TCEPDataRec(Result) do
  begin
  	VType := __cepVar.VarType;
    VCEP := ACEP;
  end;
end;

procedure TCEPVariant.Cast(var Dest: TVarData; const Source: TVarData);
begin
	case Source.VType of
  	varUString, varString:
    begin
    	Dest.VType := VarType;
      TCEPDataRec(Dest).VCEP := VarDataToStr(Source);
    end;
    varCEP:
      Dest := Source
  	else
			RaiseCastError;
  end;
end;

procedure TCEPVariant.CastTo(var Dest: TVarData; const Source: TVarData; const AVarType: TVarType);
begin
	if Source.VType = VarType then
  begin

		case AVarType of
      varUString, varString:
      	VarDataFromLStr(Dest, AnsiString(TCEPDataRec(Source).VCEP));
      varCEP:
      	Dest := Source;
      else
      	RaiseCastError;
    end;

  end
  else
  	RaiseCastError;
end;

procedure TCEPVariant.Compare(const Left, Right: TVarData; var Relationship: TVarCompareResult);
begin
	{if TVersionDataRec(Left).VVersion > TVersionDataRec(Right).VVersion then
    Relationship := crGreaterThan
  else if TVersionDataRec(Left).VVersion = TVersionDataRec(Right).VVersion then
  	Relationship := crEqual
  else
  	Relationship := crLessThan;}

  case AnsiCompareStr(AnsiString(TCEPDataRec(Left).VCEP), AnsiString(TCEPDataRec(Right).VCEP)) of
		-1: Relationship := crLessThan;
    0: Relationship := crEqual;
    1: Relationship := crGreaterThan;
  end;
end;

function TCEPVariant.IsClear(const Data: TVarData): Boolean;
begin
	Result := (Data.VType = varEmpty);
end;

procedure TCEPVariant.Clear(var Data: TVarData);
begin
	Data.VType := varEmpty;
end;

procedure TCEPVariant.Copy(var Dest: TVarData; const Source: TVarData; const Indirect: Boolean);
begin
	{with TCEPDataRec(Dest) do
  begin
  	VType := VarType;
    VCEP := TCEPDataRec(Source).VCEP;
  end;}
  Dest := Source;
end;

function TCEPVariant.GetProperty(var Dest: TVarData; const Value: TVarData; const Name: String): Boolean;
begin
	Result := True;

	if Name = 'PARTE1' then
  	Variant(Dest) := TCEPDataRec(Value).VCEP.Parte1
  else if Name = 'PARTE2' then
  	Variant(Dest) := TCEPDataRec(Value).VCEP.Parte2
  else if Name = 'FORMATADO' then
  	Variant(Dest) := TCEPDataRec(Value).VCEP.Formatado
  else
  	Result := False;
end;

(*
 * ELogradouro.
 * -----------------------------------------------------------------------------
 *)

constructor ELogradouro.Create(ACodigoErro: TLogradouroErroEnum);
const

	MENSAGENS: array[TLogradouroErroEnum] of String =
  (
  	'A string não contém um logradouro válido'
  );

begin
	FCodigoErro := ACodigoErro;

  inherited Create(MENSAGENS[ACodigoErro]);
end;

(*
 * TLogradouro.
 * -----------------------------------------------------------------------------
 *)

constructor TLogradouro.Create(ALogradouro: AnsiString);
begin
	Self := ALogradouro;
end;

class constructor TLogradouro.CreateClass;
var
	//tc: TTokenDecomposer.TTokenConfigRec;
  strAbrev, strNomes: String;
  i: TTipoLogradouroEnum;
begin
	strAbrev := '(' + ABREVIATURAS[Low(TTipoLogradouroEnum)] + ')';
  strNomes := '(' + NOMES[Low(TTipoLogradouroEnum)] + ')';
  for i := TTipoLogradouroEnum(Byte(Low(TTipoLogradouroEnum)) + 1) to High(TTipoLogradouroEnum) do
	begin
  	strAbrev := strAbrev + '|(' + ABREVIATURAS[i] + ')';
    strNomes := strNomes + '|(' + NOMES[i] + ')';
  end;
  strAbrev := '(?<Abrev>' + strAbrev + ')';
  strNomes := '(?<Nomes>' + strNomes + ')';

	FDiag := TRegEx.Create('^((' + strAbrev + ')|(' + strNomes + '))\s+(?<logradouro>[a-z0-9áâãéíóôõúç][a-z0-9áâãéíóôõúçºª\.]{0,200})',
  	[roIgnoreCase, roExplicitCapture, roCompiled]);

	{FTokens := TTokenDecomposer.Create;
  tc.Ignore := True;
  tc.Appellant := True;
  FTokens.AddToken(-1, ' ', tc);}
end;

class destructor TLogradouro.DestroyClass;
begin
	//FTokens.Free;
end;

function TLogradouro.Comprimento: Integer;
begin
	Result := Length(AnsiString(FLogradouro));
end;

procedure TLogradouro.LerDeXML(ANode: TXmlNode);
var
	att: TsdAttribute;
begin
	att := ANode.AttributeByName['tipo'];
  Tipo := TTipoLogradouroEnum(att.ValueAsInteger);
 	Self := AnsiString(ANode.NodeByName('LOGRADOURO').Value);
end;

procedure TLogradouro.GravarParaXML(ANode: TXmlNode);
var
	node: TXmlNode;
  att: TsdAttribute;
begin
	node := ANode.FindNode('LOGRADOURO');

  if not Assigned(node) then
	 	node := ANode.NodeNew('LOGRADOURO');

  node.Value := AnsiString(FLogradouro);

  att := node.AttributeByName['tipo'];

  if Assigned(att) then
  	att.Value := IntToStr(Byte(Tipo))
  else
  	node.AttributeAdd('tipo', IntToStr(Byte(Tipo)));
end;

function TLogradouro.Valido: Boolean;
begin
	Result := Length(AnsiString(FLogradouro)) > 0;
end;

class operator TLogradouro.Implicit(ALogradouro: AnsiString): TLogradouro;
var
	//aTkns: TTokenDecomposer.TTokenDataArray;
  sl: TStrings;
  i: Integer;
  match: TMatch;
  j: TTipoLogradouroEnum;
  strTipo: AnsiString;
begin
	if Length(ALogradouro) = 0 then
  begin
  	Result.Tipo := tlR;
    FillChar(Result.FLogradouro, COMPRIMENTO_MAXIMO, 0);
  end
  else
  begin
  	sl := TStringList.Create;
    try
      // Remove espaços extras que podem ter sido inseridos no texto.
      //FTokens.BreakString(ALogradouro, aTkns);
      sl.Delimiter := ' ';
      sl.DelimitedText := ALogradouro;

      ALogradouro := '';
      for i := 0 to sl.Count - 1 do // High(aTkns) do
        ALogradouro := ALogradouro + ' ' + sl[i];// aTkns[i].Token;
      ALogradouro := Trim(ALogradouro);

      match := FDiag.Match(ALogradouro);

      if not match.Success then
        Result.Tipo := tlR
      else
      begin
        if Length(match.Groups.Item[1].Value) = 0 then
          strTipo := match.Groups.Item[2].Value
        else
          strTipo := match.Groups.Item[1].Value;

        strTipo := UpperCase(strTipo);

        for j := Low(TTipoLogradouroEnum) to High(TTipoLogradouroEnum) do
          if (AnsiCompareStr(strTipo, ABREVIATURAS[j]) = 0) or (AnsiCompareStr(strTipo, NOMES[j]) = 0) then
          begin
            Result.Tipo := j;
            Break;
          end;
      end;

      ALogradouro := Trim(Copy(ALogradouro, Length(strTipo) + 1, Length(ALogradouro) - Length(strTipo)));

      AnsiStrings.StrPLCopy(Result.FLogradouro, ALogradouro, Min(Length(ALogradouro),
        SizeOf(TLogradouro)));
    finally
    	sl.Free;
    end;
  end;
end;

class operator TLogradouro.Implicit(ALogradouro: TLogradouro): AnsiString;
begin
	with ALogradouro do
  begin
  	if Comprimento > 0 then
			Result := ABREVIATURAS[Tipo] + ' ' + AnsiString(FLogradouro)
    else
    	Result := '';
  end;
end;

class operator TLogradouro.Equal(ALog1, ALog2: TLogradouro): Boolean;
begin
	Result := AnsiCompareStr(AnsiString(ALog1.FLogradouro), AnsiString(ALog2.FLogradouro)) = 0;
end;

class operator TLogradouro.NotEqual(ALog1, ALog2: TLogradouro): Boolean;
begin
	Result := AnsiCompareStr(AnsiString(ALog1.FLogradouro), AnsiString(ALog2.FLogradouro)) <> 0;
end;

(*
 * TNumero.
 * -----------------------------------------------------------------------------
 *)

constructor TNumero.Create(ANumero: AnsiString);
begin
	AnsiStrings.StrPLCopy(FNumero, ANumero, Min(Length(ANumero), COMPRIMENTO_MAXIMO));
end;

procedure TNumero.LerDeXML(ANode: TXmlNode);
begin
 	Self := AnsiString(ANode.NodeByName('NUMERO').Value);
end;

procedure TNumero.GravarParaXML(ANode: TXmlNode);
var
	node: TXmlNode;
begin
	node := ANode.FindNode('NUMERO');

  if Assigned(node) then
  	node.Value := AnsiString(Self)
  else
	 	ANode.NodeNew('NUMERO').Value := AnsiString(Self);
end;

function TNumero.Valido: Boolean;
begin
	Result := Length(AnsiString(FNumero)) > 0;
end;

class operator TNumero.Implicit(ANumero: AnsiString): TNumero;
begin
	AnsiStrings.StrPLCopy(Result.FNumero, ANumero, Min(Length(ANumero), COMPRIMENTO_MAXIMO));
end;

class operator TNumero.Implicit(ANumero: TNumero): AnsiString;
begin
	Result := AnsiString(ANumero.FNumero);
end;

class operator TNumero.Equal(ANum1, ANum2: TNumero): Boolean;
begin
	Result := AnsiCompareStr(AnsiString(ANum1.FNumero), AnsiString(ANum2.FNumero)) = 0;
end;

class operator TNumero.NotEqual(ANum1, ANum2: TNumero): Boolean;
begin
	Result := AnsiCompareStr(AnsiString(ANum1.FNumero), AnsiString(ANum2.FNumero)) <> 0;
end;

(*
 * ECidade.
 * -----------------------------------------------------------------------------
 *)

constructor ECidade.Create(ACodigoErro: TCidadeErroEnum);
const

	MENSAGENS: array[TCidadeErroEnum] of String =
  (
  	'A string não contém um nome de cidade válido'
  );

begin
	FCodigoErro := ACodigoErro;

  inherited Create(MENSAGENS[ACodigoErro]);
end;

(*
 * TCidade.
 * -----------------------------------------------------------------------------
 *)

constructor TCidade.Create(ACidade: AnsiString);
begin
	Self := ACidade;
	//AnsiStrings.StrPLCopy(FCidade, ACidade, Min(Length(ACidade), COMPRIMENTO_MAXIMO));
end;

class constructor TCidade.CreateClass;
begin
	FDiag := TRegEx.Create('^[a-z0-9áãâéêíóôõú\s]{1,200}$', [roIgnoreCase, roExplicitCapture, roCompiled]);
end;

procedure TCidade.LerDeXML(ANode: TXmlNode);
begin
 	Self := ANode.NodeByName('CIDADE').Value;
end;

procedure TCidade.GravarParaXML(ANode: TXmlNode);
var
	node: TXmlNode;
begin
	node := ANode.FindNode('CIDADE');

  if Assigned(node) then
  	node.Value := AnsiString(FCidade)
  else
	 	ANode.NodeNew('CIDADE').Value := AnsiString(FCidade);
end;

function TCidade.Valido: Boolean;
begin
	Result := Length(AnsiString(FCidade)) > 0;
end;

class operator TCidade.Implicit(ACidade: AnsiString): TCidade;
begin
	if (Length(ACidade) > 0) and not FDiag.IsMatch(ACidade) then
  	raise ECidade.Create(ceStringCidadeInvalida);

	AnsiStrings.StrPLCopy(Result.FCidade, ACidade, Min(Length(ACidade), COMPRIMENTO_MAXIMO));
end;

class operator TCidade.Implicit(ACidade: TCidade): AnsiString;
begin
	Result := AnsiString(ACidade.FCidade);
end;

class operator TCidade.Equal(ACid1, ACid2: TCidade): Boolean;
begin
	Result := AnsiCompareStr(AnsiString(ACid1.FCidade), AnsiString(ACid2.FCidade)) = 0;
end;

class operator TCidade.NotEqual(ACid1, ACid2: TCidade): Boolean;
begin
	Result := AnsiCompareStr(AnsiString(ACid1.FCidade), AnsiString(ACid2.FCidade)) <> 0;
end;

(*
 * TEndereco.
 * -----------------------------------------------------------------------------
 *)

constructor TEndereco.Create(ATipo: TEnderecoEnum; ALogradouro: TLogradouro;
	ANumero: TNumero; ACidade: TCidade; AEstado: TEstado; ACEP: TCEP);
begin
	Tipo := ATipo;
  Logradouro := ALogradouro;
  Numero := ANumero;
  Cidade := ACidade;
  Estado := AEstado;
  CEP := ACEP;
end;

procedure TEndereco.LerDeXML(ANode: TXmlNode);
var
	node: TXmlNode;
begin
	node := ANode.FindNode('ENDERECO');

 	Tipo := TEnderecoEnum(node.AttributeByName['tipo'].ValueAsInteger);
  Logradouro.LerDeXML(node);
  Numero.LerDeXML(node);
  Cidade.LerDeXML(node);
  Estado.LerDeXML(node);
  cep.LerDeXML(node);
end;

procedure TEndereco.GravarParaXML(ANode: TXmlNode);
var
	node: TXmlNode;
  att: TsdAttribute;
begin
	node := ANode.FindNode('ENDERECO');

  if not Assigned(node) then
  	node := ANode.NodeNew('ENDERECO');

  att := node.AttributeByName['tipo'];
  if Assigned(att) then
  	att.Value := Integer(Tipo).ToString
  else
		node.AttributeAdd('tipo', Integer(Tipo).ToString);

	Logradouro.GravarParaXML(node);
  Numero.GravarParaXML(node);
  Cidade.GravarParaXML(node);
  Estado.GravarParaXML(node);
  Cep.GravarParaXML(node);
end;

initialization

  __cepVar := TCEPVariant.Create(varCEP);

finalization

  __cepVar.Free;

end.
