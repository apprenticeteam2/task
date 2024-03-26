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
      path = File.expand_path("../views/#{template}.html.erb", __FILE__)
      ERB.new(File.read(path)).result(binding)
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
    @id = params[:id]
    render('edit-task')
  end

  get '/history' do
    render('history')
  end
end
