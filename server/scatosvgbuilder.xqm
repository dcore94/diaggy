module namespace _ = "urn:dcore:diaggy:builder:svg";

import module namespace svg = "urn:dcore:diaggy:emitter:svg" at "svgemitter.xqm";
import module namespace const = "urn:dcore:diaggy:constants:sca" at "scaconstants.xqm";

declare function _:build-root($info as map(*)) as element(){
  svg:emit-root(_:build-composite($info), $info)
};

declare function _:build-composite($info as map(*)) as element(){
  svg:emit-composite(
    (<rect rx="10" ry="10" x="{$const:INSETS}" y="{$const:INSETS}" 
           width="{$info('width') - 2 * $const:INSETS}" height="{$info('height') - 2 * $const:INSETS}"/>,
     <text x="60%" y="5%">{$info('name')}</text>,
     $info('components') ! _:build-component(.),
     $info('properties') ! _:build-property(.),
     $info('wires') ! _:build-wire(.)
    ),
     $info)
};

declare function _:build-component($info as map(*)) as element()*{
  svg:emit-composite(
    (<rect rx="10" ry="10" x="{$const:INSETS}" y="{$const:INSETS}" 
           width="{$info('width') - 2 * $const:INSETS}" height="{$info('height') - 2 * $const:INSETS}"/>,
     <text x="{$const:ARROW_LENGTH + $const:SPACING}" y="50%">{$info('name')}</text>,
     $info('services') ! _:build-service(.),
     $info('references') ! _:build-reference(.),
     $info('properties') ! _:build-property(.)
    ),
    $info)
};

declare function _:build-service($info as map(*)) as element()*{
  svg:emit-component(
    (<polygon points="{$const:ARROW_POINTS}"/>,
     <text x="35%" y="85%">{$info('name')}</text>
    ),
    $info)
};

declare function _:build-reference($info as map(*)) as element()*{
  svg:emit-component(
    (<polygon points="{$const:ARROW_POINTS_NEG}"/>,
     <text x="-65%" y="85%">{$info('name')}</text>
    ),
    map:put($info, "overflow", "visible")) (: NEEDS TO BE for right alignment of reference arrows:)
};

declare function _:build-property($info as map(*)) as element()*{
  svg:emit-component(
    (<rect width="100%" height="100%"/>,
     <text y="{$const:PROPERTY_HEIGHT div 2}">{$info('name')}</text>
    ),
    $info)
};

declare function _:build-wire($info as map(*)) as element()*{
  ()
};