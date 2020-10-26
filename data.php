<?php
	function displayData() {
		$html = "";
		$file = "./dataset.json";
		$content = file_get_contents($file);
		$libraries = json_decode($content, true);
		$features = $libraries["features"];
		foreach($features as $feature) {
			$type = $feature["type"];
			$properties = $feature["properties"];
			$geometry = $feature["geometry"];

			$id = $properties["fid"];
			$name = $properties["LibraryName"];
			$addressLine1 = $properties["AddressLine1"];
			$addressLine2 = $properties["AddressLine2"];
			$addressLine3 = $properties["AddressLine3"];
			$postcode = $properties["Postcode"];
			$latitude = $properties["Latitude"];
			$longitude = $properties["Longitude"];
			$website = $properties["Website"];

			$geometryType = $geometry["type"];
			$coordinates = $geometry["coordinates"];
			$geometryLatitude = $coordinates[0];
			$geometryLongitude = $coordinates[1];

			$html += '<div class="entry">' + $name + '</div>';
		}
		return $html;
	}
?>
<!DOCTYPE html>
<html>
	<head>
		<link rel="stylesheet" href="./assets/css/style.css">
		<link rel="stylesheet" href="./assets/css/resize.css">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<meta name="mobile-web-app-capable" content="yes">
		<meta charset="UTF-8">
		<meta name="author" content="Xtrendence">
		<link rel="apple-touch-icon" sizes="180x180" href="./assets/img/favicon/apple-touch-icon.png">
		<link rel="icon" type="image/png" sizes="32x32" href="./assets/img/favicon/favicon-32x32.png">
		<link rel="icon" type="image/png" sizes="16x16" href="./assets/img/favicon/favicon-16x16.png">
		<link rel="manifest" href="./assets/img/favicon/site.webmanifest">
		<link rel="mask-icon" href="./assets/img/favicon/safari-pinned-tab.svg" color="#787878">
		<meta name="msapplication-TileColor" content="#1d1d1d">
		<meta name="msapplication-config" content="./assets/img/favicon/browserconfig.xml">
		<link rel="icon" type="image/x-icon" href="./favicon.ico">
		<link rel="shortcut icon" type="image/x-icon" href="./favicon.ico">
		<script src="./assets/js/main.js"></script>
		<title>View Dataset</title>
	</head>
	<body>

	</body>
</html>