class CreateActionLogs < ActiveRecord::Migration
  def change
    create_table "action_logs", :force => true do |t|
      t.integer  "user_id"
      t.integer  "project_id"
      t.text     "data"
      t.datetime "created_at"
      t.integer  "item_id"
      t.string   "action"
    end
  end
end
