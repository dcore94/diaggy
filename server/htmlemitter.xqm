module namespace _ = "urn:dcore:diaggy:emitter:html";

declare namespace svg="http://www.w3.org/2000/svg";
declare namespace xlink="http://www.w3.org/1999/xlink";

declare function _:emit-root($content as element()*, $info as map(*)){
  <div name="canvas" class="canvas" onmouseleave="m_out_canvas(event)" onmousedown="m_down_canvas(event)" onmouseup="m_up_canvas(event)" onmousemove="m_move_canvas(event)">
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
  },
  attribute title {
    if (map:contains($info, 'title')) then $info("title") else ""
  }
};

declare function _:emit-composite($svg as element()?, $content as element()*, $info as map(*)){
  <div name="{$info('name')}" class="composite {$info('class')}" >
    { _:emit-attrs($info) } 
    {$svg}
    {$content}
  </div>
};

declare function _:emit-component($svg as element()?, $content as element()*, $info as map(*)){
  <div name="{$info('name')}" class="component {$info('class')}" >
    { _:emit-attrs($info) } 
    {$svg}
    {$content}
  </div>
};

declare function _:emit-wire($source as xs:string, $target as xs:string, $info as map(*)){
  
  let $prolog := if ( map:contains($info, "prolog")) then $info("prolog") else " m0,0"
  let $epilog := if ( map:contains($info, "epilog")) then $info("epilog") else " m0,0"
  let $ofsx := if ( map:contains($info, "ofsx")) then $info("ofsx") else 0
  let $ofsy := if ( map:contains($info, "ofsy")) then $info("ofsy") else 0
  return
  <path d="M0,0" class="wire {$info('class')}">
    <metadata>
      <source path="{$source}" prolog="{$prolog}"/>
      <target path="{$target}" epilog="{$epilog}" ofsx="{$ofsx}" ofsy="{$ofsy}"/>
    </metadata>
  </path>
};