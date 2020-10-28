<?php
	if($_SERVER["REQUEST_METHOD"] === "GET") {
		header("Content-Type: application/json");
		$file = "./dataset.json";
		$content = file_get_contents($file);
		$array = json_decode($content, true);
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
				'description' => 'http://purl.org/dc/terms/description',
				'title' => 'http://purl.org/dc/terms/title',
			),
		);
		array_unshift($array, $context);
		echo json_encode($array, JSON_PRETTY_PRINT);
	}
?>