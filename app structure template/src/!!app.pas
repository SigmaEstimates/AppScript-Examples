unit myapp;

interface

uses
  System.UI.Ribbon,
  System.UI.Dialogs,
  System.UI.ActionList,
  System.UI.Progress,
  System.IO,
  System.IO.IniFiles,
  System.Encoding,
  System.Info,
  System.Timers,
  Sigma.Validation,
  Sigma.Document,
  System.Help;

type


TApp = class
  private
  public
    constructor Create;
    destructor Destroy; override;
end;

implementation

constructor TApp.Create;
begin
end;

destructor TApp.Destroy;
begin
  inherited;
end;

initialization

var App := TApp.Create;

finalization

App.Free;
