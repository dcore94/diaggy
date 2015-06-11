module namespace _ = "urn:dcore:diaggy:emitter:html";

declare namespace svg="http://www.w3.org/2000/svg";
declare namespace xlink="http://www.w3.org/1999/xlink";

declare function _:emit-root($content as element()*, $info as map(*)){
  <div name="canvas" class="canvas">
    {$content}
  </div>
};

declare function _:emit-attrs($info as map(*)) as attribute()+ {
  attribute style{
    string-join((
      if (map:contains($info, 'x')) then "left:" || $info('x') || "px" else (),
      if (map:contains($info, '-x')) then "right:" || $info('-x') || "px" else (),
      if (map:contains($info, 'y')) then "top:" || $info('y') || "px" else (),
      if (map:contains($info, '-y')) then "bottom:" || $info('-y') || "px" else (),
      if (map:contains($info, 'width')) then "width:" || $info('width') || "px" else (),
      if (map:contains($info, 'height')) then "height:" || $info('height') || "px" else ()
    ), ";")
  },
  attribute draggable {
    if (map:contains($info, 'draggable')) then $info("draggable") else "false"
  }
};

declare function _:emit-composite($svg as element()?, $content as element()*, $info as map(*)){
  <div name="{$info('name')}" class="composite {$info('class')}" onmousedown="select(event)">
    { _:emit-attrs($info) } 
    {$svg}
    {$content}
  </div>
};

declare function _:emit-component($svg as element()?, $content as element()*, $info as map(*)){
  <div name="{$info('name')}" class="component {$info('class')}" onmousedown="select(event)">
    { _:emit-attrs($info) } 
    {$svg}
    {$content}
  </div>
};

declare function _:emit-wire($source as xs:string, $target as xs:string, $info as map(*)){
  
  let $sourcex := if ( map:contains($info, "sourcex")) then $info("sourcex") else 0
  let $sourcey := if ( map:contains($info, "sourcey")) then $info("sourcey") else 0
  let $targetx := if ( map:contains($info, "targetx")) then $info("targetx") else 0
  let $targety := if ( map:contains($info, "targety")) then $info("targety") else 0
  return
  <path d="M10,10 L100,100" class="wire {$info('class')}">
    <metadata>
      <source path="{$source}" x="{$sourcex}" y="{$sourcey}"/>
      <target path="{$target}" x="{$targetx}" y="{$targety}"/>
    </metadata>
  </path>
};