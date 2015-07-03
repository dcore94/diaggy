var dragged = null
var selected = null

var observer = null
function initObserver(){
	if(observer) observer.disconnect();
	observer = new MutationObserver(function(mutations) {
	  mutations.forEach(function(mutation) {
	    //console.log("observed mutation ", mutation.type, mutation.attributeName, mutation.target.getAttribute(mutation.attributeName), mutation.oldValue);
	  });
	});
	 
	var config = { attributes: true, attributeFilter : ["style"], attributeOldValue : true};
	var observed = document.querySelectorAll('.component, .composite');
	for (var i=0; i < observed.length; i++){
		observer.observe(observed[i], config);
	}
}

 
function move(target, dx, dy){
	var destx = dx ? Number(target.style.left.slice(0,-2)) + dx : null
	var desty = dy ? Number(target.style.top.slice(0,-2)) + dy : null
	moveto(target, destx, desty)
}

function moveto(target, x, y){
	if (x) target.style.left = x + "px";
	if (y) target.style.top = y + "px"
}

function resize(target, dw, dh){
	resizeto(target, target.offsetWidth + dw, target.offsetHeight + dh)
}

function resizeto(target, w, h){
	target.style.width = w + "px"
	target.style.height = h + "px"
}

function toggledragged(tgt){
	if(dragged != null){
		dragged.classList.remove("dragged")
	}
	if(tgt != null) tgt.classList.add("dragged")
	dragged = tgt
}

function toggleselection(tgt){
	if(selected != null){
		selected.classList.remove("selected")
	}
	if(tgt != null) tgt.classList.add("selected")
	selected = tgt
}

function close(evt){
	evt.stopPropagation()
	evt.preventDefault()
	return false
}

function m_down_canvas(evt){
	var tgt = evt.target.ownerSVGElement.parentNode
	while (tgt.getAttributeNS(null, "draggable") == 'false'){
		tgt = tgt.parentNode
	}
	select(tgt)
	return close(evt)
}

function m_move_canvas(evt){
	if(dragged){
		var dx = (evt['movementX'] ? evt.movementX : ( evt['mozMovementX'] ? evt['mozMovementX'] : 0))
		var dy = (evt['movementY'] ? evt.movementY : ( evt['mozMovementY'] ? evt['mozMovementY'] : 0))
		if (dx || dy) drag(dx, dy);
	}
	return close(evt)
}

function m_out_canvas(evt){
	undrag()
	return close(evt)
}

function m_up_canvas(evt){
	console.log("canvas up")
	undrag()
	return close(evt)
}

function select(tgt){
	if (tgt.getAttribute('name') == "canvas"){
		toggleselection(null)
		toggledragged(null)
	}else{
		toggleselection(tgt)
		toggledragged(tgt)
	}
}

function undrag(){
	if(!dragged) return;
	cache(dragged)
	toggledragged(null)
}

function drag(dx, dy){
	if(!dragged) return;
	if (dragged.getAttributeNS(null, "draggable") == 'x-true'){
		move(dragged, dx, 0)
		resizeparent(dragged, "horizontal")
		drawwires()
	} else if (dragged.getAttributeNS(null, "draggable") == 'y-true'){
		move(dragged, 0, dy)
		resizeparent(dragged, "vertical")
		drawwires()
	} else {
		move(dragged, dx, dy)
		resizeparent(dragged)
		drawwires()
	}
}

function handleKey(event){
	if (event.keyCode === 27){
		toggleselection(null)
		undrag()
	}
}

var visualcache = {}
function cache(ele){
	var name = ele.getAttributeNS(null, 'name') 
	var cacheentry = 
			{ "left" : ele.offsetLeft, 
			  "top" : ele.offsetTop, 
			  "width" : ele.offsetWidth - 2 * ele.clientLeft, //don't consider border size when storing width in cache
			  "height" : ele.offsetHeight - 2 * ele.clientTop} //don't consider border size when storing height in cache
	visualcache[name] = cacheentry
	console.log("added cache entry", ele, cacheentry)
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
	
	wire.setAttributeNS(null, "d", d)
}

function drawwires(){
	var wires = document.querySelectorAll(".wire")
	for(var i=0; i < wires.length; i++){
		drawwire(wires[i])
	}
}

function resizeparent(ele, direction){
	var parent = ele.parentNode
	if (parent.getAttribute("name") == "canvas") return;
	
	var dw = Math.max(0, (ele.offsetLeft + ele.offsetWidth) - parent.offsetWidth) 
	var dh = Math.max(0, (ele.offsetTop + ele.offsetHeight) - parent.offsetHeight)
	
	if((dw != 0 || dh != 0) && direction == null) {
		resize(parent, dw, dh)
		cache(parent)
	}else if(dw != 0 && direction == "horizontal") {
		resize(parent, dw, 0)
		cache(parent)
	}else if (dh != 0 && direction == "vertical") {
		resize(parent, 0, dh)
		cache(parent)
	}
}