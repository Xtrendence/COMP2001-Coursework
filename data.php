<?php
	function getData() {
		$file = "./dataset.json";
		$content = file_get_contents($file);
		return json_decode($content, true);
	}
	function displayInfo() {
		$data = getData();
		$type = $data["type"];
		$name = $data["name"];
		$crs = $data["crs"];
		$crsType = $crs["type"];
		$crsProperties = $crs["properties"];
		$crsPropertyName = $crsProperties["name"];
		return '<tr><td>' . $type . '</td><td>' . $name . '</td><td>' . $crsType . '</td><td>' . $crsPropertyName . '</td></tr>';
	}
	function displayFeatures($view) {
		$html = "";
		$data = getData();
		$features = $data["features"];
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

			if($view === "table") {
				$html .= '<tr><td>' . $type . '</td><td>' . $id . '</td><td>' . $name . '</td><td>' . $addressLine1 . '</td><td>' . $addressLine2 . '</td><td>' . $addressLine3 . '</td><td>' . $postcode . '</td><td>' . $latitude . '</td><td>' . $longitude . '</td><td><a href="' . $website . '">' . $name . '</a></td><td>' . $geometryType . '</td><td>' . $geometryLatitude . '</td><td>' . $geometryLongitude . '</td></tr>';
			}
			else {
				$html .= '<div class="card"><span>' . $name . '</span><span>' . $type . '</span><span>' . $id . '</span><span>' . $addressLine1 . '</span><span>' . $addressLine2 . '</span><span>' . $addressLine3 . '</span><span>' . $postcode . '</span><span>' . $latitude . '</span><span>' . $longitude . '</span><span><a href="' . $website . '">' . $name . '</a></span><span>' . $geometryType . '</span><span>' . $geometryLatitude . '</span><span>' . $geometryLongitude . '</span><span></div>';
			}
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
		<div class="buttons-wrapper">
			<button id="dataset-info">Dataset Info</button>
			<button class="active" id="table-view">Table View</button>
			<button id="card-view">Card View</button>
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
				<?php echo displayInfo(); ?>
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
					<?php echo displayFeatures("table"); ?>
				</table>
			</div>
			<div class="card-wrapper hidden">
				<?php echo displayFeatures("card"); ?>
			</div>
		</div>
	</body>
</html>