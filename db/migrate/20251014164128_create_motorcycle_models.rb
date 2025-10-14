class CreateMotorcycleModels < ActiveRecord::Migration[8.0]
  def change
    create_table :motorcycle_models do |t|
      t.string :name, null: false
      t.integer :displacement, null: false
      t.integer :start_production_year
      t.integer :end_production_year
      t.text :description
      t.integer :warranty_months, default: 36
      t.integer :warranty_km, default: 30000

      t.timestamps
    end

    add_index :motorcycle_models, :name
  end
end
