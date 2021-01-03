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

	addLinkWarnings();

	buttonDatasetInfo.addEventListener("click", () => toggleDatasetInfo());
	buttonTableView.addEventListener("click", () => changeView("table"));
	buttonCardView.addEventListener("click", () => changeView("card"));
	buttonMapView.addEventListener("click", () => changeView("map"));

	divOverlay.addEventListener("click", () => toggleDatasetInfo());

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
						let type = feature["@type"];
						let properties = feature["properties"];
						let geometry = feature["geometry"];

						let id = properties["fid"];
						let name = properties["LibraryName"];
						let addressLine1 = properties["AddressLine1"] === null ? "" : properties["AddressLine1"];
						let addressLine2 = properties["AddressLine2"] === null ? "" : properties["AddressLine2"];
						let addressLine3 = properties["AddressLine3"] === null ? "" : properties["AddressLine3"];
						let postcode = properties["Postcode"];
						let latitude = properties["Latitude"];
						let longitude = properties["Longitude"];
						let website = properties["Website"];

						let geometryType = geometry["@type"];
						let coordinates = geometry["coordinates"];
						let geometryLatitude = coordinates[1];
						let geometryLongitude = coordinates[0];

						let html = '<div class="map-card"><span class="name">' + name + '</span><span>Type: ' + type + '</span><span>ID: ' + id + '</span><span>' + addressLine1 + '</span><span>' + addressLine2 + '</span><span>' + addressLine3 + '</span><span>' + postcode + '</span><span>Latitude: ' + latitude + '</span><span>Longitude: ' + longitude + '</span><span>Website: <a target="_blank" href="' + website + '">' + name + '</a></span><span>Geometry Type: ' + geometryType + '</span><span>Geometry Latitude: ' + geometryLatitude + '</span><span>Geometry Longitude: ' + geometryLongitude + '</span><span></div>';

						addMarkers(latitude, longitude, html);
					});
				}
			}
		});
		xhr.open("GET", "./fetch.php", true);
		xhr.send();
	}

	function addMarkers(latitude, longitude, html) {
		L.marker([latitude, longitude]).addTo(map).bindPopup(html);
	}

	function addLinkWarnings() {
		let links = document.getElementsByTagName("a");
		for(let i = 0; i < links.length; i++) {
			if(links[i].target && links[i].target === "_blank") {
				links[i].addEventListener("click", (e) => {
					e.preventDefault();
					let confirm = window.confirm("This link goes to an external site, and will open in a new tab.");
					if(confirm) {
						window.open(links[i].href);
					}
				});
			}
		}
	}

	function toggleDatasetInfo() {
		if(divDatasetInfoWrapper.classList.contains("hidden")) {
			divDatasetInfoWrapper.classList.remove("hidden");
			divOverlay.classList.remove("hidden");
			divMapWrapper.classList.add("hidden");
		}
		else {
			divDatasetInfoWrapper.classList.add("hidden");
			divOverlay.classList.add("hidden");
			divMapWrapper.classList.remove("hidden");
			map.invalidateSize(true);
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

			map.invalidateSize(true);
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