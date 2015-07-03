module namespace _ = "urn:dcore:diaggy:visitor:sca";

import module namespace const = "urn:dcore:diaggy:constants:sca" at "scaconstants.xqm";

declare namespace sca = "http://docs.oasis-open.org/ns/opencsa/sca/200903";

declare function _:visit($sca as node()) as map(*){
  let $composites := $sca/sca:composite
  for $composite at $pos in $composites
  return _:visit-composite($composite, $pos, count($composites))
};

declare function _:visit-composite($composite as element(),  $pos as xs:integer, $count as xs:integer) as map(*){
  let $components := _:visit-components($composite)
  let $properties := _:visit-properties($composite)
  let $services := _:visit-services($composite)
  let $references := _:visit-references($composite)
  let $wires := _:visit-wires($composite)
  let $ast:= map {
        "components" : $components,
        "properties" : $properties,
        "services" : $services,
        "references" : $references,
        "wires" : $wires,
        "name" : $composite/string(@name),
        "class" : "scacomposite",
        "draggable" : "true", 
        "title" : $composite/string(@name), 
        "description" : $composite/string(@name),
        "width" : $const:COMPOSITE_WIDTH, 
        "height" : $const:COMPOSITE_HEIGHT
  }
  let $ast := _:estimate-composite-width($ast)
  let $ast := _:estimate-composite-height($ast)
  return $ast
};

declare function _:visit-components($composite as element()) as map(*)*{
  let $components := $composite/sca:component
  for $component at $pos in $components
  return _:visit-component($component, $pos, count($components))
};

declare function _:visit-component($component as element(), $pos as xs:integer, $count as xs:integer) as map(*){
  let $services := _:visit-services($component)
  let $references := _:visit-references($component)
  let $properties := _:visit-properties($component)
  let $implementations := _:visit-implementations($component)
  let $ast := map {
      "services" : $services,
      "references" : $references,
      "properties" : $properties,
      "implementations" : $implementations,
      "name" : $component/string(@name), 
      "class" : "scacomponent",
      "draggable" : "true", 
      "title" : $component/string(@name), 
      "description" : $component/string(@name), 
      "height" : $const:COMPONENT_HEIGHT, 
      "x" : 10, 
      "y" : 20 
  }
  let $ast := _:estimate-component-width($ast)
  let $ast := _:estimate-component-height($ast)
  return $ast
};

declare function _:visit-services($component as element()) as map(*)*{
  let $services := $component/sca:service
  for $service at $pos in $services
  return _:visit-service($service, $pos, count($services))
};

declare function _:visit-service($service as element(),  $pos as xs:integer, $count as xs:integer) as map(*){
  let $ast := map {
      "name" : $service/string(@name), 
      "class" : "scaservice", 
      "draggable" : "y-true",
      "width" : $const:ARROW_LENGTH, 
      "height" : $const:ARROW_HEIGHT, 
      "y" : $const:PROPERTY_HEIGHT + $const:SPACING + ($pos - 1) * ($const:ARROW_HEIGHT + $const:SPACING),
      "x" : -$const:ARROW_LENGTH_HALF,
      "title" : $service/string(@name), 
      "description" : $service/string(@name)
  }
  return $ast
  
};

declare function _:visit-references($component as element()) as map(*)*{
  let $references := $component/sca:reference
  for $reference at $pos in $references 
  return _:visit-reference($reference, $pos, count($references))
};

declare function _:visit-reference($reference as element(), $pos as xs:integer, $count as xs:integer) as map(*){
  let $ast := map {
      "name" : $reference/string(@name), 
      "class" : "scareference", 
      "draggable" : "y-true",
      "width" : $const:ARROW_LENGTH, 
      "height" : $const:ARROW_HEIGHT, 
      "y" : $const:PROPERTY_HEIGHT + $const:SPACING + ($pos - 1) * ($const:ARROW_HEIGHT + $const:SPACING), 
      "-x" : -$const:ARROW_LENGTH_HALF,
      "title" : $reference/string(@name), 
      "description" : $reference/string(@name)
  }
  return $ast
};

declare function _:visit-properties($component as element()) as map(*)*{
  let $properties := $component/sca:property
  for $property at $pos in $properties
  return _:visit-property($property, $pos, count($properties))
};

declare function _:visit-property($property as element(), $pos as xs:integer, $count as xs:integer) as map(*){
  let $ast := map {
      "name" : $property/string(@name), 
      "class" : "scaproperty", 
      "draggable" : "false",
      "width" : $const:PROPERTY_WIDTH, 
      "height" : $const:PROPERTY_HEIGHT, 
      "title" : $property/string(@name) || "=" || $property/string(@value), 
      "description" : $property/string(@name) || "=" || $property/string(@value),
      "y" : -$const:PROPERTY_HEIGHT div 2, 
      "x" : $const:SPACING + $pos * ($const:PROPERTY_WIDTH + $const:SPACING)
  }
  return $ast
};

declare function _:visit-implementations($component as element()) as map(*)*{
  $component/*[matches(local-name(),"^implementation.*")] ! _:visit-implementation(.)
};

declare function _:visit-implementation($implementation as element()) as map(*){
  let $name := 
    if ( exists($implementation/@name) ) then $implementation/string(@name)
    else if (exists($implementation/@xsi:type)) then substring-after($implementation/string(@xsi:type), ":")
    else substring-after(local-name($implementation), ".")
  let $ast := map {
      "name" : $name,
      "class" : "scaimplementation", 
      "draggable" : "false",
      "width" : $const:IMPLEMENTATION_WIDTH,
      "height" : $const:IMPLEMENTATION_HEIGHT, 
      "title" : $name, 
      "description" : "implementation " || $name,
      "-y" : - ($const:IMPLEMENTATION_HEIGHT div 2), 
      "x" : $const:SPACING
  }
  return $ast
};

declare function _:visit-wires($composite as element()){
  let $wires := _:compute-wires($composite)
  for $wire in $wires
  return _:visit-wire($wire)
};

declare function _:visit-wire($wire as element()){
  let $ast := map {
      "source" : $wire/string(@source),
      "prolog" : " m" || $const:ARROW_LENGTH || "," || $const:ARROW_HEIGHT_HALF || " l10,0",
      "epilog" : " l10,0",
      "target" : $wire/string(@target),
      "ofsy" : $const:ARROW_HEIGHT_HALF,
      "class" : "scawire", 
      "draggable" : "false"
  }
  return $ast
};

declare function _:compute-wires($scacomposite as element(sca:composite)){
  let $explicitwires := $scacomposite/sca:wire
  let $implicitwires := for $component in $scacomposite/sca:component[sca:reference/@target]
                        return
                          for $reference in $component/sca:reference[@target]
                          let $tgt := $reference/string(@target)
                          let $src := $component/string(@name) || "/" || $reference/string(@name)
                          return <sca:wire source="{$src}" target="{$tgt}"/>
  let $promotionwires := (
      $scacomposite/sca:service ! <sca:wire source="{./@name}" target="{./@promote}"/>,
      $scacomposite/sca:reference ! <sca:wire source="{./@promote}" target="{./@name}"/>
  )
  
  return ($explicitwires, $implicitwires, $promotionwires)
};

declare function _:estimate-component-width($info as map(*)){
   map:put($info, "width",
           $const:COMPONENT_WIDTH + count($info('properties')) * ($const:PROPERTY_WIDTH + $const:SPACING)
   )
};

declare function _:estimate-component-height($info as map(*)){
   map:put($info, "height",
           $const:COMPONENT_HEIGHT + 
           max((count($info('services')), count($info('references')))) * 
           ($const:ARROW_HEIGHT + $const:SPACING)
   )
};

declare function _:estimate-composite-width($info as map(*)){
   map:put($info, "width",
           max(($const:COMPOSITE_WIDTH,
             sum($info('components') ! map:get(., "width"))
           )) 
   )
};

declare function _:estimate-composite-height($info as map(*)){
   map:put($info, "height",
           max(($const:COMPOSITE_WIDTH,
             sum($info('components') ! map:get(., "height"))
           )) 
   )
};


(:
declare variable $_:SPACING := 10;

declare variable $_:ARROW_LENGTH := 40;
declare variable $_:ARROW_HEIGHT := 20;
declare variable $_:ARROW_LENGTH_HALF := $_:ARROW_LENGTH div 2;
declare variable $_:ARROW_HEIGHT_HALF := $_:ARROW_HEIGHT div 2;
declare variable $_:ARROW_OFFSET := $_:ARROW_LENGTH_HALF;
declare variable $_:ARROW_OFFSET_NEG := - $_:ARROW_OFFSET;
declare variable $_:ARROW_POINTS := "0,0 30,0 40,10 30,20 0,20 10,10";

declare variable $_:COMPOSITE_WIDTH := 300;
declare variable $_:COMPOSITE_HEIGHT := 150;
declare variable $_:COMPONENT_WIDTH := 150;
declare variable $_:PROPERTY_WIDTH := 20;
declare variable $_:PROPERTY_HEIGHT := 30;

declare function _:draw-arrow($name as xs:string, $class as xs:string){
  <svg overflow="visible" width="{$_:ARROW_LENGTH}" height="{$_:ARROW_HEIGHT}"
        class="{$class||'container'}" name="{$name}">
     <title>{$name}</title>
     <description>{$name}</description>
     <polygon name="{$name}" points="{$_:ARROW_POINTS}" class="{$class}"/>
     <text x="15" y="15" class="servicelabel">{$name}</text>
  </svg>
};

declare function _:render-service($scaservice as element()){
   _:draw-arrow(string($scaservice/@*:name), "service")  
};

declare function _:render-reference($scareference as element()){
   _:draw-arrow(string($scareference/@*:name), "reference")
};

declare function _:render-property($property as element()){
   let $name := string($property/@*:name)
   let $value := string($property/@*:value)
   return
   <svg width="{$_:PROPERTY_WIDTH}" height="{$_:PROPERTY_HEIGHT}" y="{-($_:PROPERTY_HEIGHT div 2)}" 
   		class="propertycontainer" name="{$name}">
     <title>{$name || '=' || $value}</title>
     <description>{$name || '=' || $value}</description>
     <rect name="{$name}" width="{$_:PROPERTY_WIDTH}" height="{$_:PROPERTY_HEIGHT}" class="property"/>
     <text x="0" y="{$_:PROPERTY_HEIGHT - 10}" >{$name}</text>
   </svg>
};

declare function _:render-implementation($impl as element()){
   let $name := string($impl/@*:name)
   let $value := $impl/local-name()
   return
   <svg width="{$_:COMPONENT_WIDTH}" height="{$_:PROPERTY_HEIGHT}" x="{$_:ARROW_LENGTH_HALF + $_:SPACING}" 
   		class="implementationcontainer" name="{$name}">
     <title>{$name || '=' || $value}</title>
     <description>{$name || '=' || $value}</description>
     <rect name="{$name}" width="{$_:COMPONENT_WIDTH}" height="{$_:PROPERTY_HEIGHT}" class="implementation"/>
     <text x="0" y="{$_:PROPERTY_HEIGHT - 10}" >{$value}</text>
   </svg>
};

declare function _:optimize-widgets($estimatedwidth as xs:double, $estimatedinternalwidth as xs:double, $estimatedheight as xs:double, 
                                    $uiservices as element()*, $uireferences as element()*, $uiproperties as element()*){

  let $servicearea := <svg class="servicearea" x="0" y="0" width="{$_:ARROW_LENGTH}" height="{$estimatedheight}">
                        {
                         for $service at $pos in $uiservices
                         return copy $newservice := $service modify(
                         insert node attribute {xs:QName('x')} {0} into $newservice,
                         insert node attribute {xs:QName('y')} {$_:SPACING + ($pos - 1) * ($_:ARROW_HEIGHT + $_:SPACING)} into $newservice)
                         return $newservice   
                        }
                      </svg>
  
  let $referencearea := <svg class="referencearea" x="{ $estimatedwidth - $_:ARROW_LENGTH}" y="0" width="{$_:ARROW_LENGTH}" height="{$estimatedheight}">
                        {
                         for $reference at $pos in $uireferences
                         return copy $newreference := $reference modify(
                         insert node attribute {xs:QName('x')} {0 } into $newreference,
                         insert node attribute {xs:QName('y')} { $_:SPACING + ($pos - 1) * ($_:ARROW_HEIGHT + $_:SPACING)} into $newreference)
                         return $newreference   
                        }
                      </svg>
  
  let $uiproperties := for $property at $pos in $uiproperties
                     return copy $newproperty := $property modify(
                     insert node attribute {xs:QName('x')} { $_:ARROW_OFFSET + $pos * ($_:SPACING + $_:PROPERTY_WIDTH)} into $newproperty)
                     return $newproperty

  return ($servicearea, $referencearea, $uiproperties)

};

declare function _:render-component($scacomposite, $scacomponent as element()){
  let $name := string($scacomponent/@*:name)
  let $uiservices :=
    for $service in $scacomponent/sca:service
    return _:render-service($service)
  
  let $uireferences :=
    for $reference in $scacomponent/sca:reference
    return _:render-reference($reference)
  
  let $uiproperties :=
    for $property in $scacomponent/sca:property
    return _:render-property($property)
  
  let $uiimpl := 
    for $implementation in $scacomponent/*[starts-with(local-name(), "implementation.")]
    return _:render-implementation($implementation)
  
  let $estimatedwidth := 2 * $_:ARROW_OFFSET + $_:COMPONENT_WIDTH + (max((0, count($uiproperties) - 4))) * ($_:PROPERTY_WIDTH + $_:SPACING)
  let $estimatedinternalwidth := $estimatedwidth - 2 * $_:ARROW_OFFSET
  let $estimatedheight := max((count($uiservices), count($uireferences))) * ($_:SPACING + $_:ARROW_HEIGHT) 
                          + 2 * $_:SPACING
  
  let $widgets := _:optimize-widgets($estimatedwidth, $estimatedinternalwidth, $estimatedheight, $uiservices, $uireferences, $uiproperties)
  
  let $uiimpl :=
    if( empty($uiimpl) ) then ()
    else
		  copy $newuiimpl := $uiimpl
		  modify insert node attribute {xs:QName('y')} { $estimatedheight - ($_:PROPERTY_HEIGHT div 2) } into $newuiimpl
		  return $newuiimpl
  
  return
    <svg overflow="visible" width="{$estimatedwidth}" height="{$estimatedheight}" name="{$name}" class="componentcontainer">
      <metadata>
        <parentcomposite name="{$scacomposite/string(@name)}"/>
      </metadata>
      <title>{$name}</title>
      <description>{$name}</description>
      <rect rx="10" ry="10" x="{$_:ARROW_OFFSET}" name="{$scacomponent/@*:name}" width="{$estimatedinternalwidth}" height="{$estimatedheight}" class="component"/>
      <text x="{$estimatedinternalwidth div 3}" y = "{if(exists($uiproperties)) then 3 * $_:SPACING else 1.5 * $_:SPACING}">{$name}</text>
      {($widgets, $uiimpl)}
    </svg>
};

declare function _:render-wires($wires as element(sca:wire)*, $uicomponents as element(svg)*){
  for $w in $wires
  let $srccomp := $uicomponents[@name = tokenize($w/@source, "/")[1]]
  let $tgtcomp := $uicomponents[@name = tokenize($w/@target, "/")[1]]
  let $X1 := xs:integer($srccomp/@x)
  let $Y1 := xs:integer($srccomp/@y)
  let $X2 := xs:integer($tgtcomp/@x)
  let $Y2 := xs:integer($tgtcomp/@y)
  let $srcref  := $srccomp//svg[@class="referencecontainer" and @name = tokenize($w/@source, "/")[2]]
  let $tgtsvc  := if(empty(tokenize($w/@target, "/")[2])) then 
                    $tgtcomp//svg[@class="servicecontainer"][1]
                  else
                    $tgtcomp//svg[@class="servicecontainer" and @name = tokenize($w/@target, "/")[2]]
  return 
  if(empty($srcref) or empty($tgtsvc)) then ()
  else
    let $x1 := $X1 + xs:integer($srccomp/@width)
    let $y1 := $Y1 + xs:integer($srcref/@y) + $_:ARROW_HEIGHT_HALF
    let $x2 := $X2 + xs:integer($tgtsvc/@x)
    let $x3 := $x2 + 10
    let $y2 := $Y2 + xs:integer($tgtsvc/@y) + $_:ARROW_HEIGHT_HALF
    let $path := "M" || $x1 || "," || $y1 || " L" || $x2 || "," || $y2 || " L" || $x3 || "," || $y2
    return 
          (<path d="{$path}" class="wire">
              <metadata>
                <src name="{$srccomp/@name}" ofsx="{xs:integer($srccomp/@width)}" ofsy="{xs:integer($srcref/@y) + $_:ARROW_HEIGHT_HALF}"/>
                <tgt name="{$tgtcomp/@name}" ofsx="{xs:integer($tgtsvc/@x)}" ofsy="{xs:integer($tgtsvc/@y) + $_:ARROW_HEIGHT_HALF}"/>
              </metadata>
            </path>
          )
};

declare function _:compute-layouts($wires as element(sca:wire)*, $components as element()*){
  let $levels :=
  map:new(
    for $w in $wires
    let $tgt := tokenize($w/@target, "/")[1]
    group by $tgt
    return map:entry($tgt, count($w))
  )
  return
  let $newcomponents := for $comp in $components
                        let $level := if(exists($levels($comp/@name))) then $levels($comp/@name) else 0
                        let $x :=  $level * ($_:COMPONENT_WIDTH + $_:ARROW_LENGTH + 2 * $_:SPACING)
                        let $y :=  (random:integer(10) * $_:SPACING)
                        return copy $newcomp := $comp modify(
                        insert node attribute {xs:QName('x')} { $x } into $newcomp,
                        insert node attribute {xs:QName('y')} { $y } into $newcomp)
                        return $newcomp
  return $newcomponents
};

declare function _:compute-wires($scacomposite as element(sca:composite)){
  let $explicitwires := $scacomposite/sca:wire
  let $implicitwires := for $component in $scacomposite/sca:component[sca:reference/@target]
                        return
                          for $reference in $component/sca:reference[@target]
                          let $tgt := $reference/string(@target)
                          let $src := $component/string(@name) || "/" || $reference/string(@name)
                          return <sca:wire source="{$src}" target="{$tgt}"/>
  return ($explicitwires, $implicitwires)
};

declare function _:render-composite($scacomposite as element()){
	let $name := string($scacomposite/@*:name)
  let $uiservices :=
    for $service in $scacomposite/sca:service
    return _:render-service($service)
  
  let $uireferences :=
    for $reference in $scacomposite/sca:reference
    return _:render-reference($reference)
    
  let $uicomponents :=
    for $component in $scacomposite/sca:component
    return _:render-component($scacomposite, $component)
  
  let $uiproperties :=
    for $property in $scacomposite/sca:property
    return _:render-property($property)
  
  let $wires := _:compute-wires($scacomposite) 
  let $uicomponents := _:compute-layouts($wires, $uicomponents)
  let $uiwires := _:render-wires($wires, $uicomponents)
      
  let $estimatedinternalwidth := max( ($_:COMPOSITE_WIDTH, for $comp in $uicomponents return xs:double($comp/@x) + xs:double($comp/@width)))
  let $estimatedwidth := $estimatedinternalwidth + 2 * $_:ARROW_OFFSET
  let $estimatedheight := max( ($_:COMPOSITE_HEIGHT, for $comp in $uicomponents return xs:double($comp/@y) + xs:double($comp/@height))) + 50

  let $widgets := _:optimize-widgets($estimatedwidth, $estimatedinternalwidth, $estimatedheight, $uiservices, $uireferences, $uiproperties)
        
  return
    <svg name="{$scacomposite/@*:name}" x="0" y="{$_:SPACING}" width="{$estimatedwidth}" height="{$estimatedheight}" class="compositecontainer">
      <title>{$name}{($estimatedwidth, $estimatedinternalwidth)}</title>
      <description>{$name}{($wires, $uiwires)}</description>
      <rect rx="10" ry="10" x="{$_:ARROW_OFFSET}" width="{$estimatedinternalwidth}" height="{$estimatedheight}" class="composite"/> 
      <text x="{$estimatedwidth div 2}" y = "{if(exists($uiproperties)) then 3 * $_:SPACING else 1.5 * $_:SPACING}">{$name}</text>
      {($widgets, $uicomponents, $uiwires)}
    </svg>
};

declare function _:render-main-svg($content as node()){
  let $composites := for $composite in $content return _:render-composite($composite)
  let $estimatedwidth := max( for $comp in $composites return xs:double($comp/@x) + xs:double($comp/@width))
  let $estimatedheight := max( for $comp in $composites return xs:double($comp/@y) + xs:double($comp/@height))
  return
  <svg width="100%" height="100%" xmlns="http://www.w3.org/2000/svg" version="1.1">
   {$composites}
  </svg> 
};:)