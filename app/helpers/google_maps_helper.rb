module GoogleMapsHelper

  def google_maps_static(latitude, longitude)
    # https://maps.googleapis.com/maps/api/staticmap?scale=2&center=34.083527%2C-118.273677&language=None&zoom=15&markers=scale%3A2%7Cicon%3Ahttps%3A%2F%2Fyelp-images.s3.amazonaws.com%2Fassets%2Fmap-markers%2Fannotation_64x86.png%7C34.083527%2C-118.273677&client=gme-yelp&sensor=false&size=286x135&signature=caDllFvZa0MP4wBgJ7gq1bf-V-k=

    center = [latitude, longitude].join(',')
    params = {
      center: center,
      scale: 2,
      zoom: 14,
      markers: ['scale:2', 'icon:https://yelp-images.s3.amazonaws.com/assets/map-markers/annotation_64x86.png', center].join('|'),
      size: '800x300',
      key: Rails.application.config.google_api_key,
    }

    url = URI('https://maps.googleapis.com/maps/api/staticmap')
    url.query = params.to_query

    image_tag url.to_s, class: 'google-maps'
  end

  def google_maps_interactive(latitude, longitude, html_attr={})
    add_google_maps_script

    attrs = html_attr.merge(class: 'google-maps-map')
    attrs['data'] = {
      latitude: latitude,
      longitude: longitude,
      zoom: 14,
      icon: 'https://yelp-images.s3.amazonaws.com/assets/map-markers/annotation_32x43.png',
    }
    content_tag 'div', nil, attrs
  end

  def add_google_maps_script
    return if google_maps_script_tag

    url = "https://maps.googleapis.com/maps/api/js?key=#{Rails.application.config.google_api_key}&callback=initMaps"
    @google_maps_script_tag = javascript_include_tag url, defer: true, async: true
  end
  attr_reader :google_maps_script_tag

end
