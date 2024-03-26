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

    def get_user_id_by_task_id(task_id)
      $task_manager.find_task(task_id)['user_id']
    end

    def validate_user!(user_id)
      error!('Forbidden', 403) unless current_user == user_id.to_i
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
        before do
          user_id = get_user_id_by_task_id(params[:id])
          validate_user!(user_id)
        end

        # formではgetかpostしか使えないためメソッドオーバーライド
        post do
          task_id = params[:id]
          case params['_method']
          when 'PATCH'
            task_name = params['task_name']
            start_time = Time.parse(params['start_time'])
            end_time = Time.parse(params['end_time'])
            $task_manager.edit_task(task_id, task_name, start_time, end_time)
            redirect '/', permanent: true
          when 'DELETE'
            $task_manager.delete_task(task_id)
            redirect '/', permanent: true
          end
        end

        # タスク完了
        patch :complete do
          # タスク完了のロジックをここに実装
        end
      end
    end
  end
end
