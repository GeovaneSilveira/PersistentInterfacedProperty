unit Unit1;

interface

uses
  DesignEditors, DesignIntf, SysUtils, Classes, Edit1, Unit2;

type
  TMyInterfacedPersistentEditor = class(TClassProperty)
  protected
    function HasSubProperties: Boolean;
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;
  end;

  TPropInteger = class(TMyInterfacedPersistent)
  private
    FMinValue: Integer;
    FMaxValue: Integer;
  published
    property MinValue: Integer read FMinValue write FMinValue default 0;
    property MaxValue: Integer read FMaxValue write FMaxValue default 0;
  end;

  TPropString = class(TMyInterfacedPersistent)
  private
    FMaxLength: Integer;
  published
    property MaxLength: Integer read FMaxLength write FMaxLength default 0;
  end;

procedure Register;

implementation

var
  MyPropertyRecorder: TMyPropertyRecorder;

procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(TMyInterfacedPersistent), TEditTeste, 'MyProp', TMyInterfacedPersistentEditor);
end;

{ TMyInterfacedPersistentEditor }

function TMyInterfacedPersistentEditor.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes;

  if not(HasSubProperties) then
    Exclude(Result, paSubProperties);

  Result := Result - [paReadOnly] + [paValueList, paSortList, paRevertable, paVolatileSubProperties];
end;

function TMyInterfacedPersistentEditor.GetValue: string;
begin
  if HasSubProperties then
    Result := TEditTeste(GetComponent(0)).MyProp.ClassType.ClassName
  else
    Result := '';
end;

procedure TMyInterfacedPersistentEditor.GetValues(Proc: TGetStrProc);
var
  i: Integer;
begin
  for i := 0 to (MyPropertyRecorder.Items.Count - 1) do
    Proc(MyPropertyRecorder.Items[i]);
end;

function TMyInterfacedPersistentEditor.HasSubProperties: Boolean;
var
  i: Integer;
begin
  for i := 0 to (PropCount - 1) do
  begin
    Result := TEditTeste(GetComponent(i)).MyProp <> nil;

    if not(Result) then
      Exit;
  end;

  Result := True;
end;

procedure TMyInterfacedPersistentEditor.SetValue(const Value: string);
var
  AClass: TMyInterfacedPersistentClass;
begin
  AClass := TMyInterfacedPersistentClass(MyPropertyRecorder.FindClassByName(Value));

  TEditTeste(GetComponent(0)).MyPropClass := AClass;

  Modified;
end;

initialization
  MyPropertyRecorder := TMyPropertyRecorder.Create;
  MyPropertyRecorder.Register(TPropInteger);
  MyPropertyRecorder.Register(TPropString);
finalization
  MyPropertyRecorder.UnRegister(TPropInteger);
  MyPropertyRecorder.UnRegister(TPropString);
  FreeAndNil(MyPropertyRecorder);
end.
