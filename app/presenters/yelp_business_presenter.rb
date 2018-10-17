class YelpBusinessPresenter < SimpleDelegator
  def alias
    id
  end

  def name
    business_info.fetch('name')
  end

  def image_url
    business_info.fetch('image_url')
  end

  def url
    business_info.fetch('url')
  end

  def phone
    business_info.fetch('display_phone')
  end

  def review_count
    business_info.fetch('review_count')
  end

  def rating
    business_info.fetch('rating')
  end

  def coordinates
    business_info.fetch('coordinates', {}).values_at('latitude', 'longitude')
  end

  def price
    business_info.fetch('price', nil) # sometimes this is not in the data?
  end

  def address
    # location.fetch('display_address', []).join(', ') # this includes the ZIP code which the mock doesn't have
    street = location['address1']
    state = location['state']
    [street, city, state].compact.join(', ')
  end

  def cross_streets
    location.fetch('cross_streets')
  end

  def city
    location.fetch('city')
  end

  def price_range
    case price
    when '$'
      'Under $10'
    when '$$'
      '$10-30'
    when '$$$'
      '$31-60'
    when '$$$$'
      'Above $61'
    else
      'Unknown pricing'
    end
  end

  def primary_category
    categories.first
  end

  def categories
    super.map { |c| YelpCategoryPresenter.new(c) }
  end

  def categories_with_ancestors
    categories.reduce([]) do |set, c|
      set.push(c)
      c.ancestors.each do |ancestor|
        set.push YelpCategoryPresenter.new(ancestor)
      end
      set
    end.uniq(&:id)
  end

  private

  def location
    business_info.fetch('location', {})
  end

end
