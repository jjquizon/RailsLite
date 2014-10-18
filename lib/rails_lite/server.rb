require 'webrick'
require_relative '../lib/phase2/controller_base'

class MyController < Phase2::ControllerBase
  def go
    if @req.path == "/redirect"
      redirect_to("http://www.google.com", "text/html")
    else
      redirect_to("/new")
    end
  end
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  MyController.new(req, res).go
end

trap('INT') { server.shutdown }
server.start
