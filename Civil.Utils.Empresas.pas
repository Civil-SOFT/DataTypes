(***
 * Civil.Utils.Empresas.pas;
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

unit Civil.Utils.Empresas;

interface

uses
	SysUtils, Classes, Generics.Collections, NativeXml, Civil.Utils.Types.Version,
  Civil.Utils.Types.CNPJ, Civil.Utils.Types.Endereco;

type

	TEmpresas = class;

	EEmpresa = class(Exception)
  public

  	type
    	TEmpresaErroEnum =
      (
      	eeCNPJInvalido
      );

    constructor Create(CodigoErro: TEmpresaErroEnum);

  strict private

  	var
    	FCodigoErro: TEmpresaErroEnum;

  public

  	property CodigoErro: TEmpresaErroEnum read FCodigoErro;

  end; { EEmpresa }

  (***
   * TEmpresa;
   *)
  PEmpresa = ^TEmpresa;
	TEmpresa = record
  public

  	constructor Create(ACNPJ: TCNPJ);

  strict private

  	var
    	FCNPJ: TCNPJ;
      FRazaoSocial,
      FNomeFantasia: AnsiString;
      FEndereco: TEndereco;

  public

  	property CNPJ: TCNPJ read FCNPJ;
    property RazaoSocial: AnsiString read FRazaoSocial write FRazaoSocial;
    property NomeFantasia: AnsiString read FNomeFantasia write FNomeFantasia;
    property Endereco: TEndereco read FEndereco write FEndereco;

    procedure GravarParaXML(ANode: TXmlNode);
    procedure LerDeXML(ANode: TXmlNode);

  end; { TEmpresa }
  TEmpresaArray = array of TEmpresa;

  EEmpresas = class(Exception)
  public

  	type
    	TEmpresasErroEnum =
      (
      	eeEmpresaDuplicada,
        eeEmpresaNaoEncontrada,
        eeCNPJNulo
      );

    constructor Create(CodigoErro: TEmpresasErroEnum);

  strict private

  	var
    	FCodigoErro: TEmpresasErroEnum;

  public

  	property CodigoErro: TEmpresasErroEnum read FCodigoErro;

  end; { EEmpresas}

  (***
   * TEmpresas;
   *
   * Coleção utilizada para gerenciar dados de empresas.
   * ----
   *)
  TEmpresas = class
  public

  	const
    	CHAVE_BASE_REGISTRO = 'Software\Civil\';

  	constructor Create(ACarregar: Boolean = False);
  	destructor Destroy; override;

  strict private

  	type
    	TEmpresaIndexType = TDictionary<TCNPJ, TEmpresa>;
      TEmpresaListType = TList<TCNPJ>;

    var
    	FIndice: TEmpresaListType;

  	class constructor CreateClass;
    class destructor DestroyClass;

  	class var
    	FEmpresas: TEmpresaIndexType;

  public

  	procedure Adicionar(AEmpresa: TEmpresa);
    procedure Remover(AEmpresa: TCNPJ); overload;
    procedure Remover(AEmpresa: TEmpresa); overload; inline;

  strict private

  	function GetEmpresaPeloCNPJ(CNPJ: TCNPJ): TEmpresa;
    function GetEmpresa(Indice: Integer): TEmpresa;

  public

  	property EmpresasPeloCNPJ[CNPJ: TCNPJ]: TEmpresa read GetEmpresaPeloCNPJ;
    property Empresas[Indice: Integer]: TEmpresa read GetEmpresa; default;

    function NumEmpresas: Integer;

  	// EmpresaCadastrada;
    //
    // Verifica se uma empresa já está cadastrada na coleção.
    // ----
    // *************************************************************************
  	function EmpresaCadastrada(ACNPJ: TCNPJ; AEmpresa: PEmpresa = nil): Boolean;

    // ObterEmpresa;
    //
    // Caso o CNPJ fornecido ao método não esteja na lista interna de empresas,
    // ---- seus dados são procurados na lista persistente. Se encontrada, é a-
		//			dicionada na lista de empresas.
    // *************************************************************************
    function ObterEmpresa(ACNPJ: TCNPJ): Boolean;

    procedure GravarParaXML(ANode: TXmlNode); virtual;
    procedure LerDeXML(ANode: TXmlNode); virtual;

    // ApagarEmpresas;
    //
    // Apaga os dados de todas as empresas cadastradas.
    // ----
    // *************************************************************************
    procedure ApagarEmpresas; dynamic;

    class function TotalEmpresasCadastradas: Integer; inline;
    class procedure ListaEmpresas(out AEmpresas: TEmpresaArray);
    class procedure ObterEmpresas(AEmpresas: TEmpresaArray);
    class function ExisteEmpresa(ACNPJ: TCNPJ; AEmpresa: PEmpresa = nil): Boolean;

  end; { TEmpresas }

implementation

uses
	Winapi.Windows, System.Win.Registry, Civil.Utils;

(*
 * EEmpresa.
 * -----------------------------------------------------------------------------
 *)

constructor EEmpresa.Create(CodigoErro: TEmpresaErroEnum);
var
	strMsg: String;
begin
	FCodigoErro := CodigoErro;

  case CodigoErro of
  	eeCNPJInvalido: strMsg := 'CNPJ inválido';
  end;

  inherited Create(strMsg);
end;

(*
 * TEmpresa.
 * -----------------------------------------------------------------------------
 *)

constructor TEmpresa.Create(ACNPJ: TCNPJ);
begin
	//inherited Create;

  FCNPJ := ACNPJ;
end;

procedure TEmpresa.GravarParaXML(ANode: TXmlNode);
var
	node: TXmlNode;
begin
	node := ANode.FindNode('DADOS_EMPRESA');

  if not Assigned(node) then
  	node := ANode.NodeNew('DADOS_EMPRESA');

  node.AttributeAdd('CNPJ', AnsiString(FCNPJ));
  node.NodeNew('RAZAO_SOCIAL').Value := AnsiString(FRazaoSocial);
  node.NodeNew('NOME_FANTASIA').Value := AnsiString(FNomeFantasia);

  FEndereco.GravarParaXML(node);
end;

procedure TEmpresa.LerDeXML(ANode: TXmlNode);
var
	node: TXmlNode;
begin
	node := ANode.NodeByName('DADOS_EMPRESA');
	with node do
  begin
  	FCNPJ := TCNPJ.Create(AttributeByName['CNPJ'].Value);
  	FRazaoSocial := NodeByName('RAZAO_SOCIAL').Value;
    FNomeFantasia := NodeByName('NOME_FANTASIA').Value;
  end;

  FEndereco.LerDeXML(node);
end;

(*
 * EEmpresas.
 * -----------------------------------------------------------------------------
 *)

constructor EEmpresas.Create(CodigoErro: TEmpresasErroEnum);
const

	MENSAGENS: array[TEmpresasErroEnum] of String =
  (
  	{eeEmpresaDuplicada} 'A empresas já faz parte da coleção',
		{eeEmpresaNaoEncontrada} 'Empresa não cadastrada na coleção',
    {eeCNPJNulo} 'Empresa com CNPJ nulo'
	);

begin
	FCodigoErro := CodigoErro;

  inherited Create(MENSAGENS[CodigoErro]);
end;

(*
 * TEmpresas.
 * -----------------------------------------------------------------------------
 *)

constructor TEmpresas.Create(ACarregar: Boolean = False);
var
	it: TEmpresaIndexType.TPairEnumerator;
begin
  inherited Create;

  FIndice := TEmpresaListType.Create;

  if ACarregar then
  begin
  	it := FEmpresas.GetEnumerator;
    try
    	while it.MoveNext do
      	FIndice.Add(it.Current.Key);
    finally
    	it.Free;
    end;
  end;
end;

destructor TEmpresas.Destroy;
begin
	ApagarEmpresas;
  FIndice.Free;

  inherited;
end;

class constructor TEmpresas.CreateClass;
var
	reg: TRegistry;
  intNumEmpresas, i: Integer;
  strm: TStream;
	strNome, strXML: AnsiString;
  docXML: TNativeXml;
  empr: TEmpresa;
begin
	FEmpresas := TEmpresaIndexType.Create(KEY_READ);

  strm := TMemoryStream.Create;
  reg := TRegistry.Create;
  docXML := TNativeXml.Create(nil);
  try
  	reg.RootKey := HKEY_CURRENT_USER;

    if not reg.KeyExists(CHAVE_BASE_REGISTRO + '\Empresas\') then
    	Exit;

    reg.OpenKey(CHAVE_BASE_REGISTRO + '\Empresas\', False);

    intNumEmpresas := reg.ReadInteger('NUM_EMPRESAS');

    for i := 0 to intNumEmpresas - 1 do
    begin
      strNome := 'EMPRESA' + IntToStr(i);
    	strm.Position := 0;
      strm.Size := reg.GetDataSize(strNome);
      reg.ReadBinaryData(strNome, TMemoryStream(strm).Memory^, strm.Size);
      strm.Position := 0;
      strXML := '';
      strm.ReadString(strXML);
      docXML.Clear;
      docXML.ReadFromString( AnsiToUtf8(strXML) );
			empr.LerDeXML(docXML.Root);
      FEmpresas.Add(empr.CNPJ, empr);
    end;
  finally
  	reg.Free;
    strm.Free;
    docXML.Free;
  end;
end;

class destructor TEmpresas.DestroyClass;
var
	reg: TRegistry;
  i: Integer;
  it: TEmpresaIndexType.TPairEnumerator;
  strm: TStream;
  strXML: AnsiString;
  doc: TNativeXml;
begin
  reg := TRegistry.Create(KEY_ALL_ACCESS);
  strm := TMemoryStream.Create;
  it := FEmpresas.GetEnumerator;
  doc := TNativeXml.Create(nil);
  try
  	reg.RootKey := HKEY_CURRENT_USER;
    reg.OpenKey(CHAVE_BASE_REGISTRO + '\Empresas\', True);
    reg.WriteInteger('NUM_EMPRESAS', FEmpresas.Count);

    i := 0;
		while it.MoveNext do
    begin
    	doc.Clear;
			doc.Root.Name := 'EMPRESA' + IntToStr(i);
      it.Current.Value.GravarParaXML(doc.Root);
      strXML := doc.WriteToString;
      strm.Size := 0;
      strm.Position := 0;
      strm.WriteString(strXML);
      strm.Position := 0;

    	reg.WriteBinaryData(doc.Root.Name, TMemoryStream(strm).Memory^, strm.Size);
      Inc(i);
    end;
  finally
  	reg.Free;
    strm.Free;
    it.Free;
    doc.Free;
  end;

	FEmpresas.Free;
end;

procedure TEmpresas.Adicionar(AEmpresa: TEmpresa);
begin
	if AEmpresa.CNPJ = NULL_CNPJ then
  	raise EEmpresas.Create(eeCNPJNulo);

	if FIndice.IndexOf(AEmpresa.CNPJ) > -1 then
		raise EEmpresas.Create(eeEmpresaDuplicada);

  //FIndice.RegisterItem(AnsiString(AEmpresa.CNPJ), AEmpresa);
  if not FEmpresas.ContainsKey(AEmpresa.CNPJ) then
	  FEmpresas.Add(AEmpresa.CNPJ, AEmpresa);

  FIndice.Add(AEmpresa.CNPJ);
end;

procedure TEmpresas.Remover(AEmpresa: TCNPJ);
var
	intIndice: Integer;
begin
	intIndice := FIndice.IndexOf(AEmpresa);
	//if not FIndice.ContainsKey(AEmpresa) then
  if intIndice = -1 then
  	raise EEmpresas.Create(eeEmpresaNaoEncontrada);

  //FIndice.Remove(AEmpresa);
  FIndice.Delete(intIndice);
end;

procedure TEmpresas.Remover(AEmpresa: TEmpresa);
begin
	Remover(AEmpresa.CNPJ);
end;

function TEmpresas.GetEmpresaPeloCNPJ(CNPJ: TCNPJ): TEmpresa;
var
	intIndice: Integer;
begin
	{if not FIndice.TryGetValue(CNPJ, Result) then
  	raise EEmpresas.Create(eeEmpresaNaoEncontrada);}

  intIndice := FIndice.IndexOf(CNPJ);
  if intIndice = -1 then
  	raise EEmpresas.Create(eeEmpresaNaoEncontrada);

  Result := FEmpresas.Items[FIndice[intIndice]];
end;

function TEmpresas.GetEmpresa(Indice: Integer): TEmpresa;
begin
	Result := FEmpresas.Items[ FIndice[Indice] ];
	//Result := FIndice.ToArray[Indice].Value;
end;

function TEmpresas.NumEmpresas: Integer;
begin
	Result := FIndice.Count;
end;

function TEmpresas.EmpresaCadastrada(ACNPJ: TCNPJ; AEmpresa: PEmpresa = nil): Boolean;
var
	intIndice: Integer;
begin
	intIndice := FIndice.IndexOf(ACNPJ);
  Result := intIndice > -1;

	if Result and Assigned(AEmpresa) then
		AEmpresa^ := FEmpresas.Items[FIndice[intIndice]];
end;

function TEmpresas.ObterEmpresa(ACNPJ: TCNPJ): Boolean;
begin
	Result := False;

  if FIndice.IndexOf(ACNPJ) > -1 then Exit;

	if FEmpresas.ContainsKey(ACNPJ) then
  begin
  	Result := True;
    FIndice.Add(ACNPJ)
  end;
end;

procedure TEmpresas.GravarParaXML(ANode: TXmlNode);
var
	//it: TEmpresaIndexType.TPairEnumerator;
  i: Integer;
  node, nodeEmpr: TXmlNode;
  empr: TEmpresa;
begin
	nodeEmpr := ANode.NodeByName('EMPRESAS');

  if not Assigned(nodeEmpr) then
		nodeEmpr := ANode.NodeNew('EMPRESAS');

  for i := 0 to FIndice.Count - 1 do
  begin
  	empr := FEmpresas.Items[ FIndice[i] ];
    node := nodeEmpr.NodeNew('EMPRESA');
    empr.GravarParaXML(node);
  end;

	{it := FIndice.GetEnumerator;
  try
  	while it.MoveNext do
    begin
    	node := nodeEmpr.NodeNew('EMPRESA');
	    it.Current.Value.GravarParaXML(node);
    end;
  finally
  	it.Free;
  end;}
end;

procedure TEmpresas.LerDeXML(ANode: TXmlNode);
var
	i: Integer;
  empr: TEmpresa;
  node: TXmlNode;
begin
	ANode := ANode.FindNode('EMPRESAS');
	ApagarEmpresas;
  for i := 0 to ANode.NodeCount - 1 do
  begin
  	node := ANode.Nodes[i];

    if node.Name <> 'EMPRESA' then Continue;

		empr.LerDeXML(NODE);
    Adicionar(empr);
  end;
end;

procedure TEmpresas.ApagarEmpresas;
begin
  FIndice.Clear;
end;

class function TEmpresas.TotalEmpresasCadastradas: Integer;
begin
	Result := FEmpresas.Count;
end;

class procedure TEmpresas.ListaEmpresas(out AEmpresas: TEmpresaArray);
var
	it: TEmpresaIndexType.TPairEnumerator;
  i: Integer;
begin
  SetLength(AEmpresas, FEmpresas.Count);
  it := FEmpresas.GetEnumerator;
  try
  	i := 0;
  	while it.MoveNext do
    begin
    	AEmpresas[i] := it.Current.Value;
      Inc(i);
    end;
  finally
  	it.Free;
  end;
end;

class procedure TEmpresas.ObterEmpresas(AEmpresas: TEmpresaArray);
var
	i: Integer;
  empr: TEmpresa;
begin
	for i := 0 to High(AEmpresas) do
  begin
  	empr := AEmpresas[i];
  	if not FEmpresas.ContainsKey(empr.CNPJ) then
    	FEmpresas.Add(empr.CNPJ, empr);
  end;
end;

class function TEmpresas.ExisteEmpresa(ACNPJ: TCNPJ; AEmpresa: PEmpresa = nil): Boolean;
begin
	Result := FEmpresas.ContainsKey(ACNPJ);

  if Result and Assigned(AEmpresa) then
		AEmpresa^ := FEmpresas.Items[ACNPJ];
end;

end.
