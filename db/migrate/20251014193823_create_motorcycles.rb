class CreateMotorcycles < ActiveRecord::Migration[8.0]
  def change
    create_table :motorcycles do |t|
      t.references :user, null: false, foreign_key: true
      t.references :motorcycle_model, null: false, foreign_key: true
      t.string :license_plate, null: false
      t.string :chassis, null: false
      t.integer :year_of_manufacture, null: false
      t.string :color
      t.integer :current_km, default: 0
      t.date :purchase_date, null: false
      t.string :invoice_number

      t.timestamps
    end

    add_index :motos, :placa, unique: true
    add_index :motos, :chassi, unique: true
  end
end
