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
end
