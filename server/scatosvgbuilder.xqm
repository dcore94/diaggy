module namespace _ = "urn:dcore:diaggy:builder:svg";

import module namespace html = "urn:dcore:diaggy:emitter:html" at "htmlemitter.xqm";
import module namespace const = "urn:dcore:diaggy:constants:sca" at "scaconstants.xqm";

declare function _:build-root($info as map(*)) as element(){
  html:emit-root(_:build-composite($info), $info)
};

declare function _:build-composite($info as map(*)) as element(){
  html:emit-composite(
     <svg style="width:100%;height:100%">
      <rect rx="10" ry="10" width="100%" height="100%"/>
      <text x="60%" y="5%">{$info('name')}</text>   
      <title>{$info("title")}</title>
      <description>{$info("description")}</description>
    </svg>,
    ($info('components') ! _:build-component(.),
     $info('properties') ! _:build-property(.),
     $info('wires') ! _:build-wire(.)),
     $info)
};

declare function _:build-component($info as map(*)) as element()*{
  html:emit-composite(
    <svg style="width:100%;height:100%">
      <rect rx="10" ry="10" width="100%" height="100%"/>
      <text x="{$const:ARROW_LENGTH + $const:SPACING}" y="50%">{$info('name')}</text>
    </svg>,
    (
     $info('services') ! _:build-service(.),
     $info('references') ! _:build-reference(.),
     $info('properties') ! _:build-property(.)
    ),
    $info)
};

declare function _:build-service($info as map(*)) as element()*{
  html:emit-component(
    <svg style="width:100%;height:100%">
      <polygon points="{$const:ARROW_POINTS}"/>
      <text x="35%" y="85%">{$info('name')}</text>
      <title>{$info("title")}</title>
      <description>{$info("description")}</description>
    </svg>,
    (),
    $info)
};

declare function _:build-reference($info as map(*)) as element()*{
  html:emit-component(
    <svg style="width:100%;height:100%">
      <polygon points="{$const:ARROW_POINTS}"/>
      <text x="35%" y="85%">{$info('name')}</text>
      <title>{$info("title")}</title>
      <description>{$info("description")}</description>
    </svg>,
    (),
    $info)
};

declare function _:build-property($info as map(*)) as element()*{
  html:emit-component(
    <svg style="width:100%;height:100%">
      <rect width="100%" height="100%"/>
      <text y="{$const:PROPERTY_HEIGHT div 2}">{$info('name')}</text>
      <title>{$info("title")}</title>
      <description>{$info("description")}</description>
    </svg>,
    (),
    $info)
};

declare function _:build-wire($info as map(*)) as element()*{
  ()
};