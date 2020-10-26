document.addEventListener("DOMContentLoaded", () => {
	let buttonTableView = document.getElementById("table-view");
	let buttonCardView = document.getElementById("card-view");

	let divTableWrapper = document.getElementsByClassName("table-wrapper")[0];
	let divCardWrapper = document.getElementsByClassName("card-wrapper")[0];

	buttonTableView.addEventListener("click", () => changeView("table"));
	buttonCardView.addEventListener("click", () => changeView("card"));

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