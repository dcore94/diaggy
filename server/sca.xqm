module namespace _ = "urn:dcore:diaggy:profile:sca";

import module namespace scavisitor = "urn:dcore:diaggy:visitor:sca" at "scavisitor.xqm";

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
   scavisitor:visit($body)
   (:<svg class="canvas" width="500" height="500">
      <svg name="C1" class="composite" x="0" y="0" width="200" height="200" draggable="true">
          <rect width="200" height="200"/>    
          <svg name="C2" class="composite" x="10" y="10" width="100" height="100" draggable="true">
              <rect width="100" height="100"/>    
              <svg name="c1" class="component type2" x="10" y="10" width="30" height="30" draggable="true">
                  <rect width="100%" height="100%"/>    
              
                  <svg name="p1" class="component port out" x="20" y="5" width="10" height="10">
                      <polygon points="0,0 10,5 0,10"/>
                      <metadata>
                          <offset x="10" y="4"/>
                      </metadata>
                  </svg>
              </svg>
          </svg>
      
          <svg name="c2" class="component type1" x="140" y="40" width="30" height="30" draggable="true">
              <rect width="100%" height="100%"/>
              <svg name="p2" class="component port in" x="0" y="5" width="10" height="10">
                  <polygon points="0,0 10,5 0,10"/>
                  <metadata>
                      <offset x="0" y="4"/>
                  </metadata>
              </svg>
          </svg>
          
          <svg name="w1" class="wire" overflow="visible">
              <path d="M50,29 L140,49"/>
              <metadata>
                  <src name="C1/C2/c1/p1"/>
                  <tgt name="C1/c2/p2"/>
              </metadata>
          </svg>
          
      </svg>
  </svg>:)
};