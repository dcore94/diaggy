module namespace sk = "urn:dcore:diaggy:skeleton";

import module namespace diaggy = "urn:dcore:diaggy:implementation" at "diaggy.xqm";
import module namespace sca = "urn:dcore:diaggy:profile:sca" at "sca.xqm";

declare variable $sk:IMPL := map {
  "sca" : "urn:dcore:diaggy:profile:sca"
};

declare function sk:get-implforprofile($profile as xs:string, $operation as xs:string, $arity as xs:integer){
  let $ns := 
  if ( empty($sk:IMPL($profile)) ) then 
    error(QName("err", "PROF"), "Unsupported profile " || $profile)
  else 
    $sk:IMPL($profile)
  return function-lookup(QName($ns, $operation), $arity)
};

declare
  %rest:error("err:PROF")
  %rest:error-param("description", "{$description}")
function sk:profile-error($description)
{
  "PROFILE ERROR! " || $description
};

declare
  %rest:error("*")
  %rest:error-param("description", "{$description}")
  %rest:error-param("additional", "{$detail}")
function sk:internal-error($description, $detail)
{
  "INTERNAL ERROR! " || $description || " - " || $detail
};

declare 
%rest:path("diaggy/template/{$profile}")
%rest:GET
function sk:get-template($profile as xs:string?){

  if (empty($profile)) then
    error(QName("sk", "PROF"), "Missing required parameter profile")
  else
    let $f := sk:get-implforprofile($profile, "get-template", 0)
    return $f() 
};

declare 
%rest:path("diaggy/validate/{$profile}")
%rest:POST("{$body}")
%rest:consumes("application/xml")
function sk:validate($body, $profile as xs:string){
  
  if (empty($profile)) then
    error(QName("sk", "PROF"), "Missing required parameter profile")
  else
    let $f := sk:get-implforprofile($profile, "validate", 1)
    return $f($body) 
};

declare 
%rest:path("diaggy/render/{$profile}")
%rest:POST("{$body}")
%rest:consumes("application/xml")
function sk:render($body, $profile as xs:string){
  if (empty($profile)) then
    error(QName("sk", "PROF"), "Missing required parameter profile")
  else
    let $f := sk:get-implforprofile($profile, "render", 1)
    return $f($body)
};

declare 
%rest:path("diaggy/export")
%rest:POST("{$body}")
%rest:consumes("application/xml")
function sk:export($body){
  sk:export($body, "svg")
}; 

declare 
%rest:path("diaggy/export/{$format}")
%rest:POST("{$body}")
%rest:consumes("application/xml")
function sk:export($body, $format as xs:string){
prof:time(	
  diaggy:export($body, $format), false(), $body
)
};   