function svgexport_recurse(node){
	var childsvgs = node.querySelectorAll("div")
	console.log(childsvgs)
	document.querySelector("div[name='canvas'] > div")
	return document.querySelector("#LOG").appendChild(exported)
}

function svgexport(){
	var canvas = document.querySelector("div[name='canvas']")
	console.log(canvas)
	var exported = document.createElement("svg")
	exported.setAttribute("width", canvas.offsetWidth)
	exported.setAttribute("height", canvas.offsetHeight)
	
	var childsvgs = canvas.querySelectorAll("div")
	console.log(childsvgs)
	document.querySelector("div[name='canvas'] > div")
	return document.querySelector("#LOG").appendChild(exported)
}