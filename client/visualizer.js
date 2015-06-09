var dragged = null;

function select(evt){
    var svg = evt.target.ownerSVGElement
    while (svg.getAttributeNS(null, "draggable") == 'false'){
    	svg = svg.ownerSVGElement
    	if (svg.ownerSVGElement == null) return;
    }    
    console.log("dragging", svg)
    svg.setAttributeNS(null, "onmousemove", "drag(evt)")
    svg.setAttributeNS(null, "onmouseup", "unselect(evt)")
    svg.setAttributeNS(null, "onmouseout", "unselect(evt)")
    dragged = svg
    evt.preventDefault(true)
    return false;
}

function drag(evt){
    var x = (evt['movementX'] ? evt.movementX : ( evt['mozMovementX'] ? evt['mozMovementX'] : 0))
    var y = (evt['movementY'] ? evt.movementY : ( evt['mozMovementY'] ? evt['mozMovementY'] : 0))
    dragged.setAttributeNS(null, "x", dragged.x.baseVal.value + x)
    dragged.setAttributeNS(null, "y", dragged.y.baseVal.value + y)
    evt.preventDefault(true)
    return false;
}

function unselect(evt){
    dragged.removeAttributeNS(null, "onmouseup")
    dragged.removeAttributeNS(null, "onmouseout")    
    dragged.removeAttributeNS(null, "onmousemove")
    cache(dragged)
    dragged = null
    evt.preventDefault(true)
    return false;
}

var visualcache = {}
function cache(svg){
	var name = svg.getAttributeNS(null, 'name') 
	var cacheentry = 
			{ "x" : dragged.x.baseVal.value, "y" : dragged.y.baseVal.value, 
			  "width" : dragged.width.baseVal.value, "height" : dragged.height.baseVal.value 
			}
	visualcache[name] = cacheentry
}

function overridefromcache(svg){
	var name = svg.getAttributeNS(null, 'name') 
	if (visualcache[name]) {
		var cached = visualcache[name]
		svg.setAttributeNS(null, "x", cached['x'])
		svg.setAttributeNS(null, "y", cached['y'])
		console.log(svg.width.baseVal.value , cached['width'])
		if (svg.width.baseVal.value > cached['width']) svg.setAttributeNS(null, "width", cached['width']);
		if (svg.height.baseVal.value > cached['height']) svg.setAttributeNS(null, "height", cached['height']);
	}
}

function overrideallfromcache(){
	var svgs = document.querySelectorAll("svg")
	for(var i=0; i < svgs.length; i++){
		overridefromcache(svgs[i])
	}
}