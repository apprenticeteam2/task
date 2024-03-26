require './db_connect'

class CreateTasks < ActiveRecord::Migration[7.1]
	def change
		create_table :tasks, id: :bigint do |t|
			t.int :user_id, null: false
			t.string :name, limit:50, null: false
			t.datetime :start_time, null: false
			t.datetime :end_time, null: false
			t.boolean :completed
			t.integer :fine, null: false, default: 0

			t.timestamps default: -> {'CURRENT_TIMESTAMP'}
		end
	end
end

CreateTasks.new.change
