class AddShortAndFullDescriptionToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :full_description, :text
  end
end
