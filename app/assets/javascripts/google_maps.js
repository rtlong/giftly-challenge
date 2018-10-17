function initMaps() {
  const nodes = document.querySelectorAll('.google-maps-map')
  nodes.forEach(function (node) {
    // The map, centered at Uluru
    const center = {
      lat: Number(node.dataset.latitude),
      lng: Number(node.dataset.longitude),
    }

    var map = new google.maps.Map(node, {
      zoom: Number(node.dataset.zoom),
      center: center,
      gestureHandling: 'cooperative',
      disableDefaultUI: true,
    })

    var marker = new google.maps.Marker({
      position: center,
      map: map,
      icon: {
        url: node.dataset.icon,
      },
    })
  })
}

window.initMaps = initMaps
