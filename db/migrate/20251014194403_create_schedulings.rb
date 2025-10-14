class CreateSchedulings < ActiveRecord::Migration[8.0]
  def change
    create_table :schedulings do |t|
      t.references :motorcycle, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :scheduled_time_date, null: false
      t.string :type, null: false  # "garantia" ou "normal"
      t.integer :current_scheduling_km
      t.text :client_observations, default: "pendente" # "pendente", "confirmado", "cancelado", "realizado"
      t.string :status

      t.timestamps
    end

    add_index :schedulings, :status
    add_index :schedulings, :scheduled_time_date
    add_index :schedulings, :type
  end
end
