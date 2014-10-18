require 'erb'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'active_support/core_ext'

class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res, route_params = {})
    @req, @res = req, res
    @route_params = route_params
    @params = Params.new(req, @route_params)
  end

  def session
    @session ||= Session.new(@req)
  end
  
  def already_built_response?
    @already_built_response ||= false
  end

  def redirect_to(url)
    if @already_built_response
      raise "Double render error"
    else
      @res.status = 302
      @res['location'] = url
      @already_built_response = true
    end
  end

  def render_content(content, type)
    if @already_built_response
      raise "Already built response"
    else
      @res.body = content
      @res.content_type = type
      @already_built_response = true
      session.store_session(res)

    end
  end

  def render(template_name)
    controller_name = self.class.to_s.underscore
    view = template_name.to_s

    build_string = '../views/'
    build_string << controller_name
    build_string << '/'
    build_string << view
    build_string << '.html.erb'

    template_html = File.read(build_string)
    render_content(ERB.new(template_html).result(binding), "text/html")
  end

  def redirect_to(url)
    super(url)
    session.store_session(res)
  end

  def invoke_action(name)
    self.send(name)
    render(name) unless already_built_response?
  end


end
