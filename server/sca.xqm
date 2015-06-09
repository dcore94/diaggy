module namespace _ = "urn:dcore:diaggy:profile:sca";

import module namespace scavisitor = "urn:dcore:diaggy:visitor:sca" at "scavisitor.xqm";
import module namespace svgbuilder = "urn:dcore:diaggy:builder:svg" at "scatosvgbuilder.xqm";

declare namespace sca = "http://docs.oasis-open.org/ns/opencsa/sca/200903";

declare function _:get-template(){

  (:<sca:composite xmlns:sca="http://docs.oasis-open.org/ns/opencsa/sca/200903"	name="template-composite" targetNamespace="urn:dedalus:sca">
	</sca:composite>:)
  
  (:<sca:composite xmlns:sca="http://docs.oasis-open.org/ns/opencsa/sca/200903" name="template-composite" targetNamespace="urn:dedalus:sca">
      <sca:component name="B"/>
    </sca:composite>:)
  
  <sca:composite xmlns:sca="http://docs.oasis-open.org/ns/opencsa/sca/200903" name="template-composite" targetNamespace="urn:dedalus:sca">
    <sca:component name="B">
      <sca:property name="X12" value="D"/>
      <sca:reference name="R1" target="C/S1"/>
    </sca:component>
    <sca:component name="C">
      <sca:service name="S1"/>
    </sca:component>
  </sca:composite>
  
};

declare function _:validate($body){
  validate:xsd-info($body, "/home/lettere/healthsoaf-workspace/midas/sca/xsd/sca.xsd")
};

declare function _:render($body){
   svgbuilder:build-root(scavisitor:visit($body))
};