# delphi_explode_implode
Delphi 2010+ version of PHP functions and more

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
    
