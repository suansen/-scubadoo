import mapboxgl from "mapbox-gl";
import "mapbox-gl/dist/mapbox-gl.css";
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder";

const fitMapToMarkers = (map, markers) => {
  const bounds = new mapboxgl.LngLatBounds();
  markers.forEach((marker) => bounds.extend([marker.lng, marker.lat]));
  map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 500 });
};

const initMapbox = () => {
  const mapElement = document.getElementById("map");
  const staticMapElement = document.getElementById("static-map");

  if (mapElement) {
    // only build a map if there's a div#map to inject into
    mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
    const map = new mapboxgl.Map({
      container: "map",
      style: "mapbox://styles/mapbox/streets-v10",
    });

    const markers = JSON.parse(mapElement.dataset.markers);
    markers.forEach((marker) => {
      new mapboxgl.Marker().setLngLat([marker.lng, marker.lat]).addTo(map);
    });

    fitMapToMarkers(map, markers);
  }

  if (staticMapElement) {
    // only build a map if there's a div#map to inject into
    mapboxgl.accessToken = staticMapElement.dataset.mapboxApiKey;
    const map = new mapboxgl.Map({
      container: "static-map",
      style: "mapbox://styles/mapbox/streets-v10",
      // interactive: false,
    });

    const markers = JSON.parse(staticMapElement.dataset.markers);
    markers.forEach((marker) => {
      new mapboxgl.Marker().setLngLat([marker.lng, marker.lat]).addTo(map);
    });

    fitMapToMarkers(map, markers);
  }
};

export { initMapbox };
