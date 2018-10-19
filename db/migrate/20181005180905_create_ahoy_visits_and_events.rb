class CreateAhoyVisitsAndEvents < ActiveRecord::Migration[5.0]
  def change
    rename_table :visits, :ahoy_visits
  end
end
