(***
 * Civil.Utils.Types.Email.pas;
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
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *)

unit Civil.Utils.Types.Email;

interface

uses
	SysUtils, Classes, Math, System.Variants, Generics.Collections, NativeXml,
  RegularExpressions, AnsiStrings, Winapi.Windows, Civil.Utils.Types;

type

	EEmail = class(Exception)
  public

  	type
    	TEmailErroEnum =
      (
      	eeStringEmailInvalida
      );

    constructor Create(ACodigoErro: TEmailErroEnum);

  strict private

  	var
    	FCodigoErro: TEmailErroEnum;

  public

  	property CodigoErro: TEmailErroEnum read FCodigoErro;

  end; { EEmail }

	TEmail = packed record
  public

  	constructor Create(AEmail: AnsiString);

  strict private

  	class constructor CreateClass;

  	class var
    	FDiag,
      FDiagExtracao,
      FDiagParte1,
      FDiagParte2,
      FDiagParte3,
      FDiagNomeConta: TRegEx;

  	type
      TParte1Type = packed array[0..248] of AnsiChar;
      TParte2Type = packed array[0..2] of AnsiChar;
      TParte3Type = packed array[0..1] of AnsiChar;
    	TNomeContaType = packed array[0..63] of AnsiChar;

  	var
    	FNomeConta: TNomeContaType;
      FParte1: TParte1Type;
      FParte2: TParte2Type;
      FParte3: TParte3Type;

    function GetNomeConta: AnsiString; inline;
    procedure SetNomeConta(AValor: AnsiString); inline;
    function GetParte1: AnsiString; inline;
    procedure SetParte1(AValor: AnsiString); inline;
    function GetParte2: AnsiString; inline;
    procedure SetParte2(AValor: AnsiString); inline;
    function GetParte3: AnsiString; inline;
    procedure SetParte3(AValor: AnsiString); inline;

  public

  	property NomeConta: AnsiString read GetNomeConta write SetNomeConta;
    property Parte1: AnsiString read GetParte1 write SetParte1;
    property Parte2: AnsiString read GetParte2 write SetParte2;
    property Parte3: AnsiString read GetParte3 write SetParte3;

    function Comprimento: Integer; inline;

    procedure LerDe(ANode: TXmlNode); inline;
    procedure GravarPara(ANode: TXmlNode); inline;

	  class function ValidarEmail(AEmail: AnsiString): Boolean; static;
    class function Extrair(ATexto: AnsiString; out AResultado: TDadosExtraidosArray): Integer; static;

    class operator Implicit(AEmail: AnsiString): TEmail; overload;
    class operator Implicit(AEmail: TEmail): AnsiString; overload; inline;

    class operator Equal(AEmail1, AEmail2: TEmail): Boolean; inline;
    class operator NotEqual(AEmail1, AEmail2: TEmail): Boolean; inline;

  end; { TEmail }

const

	NULL_MAIL: TEMail =
  (
  	FNomeConta: ''; FParte1: ''; FParte2: ''; FParte3: '';
  );

implementation

uses
	Civil.Utils.VariantIds;

(*
 * EEmail.
 * -----------------------------------------------------------------------------
 *)

constructor EEmail.Create(ACodigoErro: TEmailErroEnum);
const

	MENSAGENS: array[TEmailErroEnum] of String =
  (
  	'A string não contém um e-mail válido'
  );

begin
	FCodigoErro := ACodigoErro;

  inherited Create(MENSAGENS[ACodigoErro]);
end;

(*
 * TEmail.
 * -----------------------------------------------------------------------------
 *)

constructor TEmail.Create(AEmail: AnsiString);
begin
	Self := AEmail;
end;

class constructor TEmail.CreateClass;
const

	PRODUCAO = '(?<NomeConta>[a-z0-9\._-]{1,64})@(?<Parte1>[a-z0-9_\-]{1,249})\.(?<Parte2>[a-z0-9-]{1,3})(\.(?<Parte3>[a-z0-9]{2}))?';

begin
  FDiag := TRegEx.Create('^' + PRODUCAO + '$', [roExplicitCapture, roIgnoreCase, roCompiled]);
  FDiagExtracao := TRegEx.Create(PRODUCAO, [roExplicitCapture, roIgnoreCase, roCompiled]);
  FDiagNomeConta := TRegEx.Create('^[a-z0-9\._\-]{1,64}$', [roIgnoreCase, roExplicitCapture, roCompiled]);
  FDiagParte1 := TRegEx.Create('^[a-z0-9_\-]{1,249}$', [roIgnoreCase, roExplicitCapture, roCompiled]);
  FDiagParte2 := TRegEx.Create('^[a-z0-9]{1,3}$', [roIgnoreCase, roExplicitCapture, roCompiled]);
  FDiagParte3 := TRegEx.Create('^[a-z0-9]{2}$', [roIgnoreCase, roExplicitCapture, roCompiled]);
end;

function TEmail.GetNomeConta: AnsiString;
begin
	Result := AnsiString(FNomeConta);
end;

procedure TEmail.SetNomeConta(AValor: AnsiString);
begin
	if not FDiagNomeConta.IsMatch(AValor) then
  	raise EEmail.Create(eeStringEmailInvalida);

	AnsiStrings.StrPCopy(FNomeConta, AValor);
end;

function TEmail.GetParte1: AnsiString;
begin
	Result := AnsiString(FParte1);
end;

procedure TEmail.SetParte1(AValor: AnsiString);
begin
	if not FDiagParte1.IsMatch(AValor) then
  	raise EEmail.Create(eeStringEmailInvalida);

	AnsiStrings.StrPCopy(FParte1, AValor);
end;

function TEmail.GetParte2: AnsiString;
begin
	Result := AnsiString(FParte2);
end;

procedure TEmail.SetParte2(AValor: AnsiString);
begin
	if not FDiagParte2.IsMatch(AValor) then
  	raise EEmail.Create(eeStringEmailInvalida);

  AnsiStrings.StrPCopy(FParte2, AValor);
end;

function TEmail.GetParte3: AnsiString;
begin
	Result := AnsiString(FParte3);
end;

procedure TEmail.SetParte3(AValor: AnsiString);
begin
	if not FDiagParte3.IsMatch(AValor) then
  	raise EEmail.Create(eeStringEmailInvalida);

  AnsiStrings.StrPCopy(FParte3, AValor);
end;

function TEmail.Comprimento: Integer;
var
	intComp3: Integer;
begin
	intComp3 := Length(AnsiString(FParte3));
	Result := Length(AnsiString(FNomeConta)) + Length(AnsiString(FParte1)) +
  	Length(AnsiString(FParte2)) + intComp3;

  Inc(Result, 2);

  if intComp3 > 0 then
  	Inc(Result);
end;

procedure TEmail.LerDe(ANode: TXmlNode);
begin
	Self := ANode.NodeByName('EMAIL').Value;
end;

procedure TEmail.GravarPara(ANode: TXmlNode);
var
	node: TXmlNode;
begin
	node := ANode.FindNode('EMAIL');

  if Assigned(node) then
  	node.Value := AnsiString(Self)
  else
		ANode.NodeNew('EMAIL').Value := AnsiString(Self);
end;

class function TEmail.ValidarEmail(AEmail: AnsiString): Boolean;
begin
  Result := FDiag.IsMatch(AEmail);
end;

class function TEmail.Extrair(ATexto: AnsiString; out AResultado: TDadosExtraidosArray): Integer;
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
    Valido := ValidarEmail(Dados);
  end;

  Result := matches.Count;
end;

class operator TEmail.Implicit(AEmail: AnsiString): TEmail;
var
	match: TMatch;
begin
  match := FDiag.Match(AEmail);

  if not match.Success then
  	raise EEmail.Create(eeStringEmailInvalida);

  with Result do
  begin
	  AnsiStrings.StrPCopy(FNomeConta, match.Groups.Item[1].Value);
  	AnsiStrings.StrPCopy(FParte1, match.Groups.Item[2].Value);
	  AnsiStrings.StrPCopy(FParte2, match.Groups.Item[3].Value);

  	if match.Groups.Count = 5 then
			AnsiStrings.StrPCopy(FParte3, match.Groups.Item[4].Value)
    else
    	FillChar(FParte3, SizeOf(FParte3), 0);
  end;
end;

class operator TEmail.Implicit(AEmail: TEmail): AnsiString;
begin
	with AEmail do
  begin
		Result := AnsiString(FNomeConta) + '@' + AnsiString(FParte1) + '.' +
  		AnsiString(FParte2);

	  if Length(AnsiString(FParte3)) > 0 then
    	Result := Result + '.' + AnsiString(FParte3);
  end;
end;

class operator TEmail.Equal(AEmail1, AEmail2: TEmail): Boolean;
begin
	Result := AnsiCompareStr(AnsiString(AEmail1), AnsiString(AEmail2)) = 0;
end;

class operator TEmail.NotEqual(AEmail1, AEmail2: TEmail): Boolean;
begin
	Result := AnsiCompareStr(AnsiString(AEmail1), AnsiString(AEmail2)) <> 0;
end;

end.
