<?php
	class Utils {
		public static function getData($file) {
			$content = file_get_contents($file);
			return json_decode($content, true);
		}
		public static function displayInfo($file) {
			$data = Utils::getData($file);
			$type = $data["type"];
			$name = $data["name"];
			$crs = $data["crs"];
			$crsType = $crs["type"];
			$crsProperties = $crs["properties"];
			$crsPropertyName = $crsProperties["name"];
			return '<tr><td>' . $type . '</td><td>' . $name . '</td><td>' . $crsType . '</td><td>' . $crsPropertyName . '</td></tr>';
		}
		public static function displayFeatures($file, $view) {
			$html = "";
			$data = Utils::getData($file);
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
					$html .= '<tr><td>' . $type . '</td><td>' . $id . '</td><td>' . $name . '</td><td>' . $addressLine1 . '</td><td>' . $addressLine2 . '</td><td>' . $addressLine3 . '</td><td>' . $postcode . '</td><td>' . $latitude . '</td><td>' . $longitude . '</td><td><a target="_blank" href="' . $website . '">' . $name . '</a></td><td>' . $geometryType . '</td><td>' . $geometryLatitude . '</td><td>' . $geometryLongitude . '</td></tr>';
				}
				else {
					$html .= '<div class="card"><span class="name">' . $name . '</span><span>Type: ' . $type . '</span><span>ID: ' . $id . '</span><span>' . $addressLine1 . '</span><span>' . $addressLine2 . '</span><span>' . $addressLine3 . '</span><span>' . $postcode . '</span><span>Latitude: ' . $latitude . '</span><span>Longitude: ' . $longitude . '</span><span>Website: <a target="_blank" href="' . $website . '">' . $name . '</a></span><span>Geometry Type: ' . $geometryType . '</span><span>Geometry Latitude: ' . $geometryLatitude . '</span><span>Geometry Longitude: ' . $geometryLongitude . '</span><span></div>';
				}
			}
			return $html;
		}
	}
?>