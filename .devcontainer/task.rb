# encoding: UTF-8
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
    puts 'データベースの接続に失敗しました。'
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
    puts 'タスクの取得に成功しました。'
    # DATETIME型をSTRINGに変換
    tasks.each do |row|
      row["start_time"] = row["start_time"].strftime('%H:%M')
      row["end_time"] = row["end_time"].strftime('%H:%M')
    end
    tasks
  rescue Mysql2::Error => e
    puts "タスクの取得に失敗しました: #{e.message}"
  end

  def add_task(user_id, name, start_time, end_time)
    query = 'INSERT INTO tasks (user_id,name,start_time,end_time) VALUES(?, ?, ?, ?)'
    @client.prepare(query).execute(user_id, name, start_time, end_time)
    puts 'タスクの追加に成功しました。'
  rescue Mysql2::Error => e
    puts "タスクの追加に失敗しました: #{e.message}"
  end

end
