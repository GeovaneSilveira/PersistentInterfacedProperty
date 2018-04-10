unit Edit1;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls;

type
  TMyInterfacedPersistent = class(TInterfacedPersistent);

  TMyInterfacedPersistentClass = class of TMyInterfacedPersistent;

  TEditTeste = class(TEdit)
  private
    FMyProp: TMyInterfacedPersistent;
    FMyPropClass: TMyInterfacedPersistentClass;
    procedure SetMyPropClass(const Value: TMyInterfacedPersistentClass);
  public
    destructor Destroy; override;

    property MyPropClass: TMyInterfacedPersistentClass read FMyPropClass write SetMyPropClass;
  published
    property MyProp: TMyInterfacedPersistent read FMyProp write FMyProp;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TEditTeste]);
end;

{ TEditTeste }

destructor TEditTeste.Destroy;
begin
  FreeAndNil(FMyProp);
  inherited;
end;

procedure TEditTeste.SetMyPropClass(const Value: TMyInterfacedPersistentClass);
begin
  if (FMyPropClass <> Value) then
  begin
    FMyPropClass := Value;

    FreeAndNil(FMyProp);

    if (FMyPropClass <> nil) then
      FMyProp := FMyPropClass.Create;
  end;
end;

end.
