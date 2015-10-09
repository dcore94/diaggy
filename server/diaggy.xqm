module namespace _ = "urn:dcore:diaggy:implementation";

declare function _:export-recurse($node, $format){
  <svg>{(
    $node/svg/@*, $node/svg/*,
    for $div in $node/div
    return _:export-recurse($div, $format)  
  )}</svg>
};

declare function _:export($body as node(), $format as xs:string){
  _:export-recurse($body/div, $format)
};