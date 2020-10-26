document.addEventListener("DOMContentLoaded", () => {
	let buttonDatasetInfo = document.getElementById("dataset-info");
	let buttonTableView = document.getElementById("table-view");
	let buttonCardView = document.getElementById("card-view");

	let divOverlay = document.getElementsByClassName("overlay")[0];
	let divDatasetInfoWrapper = document.getElementsByClassName("dataset-info-wrapper")[0];
	let divTableWrapper = document.getElementsByClassName("table-wrapper")[0];
	let divCardWrapper = document.getElementsByClassName("card-wrapper")[0];

	buttonDatasetInfo.addEventListener("click", () => toggleDatasetInfo());
	buttonTableView.addEventListener("click", () => changeView("table"));
	buttonCardView.addEventListener("click", () => changeView("card"));

	divOverlay.addEventListener("click", () => toggleDatasetInfo());

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

			divTableWrapper.classList.remove("hidden");
			divCardWrapper.classList.add("hidden");
		}
		else {
			buttonTableView.classList.remove("active");
			buttonCardView.classList.add("active");

			divTableWrapper.classList.add("hidden");
			divCardWrapper.classList.remove("hidden");
		}
	}
});