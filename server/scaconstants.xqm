module namespace _ = "urn:dcore:diaggy:constants:sca";

declare variable $_:SPACING := 10;
declare variable $_:INSETS := 20;

declare variable $_:ARROW_LENGTH := 60;
declare variable $_:ARROW_HEIGHT := 30;
declare variable $_:ARROW_LENGTH_HALF := $_:ARROW_LENGTH div 2;
declare variable $_:ARROW_HEIGHT_HALF := $_:ARROW_HEIGHT div 2;
declare variable $_:ARROW_OFFSET := $_:ARROW_LENGTH_HALF;
declare variable $_:ARROW_OFFSET_NEG := - $_:ARROW_OFFSET;
declare variable $_:ARROW_POINTS := "0,0 50,0 60,15 50,30 0,30 10,15";
declare variable $_:COMPOSITE_WIDTH := 300;
declare variable $_:COMPOSITE_HEIGHT := 150;
declare variable $_:COMPONENT_WIDTH := 150;
declare variable $_:COMPONENT_HEIGHT := 100;
declare variable $_:PROPERTY_WIDTH := 20;
declare variable $_:PROPERTY_HEIGHT := 30;
declare variable $_:IMPLEMENTATION_WIDTH := 150;
declare variable $_:IMPLEMENTATION_HEIGHT := 30;