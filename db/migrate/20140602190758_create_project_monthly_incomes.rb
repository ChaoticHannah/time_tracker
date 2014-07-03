class CreateProjectMonthlyIncomes < ActiveRecord::Migration
  def up
    create_table :project_monthly_incomes do |t|
    	t.integer :project_id
    	t.integer :income_per_month
    	t.date :month

      t.timestamps
    end
  end

  def down
  	drop_table :project_monthly_incomes
  end
end
