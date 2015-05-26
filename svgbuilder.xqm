module namespace _ = "urn:dcore:diaggy:builder:svg";

declare namespace svg="http://www.w3.org/2000/svg";
declare namespace xlink="http://www.w3.org/1999/xlink";

declare function _:build-root($content as element()*, $layout as map(*)){
  <svg name="canvas" class="canvas" width="100%" height="100%">
    {$content}
  </svg>
};

declare function _:build-composite($content as element()*, $layout as map(*)){
  <svg name="{$layout('name')}" class="composite {$layout('class')}" width="{$layout('width')}" height="{$layout('height')}" draggable="{$layout('draggable')}">
    <title>{$layout("title")}</title>
    <description>{$layout("description")}</description>
    {$content}
  </svg>
};

declare function _:build-component($content as element()*, $layout as map(*)){
  <svg name="{$layout('name')}" class="component {$layout('class')}" width="{$layout('width')}" height="{$layout('height')}" draggable="{$layout('draggable')}">
    <title>{$layout("title")}</title>
    <description>{$layout("description")}</description>
    {$content}
  </svg>
};

declare function _:build-wire($source as xs:string, $target as xs:string, $layout as map(*)){
  <svg class="wire {$layout('class')}">
    {$layout("path")}
    <metadata>
      <src name="{$source}" ofsx="0" ofsy="0"/>
      <tgt name="{$target}" ofsx="0" ofsy="0"/>
    </metadata>
  </svg>
};