class YelpBusiness < YelpBaseModel
  def business_info
    @business_info ||= cache_fetch(:business_info) do
      self.class.yelp_client.business_info(id).parsed_response
    end
  end

  def reviews
    @reviews ||= cache_fetch(:business_reviews) do
      self.class.yelp_client.business_reviews(id).fetch('reviews')
    end
  end

  def category_ids
    business_info.fetch('categories', []).map { |c| c.fetch('alias') }
  end

  def categories
    @categories ||= category_ids.map { |cid| YelpCategory.load(cid) }
  end

  def preload
    business_info
    reviews
    categories
  end
end
