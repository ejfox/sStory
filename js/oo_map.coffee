# Define our features
frankogawa = [
    {
        lat: 37.8044
        lng: -122.27123
    },
    {
        lat: 37.80905
        lng: -122.27079
    },
    { 
        lat: 37.8049
        lng: -122.27247
    }
]

telegraph = [
    {
        lat: 37.80857,
        lng: -122.27092
    },
    {
        lat: 37.80905
        lng: -122.27079
    }
]

# Define a geojson data layer
geoJsonLayer = new L.GeoJSON(data)

# Define the map to use from MapBox
url = 'http://api.tiles.mapbox.com/v3/mapbox.mapbox-streets.jsonp'

wax.tilejson(url, (tilejson) ->
    map = new L.Map('mapbox', {
        zoomControl: false,
        scrollWheelZoom: false
    })
    
    # Center map
    .setView(new L.LatLng(37.80548, -122.27193), 17)
    
    # Add MapBox Streets as base layer
    .addLayer(new wax.leaf.connector(tilejson))
    
    # Add the geojson layer
    .addLayer(geojsonLayer)
    
    map.on('click', onMapClick)
        
(e) ->
    $('body').append("You clicked the map at "+e.latlng+"<br />")
        
    
)


       
    
console.log("fo",frankogawa[1])