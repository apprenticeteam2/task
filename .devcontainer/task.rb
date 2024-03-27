require 'mysql2'
require 'erb'
require 'cgi'
require 'time'

def format_time(datetime_str)
  datetime = Time.parse(datetime_str)
  datetime.strftime('%H:%M')
end

class TaskManager
  def initialize(host, username, password, database)
    @client = Mysql2::Client.new(host: host,
                                 username: username, password: password, database: database)
    puts 'データベースの接続に成功しました。'
  rescue Mysql2::Error => e
    puts "データベースの接続に失敗しました: #{e.message}"
  end

  def add_user
    query = 'INSERT INTO users VALUES()'
    @client.query(query)
    user_id = @client.last_id
    puts "ユーザー#{user_id}の追加に成功しました。"
    user_id
  rescue Mysql2::Error => e
    puts "ユーザーの追加に失敗しました: #{e.message}"
  end

  def find_user(user_id)
    query = 'SELECT id FROM users WHERE id = ?'
    user = @client.prepare(query).execute(user_id).first
    if user
      puts "ユーザー#{user_id}の取得に成功しました"
    else
      puts "ユーザー#{user_id}は見つかりませんでした"
    end
    user["id"]
  rescue Mysql2::Error => e
    puts "ユーザー#{user_id}の取得に失敗しました: #{e.message}"
  end

  def get_tasks(user_id)
    query = 'SELECT * FROM tasks WHERE user_id = ?;'
    tasks = @client.prepare(query).execute(user_id)
    if tasks
      puts 'タスクの取得に成功しました。'
    else
      puts 'タスクは見つかりませんでした。'
    end
    # DATETIME型をSTRINGに変換
    tasks.each do |row|
      row["start_time"] = row["start_time"].strftime('%H:%M')
      row["end_time"] = row["end_time"].strftime('%H:%M')
    end
    tasks
  rescue Mysql2::Error => e
    puts "タスクの取得に失敗しました: #{e.message}"
  end

  def add_task(user_id, task_name, start_time, end_time)
    query = 'INSERT INTO tasks (user_id, name, start_time, end_time) VALUES(?, ?, ?, ?)'
    @client.prepare(query).execute(user_id, task_name, start_time, end_time)
    puts 'タスクの追加に成功しました。'
  rescue Mysql2::Error => e
    puts "タスクの追加に失敗しました: #{e.message}"
  end

  def find_task(task_id)
    query = 'SELECT * FROM tasks WHERE id = ?;'
    task = @client.prepare(query).execute(task_id).first
    if task
      puts "タスク#{task_id}の取得に成功しました"
    else
      puts "タスク#{task_id}は見つかりませんでした"
    end
    puts task
    task
  rescue Mysql2::Error => e
    puts "タスク#{task_id}の取得に失敗しました: #{e.message}"
  end

  def edit_task(task_id, task_name, start_time, end_time)
    query = 'UPDATE tasks SET name = ?, start_time = ?, end_time = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?'
    @client.prepare(query).execute(task_name, start_time, end_time, task_id)
    puts "タスク#{task_id}の編集に成功しました。"
  rescue Mysql2::Error => e
    puts "タスク#{task_id}の編集に失敗しました: #{e.message}"
  end

  def delete_task(task_id)
    query = 'DELETE from tasks WHERE id = ?'
    @client.prepare(query).execute(task_id)
    puts "タスク#{task_id}の削除に成功しました。"
  rescue Mysql2::Error => e
    puts "タスク#{task_id}の削除に失敗しました: #{e.message}"
  end
end
