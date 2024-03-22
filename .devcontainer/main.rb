require 'webrick'
require 'json'

class Servlet < WEBrick::HTTPServlet::AbstractServlet
	def render_erb_template(file)
		ERB.new(File.read(file)).result(binding)
	end
  def do_POST(request, response)
		begin
			response.status = 200
			response['Content-Type'] = 'application/json'
			post_data = JSON.parse(request.body)

			# ここで受け取ったデータを処理する
			response.body = post_data.to_json
		rescue JSON::ParserError
			response.status = 400
			response['Content-Type'] = 'application/json'
			response.body = {error: 'Invalid JSON format'}.to_json
		end
	end

	def do_GET(request, response)
    response.status = 200
    response['Content-Type'] = 'text/plain'

    response.body = 'Hello from another endpoint!'
  end

	def do_PUT(request, response)
		begin
			response.status = 200
			response['Content-Type'] = 'application/json'
			post_data = JSON.parse(request.body)

			# ここで受け取ったデータを処理する
			response.body = post_data.to_json
		rescue JSON::ParserError
			response.status = 400
			response['Content-Type'] = 'application/json'
			response.body = {error: 'Invalid JSON format'}.to_json
		end
  end

	def do_DELETE(request, response)
    response.status = 200
    response['Content-Type'] = 'application/json'

    post_data = JSON.parse(request.body)

    # ここで受け取ったデータを処理する
    response.body = post_data.to_json
  end
end

server = Servlet.new(
	DocumentRoot: './',
	BindAddress: '0.0.0.0',
	Port: 8000
)
# srv.mount('/', Servlet::FileHandler, 'index.erb')
# srv.mount('/new', Servlet::FileHandler, 'add-task.erb')
# srv.mount('/history', Servlet::FileHandler, 'history.erb')
# srv.mount('/edit', Servlet::FileHandler, 'edit-task.erb')
server.mount_proc '/' do |req, res|
  res.body = render_erb_template('index.erb')
  res['Content-Type'] = 'text/html; charset=UTF-8'
end

server.mount_proc '/new' do |req, res|
  res.body = render_erb_template('add-task.erb')
  res['Content-Type'] = 'text/html; charset=UTF-8'
end

server.mount_proc '/history' do |req, res|
  res.body = render_erb_template('./history.erb')
  res['Content-Type'] = 'text/html; charset=UTF-8'
end

server.mount_proc '/edit' do |req, res|
  res.body = render_erb_template('./edit-task.erb')
  res['Content-Type'] = 'text/html; charset=UTF-8'
end


# server.mount('/', Servlet, './index.html')
# server.mount('/new', Servlet './add-task.erb')
# # server.mount '/:id', Servlet
# server.mount('/history', Servlet, './history.html')

trap 'INT' do server.shutdown end

server.start
