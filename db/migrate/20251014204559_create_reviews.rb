class CreateReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :reviews do |t|
      t.references :scheduling, null: false, foreign_key: true
      t.references :motorcycle, null: false, foreign_key: true
      t.references :mechanic, null: false, foreign_key: true
      t.datetime :start_date, null: false
      t.datetime :completion_date
      t.integer :km_review, null: false
      t.string :service_type, null: false # "garantia" ou "normal"
      t.string :status, default: "em_andamento" # "em_andamento", "concluida", "aguardando_peca"
      t.decimal :labor_value, precision: 10, scale: 2, default: 0
      t.decimal :total_value, precision: 10, scale: 2, default: 0
      t.text :mechanic_observations
      t.text :internal_observations
      t.text :report # Para revisões de garantia

      t.timestamps
    end

    add_index :reviews, :status
    add_index :reviews, :service_type
    add_index :reviews, :start_date
  end
end
