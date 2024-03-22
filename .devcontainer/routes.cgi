require 'cgi'
require 'erb'


cgi = CGI.new
path = cgi.path_info

case path

when '/'
	template = ERB.new(File.read('index.erb'))
when '/new'
	template = ERB.new(File.read('add-task.erb'))
when '/history'
	template = ERB.new(File.read('history.erb'))
when '/edit'
	template = ERB.new(File.read('edit-task.erb'))
end

cgi.out('type => 'text/html;', 'charset' => 'UTF-8') do
	template.result(binding)
end
