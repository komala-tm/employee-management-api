class CreateEmployees < ActiveRecord::Migration[8.1]
  def change
    create_table :employees do |t|
      t.string :name
      t.string :email
      t.decimal :salary
      t.references :department, null: false, foreign_key: true

      t.timestamps
    end
  end
end
