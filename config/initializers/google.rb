Rails.application.config.google_api_key = ENV.fetch('GOOGLE_API_KEY') {
  warn "WARNING: $GOOGLE_API_KEY is required but is not set"
}
