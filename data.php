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