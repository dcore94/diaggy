function getProfile(){
	return document.getElementById("PROFILE_SELECTOR").value
}

function getTemplateUrl(){
	return "/diaggy/template/" + getProfile() 
}

function getValidateUrl(){
	return "/diaggy/validate/" + getProfile() 
}

function getRenderUrl(){
	return "/diaggy/render/" + getProfile() 
}

function getExportUrl(){
	return "/diaggy/export" 
}

function ignoreerrorcb(error, data, xhr){
	return
}

function defaulterrorcb(error, data, xhr){
	alert(error)
}

function xhr(url, cb, errorcb, method, data, contenttype) {
	var requestTimeout,xhr;
	 
	var obj = (window.ActiveXObject) ? new ActiveXObject("Microsoft.XMLHTTP") : 
				(XMLHttpRequest && new XMLHttpRequest()) || null;
	
	var ercb = errorcb ? errorcb : defaulterrorcb
	
	requestTimeout = setTimeout(
			function() {
				obj.abort(); 
				ercb(new Error("xhr: aborted by a timeout"), "",xhr); 
			}, 
			5000);
	 
	obj.onreadystatechange = 
		 function(){
		 	if (obj.readyState != 4) return;
		 	clearTimeout(requestTimeout);
		 	if (obj.status < 300){
		 		cb(obj.responseText, obj);
		 	}else{
		 		ercb(new Error("xhr: ERROR"), "",obj)
		 	}
	 	}
	 
	obj.open(method ? method.toUpperCase() : "GET", url, true);

	 //xhr.withCredentials = true;

	if(!data)
		obj.send();
	else {
		obj.setRequestHeader('Content-type', contenttype ? contenttype : 'application/x-www-form-urlencoded');
		obj.send(data)
	}
}