// GET via SSL
var Url := 'https://google.dk';
var Response := WebClient.Get(Url);
if (Response.Success) then
  MessageTaskDlg('HTTP Get success', Format('Address: %s|%s', [Url, Response.ContentAsText]), mtInformation, [mbOk])
else
  MessageTaskDlg('HTTP Get error', Format('Address: %s'#13'Error code: %d|%s', [Url, Response.StatusCode, Response.ContentAsText]), mtError, [mbOk]);

// POST
// First we create a new JSON object with some data to POST
var Content := JSON.NewObject;
Content.Property1 := 100;
Content.Property2 := "Hello";
Content.List := JSON.NewArray;
Content.List[0] := 6;
Content.List[1] := 12;

Url := 'http://sigmaservice.net/jsontest/';
//Post the Content data to our test webservice
Response := WebClient.Post(Url, Content, 'application/json');
if (Response.Success) then
begin
  //Parse the returned data from JSON to an AppScript object
  var returnedData = JSON.Parse( Response.ContentAsText );

  //And show the JSON output form the test webservice (which includes our post data)
  MessageTaskDlg('HTTP Post success', JSONBeautify( returnedData ), mtInformation, [mbOk]);

  //Additionally show how to access a specific data:
  ShowMessage(returnedData.data.Property1);
end else
  MessageTaskDlg('HTTP Post error', Format('Address: %s'#13'Error code: %d|%s', [Url, Response.StatusCode, Response.ContentAsText]), mtError, [mbOk]);
  