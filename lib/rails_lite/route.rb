class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method.to_s.downcase
    @controller_class = controller_class
    @action_name = action_name
  end

  def matches?(req)
    return true if req.path =~ @pattern &&
                      @http_method == req.request_method.to_s.downcase
    false
  end

  def run(req, res)
    matched_data = @pattern.match(req.path)
    route_params = {}
    matched_data.names.each do |name|
      route_params[name] = matched_data[name]
    end

    controller = @controller_class.new(req, res, route_params)
    controller.invoke_action(@action_name)
  end
end
