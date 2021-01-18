<?php 
	// Import the "Utils" class which contains a bunch of static helper functions. This just helps keep the code clean.
	require("./utils.php"); 
	$file = "../libraries/dataset.json";
?>
<!DOCTYPE html>
<html lang="en">
	<head>
		<link rel="stylesheet" href="./assets/css/style.css">
		<link rel="stylesheet" href="./assets/css/resize.css">
		<link rel="stylesheet" href="./assets/css/leaflet.css">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<meta name="mobile-web-app-capable" content="yes">
		<meta charset="UTF-8">
		<meta name="author" content="Xtrendence">
		<link rel="apple-touch-icon" sizes="180x180" href="./assets/img/favicon/apple-touch-icon.png">
		<link rel="icon" type="image/png" sizes="32x32" href="./assets/img/favicon/favicon-32x32.png">
		<link rel="icon" type="image/png" sizes="16x16" href="./assets/img/favicon/favicon-16x16.png">
		<link rel="mask-icon" href="./assets/img/favicon/safari-pinned-tab.svg" color="#787878">
		<meta name="msapplication-TileColor" content="#1d1d1d">
		<meta name="msapplication-config" content="./assets/img/favicon/browserconfig.xml">
		<link rel="icon" type="image/x-icon" href="./assets/img/favicon/favicon.ico">
		<link rel="shortcut icon" type="image/x-icon" href="./assets/img/favicon/favicon.ico">
		<script src="./assets/js/leaflet.js"></script>
		<script src="./assets/js/data.js"></script>
		<title>View Dataset</title>
	</head>
	<body>
		<div class="buttons-wrapper">
			<a href="./index.php"><svg alt="Back Button Icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><!-- Font Awesome Free 5.15.1 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free (Icons: CC BY 4.0, Fonts: SIL OFL 1.1, Code: MIT License) --><path d="M256 504C119 504 8 393 8 256S119 8 256 8s248 111 248 248-111 248-248 248zm116-292H256v-70.9c0-10.7-13-16.1-20.5-8.5L121.2 247.5c-4.7 4.7-4.7 12.2 0 16.9l114.3 114.9c7.6 7.6 20.5 2.2 20.5-8.5V300h116c6.6 0 12-5.4 12-12v-64c0-6.6-5.4-12-12-12z"/>
				<title>Back Button Icon</title>
				<defs>
					<linearGradient id="blue-gradient" x1="0%" y1="0%" x2="100%" y2="0%">
						<stop offset="0%" style="stop-color:rgb(58,123,213);stop-opacity:1" />
						<stop offset="100%" style="stop-color:rgb(0,183,224);stop-opacity:1" />
					</linearGradient>
				</defs>
			</svg></a>
			<button id="dataset-info">Dataset Info</button>
			<button class="active" id="table-view">Table View</button>
			<button id="card-view">Card View</button>
			<button id="map-view">Map View</button>
		</div>
		<div class="overlay hidden"></div>
		<div class="dataset-info-wrapper hidden">
			<table cellspacing="0">
				<tr>
					<th>Type</th>
					<th>Name</th>
					<th>CRS Type</th>
					<th>CRS Property Name</th>
				</tr>
				<?php echo Utils::displayInfo($file); ?>
			</table>
		</div>
		<div class="data-wrapper">
			<div class="table-wrapper">
				<table cellspacing="0">
					<tr>
						<th>Type</th>
						<th>ID</th>
						<th>Library Name</th>
						<th>Address Line 1</th>
						<th>Address Line 2</th>
						<th>Address Line 3</th>
						<th>Postcode</th>
						<th>Latitude</th>
						<th>Longitude</th>
						<th>Website</th>
						<th>Geometry Type</th>
						<th>Geometry Latitude</th>
						<th>Geometry Longitude</th>
					</tr>
					<?php echo Utils::displayFeatures($file, "table"); ?>
				</table>
			</div>
			<div class="card-wrapper hidden">
				<?php echo Utils::displayFeatures($file, "card"); ?>
			</div>
			<div class="map-wrapper hidden">
				<div id="map"></div>
			</div>
		</div>
	</body>
</html>