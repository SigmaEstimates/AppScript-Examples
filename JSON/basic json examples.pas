var JSONDataString = ' {"property1": "value1", "array1": [ {"prop": "val1"}, {"prop": "val2"} ] } ';

var JSONData := JSON.Parse( JSONDataString );

print( JSONData.property1 );
print( JSONData.array1[1].prop );

JSONData.array2 := JSON.NewArray;

var JSONElement := JSON.NewObject;
JSONElement.name := 'John';
JSONData.array2.Add( JSONElement );

JSONElement := JSON.NewObject;
JSONElement.name := 'Susanne';
JSONData.array2.Add( JSONElement );

ShowMessage( JSONBeautify ( JSONData ) );

var JSONDataString2 := JSON.Stringify( JSONData );

print( "Elements: " + JSONData.array2.length );
print( "Element name: " + JSONData.elementname(0) );

for var i := JSONData.array1.low() to JSONData.array1.high() do
  print(JSONData.array1[i].elementname(0) + ": " + JSONData.array1[i].prop );
