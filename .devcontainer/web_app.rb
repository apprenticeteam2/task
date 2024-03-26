require 'grape'
require 'erb'

class WebApp < Grape::API
  content_type :html, 'text/html'
  format :html

  helpers do
    def session
      env['rack.session']
    end

    def current_user
      if session[:user_id].nil?
        # ユーザーがデータベースに存在しない場合、新しいユーザーを作成
        puts 'ユーザー存在しない'
        user_id = $task_manager.add_user
        session[:user_id] = user_id
        user_id
      else
        # 既に存在するユーザーを取得
        $task_manager.find_user(session[:user_id])
      end
    end

    def render(template)
      erb_filename, locals = if template.is_a?(Hash)
        [template[:partial], template.fetch(:locals, {})]
      else
        [template, {}]
      end

      path = File.expand_path("../views/#{erb_filename}.html.erb", __FILE__)
      erb_template = ERB.new(File.read(path))

      merged_binding = binding
      locals.each { |key, value| merged_binding.local_variable_set(key, value) }
      # テンプレートの評価と結果の返却
      erb_template.result(merged_binding)
    end
  end

  before do
    @current_user = current_user
  end

  get '/' do
    @tasks = $task_manager.get_tasks(current_user)
    render('index')
  end

  get '/new' do
    render('add-task')
  end

  get '/edit/:id' do
    id = params[:id]
    @task = $task_manager.find_task(id)
    render('edit-task')
  end

  get '/history' do
    render('history')
  end
end
