class YelpAPI
  include HTTParty

  base_uri 'https://api.yelp.com/v3'
  raise_on [404, 500]

  def initialize(api_key:)
    @options = {
      headers: {
        Authorization: "Bearer #{api_key}",
      },
      debug_output: STDOUT,
    }
  end

  def business_info(id)
    safe_id = URI.escape(id)
    self.class.get("/businesses/#{safe_id}", @options)
  end

  def business_reviews(id)
    safe_id = URI.escape(id)
    self.class.get("/businesses/#{safe_id}/reviews", @options)
  end

  def all_categories
    self.class.get("/categories", @options)
  end

  def category(id)
    safe_id = URI.escape(id)
    self.class.get("/categories/#{safe_id}", @options)
  end
end
