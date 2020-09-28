/*
This example demonstrates custom validation rules. It works by registrering a TValidationSuite, which
is invoked when Sigma runs the validation system. It allows to add new rules, and implements the rule
validation.

The example shows how to validate a custom field, which has an assigned list of allowed values, to
examine whether it has values not allowed.

*/


unit SigmaValidationSuiteCustomFieldValue;

interface

uses
  Sigma.Validation;

type
  // Dictionary of custom field values
  TValueDictionary = array[string] of boolean;

  // Record of a custom field and its values
  TCustomFieldValues = record
    CustomFieldID: string;
    Values: TValueDictionary;
  end;

  // List of custom fields to check during validation
  TCustomFieldValueList = array of TCustomFieldValues;

type
  TValidationSuite = class(TCustomSigmaValidationSuite)
  private
    FSuiteHandle: integer;
    FRuleHandle: integer;
    FCustomFieldValueList: TCustomFieldValueList;
  public
    procedure Registered(ValidationSuiteHandle: integer); override;

    function BeginValidation(Project: TSigmaProject): boolean; override;
    function Validate(Item: TSigmaItem): boolean; override;
    procedure EndValidation; override;

    property SuiteHandle: integer read FSuiteHandle;
    property RuleHandle: integer read FRuleHandle;
  end;

implementation

procedure TValidationSuite.Registered(ValidationSuiteHandle: integer); 
begin
  (*
  ** The Registered() method is called by the validation manager when the
  ** validation suite is registered.
  **
  ** The validation suite handle is used to identify the validation suite.
  *)

  // Save the suite handle.
  FSuiteHandle := ValidationSuiteHandle;

  // Register a single rule into the suite.
  // The passed description string is presently unused.
  // The returned rule handle is used to identify the rule.
  FRuleHandle := SigmaValidationManager.RegisterValidationRule(FSuiteHandle, 'Custom field value is in list');
end;

function TValidationSuite.BeginValidation(Project: TSigmaProject): boolean;
begin
  (*
  ** The BeginValidation() is called when validation begins.
  **
  ** The method should initialize the suite and optionally perform project-level
  ** validation.
  *)


  // Create a list of custom fields and their values that we should verify against
  for var i := 0 to Project.CustomFields.Count-1 do
  begin
    var CustomField := Project.CustomFields[i];

    // Ignore Categories - It's handled by a standard validation rule
    if (CustomField.ID = 'System.Categories') or (CustomField.ID = 'Project.Categories') then
      continue;

    // Only consider custom field if it has a list and disallow unlisted values
    if (CustomField.HasList) and (not CustomField.AllowUnlisted) then
    begin
      var CustomFieldValues: TCustomFieldValues;

      CustomFieldValues.CustomFieldID := CustomField.ID;

      // Copy custom field values to our dictionary
      for var j := 0 to CustomField.Values.Count-1 do
        CustomFieldValues.Values[AnsiUpperCase(CustomField.Values.Names[j])] := True;

      FCustomFieldValueList.Add(CustomFieldValues);
    end;
  end;

  // Return True to continue validating with this suite.
  // If False is returned then the Validate() method will not be called to
  // validate project items.
  Result := True;
end;

function TValidationSuite.Validate(Item: TSigmaItem): boolean;
begin
  (*
  ** The Validate() method is called once for each item in the project and
  ** should perform validation for each validation rule on the passed item.
  *)

  // Our custom rule produces a warning if a custom field value
  // does not exist in the custom field value list.

  // Validate item against each custom field in our list.
  for var i := 0 to FCustomFieldValueList.Count-1 do
  begin
    var Value := Item.CustomFieldValues[FCustomFieldValueList[i].CustomFieldID];
    var sValue := VarToStr(Value);

    // Disregard empty values - there's another validation rule that handles those
    if (sValue <> '') then
    begin
      // Produce a warning if value isn't in list of allowed values
      if (not FCustomFieldValueList[i].Values[AnsiUpperCase(sValue)]) then
        AddResult(FRuleHandle, sevWarning, 'Invalid custom field value: '+sValue, Item);
    end;
  end;

  // Return True to continue validation using this suite on child items.
  // Return False to skip validating child items.
  Result := True;
end;

procedure TValidationSuite.EndValidation;
begin
  (*
  ** The EndValidation() method is called when validation has completed.
  ** The method should release any resources allocated during validation.
  *)
  FCustomFieldValueList.Clear;
end;

var
  FValidationSuite: TValidationSuite;
initialization
  // Create an instance of the custom validation suite...
  FValidationSuite := TValidationSuite.Create;
  // ... and register it with the validation manager.
  SigmaValidationManager.RegisterValidationSuite(FValidationSuite);

finalization
  // Unregister the custom validation suite.
  SigmaValidationManager.UnregisterValidationSuite(FValidationSuite.SuiteHandle);
  FValidationSuite.Free;
end;
