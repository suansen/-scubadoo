import mapboxgl from "mapbox-gl";
import "mapbox-gl/dist/mapbox-gl.css";
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder";
import ShipWreck from "../images/shipwreck_marker2.png";
import Octopus from "../images/octopus.png";
import Center from "../images/center.png";

const fitMapToMarkers = (map, markers) => {
  const bounds = new mapboxgl.LngLatBounds();
  markers.forEach((marker) => bounds.extend([marker.lng, marker.lat]));
  map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 500 });
};

const addMarkersToMap = (map, markers) => {
  const current_path = window.location.pathname;
  console.log(current_path);
  markers.forEach((marker) => {
    const popup = new mapboxgl.Popup().setHTML(marker.info_window); // add this
    const el = document.createElement("div");
    el.className = "marker";
    if (current_path.includes("trips")) {
      el.style.backgroundImage = `url(${ShipWreck})`;
    } else if (current_path.includes("centers")) {
      el.style.backgroundImage = `url(${Center})`;
    } else {
      el.style.backgroundImage = `url(${Octopus})`;
    }
    // el.style.backgroundImage = "url(https://placekitten.com/g/50/50/)";
    el.style.width = `70px`;
    el.style.height = `70px`;
    el.style.backgroundSize = "100%";

    new mapboxgl.Marker(el)
      .setLngLat([marker.lng, marker.lat])
      .setPopup(popup) // add this
      .addTo(map);
  });
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

    const geocoder = new MapboxGeocoder({
      accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl
      });

    document.getElementById('geocoder').appendChild(geocoder.onAdd(map));

    fitMapToMarkers(map, markers);
    addMarkersToMap(map, markers);
    map.addControl(new mapboxgl.NavigationControl());
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
