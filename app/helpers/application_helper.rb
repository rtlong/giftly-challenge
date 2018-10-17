module ApplicationHelper
  def page_title
    @page_title || 'Giftly'
  end

  def breadcrumbs
    @breadcrumbs_nav || []
  end

  def yelp_price_widget(price)
    return nil unless price

    num = case price
          when '$'
            1
          when '$$'
            2
          when '$$$'
            3
          when '$$$$'
            4
          else
            0
          end

    render partial: 'yelp-price-widget', locals: { num_dollar_signs: num }
  end

  def yelp_ratings_widget(rating:, count: nil, logo: false, size: 'large')
    render partial: 'yelp-ratings-widget', locals: {
             stars_class: yelp_ratings_stars_class(size, rating),
             reviews_count: count,
             show_logo: logo,
           }
  end

  def yelp_ratings_stars_class(size, rating_float)
    rating_int = (rating_float * 10).round
    num = rating_float.floor
    is_half = rating_float - num > 0.01 # float comparisons need a little wiggle room
    "i-stars--" + [size, num, is_half ? 'half' : nil].compact.join('-')
  end

  def google_maps_static(latitude, longitude)
    # https://maps.googleapis.com/maps/api/staticmap?scale=2&center=34.083527%2C-118.273677&language=None&zoom=15&markers=scale%3A2%7Cicon%3Ahttps%3A%2F%2Fyelp-images.s3.amazonaws.com%2Fassets%2Fmap-markers%2Fannotation_64x86.png%7C34.083527%2C-118.273677&client=gme-yelp&sensor=false&size=286x135&signature=caDllFvZa0MP4wBgJ7gq1bf-V-k=

    center = [latitude, longitude].join(',')
    params = {
      center: center,
      scale: 2,
      zoom: 15,
      markers: ['scale:2', 'icon:https://yelp-images.s3.amazonaws.com/assets/map-markers/annotation_64x86.png', center].join('|'),
      size: '800x300',
      key: Rails.application.config.google_api_key,
    }

    url = URI('https://maps.googleapis.com/maps/api/staticmap')
    url.query = params.to_query

    image_tag url.to_s, class: 'google-maps'
  end
end
