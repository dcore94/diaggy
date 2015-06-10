module namespace _ = "urn:dcore:diaggy:emitter:svg";

declare namespace svg="http://www.w3.org/2000/svg";
declare namespace xlink="http://www.w3.org/1999/xlink";

declare function _:emit-root($content as element()*, $info as map(*)){
  <svg name="canvas" class="canvas" width="100%" height="100%" onresize="console.log('resizing canvas', this)">
    {$content}
  </svg>
};

declare function _:emit-composite($content as element()*, $info as map(*)){
  <svg name="{$info('name')}" class="composite {$info('class')}" 
    width="{$info('width')}" height="{$info('height')}" onmousedown="select(evt)" onresize="console.log('resizing', this)">
    { if (map:contains($info, 'draggable')) then attribute draggable { $info('draggable') } else ()}
    { if (map:contains($info, 'x')) then attribute x { $info('x') } else ()}
    { if (map:contains($info, 'y')) then attribute y { $info('y') } else ()}
    { if (map:contains($info, 'overflow')) then attribute overflow { $info('overflow') } else ()}
    <title>{$info("title")}</title>
    <description>{$info("description")}</description>
    {$content}
  </svg>
};

declare function _:emit-component($content as element()*, $info as map(*)){
  <svg name="{$info('name')}" class="component {$info('class')}" 
    width="{$info('width')}" height="{$info('height')}">
    { if (map:contains($info, 'draggable')) then attribute draggable { $info('draggable') } else ()}
    { if (map:contains($info, 'x')) then attribute x { $info('x') } else ()}
    { if (map:contains($info, 'y')) then attribute y { $info('y') } else ()}
    { if (map:contains($info, 'overflow')) then attribute overflow { $info('overflow') } else ()}
    <title>{$info("title")}</title>
    <description>{$info("description")}</description>
    {$content}
  </svg>
};

declare function _:emit-wire($source as xs:string, $target as xs:string, $info as map(*)){
  <svg class="wire {$info('class')}">
    {$info("path")}
    <metadata>
      <src name="{$source}" ofsx="0" ofsy="0"/>
      <tgt name="{$target}" ofsx="0" ofsy="0"/>
    </metadata>
  </svg>
};