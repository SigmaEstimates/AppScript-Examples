//First, name the unit (this name is used to potentially include it in other units)
unit ExportExcelAndCSV;


//The interface section is used to define types and classes
interface

//Uses are inclusion of other libraries/units
uses
    Sigma.Document,       // Access to the Sigma application, the documents (projects) and their data
    System.UI.Dialogs,    // A library containing various Dialog methods, including ShowMessage()
    System.UI.Ribbon,     // A library providing access to the Application Ribbon (for adding/manipulating Ribbons and buttons)
    COM;                  // A library providing access to Windows COM servers (in this case to communicate with Excel)

//Type definitions, including classes
type

//We create a new class names TApp, that is inherited from the base class
TApp = class
  
  //Private properties, methods, variables - not accessiable outside the class
  private
    CSVLine: TStringList;
    FRibbonTab: TRibbonTab;
    FRow := 5;

    procedure ExportCSV(Sender: TRibbonItem);
    procedure ExportCSVComponent(Item: TSigmaItem; CSV: TStringList);

    procedure ExportExcel(Sender: TRibbonItem);
    procedure ExportExcelComponent(Sheet: COMVariant; Item: TSigmaItem);

  //Public properties, methods, variables - visible and accessible outside the class
  public

    procedure AddRIbbon();
    procedure RemoveRIbbon();
end;

//After the interface section follows the implementation section, that must implement all classes
implementation

//Implenting a class method (procedure or function) is done this way:
procedure TApp.AddRibbon();
begin
    //Create new Ribbon tab and group
    FRibbonTab := Ribbon.Tabs.Add;
    FRibbonTab.Caption := 'Export Tools';
    var FGroup := FRibbonTab.Groups.Insert(0);
    FGroup.Caption := 'Export';

    //Add button to execute App
    var Item := FGroup.Items.Add(TRibbonLargeButtonItem);
    Item.OnClick := ExportCSV;  //Assign a method to call when clicking the Ribbon button
    Item.Caption := "CSV file export";
    Item.LargeGlyph.LoadFromFile('export_csv.png', true);  //Expected in the same folder as the AppScript file (or the same .sigmabundle file)

    Item := FGroup.Items.Add(TRibbonLargeButtonItem);
    Item.OnClick := ExportExcel;
    Item.Caption := "Excel file export";
    Item.LargeGlyph.LoadFromFile('export_excel.png', true);
end;

procedure TApp.RemoveRibbon();
begin
   FRibbonTab.Free;  //Will remove the Ribbon Tab
end;

procedure TApp.ExportCSV(Sender: TRibbonItem);
begin
    //Create a new AppScript insightview
    var FInsightViewTree := TSigmaInsightViewTree.Create( Application.ActiveProject );

    //Get a handle to an existing Insight view in the active project
    var InsightView := Application.ActiveProject.InsightViews.FindByName("Location");

    //Ensure Insight view exists, load settings from existing and build with project root as source
    ASSERT(InsightView <> nil);
    FInsightViewTree.LoadSettings(InsightView.Setup);
    FInsightViewTree.Build(Application.ActiveProject.RootItem);

    //Create CSV file holder based on TStringList class
    var CSVFile := new TStringList;

    //Create instance of CSV Line, used to produce every CSV file line (record)
    CSVLine := new TStringList;
    CSVLine.Delimiter := ';';
    
    //Build a header line
    CSVLine.Add("Level");
    CSVLine.Add("Text");
    CSVLine.Add("Phase");
    CSVLine.Add("SalesPrice");
    CSVFile.Add( CSVLine.Delimitedtext);

    //Now recursively add all lines from insight and save to file
    ExportCSVComponent(FInsightViewTree.RootItem, CSVFile);
    CSVFile.SaveToFile("output.csv");

    CSVLine.Free;

end;

procedure TApp.ExportCSVComponent(Item: TSigmaItem; CSV: TStringList);
begin
    //Prepare for new line, and add columns
    CSVLine.Clear;
    CSVLine.Add( IntToStr(Item.Level) );
    CSVLine.Add(Item.Values[tcText]);
    CSVLine.Add(Item.CustomFieldValues["Phase"]);
    CSVLine.Add(Item.Values[tcSalesPrice]);
    CSV.Add( CSVLine.Delimitedtext);

    //Recursively add children
    for var i := 0 to Item.Items.Count-1 do
        if Item.Items.Count > 0 then
            ExportCSVComponent(Item.Items[i], CSV);

end;


procedure TApp.ExportExcel(Sender: TRibbonItem);
begin
    //Create a new AppScript insightview
    var FInsightViewTree := TSigmaInsightViewTree.Create(Application.ActiveProject);

    //Get a handle to an existing Insight view in the active project
    var InsightView := Application.ActiveProject.InsightViews.FindByName("Location");

    //Ensure Insight view exists, load settings from existing and build with project root as source
    ASSERT(InsightView <> nil);
    FInsightViewTree.LoadSettings(InsightView.Setup);
    FInsightViewTree.Build(Application.ActiveProject.RootItem);

    //Create Excel COM object
    var MSExcel := CreateOleObject('Excel.Application');
	
    //To speed up things, we don't want Excel to reflect changes during the proces
    MSExcel.ScreenUpdating := False;
	
    //Now add a workbook - if you give an excel file as argument to Add, it will be used as template
    var WorkBook := MSExcel.Workbooks.Add();
	
    //And finally select the first sheet (there is always a sheet in a new workbook)
    var Sheet := WorkBook.Sheets(1);

    //Now recursively add all lines from insight and show Excel
    FRow := 5;
    ExportExcelComponent(Sheet, FInsightViewTree.RootItem);

    MSExcel.ScreenUpdating := True;
    Sheet.Activate;
    MSExcel.Visible := true;
    MSExcel.WindowState := -4137; //xlMaximized

end;

procedure TApp.ExportExcelComponent(Sheet: COMVariant; Item: TSigmaItem);
begin
    Sheet.Cells(FRow, 1).Value := IntToStr(Item.Level);
    Sheet.Cells(FRow, 2).Value := Item.Values[tcText];
    if Item.Level>0 then
       Sheet.Cells(FRow, 2).InsertIndent( Item.Level );
    Sheet.Cells(FRow, 3).Value := Item.CustomFieldValues["Phase"];
    Sheet.Cells(FRow, 4).Value := Item.Values[tcSalesPrice];
    FRow := FRow +1;

    //Recursively add children
    for var i := 0 to Item.Items.Count-1 do
        if Item.Items.Count > 0 then
            ExportExcelComponent(Sheet, Item.Items[i]);

end;

//The initialization part is executed when Sigma loads the AppScript
initialization

var MyApp := TApp.Create;
MyApp.AddRIbbon;

//The finalization part is executed when Sigma unloads the AppScript (when Sigma is closed/terminated)
finalization

MyApp.RemoveRIbbon;
MyApp.Free;

