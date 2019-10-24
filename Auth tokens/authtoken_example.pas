unit TestAuthToken;

interface
implementation

uses
System.Net.HTTP.Client,
Sigma.Document;

procedure NewAuth(App: TSigmaApplication; NotificationType: TSigmaApplicationNotification);
begin
  if NotificationType = anAuthToken then
  begin
    var url := TUri.Create(Application.AuthTokenData);
    if url.Params <> '' then
    begin
      var params := TStringList.Create;
      params.Delimiter := '&';
      params.DelimitedText := url.Params;
      if (params.Values['SigmaApp'] = 'MySigmaAppName') then
         print( params.Values['token'] ); //Should be stored and used...
      params.Free;
    end;
  end;
end;

initialization
  Application.OnNotify := NewAuth;
finalization
  Application.OnNotify := nil;