require 'json'
require 'webrick'

class Session
  def find_cookies
    @req.cookies.find { |cookie | cookie.name == '_rails_lite_app' }
  end

  def initialize(req)
    @req = req
    @cookies = find_cookies.nil? ? {} : JSON.parse(find_cookies.value)
  end

  def [](key)
    @cookies[key]
  end

  def []=(key, val)
    @cookies[key] = val
  end

  def store_session(res)
    res.cookies << WEBrick::Cookie.new('_rails_lite_app', @cookies.to_json)
  end
end
