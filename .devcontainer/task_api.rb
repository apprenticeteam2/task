require_relative 'task'

class TaskAPI < Grape::API
  format :json
  
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
        puts user_id
        user_id
      else
        # 既に存在するユーザーを取得
        puts 'ユーザー存在する'
        puts session[:user_id]
        puts $task_manager.find_user(session[:user_id])
        $task_manager.find_user(session[:user_id])
      end
    end
  end

  resource :api do
    # タスク取得 *erbなら使わない
    # get :tasks do
    #   tasks_array = $task_manager.get_tasks.map do |task|
    #     {
    #       id: task['id'],
    #       name: task['name'],
    #       start_time: task['start_time'],
    #       end_time: task['end_time'],
    #       completed: task['completed']
    #     }
    #   end
    #   tasks_array
    # end

    resource :task do
      # タスク追加
      post do
        user_id = current_user
        task_name = params['name']
        start_time = Time.parse(params['start_time'])
        end_time = Time.parse(params['end_time'])
        $task_manager.add_task(user_id, task_name, start_time, end_time)
        redirect '/', permanent: true
      end

      route_param :id do
        # タスク編集
        patch do
          # タスク編集のロジックをここに実装
        end

        # タスク完了
        patch :complete do
          # タスク完了のロジックをここに実装
        end

        # タスク削除
        delete do
          # タスク削除のロジックをここに実装
        end
      end
    end
  end
end
