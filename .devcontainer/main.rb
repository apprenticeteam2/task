require 'webrick'
require 'erb'
require 'json'
require_relative 'task.rb'

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
			if request.path == '/'
				task_manager = TaskManager.new('localhost', 'root', 'rootpass', 'mydb')
				task_manager.show_task()
				puts task_manager.render_erb_template(index.erb)
			else
      	response.body = render_erb_template(route_map[request.path])
			end
    elsif request.path.match?(%r{^/(css|js)/})
      serve_static_file(request, response)
    end
	rescue JSON::ParserError
      response.status = 404
      response['Content-Type'] = 'text/plain'
      response.body = 'Not Found'
  end

  def do_POST(request, response)

		begin
			case request.path
			when '/new'
				task_manager = TaskManager.new('localhost', 'root', 'rootpass', 'mydb')
				h = request.query
				user_id =h['user_id']
				name = h['name']
				start_time = h['start_time']
				end_time = h['end-time']
				completed = h['completed'] == true
				fine = h['fine'].to_i

				task_manager.add_task(user_id, name, start_time, end_time, completed, fine)
				response.status = 200
				response['Content-Type'] = 'application/json'
				response.body = { message: 'Task added successfully' }.to_json

			# ここで受け取ったデータを処理する
			# post_data = JSON.parse(request.body)
			# response.body = post_data.to_json
			end
		rescue JSON::ParserError
			response.status = 400
			response['Content-Type'] = 'application/json'
			response.body = { error: 'Invalid JSON format' }.to_json
		end
	end
  def do_PUT(request, response)
		case request.path
		when '/new'
		task_manager = TaskManager.new('localhost', 'root', 'rootpass', 'mydb')
		h = request.query
		user_id =h['user_id']
		name = h['name']
		start_time = h['start_time']
		end_time = h['end-time']
		completed = h['completed'] == true
		fine = h['fine'].to_i

		task_manager.update_task(name: nil, user_id: nil, start_time: nil, end_time: nil, completed: nil, fine: nil)
		response.status = 200
		response['Content-Type'] = 'application/json'
		response.body = { message: 'Task added successfully' }.to_json
		end
    # ここで受け取ったデータを処理する
  rescue JSON::ParserError
    response.status = 400
    response['Content-Type'] = 'application/json'
    response.body = { error: 'Invalid JSON format' }.to_json
  end

  def do_DELETE(request, response)
task_manager = TaskManager.new('localhost', 'root', 'rootpass', 'mydb')
		h = request.query
		name = h['name']
		user_id = h['user_id']
		task_manager.delete_task(name, user_id)
    response.status = 200
    response['Content-Type'] = 'application/json'
		response.body = { message: 'Task added successfully' }.to_json
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
task_manager = TaskManager.new('localhost', 'root', 'rootpass', 'mydb')

ruby task_manager.show_task
server = WEBrick::HTTPServer.new(Port: 8000)

# Servletをマウント
server.mount '/', Servlet

trap 'INT' do server.shutdown end

server.start
