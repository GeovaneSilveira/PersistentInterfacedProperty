unit Unit2;

interface

uses
  System.Classes;

type
  TMyPropertyRecorder = class
  private
    FItems: TStringList;
  public
    constructor Create;
    destructor Destroy;

    function GetIndexByClass(const AClass: TClass): Integer;
    function FindClassByName(const AClassName: string): TClass;

    property Items: TStringList read FItems;

    procedure Register(const AClass: TClass);
    procedure UnRegister(const AClass: TClass);
  end;

implementation

{ TMyPropertyRecorder }

function TMyPropertyRecorder.GetIndexByClass(const AClass: TClass): Integer;
begin
  Result := FItems.IndexOfObject(TObject(AClass));
end;

constructor TMyPropertyRecorder.Create;
begin
  inherited Create;
  FItems := TStringList.Create;
end;

destructor TMyPropertyRecorder.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

function TMyPropertyRecorder.FindClassByName(const AClassName: string): TClass;
var
  i: Integer;
begin
  Result := nil;

  for i := 0 to (FItems.Count - 1) do
    if (FItems[i] = AClassName) then
    begin
      Result := TClass(FItems.Objects[i]);
      Break;
    end;
end;

procedure TMyPropertyRecorder.Register(const AClass: TClass);
begin
  if (GetIndexByClass(AClass) = -1) then
    FItems.AddObject(AClass.ClassName, TObject(AClass));
end;

procedure TMyPropertyRecorder.UnRegister(const AClass: TClass);
var
  i: Integer;
begin
  i := GetIndexByClass(AClass);

  if (i > -1) then
    FItems.Delete(i);
end;

end.
