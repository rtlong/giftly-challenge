Rails.application.config.yelp_api_key = ENV.fetch('YELP_API_KEY') {
  warn "WARNING: $YELP_API_KEY is required but is not set"
}
