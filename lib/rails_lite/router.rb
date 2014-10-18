class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
    instance_eval(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller, action_name|
      add_route(pattern, http_method, controller, action_name)
    end
  end

  def match(req)
    @routes.find { |route| route.matches?(req) }
  end

  def run(req, res)
    matches = match(req)

    if matches.nil?
      res.status = 404
    else
      matches.run(req,res)
    end
  end
end
