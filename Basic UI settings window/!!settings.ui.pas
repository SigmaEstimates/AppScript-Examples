//First, name the unit (this name is used to potentially include it in other units)
unit UIExample;

//The interface section is used to define types and classes
interface

//Uses are inclusion of other libraries/units
uses
  System.UI.Dialogs,   // A library containing various Dialog methods, including ShowMessage()
  System.UI.Progress,  // Library to show and control progress bars
  System.UI.Controls,  // UI Controls to be used in custom dialogs
  System.UI.Layout,    // Layout helper for creating custom dialogs
  Sigma.Document;      // Access to the Sigma application, the documents (projects) and their data
type

//We create a new class names TApp, that is inherited from the TDialog class, that has methods and properties
//for creating a dialog window
TSettingsDialog = class(TDialog)

  //Private properties, methods, variables - not accessiable outside the class
  private
    procedure OnUseInsightClick (Control: TControl);
    Levels: TSpinEdit;
    UseInsight: TCheckbox;
    IndentLevel: TSpinEdit;
    LookupCustomFields: TCheckBox;
    InsightView: TCombobox;
    function GetInsightView: TCombobox;

  //Public properties, methods, variables - visible and accessible outside the class
  public
    property UIInsightView: TCombobox read GetInsightView;
    constructor Create;
end;

//After the interface section follows the implementation section, that must implement all classes
implementation

//Implenting a class constructor is done this way:
constructor TSettingsDialog.Create;
begin
  //Since we want the ancestor class properties and methods to be initialized we call inherited Create
  inherited Create;

  //General settings for the window/dialog (these are properties on the TDialog class
  Height := 300;
  Caption := "My settings dialog";
  Title := "Settings my fantastic App";

  //Create a TLayout, that will help us with the layout of control items
  var Layout := TLayout.Create(Self);
  Layout.Parent := Container;  //Connect it to the dialog
  Layout.ParentBackground := true;
  Layout.Align := alClient;

  //Also, create a layout style and applyto the layout helper
  var MyLayoutStyle := TLayoutStyle.Create;
  MyLayoutStyle.GroupOptions.Color := $ffffff;
  Layout.Style := MyLayoutStyle;

  //To demonstrate tabbed groups, we first create a main group and set
  // LayoutDirection to Tabbed. Try to use ldHorizontal instead...
  var grSettings := Layout.Items.CreateGroup;
  grSettings.LayoutDirection := ldTabbed;
  grSettings.ShowBorder := false;
  grSettings.Width := Layout.Width;

  //Now create two sub groups
  var grStandard := grSettings.CreateGroup;
  grStandard.Caption.Text := "Standard";
  var grAdvanced := grSettings.CreateGroup;
  grAdvanced.Caption.Text := "Advanced";

  //Create a checkbox, and insert in the Standard group
  UseInsight := TCheckbox.Create(Self);
  UseInsight.Caption := "Use insight view";
  var Item := grStandard.CreateItem(UseInsight);
  UseInsight.OnClick := OnUseInsightClick;  //Assign a procedure to react on clicking the checkbox

  //Create a dropdows, and insert in the Standard group
  //Also, get the list of Insight views in the current project, and add to list
  InsightView := TComboBox.Create(Self);
  InsightView.Width := 200;
  InsightView.DropDownListStyle := lsFixedList;
  for var i := 0 to Application.ActiveProject.InsightViews.Count-1 do
     InsightView.Items.Add(Application.ActiveProject.InsightViews.Items[i].Name);
  Item := grStandard.CreateItem(InsightView);
  Item.Caption.Text := "Insight:";

  //Add a spin control
  Levels := TSpinEdit.Create(Self);
  Levels.Value := 2;
  Levels.Width := 50;
  Levels.ValueType :=ValueTypeinteger;
  Item := grStandard.CreateItem(Levels);
  Item.Caption.Text := "Max levels";
  Item.AlignHorz :=  ahLeft;

  var Edit = TEdit.Create(Self);
  Item := grAdvanced.CreateItem(Edit);
  Item.Caption.Text := 'Write here:';

end;

//Helper function for getting the UIInsightView property
function TSettingsDialog.GetInsightView: TCombobox;
begin
  result := InsightView;
end;


//Procedure to react on the setting of UseInsight
procedure TSettingsDialog.OnUseInsightClick (Control: TControl);
begin
  InsightView.Enabled := UseInsight.Checked;
end;

//The initialization part is executed when Sigma loads the AppScript
initialization

  //Create an instance of our TSettingsDialog, show it, and tell which Insight was chosen.
  var MyDialog := TSettingsDialog.Create;
  MyDialog.ShowModal;

  ShowMessage('You selected the Insight named: ' + MyDialog.UIInsightView.Items[ MyDialog.UIInsightView.ItemIndex ]);

//The finalization part is executed when Sigma unloads the AppScript (when Sigma is closed/terminated)
finalization
  //Free up the resources
  MyDialog.Free;

end.