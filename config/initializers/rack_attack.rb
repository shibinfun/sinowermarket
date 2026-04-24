class Rack::Attack
  ### Configure Cache ###
  # If you are using Rails 5+ with ActiveSupport::Cache::RedisStore, Rack::Attack will use it automatically.
  # For other cache stores, you must set Rack::Attack.cache.store.
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  ### Throttle Spammy Clients ###

  # Throttle all requests by IP (60rpm)
  # Key: "rack::attack:#{Time.now.to_i / 1.minute}:req/ip:#{req.ip}"
  throttle('req/ip', limit: 300, period: 5.minutes) do |req|
    req.ip
  end

  ### Throttle Login Attempts ###

  # Throttle POST requests to /users/sign_in by IP address
  # Key: "rack::attack:allow2ban:login/ip:#{req.ip}"
  throttle('logins/ip', limit: 5, period: 20.seconds) do |req|
    if req.path == '/users/sign_in' && req.post?
      req.ip
    end
  end

  # Throttle POST requests to /users/sign_in by email address
  # Key: "rack::attack:allow2ban:login/email:#{Digest::SHA256.hexdigest(req.params['user']['email'])}"
  #
  # Note: This creates a more targeted throttle that helps prevent a single IP from
  # attacking many different accounts.
  throttle('logins/email', limit: 5, period: 20.seconds) do |req|
    if req.path == '/users/sign_in' && req.post?
      # return the email if present, nil otherwise
      req.params['user']['email'].to_s.downcase.gsub(/\s+/, "") if req.params['user'] && req.params['user']['email']
    end
  end

  ### Custom Response ###
  self.throttled_responder = lambda do |env|
    [ 429,  # status
      { 'Content-Type' => 'text/html' },   # headers
      ['<html><body><h1>Too Many Requests</h1><p>Please wait a moment and try again.</p></body></html>'] # body
    ]
  end
end
