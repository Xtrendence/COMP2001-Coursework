document.addEventListener("DOMContentLoaded", () => {
	addLinkWarnings();

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
});