var dragged = null
var selected = null

function move(target, dx, dy){
	moveto(target, target.offsetLeft + dx, target.offsetTop + dy)
}

function moveto(target, x, y){
	target.style.left = x + "px"
	target.style.top = y + "px"
}

function resize(target, dw, dh){
	resizeto(target, target.offsetWidth + dw, target.offsetHeight + dh)
}

function resizeto(target, w, h){
	target.style.width = w + "px"
	target.style.height = h + "px"
}

function toggleselection(tgt){
	if(selected != null){
		selected.classList.remove("selected")
	}
	if(tgt != null) tgt.classList.add("selected")
	selected = tgt;
}

function select(evt){
	var tgt = evt.target.ownerSVGElement.parentNode
	while (tgt.getAttributeNS(null, "draggable") == 'false'){
		if (tgt.parentNode.getAttribute("name") == "canvas") {
			toggleselection(null)
		};
		tgt = tgt.parentNode
	}
	tgt.setAttributeNS(null, "onmousemove", "drag(event)")
	tgt.setAttributeNS(null, "onmouseup", "unselect(event)")
	tgt.setAttributeNS(null, "onmouseout", "unselect(event)")
	dragged = tgt
	toggleselection(tgt)
	evt.preventDefault(true)
	return false;
}

function drag(evt){
	var x = (evt['movementX'] ? evt.movementX : ( evt['mozMovementX'] ? evt['mozMovementX'] : 0))
	var y = (evt['movementY'] ? evt.movementY : ( evt['mozMovementY'] ? evt['mozMovementY'] : 0))
	move(dragged, x, y)
	resizeparent(dragged)
	drawwires()
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

function handleKey(event){
	if (event.keyCode === 27){
		toggleselection()
	}
}

var visualcache = {}
function cache(ele){
	var name = ele.getAttributeNS(null, 'name') 
	var cacheentry = 
			{ "left" : ele.offsetLeft, "top" : ele.offsetTop, "width" : ele.offsetWidth, "height" : ele.offsetHeight }
	visualcache[name] = cacheentry
	console.log("added cache entry", name, cacheentry)
}

function overridefromcache(ele){
	var name = ele.getAttributeNS(null, 'name') 
	if (visualcache[name]) {
		var cached = visualcache[name]
		console.log("found in cache", name, cached)
		moveto(ele, cached['left'], cached['top'])
		resizeto(ele, cached['width'], cached['height'])
	}
}

function overrideallfromcache(){
	var divs = document.querySelector("div [name='canvas']").querySelectorAll("div")
	for(var i=0; i < divs.length; i++){
		overridefromcache(divs[i])
	}
}

function pathtocoords(path){
	var div = document.querySelector("div.canvas")
	var x = 0
	var y = 0
	for(var i=0; i < path.length; i++){
		div = div.querySelector("div[name='" + path[i] + "']")
		x += div.offsetLeft
		y += div.offsetTop
		//console.log(div.getAttribute('name'), div.offsetLeft, div.offsetTop)
	}
	return [x, y]
}

function drawwire(wire){
	var source = wire.querySelector("metadata>source")
	var sourcepath = source.getAttribute("path").split("/")
	
	var target = wire.querySelector("metadata>target")
	var targetpath = target.getAttribute("path").split("/")
	
	var ofsx = Number(target.getAttribute("ofsx"))
	var ofsy = Number(target.getAttribute("ofsy"))
	
	var co1 = pathtocoords(sourcepath)
	var co2 = pathtocoords(targetpath)
	
	var origin = "M" + co1[0] + "," + co1[1]
	var prolog = source.getAttribute("prolog")
	var epilog = target.getAttribute("epilog")
	var d = origin + prolog + " L" + (co2[0] + ofsx) + "," + (co2[1] + ofsy) + epilog
	//console.log(ofsx, ofsy, d)
	wire.setAttributeNS(null, "d", d)
}

function drawwires(){
	var wires = document.querySelectorAll(".wire")
	for(var i=0; i < wires.length; i++){
		drawwire(wires[i])
	}
}

function resizeparent(ele){
	var parent = ele.parentNode
	if (parent.getAttribute("name") == "canvas") return;
	var dw = Math.max(0, (ele.offsetLeft + ele.offsetWidth) - parent.offsetWidth) 
	var dh = Math.max(0, (ele.offsetTop + ele.offsetHeight) - parent.offsetHeight)
	if(dw != 0 || dh != 0){
		console.log(parent, dw, dh)
		resize(parent, dw, dh)
		cache(parent)
	}
}