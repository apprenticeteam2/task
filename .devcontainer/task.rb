require 'mysql2'
require 'erb'
require 'cgi'


class TaskManager
	def initialize(host, username, password, database)
		@client = Mysql2::Client.new(host: host,
	username: username, password: password, database: database)
	end

	def add_task(user_id,name,start_time,end_time,completed,fine)

			# データベースを保存
				query = "INSERT INTO tasks (user_id,name,start_time,end_time,completed,fine) VALUES(?, ?, ?, ?, ?, ?)"
				@client.prepare(query).execute(user_id,name,start_time,end_time,completed,fine)

			# 確認メッセージ
				puts cgi.header
				puts 'データベースの保存に成功しました。'
			else

	end

    #保存されているタスクを表示します
	# def list_tasks
	# 	@tasks =@client.query("SELECT * FROM tasks")
	# 	@tasks.each do|task|
	# 			puts "#{task['user_id']}: #{task['name']} - #{task['start_time']} #{task['end_time']} #{task['completed']} #{task['fine']}"
	# 	end
	# end

	def update_task(id, name: nil, user_id: nil, start_time: nil, end_time: nil, completed: nil, fine: nil)
    # おそらく、配列にカラムの値を格納したほうが、クエリが書きやすくなるから。
		set_clauses = []
		set_clauses << "name = ?" unless name.nil?
		set_clauses << "user_id = ?" unless user_id.nil?
		set_clauses << "start_time = ?" unless start_time.nil?
		set_clauses << "end_time = ?" unless end_time.nil?
		set_clauses << "completed = ?" unless completed.nil?
		set_clauses << "fine = ?" unless fine.nil?

# 更新するデータが空の場合は、終了
		return if set_clauses.empty?

		query = "UPDATE tasks SET #{set_clauses.join(", ")}" WHERE id = ?"
# compactでnilを除外して、配列を作る。最後にidカラムを配列に加える。
		params = [name, user_id, start_time, end_time, completed, fine ].compact + [id]
# `*`は、スプラット演算子
		@client.prepare(query).execute(*params)
	end
	def delete_task(id)
# `?`は、プレースホルダー。
## SQLインジェクション攻撃による、書き換えを防ぐ演算子。
		query = "DELETE FROM tasks WHERE id = ?"
		@client.prepare(query).execute(id)
	end
end


client = TaskManager.new(host: 'localhost',
	username: 'myuser', password: 'rootpass', database: 'mydb')

cgi = CGI.new
params = cgi.params

if cgi.request_method == 'POST'

# フォームデータを取得
# user_idは後から修正
	name = cgi ['name']
	start_time = cgi['start_time']
	end_time = cgi['end-time']
	completed = cgi['completed']
	fine = cgi['fine'].to_i
	completed = cgi['completed'] == true
	user_id = 1

	task_manager.add_task(user_id,name,start_time,end_time,completed,fine)
else
	# ERBテンプレートを使用してフォームを表示
  template = ERB.new(File.read("contact_form.erb"))
  puts cgi.header
  puts template.result()
end