document.addEventListener("DOMContentLoaded", () => {
	let buttonDatasetInfo = document.getElementById("dataset-info");
	let buttonTableView = document.getElementById("table-view");
	let buttonCardView = document.getElementById("card-view");
	let buttonMapView = document.getElementById("map-view");

	let divOverlay = document.getElementsByClassName("overlay")[0];
	let divDatasetInfoWrapper = document.getElementsByClassName("dataset-info-wrapper")[0];
	let divTableWrapper = document.getElementsByClassName("table-wrapper")[0];
	let divCardWrapper = document.getElementsByClassName("card-wrapper")[0];
	let divMapWrapper = document.getElementsByClassName("map-wrapper")[0];

	buttonDatasetInfo.addEventListener("click", () => toggleDatasetInfo());
	buttonTableView.addEventListener("click", () => changeView("table"));
	buttonCardView.addEventListener("click", () => changeView("card"));
	buttonMapView.addEventListener("click", () => changeView("map"));

	divOverlay.addEventListener("click", () => toggleDatasetInfo());

	changeView("map");

	let map = L.map("map").setView([50.375406, -4.138342], 13);

	L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
		attribution:"Map data &copy; <a href=\"https://www.openstreetmap.org/\">OpenStreetMap</a> contributors, <a href=\"https://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA</a>, Imagery © <a href=\"https://www.mapbox.com/\">Mapbox</a>",
		maxZoom:18,
		id:"mapbox/streets-v11",
		tileSize:512,
		zoomOffset:-1,
		accessToken:"pk.eyJ1IjoieHRyZW5kZW5jZSIsImEiOiJja2dzZG51dzQwbWt1MnltZnh0NzQzNGxkIn0.cIoDThLX2Xo62FpKFFj5wQ"
	}).addTo(map);

	getMarkers();

	function getMarkers() {
		let xhr = new XMLHttpRequest();
		xhr.addEventListener("readystatechange", () => {
			if(xhr.readyState === XMLHttpRequest.DONE) {
				let json = xhr.responseText;
				if(validJSON(json)) {
					let object = JSON.parse(json);
					let features = object.features;
					features.map(feature => {
						addMarkers(feature.properties.Latitude, feature.properties.Longitude, feature.properties.LibraryName);
					});
				}
			}
		});
		xhr.open("GET", "./fetch.php", true);
		xhr.send();
	}

	function addMarkers(latitude, longitude, text) {
		L.marker([latitude, longitude]).addTo(map).bindPopup("<b>" + text + "</b>");
	}

	function toggleDatasetInfo() {
		if(divDatasetInfoWrapper.classList.contains("hidden")) {
			divDatasetInfoWrapper.classList.remove("hidden");
			divOverlay.classList.remove("hidden");
		}
		else {
			divDatasetInfoWrapper.classList.add("hidden");
			divOverlay.classList.add("hidden");
		}
	}

	function changeView(view) {
		if(view === "table") {
			buttonTableView.classList.add("active");
			buttonCardView.classList.remove("active");
			buttonMapView.classList.remove("active");

			divTableWrapper.classList.remove("hidden");
			divCardWrapper.classList.add("hidden");
			divMapWrapper.classList.add("hidden");
		}
		else if(view === "card") {
			buttonTableView.classList.remove("active");
			buttonCardView.classList.add("active");
			buttonMapView.classList.remove("active");

			divTableWrapper.classList.add("hidden");
			divCardWrapper.classList.remove("hidden");
			divMapWrapper.classList.add("hidden");
		}
		else {
			buttonTableView.classList.remove("active");
			buttonCardView.classList.remove("active");
			buttonMapView.classList.add("active");

			divTableWrapper.classList.add("hidden");
			divCardWrapper.classList.add("hidden");
			divMapWrapper.classList.remove("hidden");
		}
	}

	function validJSON(json) {
		try {
			let object = JSON.parse(json);
			if(object && typeof object === "object") {
				return object;
			}
		}
		catch(e) { }
		return false;
	}
});