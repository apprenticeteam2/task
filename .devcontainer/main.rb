require 'webrick'
require 'erb'
require 'json'

class Servlet < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(request, response)
    route_map = {
      '/' => 'index.erb',
      '/new' => 'add-task.erb',
      '/edit' => 'edit-task.erb',
      '/history' => 'history.erb'
    }

    if route_map.key?(request.path)
      response.status = 200
      response['Content-Type'] = 'text/html'
      response.body = render_erb_template(template_map[request.path])
    elsif request.path.match?(%r{^/(css|js)/})
      serve_static_file(request, response)
    else
      response.status = 404
      response['Content-Type'] = 'text/plain'
      response.body = 'Not Found'
    end
  end

  def do_POST(request, response)
    response.status = 200
    response['Content-Type'] = 'application/json'
    post_data = JSON.parse(request.body)

    # ここで受け取ったデータを処理する
    response.body = post_data.to_json
  rescue JSON::ParserError
    response.status = 400
    response['Content-Type'] = 'application/json'
    response.body = { error: 'Invalid JSON format' }.to_json
  end

  def do_PUT(request, response)
    response.status = 200
    response['Content-Type'] = 'application/json'
    post_data = JSON.parse(request.body)

    # ここで受け取ったデータを処理する
    response.body = post_data.to_json
  rescue JSON::ParserError
    response.status = 400
    response['Content-Type'] = 'application/json'
    response.body = { error: 'Invalid JSON format' }.to_json
  end

  def do_DELETE(request, response)
    response.status = 200
    response['Content-Type'] = 'application/json'

    post_data = JSON.parse(request.body)

    # ここで受け取ったデータを処理する
    response.body = post_data.to_json
  end

  private

  def render_erb_template(file)
    content = File.read(file)
    ERB.new(content).result(binding)
  end

  def serve_static_file(request, response)
    path = File.join(Dir.pwd, request.path)
    if File.exist?(path) && !File.directory?(path)
      response.status = 200
      response['Content-Type'] = mime_type(path)
      response.body = File.read(path)
    else
      response.status = 404
      response['Content-Type'] = 'text/plain'
      response.body = 'File not found'
    end
  end

  def mime_type(path)
    case File.extname(path)
    when '.css'
      'text/css'
    when '.js'
      'application/javascript'
    else
      'application/octet-stream'
    end
  end
end

server = WEBrick::HTTPServer.new(Port: 8000)

# Servletをマウント
server.mount '/', Servlet

trap 'INT' do server.shutdown end

server.start
