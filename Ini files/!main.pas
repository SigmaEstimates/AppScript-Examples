uses
  System.IO.Inifiles;

const
  //Inifile will be stored in %APPDATA%\CodeGroup\Sigma Install Folder Name\myinifile.ini
  sInifileName = '%sigma_currentuser%\myinifile.ini';

var Username: string;

procedure LoadSettings;
begin
  var IniFile := TMemoryIniFile.Create;
  try
    IniFile.LoadFromFile(sInifileName);
    Username := IniFile.ReadString('Userinfo', 'Username', '');
  finally
    IniFile.Free;
  end;
end;

procedure SaveSettings(Username: string);
begin
  var IniFile := TMemoryIniFile.Create;
  try
    IniFile.LoadFromFile(sInifileName);

    IniFile.WriteString('Userinfo', 'Username', Username);
    IniFile.SaveToFile(sInifileName);
  finally
    IniFile.Free;
  end;
end;

Username := 'TheUserName';
SaveSettings(Username);
Username := '';
LoadSettings();

showmessage(Username) ;
