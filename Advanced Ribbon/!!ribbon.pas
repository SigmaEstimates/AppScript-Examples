unit RibbonDemo;

interface


uses
  System.UI.Ribbon,
  System.UI.Dialogs,
  System.UI.ActionList,
  Sigma.Document;

type
  TRibbonDemo = class
  private
    FActionList: TActionList;
    FRibbonTab: TRibbonTab;
  protected
    procedure OnActionFirstUpdate(Sender: TAction);
    procedure OnActionFirstExecute(Sender: TAction);
    procedure OnActionDoItExecute(Sender: TAction);
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

constructor TRibbonDemo.Create;
var
  Group: TRibbonTabGroup;
  Item: TRibbonItem;
begin
  FActionList := TActionList.Create(nil);

  FRibbonTab := Ribbon.Tabs.Add;
  try
    FRibbonTab.Caption := 'Ribbon test';

    Group := FRibbonTab.Groups.Add;
    Group.Caption := 'Project';
    // ---
    var Action := FActionList.Add;
    Action.Caption := 'First';
    Action.OnUpdate := OnActionFirstUpdate;
    Action.OnExecute := OnActionFirstExecute;
    Item := Group.Items.Add(TRibbonLargeButtonItem);
    Item.Action := Action;
    //Item.LargeGlyph.LoadFromFile('First 32x32.png');

    Action := FActionList.Add;
    Action.Caption := 'Second';
    Action.Enabled := True;
    Action.OnExecute := procedure(Sender: TAction)
      begin
        ShowMessage(Application.ActiveProject.Name);
      end;
    Action.OnUpdate := procedure(Sender: TAction)
      begin
        Sender.Enabled := (Application.ActiveProject <> nil);
      end;
    Item := Group.Items.Add(TRibbonLargeButtonItem);
    Item.Action := Action;
    //Item.LargeGlyph.LoadFromFile('second 32x32.png');

    Item := Group.Items.Add(TRibbonLargeButtonItem);
    Item.Caption := 'About';
    //Item.LargeGlyph.LoadFromFile('about 32x32.png');
    Item.BeginGroup := True;
    Item.OnClick := procedure(Sender: TRibbonItem)
      begin
        ShowMessage(
          'Ribbon demo'+#13+
          'Version 1.0'+#13#13+
          '© 2016 Sigma Estimates'
        );
      end;

    Group := FRibbonTab.Groups.Add;
    Group.Caption := 'Stuff';
    // ---
    Action := FActionList.Add;
    Action.Caption := _('Do it!');
    Action.Enabled := True;
    Action.OnExecute := OnActionDoItExecute;
    Item := Group.Items.Add(TRibbonButtonItem);
    Item.Action := Action;
    //Item.Glyph.LoadFromFile('do it 16x16.bmp');


    Item := Group.Items.Add(TRibbonLargeButtonItem);
    Item.Caption := 'Drop down';
    TRibbonButtonItem(Item).ButtonStyle := rbsDropDown;
    TRibbonButtonItem(Item).DropDownEnabled := True;
    //Item.LargeGlyph.LoadFromFile('dropdown 32x32.bmp');

    var MenuItem := TRibbonLargeButtonItem(Item).DropDownMenu.Items.Add(TRibbonButtonItem);
    MenuItem.Caption := 'First item';
    MenuItem.OnClick := procedure(Sender: TRibbonItem)
      begin
        ShowMessage(Sender.Caption+' clicked');
      end;

    MenuItem := TRibbonLargeButtonItem(Item).DropDownMenu.Items.Add(TRibbonButtonItem);
    MenuItem.Caption := 'Second item';
    MenuItem.OnClick := procedure(Sender: TRibbonItem)
      begin
        ShowMessage(Sender.Caption+' clicked');
      end;

    FRibbonTab.Activate;
  except
    FRibbonTab.Free;
    FRibbonTab := nil;
    raise;
  end;
end;

destructor TRibbonDemo.Destroy;
begin
  FRibbonTab.Free;
  FActionList.Free;
  inherited;
end;


// -----------------------------------------------------------------------------
procedure TRibbonDemo.OnActionFirstUpdate(Sender: TAction);
begin
  Sender.Enabled := True;
end;

procedure TRibbonDemo.OnActionFirstExecute(Sender: TAction);
begin
  Showmessage(Format("Hello from %s", [Sender.Caption]));
end;

procedure TRibbonDemo.OnActionDoItExecute(Sender: TAction);
begin
  ShowMessage('"Doing" it...');
end;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
var
  FRibbonDemo: TRibbonDemo = nil;

initialization
  FRibbonDemo := TRibbonDemo.Create;
finalization
  FRibbonDemo.Free;
end.