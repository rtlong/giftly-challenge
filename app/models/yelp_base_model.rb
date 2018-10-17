class YelpBaseModel
  CACHE_EXPIRATION = 24.hours

  def self.load(yelp_alias)
    new(yelp_alias).tap { |business|
      business.preload
    }
  end

  def initialize(yelp_alias)
    @id = yelp_alias
  end

  attr_reader :id

  protected

  def cache_fetch(subresource_key = nil, &block)
    key = self.class.cache_key(id, subresource_key)
    Rails.cache.fetch(key, expires_in: CACHE_EXPIRATION, &block)
  end

  def self.cache_key(id, subresource_key = nil)
    [
      'yelp',
      self.class.name.underscore.sub(/^yelp_/, ''),
      subresource_key,
      id,
    ].compact
  end

  def self.yelp_client
    @yelp_client ||= YelpAPI.new(api_key: Rails.application.config.yelp_api_key)
  end
end
