unit uGMUtils;

interface

uses
  SysUtils,
  Classes,
  Graphics,
  StdCtrls,
  Types;
//  Generics.Collections;

type
  TStringArray = Array of String;
  TWideStringArray = Array of WideString;

function explode(const Spliter: Char; const Value: String; const TrimParts: Boolean = True): TStringArray; overload;
function explode(const Spliter: String; const Value: String; const TrimParts: Boolean = True): TStringArray; overload;
function explode_quotes(const Spliter: Char; const Value: String; const TrimParts: Boolean = True): TStringArray; overload;
function explode_quotes(const Spliter: String; const Value: String; const TrimParts: Boolean = True): TStringArray; overload;
function implode(const Spliter: Char; const Value: TStringArray; const TrimParts: Boolean = True): String; overload;
function implode(const Spliter: String; const Value: TStringArray; const TrimParts: Boolean = True): String; overload;
function array_merge(const Spliter: Char; const array1, array2: TStringArray; const AllowDuplicates: Boolean = False): TStringArray;
function in_array(const needle: String; const haystack: TStringArray; const OnlyTheSame: Boolean = False): Boolean;
function array_diff(array1, array2: TStringArray): TStringArray;
function array_intersect(array1, array2: TStringArray): TStringArray;
function array_count(const Value: String; const _array: TStringArray; const OnlyTheSame: Boolean = False): Integer;
function array_delete(const _array: TStringArray; const index: Integer): TStringArray;
function array_index(const needle: String; const haystack: TStringArray; const OnlyTheSame: Boolean = False): Integer;
function array_insert(const Value: String; var _array: TStringArray; index: Integer = -1): Integer;

function explodews(const Spliter: WideString; const Value: WideString; const TrimParts: Boolean = True): TWideStringArray;
function implodews(const Spliter: WideString; const Value: TWideStringArray; const TrimParts: Boolean = True): WideString;
function in_arrayws(const needle: WideString; const haystack: TWideStringArray; const OnlyTheSame: Boolean = False): Boolean;

procedure ClearString(var Value: String; ToClr: String; ToReplace: String = '');
procedure ClearStringWide(var Value: WideString; ToClr: WideString; ToReplace: WideString = '');

function ifString(const cond: Boolean; const valTrue: String; const valFalse: String = ''): String;
function ifDate(const cond: Boolean; const valTrue, valFalse: TDate): TDate;
function ifInteger(const cond: Boolean; const valTrue, valFalse: Integer): Integer;

procedure DebugOutputStrToFile(const FileName: String; const Output: String; const Append: Boolean = False; Encoding: TEncoding = Nil); overload;
procedure DebugOutputStrToFile(const FileName: String; const Output: WideString; const Append: Boolean = False; Encoding: TEncoding = Nil); overload;

function StringMatchesMask(S, Mask: String; const case_sensitive: Boolean = False): Boolean;

function CharFromVirtualKey(Key: Word): Char;
function ShiftStateToKeyData(Shift: TShiftState): Longint;

function ExtractURLProtocol(const URL: String): String;
function ExtractURLHost(const URL: String): String;
function ExtractURLFullPath(const URL: String): String;
function ExtractURLPath(const URL: String): String;
function ExtractURLFileName(const URL: String): String;

function IsDirectoryEmpty(const directory: String): Boolean;

function  FontToString(const Font: TFont): String;
function  StringToFont(const Text: String; var Font: TFont): Boolean;

{
type
  array_<T> = class
    class function insert(const Value: T; var _array: TArray<T>; index: Integer = -1): Integer;
  end;
}

implementation

uses
//  Classes,
//  Controls,
  Windows
//  Graphics,
//  Messages;
  , StrUtils
  ;

{
  function explode
  funkcja rozbija ciag tekstowy na czesci wedlug podanego rozdzielnika
  pascalowa wersje funkcji wystepujacej w PHP

  Autor: Grzegorz Molenda
  Data: 01.2013
  Copyright (C) 2013, Grzegorz Molenda; vitesoft.net; gmnevton@o2.pl

  parametry wejsciowe:
  Spliter: Char      - dowolny znak rozdzielajacy, np.: ',' lub ';'
  Value: String      - dowolny ciag tekstowy zawierajacy znaki rozdzielajace,
                       jesli ciag nie zawiera znakow rozdzielajacych - zwracana jest tablica jednoelementowa zawierajaca ciag
  TrimParts: Boolean - czy usuwac biale znaki z poczatku i konca rozdzielonych tekstow

  zwracana wartosc:
  TStringArray       - dynamiczna tablica ciagow tekstowych,
                       zawierajaca minimum jeden ciag lub pusta tablica, jesli ciag wejsciowy byl pusty

  przyklad:
  result = explode(';', ' tekst1 ; tekst2 ; tekst3 ; ');

    zwroci tablice skladajaca sie z 3 elementow:
    result[0] = 'tekst1';
    result[1] = 'tekst2';
    result[2] = 'tekst3';
}
function explode(const Spliter: Char; const Value: String; const TrimParts: Boolean = True): TStringArray;
begin
  Result:=explode(String(Spliter), Value, TrimParts);
end;

function explode(const Spliter: String; const Value: String; const TrimParts: Boolean = True): TStringArray; overload;
var
  poz, sl: Integer;
  temp_value, temp: String;
begin
  SetLength(Result, 0);
  temp_value:=TrimRight(Value);
  sl:=Length(Spliter);
  if (Length(temp_value) >= sl) and (temp_value[Length(temp_value) - sl + 1] = Spliter) then
    Delete(temp_value, Length(temp_value) - sl + 1, sl)
  else
    temp_value:=Value;

  while temp_value <> '' do begin
    poz:=Pos(Spliter, temp_value);
    if poz > 0 then begin
      temp:=Copy(temp_value, 1, poz - 1);
      SetLength(Result, Length(Result) + 1);
      if TrimParts then
        temp:=Trim(temp);
      Result[High(Result)]:=temp;
      Delete(temp_value, 1, poz + sl - 1);
    end
    else begin
      poz:=Length(temp_value) + 1;
      temp:=Copy(temp_value, 1, poz - 1);
      SetLength(Result, Length(Result) + 1);
      if TrimParts then
        temp:=Trim(temp);
      Result[High(Result)]:=temp;
      Delete(temp_value, 1, poz);
    end;
  end;
end;

function explode_quotes(const Spliter: Char; const Value: String; const TrimParts: Boolean = True): TStringArray;
begin
  Result:=explode_quotes(String(Spliter), Value, TrimParts);
end;

function explode_quotes(const Spliter: String; const Value: String; const TrimParts: Boolean = True): TStringArray; overload;
var
  poz, sl: Integer;
  temp_value, temp: String;

  function inQuotes(const Text: String): Boolean;
  var
    C: Char;
  begin
    Result:=False;
    for C in Text do
      if CharInSet(C, ['''', '"']) then
        Result:=not Result;
  end;

  function deQuoted(var Text: String): Boolean;
  var
    len: Integer;
    quote_char: Char;
  begin
    Result:=False;
    if (Pos('''', Text) > 1) or (Pos('"', Text) > 1) then
      Text:=TrimLeft(Text);
    len:=Length(Text);
    if len > 0 then begin
      quote_char:=#0;
      if CharInSet(Text[1], ['''', '"']) then begin
        quote_char:=Text[1];
        Delete(Text, 1, 1);
        Dec(len);
        Result:=True;
      end;
      if (quote_char <> #0) and (len > 0) and (Text[len] = quote_char) then
        Delete(Text, len, 1);
    end;
  end;

begin
  SetLength(Result, 0);
  temp_value:=TrimRight(Value);
  sl:=Length(Spliter);
  if (Length(temp_value) >= sl) and (temp_value[Length(temp_value) - sl + 1] = Spliter) then
    Delete(temp_value, Length(temp_value) - sl + 1, sl)
  else
    temp_value:=Value;

  poz:=1;
  while temp_value <> '' do begin
    poz:=PosEx(Spliter, temp_value, poz);
    if poz > 0 then begin
      temp:=Copy(temp_value, 1, poz - 1);
      if inQuotes(temp) then begin
        Inc(poz);
        Continue;
      end;
      SetLength(Result, Length(Result) + 1);
      if not deQuoted(temp) and TrimParts then
        temp:=Trim(temp);
//      deQuoted(temp);
      Result[High(Result)]:=temp;
      Delete(temp_value, 1, poz + sl - 1);
      poz:=1;
    end
    else begin
      poz:=Length(temp_value) + 1;
      temp:=Copy(temp_value, 1, poz - 1);
      SetLength(Result, Length(Result) + 1);
      if not deQuoted(temp) and TrimParts then
        temp:=Trim(temp);
//      deQuoted(temp);
      Result[High(Result)]:=temp;
      Delete(temp_value, 1, poz);
    end;
  end;
end;

{
  function implode
  funkcja scalajaca dynamiczna tablice ciagow tekstowych w jeden ciag rozdzelany wedlug podanego rozdzielnika
  pascalowa wersje funkcji wystepujacej w PHP

  Autor: Grzegorz Molenda
  Data: 01.2013
  Copyright (C) 2013, Grzegorz Molenda; vitesoft.net; gmnevton@o2.pl

  parametry wejsciowe:
  Spliter: Char       - dowolny znak rozdzielajacy, np.: ',' lub ';'
  Value: TStringArray - dynamiczna tablica ciagow tekstowych zawierajacych tekst,
                        jesli tablica nie zawiera elementow - zwracany jest pusty ciag tekstowy
  TrimParts: Boolean  - czy usuwac biale znaki z poczatku i konca rozdzielonych tekstow

  zwracana wartosc:
  String              - ciag tekstowy,
                        pusty ciag, jesli ciag wejsciowy byl pusty

  przyklad:
  tab: TStringArray;
  SetLength(tab, 3);
  tab[0] = 'tekst1';
  tab[1] = 'tekst2';
  tab[2] = 'tekst3';
  result = implode(';', tab);

    zwroci ciag skladajacy sie z 3 elementow:
    result = 'tekst1;tekst2;tekst3;';
}
function implode(const Spliter: Char; const Value: TStringArray; const TrimParts: Boolean = True): String;
begin
  Result:=implode(String(Spliter), Value, TrimParts);
end;

function implode(const Spliter: String; const Value: TStringArray; const TrimParts: Boolean = True): String; overload;
var
  i, l, sl: Integer;
  temp_value: String;
begin
  Result:='';
  sl:=Length(Spliter);
  for i:=0 to Length(Value) - 1 do begin
    temp_value:=Value[i];
    l:=Length(temp_value);
    if (l >= sl) and (temp_value[l - sl + 1] = Spliter) then
      Delete(temp_value, l - sl + 1, sl);
    if TrimParts then
      temp_value:=Trim(temp_value);
    if ((Result = '') and (temp_value <> '')) or not in_array(temp_value, explode(Spliter, Result)) then
      Result:=Result + temp_value + Spliter;
  end;
end;

function array_merge(const Spliter: Char; const array1, array2: TStringArray; const AllowDuplicates: Boolean = False): TStringArray;
var
  i: Integer;
  tab: String;
begin
  tab:=implode(Spliter, array1);
  tab:=tab + implode(Spliter, array2);
  Result:=explode(Spliter, tab);
  if not AllowDuplicates then begin
    for i:=Length(Result) - 1 downto 0 do
      if in_array(Result[i], array1) and in_array(Result[i], array2) and (array_count(Result[i], Result) > 1) then
        Result:=array_delete(Result, i);
  end;
end;

function in_array(const needle: String; const haystack: TStringArray; const OnlyTheSame: Boolean = False): Boolean;
var
  i, l: Integer;
  a, b: Integer;
  temp_value: String;
begin
  Result:=False;
  l:=Length(haystack);
  if l = 0 then
    Exit;

  try
    a:=0; // satisfy compiler
    if not OnlyTheSame then
      a:=Length(needle);
    for i:=0 to l - 1 do begin
      temp_value:=haystack[i];
      if not OnlyTheSame then begin
        b:=Length(temp_value);
        if b > a then
          Delete(temp_value, a + 1, b - a);
      end;
      if needle = temp_value then begin
        Result:=True;
        Break;
      end;
    end;
  except
    Result:=False;
  end;
end;

function array_diff(array1, array2: TStringArray): TStringArray;
var
  a, b, i: Integer;
//  c: Integer;
  atmp: TStringArray;
begin
  a:=Length(array1);
  b:=Length(array2);
  if (a > 0) and (b > 0) then begin
    SetLength(Result, 0);
    if b > a then begin
      atmp:=array1;
      array1:=array2;
      array2:=atmp;
//      c:=a;
      a:=b;
//      b:=c;
    end;
    for i:=0 to a - 1 do begin
      if not in_array(array1[i], array2) then begin
        SetLength(Result, Length(Result) + 1);
        Result[High(Result)]:=array1[i];
      end;
    end;
{
    for i:=0 to b - 1 do begin
      if not in_array(array2[i], Result) then begin
        SetLength(Result, Length(Result) + 1);
        Result[High(Result)]:=array2[i];
      end;
    end;
}
  end
  else begin
    if a > 0 then
      Result:=array1
    else
      Result:=array2;
  end;
end;

function array_intersect(array1, array2: TStringArray): TStringArray;
var
  a, b, i: Integer;
//  c: Integer;
  atmp: TStringArray;
begin
  SetLength(Result, 0);
  a:=Length(array1);
  b:=Length(array2);
  if (a > 0) and (b > 0) then begin
    if b > a then begin
      atmp:=array1;
      array1:=array2;
      array2:=atmp;
//      c:=a;
      a:=b;
//      b:=c;
    end;
    for i:=0 to a - 1 do begin
      if in_array(array1[i], array2) then begin
        SetLength(Result, Length(Result) + 1);
        Result[High(Result)]:=array1[i];
      end;
    end;
{
    for i:=0 to b - 1 do begin
      if not in_array(array2[i], Result) then begin
        SetLength(Result, Length(Result) + 1);
        Result[High(Result)]:=array2[i];
      end;
    end;
}
  end;
end;

function array_count(const Value: String; const _array: TStringArray; const OnlyTheSame: Boolean = False): Integer;
var
  i: Integer;
  a, b: Integer;
  temp_value: String;
begin
  Result:=0;
  a:=0; // satisfy compiler
  if not OnlyTheSame then
    a:=Length(Value);
  for i:=0 to Length(_array) - 1 do begin
    temp_value:=_array[i];
    if not OnlyTheSame then begin
      b:=Length(temp_value);
      if b > a then
        Delete(temp_value, a + 1, b - a);
    end;
    if Value = temp_value then
      Inc(Result);
  end;
end;

function array_delete(const _array: TStringArray; const index: Integer): TStringArray;
var
  ALength: Integer;
  TailElements: Integer;
begin
  Result:=_array;
  ALength:=Length(_array);
  if ALength = 0 then
    Exit;

  if (index < 0) or (index > ALength - 1) then
    Exit;

  Finalize(Result[index]);
  TailElements := (ALength - 1) - Index;
  if TailElements > 0 then
    Move(Result[index + 1], Result[index], SizeOf(String) * TailElements);
//  Initialize(Result[ALength - 1]);
  SetLength(Result, ALength - 1);
end;

function array_index(const needle: String; const haystack: TStringArray; const OnlyTheSame: Boolean = False): Integer;
var
  i, l: Integer;
  a, b: Integer;
  temp_value: String;
begin
  Result:=-1;
  l:=Length(haystack);
  if l = 0 then
    Exit;

  try
    a:=0; // satisfy compiler
    if not OnlyTheSame then
      a:=Length(needle);
    for i:=0 to l - 1 do begin
      temp_value:=haystack[i];
      if not OnlyTheSame then begin
        b:=Length(temp_value);
        if b > a then
          Delete(temp_value, a + 1, b - a);
      end;
      if needle = temp_value then begin
        Result:=i;
        Break;
      end;
    end;
  except
    Result:=-1;
  end;
end;

function array_insert(const Value: String; var _array: TStringArray; index: Integer = -1): Integer;
var
  count: Integer;
begin
//  Result:=-1;
  try
    count:=Length(_array);
    SetLength(_array, count + 1);
    Inc(count);

    if index = -1 then
      index:=count - 1;

    if index < count - 1 then
      System.Move(_array[index], _array[index + 1], (count - 1 - index) * SizeOf(String));

    _array[index]:=Value;

    Result:=index;
  except
    Result:=-1;
  end;
end;

{
class function array_<T>.insert(const Value: T; var _array: TArray<T>; index: Integer = -1): Integer;
//begin
//  SetLength(Arr, Length(Arr)+1);
//  Arr[High(Arr)] := Value;
//end;
var
  count: Integer;
begin
//  Result:=-1;
  try
    count:=Length(_array);
    SetLength(_array, count + 1);
    Inc(count);

    if index = -1 then
      index:=count - 1;

    if index < count - 1 then
      System.Move(_array[index], _array[index + 1], (count - 1 - index) * SizeOf(array_<T>));

    _array[index]:=Value;

    Result:=index;
  except
    Result:=-1;
  end;
end;
}

function WideTrim(const WS: WideString): WideString;
var
  I, L: Integer;
begin
  L := Length(WS);
  I := 1;
  while (I <= L) and (WS[I] <= ' ') do Inc(I);
  if I > L then Result := '' else
  begin
    while (L > 0) and (WS[L] <= ' ') do Dec(L);
    Result := Copy(WS, I, L - I + 1);
  end;
end;

function WideTrimLeft(const WS: WideString): WideString;
var
  I, L: Integer;
begin
  L := Length(WS);
  I := 1;
  while (I <= L) and (WS[I] <= ' ') do Inc(I);
  Result := Copy(WS, I, Maxint);
end;

function WideTrimRight(const WS: WideString): WideString;
var
  I: Integer;
begin
  I := Length(WS);
  while (I > 0) and (WS[I] <= ' ') do Dec(I);
  Result := Copy(WS, 1, I);
end;

function explodews(const Spliter: WideString; const Value: WideString; const TrimParts: Boolean = True): TWideStringArray;
var
  poz: Integer;
  temp_value, temp: WideString;
begin
  SetLength(Result, 0);
  temp_value:=WideTrimRight(Value);
  if (Length(temp_value) > 0) and (temp_value[Length(temp_value) - Length(Spliter) + 1] = Spliter) then
    Delete(temp_value, Length(temp_value) - Length(Spliter) + 1, Length(Spliter))
  else
    temp_value:=Value;

  while temp_value <> '' do begin
    poz:=Pos(Spliter, temp_value);
    if poz > 0 then begin
      temp:=Copy(temp_value, 1, poz - 1);
      SetLength(Result, Length(Result) + 1);
      if TrimParts then
        temp:=WideTrim(temp);
      Result[High(Result)]:=temp;
      Delete(temp_value, 1, poz + Length(Spliter) - 1);
    end
    else begin
      poz:=Length(temp_value) + 1;
      temp:=Copy(temp_value, 1, poz - 1);
      SetLength(Result, Length(Result) + 1);
      if TrimParts then
        temp:=WideTrim(temp);
      Result[High(Result)]:=temp;
      Delete(temp_value, 1, poz);
    end;
  end;
end;

function implodews(const Spliter: WideString; const Value: TWideStringArray; const TrimParts: Boolean = True): WideString;
var
  i, l: Integer;
  temp_value: WideString;
begin
  Result:='';
  for i:=0 to Length(Value) - 1 do begin
    temp_value:=Value[i];
    l:=Length(temp_value);
    if (l > 0) and (temp_value[l - Length(Spliter) + 1] = Spliter) then
      Delete(temp_value, l - Length(Spliter) + 1, Length(Spliter));
    if TrimParts then
      temp_value:=WideTrim(temp_value);
    if ((Result = '') and (temp_value <> '')) or not in_arrayws(temp_value, explodews(Spliter, Result)) then
      Result:=Result + temp_value + Spliter;
  end;
end;

function in_arrayws(const needle: WideString; const haystack: TWideStringArray; const OnlyTheSame: Boolean = False): Boolean;
var
  i, l: Integer;
  a, b: Integer;
  temp_value: WideString;
begin
  Result:=False;
  l:=Length(haystack);
  if l = 0 then
    Exit;

  try
    a:=0; // satisfy compiler
    if not OnlyTheSame then
      a:=Length(needle);
    for i:=0 to l - 1 do begin
      temp_value:=haystack[i];
      if not OnlyTheSame then begin
        b:=Length(temp_value);
        if b > a then
          Delete(temp_value, a + 1, b - a);
      end;
      if needle = temp_value then begin
        Result:=True;
        Break;
      end;
    end;
  except
    Result:=False;
  end;
end;

procedure ClearString(var Value: String; ToClr: String; ToReplace: String = '');
var
  i, last, j, k: Integer;
begin
//  Finalize(Result);
//  Result:=Value;
  if ToClr <> '' then begin
    last:=1;
    j:=Length(ToReplace);
    if j = 0 then
      j:=1;
    k:=Length(ToClr);
    i:=PosEx(ToClr, Value, last);
    while i > 0 do begin
      Delete(Value, i, k);
      if ToReplace <> '' then
        Insert(ToReplace, Value, i);
      last:=i + j;
      i:=PosEx(ToClr, Value, last);
    end;
  end;
end;

procedure ClearStringWide(var Value: WideString; ToClr: WideString; ToReplace: WideString = '');
var
  i, last, j, k: Integer;
begin
//  Finalize(Result);
//  Result:=Value;
  if ToClr <> '' then begin
    last:=1;
    j:=Length(ToReplace);
    if j = 0 then
      j:=1;
    k:=Length(ToClr);
    i:=PosEx(ToClr, Value, last);
    while i > 0 do begin
      Delete(Value, i, k);
      if ToReplace <> '' then
        Insert(ToReplace, Value, i);
      last:=i + j;
      i:=PosEx(ToClr, Value, last);
    end;
  end;
end;

function ifString(const cond: Boolean; const valTrue: String; const valFalse: String = ''): String;
begin
  if cond then
    Result:=valTrue
  else
    Result:=valFalse;
end;

function ifDate(const cond: Boolean; const valTrue, valFalse: TDate): TDate;
begin
  if cond then
    Result:=valTrue
  else
    Result:=valFalse;
end;

function ifInteger(const cond: Boolean; const valTrue, valFalse: Integer): Integer;
begin
  if cond then
    Result:=valTrue
  else
    Result:=valFalse;
end;

procedure SaveToFile(const FileName, Output: String; const Append: Boolean; const Encoding: TEncoding);
begin
  try
    with TStreamWriter.Create(FileName, Append, Encoding) do try
      if not Append then begin
        // clear bom header
        BaseStream.Position:=0;
        BaseStream.Size:=0;
      end;
      WriteLine(Output);
    finally
      Free;
    end;
  except
  end;
end;

procedure DebugOutputStrToFile(const FileName: String; const Output: String; const Append: Boolean = False; Encoding: TEncoding = Nil);
begin
{.$IFDEF DEBUG}
  if FindCmdLineSwitch('DEBUG', ['-', '/'], True) then begin
    if Encoding = Nil then
      Encoding:=TEncoding.UTF8;
    SaveToFile(FileName, Output, Append, Encoding);
  end;
{.$ENDIF}
end;

procedure DebugOutputStrToFile(const FileName: String; const Output: WideString; const Append: Boolean = False; Encoding: TEncoding = Nil);
begin
{.$IFDEF DEBUG}
  if FindCmdLineSwitch('DEBUG', ['-', '/'], True) then begin
    if Encoding = Nil then
      Encoding:=TEncoding.UTF8;
    SaveToFile(FileName, Output, Append, Encoding);
  end;
{.$ENDIF}
end;

function StringMatchesMask(S, Mask: String; const case_sensitive: Boolean = False): Boolean;
var
  sIndex, maskIndex: Integer;
begin
  if not case_sensitive then begin
    S := AnsiUpperCase(S);
    Mask := AnsiUpperCase(mask);
  end;
  Result := True; // blatant optimism
  sIndex := 1;
  maskIndex := 1;
  while (sIndex <= Length(S)) and (maskIndex <= Length(mask)) do begin
    case mask[maskIndex] of
      '?': begin // matches any character
        Inc(sIndex);
        Inc(maskIndex);
      end;
      '*': begin // matches 0 or more characters, so need to check for next character in Mask
        Inc(maskIndex);
        if maskIndex > Length(mask) then // * at end matches rest of string
            Exit
        else if CharInSet(mask[maskindex], ['*', '?']) then
            raise Exception.Create('Invalid mask');
        // look for Mask character in S
        while (sIndex <= Length(S)) and (S[sIndex] <> mask[maskIndex]) do
          Inc(sIndex);
        if sIndex > Length(S) then begin // character not found, no match
          Result := False;
          Exit;
        end;
      end;
    else
      if S[sIndex] = mask[maskIndex] then begin
        Inc(sIndex);
        Inc(maskIndex);
      end
      else begin // no match
        Result := False;
        Exit;
      end;
    end;
  end;
  // if we have reached the end of both S and Mask we have a complete match, otherwise we only have a partial match
  if (sIndex <= Length(S)) or (maskIndex <= Length(mask)) then
    Result := False;
end;

function CharFromVirtualKey(Key: Word): Char;
var
  keyboardState: TKeyboardState;
  asciiResult: Integer;
  Buffer: array[0..1] of AnsiChar;
begin
//  Result:=#0;
  GetKeyboardState(keyboardState);
  // Avoid conversion to control characters. We have captured the control key state already in Shift.
  keyboardState[VK_CONTROL] := 0;
  asciiResult := ToAscii(Key, MapVirtualKey(Key, 0), keyboardState, @Buffer, 0);
  case asciiResult of
    0: Result:=#0;
    1: Result:=Char(Buffer[0]);
    2: Result:=#0;
    else
      Result:=#0;
  end;
  ToAscii(Key, MapVirtualKey(Key, 0), keyboardState, @Buffer, 0);
end;

function ShiftStateToKeyData(Shift: TShiftState): Longint;
const
  AltMask = $20000000;
  CtrlMask = $10000000;
  ShiftMask = $08000000;
begin
  Result := 0;
  if ssAlt in Shift then
    Result := Result or AltMask;
  if ssCtrl in Shift then
    Result := Result or CtrlMask;
  if ssShift in Shift then
    Result := Result or ShiftMask;
end;

function ExtractURLProtocol(const URL: String): String;
begin
  Result:='';
  if Pos('://', URL) > 0 then
    Delete(Result, Pos('://', URL), MaxInt);
end;

function ExtractURLHost(const URL: String): String;
var
  i: Integer;
begin
  Result:=URL;
  if Pos('://', Result) > 0 then
    Delete(Result, 1, Pos('://', Result) + 2);
  i:=Pos('/', Result);
  if i > 0 then
    Delete(Result, i, MaxInt);
end;

function ExtractURLFullPath(const URL: String): String;
//var
//  i: Integer;
begin
  Result:=URL;
//  if Pos('://', Result) > 0 then
//    Delete(Result, 1, Pos('://', Result) + 2);
//  if (Length(Result) > 0) and (Result[1] = '/') then
//    Delete(Result, 1, 1);
//  i:=Pos('.', Result);
  if Pos('/', Result) > 0 then
    Delete(Result, LastDelimiter('/', Result) + 1, MaxInt)
  else
    Result:='';
end;

function ExtractURLPath(const URL: String): String;
var
  i: Integer;
begin
  Result:=URL;
  if Pos('://', Result) > 0 then begin
    Delete(Result, 1, Pos('://', Result) + 2);
//  if (Length(Result) > 0) and (Result[1] = '/') then
//    Delete(Result, 1, 1);
    i:=Pos('/', Result);
    if i > 0 then
      Delete(Result, 1, i - 1);
  end;
  if Pos('/', Result) > 0 then
    Delete(Result, LastDelimiter('/', Result) + 1, MaxInt)
  else
    Result:='';
end;

function ExtractURLFileName(const URL: String): String;
begin
  Result:='';
  if Pos('/', URL) > 0 then
    Result:=Copy(URL, LastDelimiter('/', URL) + 1, MaxInt);
end;

function IsDirectoryEmpty(const directory: String): Boolean;
var
  searchRec: TSearchRec;
begin
  if DirectoryExists(ExtractFilePath(directory)) then try
    Result:=not ((FindFirst(IncludeTrailingPathDelimiter(ExtractFilePath(directory)) + '*.*', faAnyFile + faReadOnly + faHidden - faDirectory - faVolumeID, searchRec) = 0) and
                 (FindNext(searchRec) = 0) and
                 (FindNext(searchRec) <> 0));
  finally
    SysUtils.FindClose(searchRec);
  end
  else
    Result:=True;
end;

function  FontToString(const Font: TFont): String;
var
  style: String;
begin
  style:='';
  if fsBold in Font.Style then
    style:=style + 'Bold, ';
  if fsItalic in Font.Style then
    style:=style + 'Italic, ';
  if fsUnderline in Font.Style then
    style:=style + 'Underline, ';
  if fsStrikeOut in Font.Style then
    style:=style + 'StrikeOut, ';
  if style <> '' then begin
    style:=Copy(style, 1, Length(style) - 2);
    Result:=Format('%s, %dpt, %s', [Font.Name, Font.Size, style]);
  end
  else
    Result:=Format('%s, %dpt', [Font.Name, Font.Size]);
end;

function StringToFont(const Text: String; var Font: TFont): Boolean;

  function ToNumber(const str: String): String;
  var
    s: Char;
  begin
    Result:='';
    for s in str do begin
      if s in ['0'..'9', '-'] then
        Result:=Result + s;
    end;
  end;

  procedure AddStyle(const style: String);
  begin
    if style = 'Bold' then
      Font.Style:=Font.Style + [fsBold]
    else if style = 'Italic' then
      Font.Style:=Font.Style + [fsItalic]
    else if style = 'Underline' then
      Font.Style:=Font.Style + [fsUnderline]
    else if style = 'StrikeOut' then
      Font.Style:=Font.Style + [fsStrikeOut];
  end;

var
  parts: TStringArray;
begin
  Result:=False;
  parts:=explode(',', Text, True); // font name, size, style...
  try
    if Length(parts) > 0 then begin
      Font.Name:=parts[0];
      Font.Size:=StrToIntDef(ToNumber(parts[1]), 8);
      Font.Style:=[];
      if Length(parts) > 2 then // style 1
        AddStyle(parts[2]);
      if Length(parts) > 3 then // style 2
        AddStyle(parts[3]);
      if Length(parts) > 4 then // style 3
        AddStyle(parts[4]);
      if Length(parts) > 5 then // style 4
        AddStyle(parts[5]);
      Result:=True;
    end;
  finally
    SetLength(parts, 0);
  end;
end;

end.
