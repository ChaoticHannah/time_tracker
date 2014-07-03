class CreateTasks < ActiveRecord::Migration
  def up
    create_table :tasks do |t|
    	t.string :name
    	t.integer :project_id
    	t.integer :user_id
    	t.text :description
    	t.time :estimate_time
    	t.time :real_time
    	t.string :status
    	t.string :specialization

      t.timestamps
    end
  end

  def down
  	drop_table :tasks
  end
end
