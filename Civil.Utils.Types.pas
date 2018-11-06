(***
 * Civil.Utils.Types.pas;
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2018 Eng.º Anderson Marques Ribeiro
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

unit Civil.Utils.Types;

interface

uses
	SysUtils, Classes, Math, System.Variants, Generics.Collections, Civil.Utils,
  NativeXml, RegularExpressions, AnsiStrings, Winapi.Windows;

const
 	// DIGITO_INF, DIGITO_SUP;
  //
  // O tipo TAnsiDigitoType é construído usando-se estas duas constantes e não
  // ---- diretamente com '0'..'9'. É necessário proceder deste jeito para que
	//			TAnsiDigitoType não seja do tipo Char, que usa 2 bytes. Esta declara-
  //			ção força TDigitoType a ser AnsiChar.
  // ***************************************************************************
 	DIGITO_INF = AnsiChar('0');
  DIGITO_SUP = AnsiChar('9');

type

 	TAnsiDigitoType = DIGITO_INF..DIGITO_SUP;

  (***
   * TDadosExtraidosRec;
   *
   * Os tipos definidos nesta unidade são capazes de extrair informações de tex-
   * ---- tos. Esta estrutura serve para organizar os dados obtidos.
   *)
  TDadosExtraidosRec = record
  	Dados: AnsiString;
    Posicao: Integer;
    Valido: Boolean;
  end; { TDadosExtraidos }
  TDadosExtraidosArray = array of TDadosExtraidosRec;

implementation

end.
