<?php
	if($_SERVER["REQUEST_METHOD"] === "GET") {
		header("Content-Type: application/json");
		$file = "./dataset.json";
		$content = file_get_contents($file);
		$formatted = str_replace("\"type\"", "\"@type\"", $content);
		$array = json_decode($formatted, true);
		$context = array(
			'@context' => array(
				'geojson' => 'https://purl.org/geojson/vocab#',
				'Feature' => 'geojson:Feature',
				'FeatureCollection' => 'geojson:FeatureCollection',
				'GeometryCollection' => 'geojson:GeometryCollection',
				'LineString' => 'geojson:LineString',
				'MultiLineString' => 'geojson:MultiLineString',
				'MultiPoint' => 'geojson:MultiPoint',
				'MultiPolygon' => 'geojson:MultiPolygon',
				'Point' => 'geojson:Point',
				'Polygon' => 'geojson:Polygon',
				'bbox' => array(
					'@container' => '@list',
					'@id' => 'geojson:bbox',
				),
				'coordinates' => array(
					'@container' => '@list',
					'@id' => 'geojson:coordinates',
				),
				'features' => array(
					'@container' => '@set',
					'@id' => 'geojson:features',
				),
				'geometry' => 'geojson:geometry',
				'id' => '@id',
				'properties' => 'geojson:properties',
				'type' => '@type',
				'LibraryName' => 'https://schema.org/name',
				'AddressLine1' => 'https://schema.org/address',
				'AddressLine2' => 'https://schema.org/address',
				'AddressLine3' => 'https://schema.org/address',
				'Postcode' => 'https://schema.org/postalCode',
				'Website' => 'https://schema.org/ur'
			),
		);
		$combined = $context + $array;
		echo json_encode($combined, JSON_PRETTY_PRINT);
	}
?>