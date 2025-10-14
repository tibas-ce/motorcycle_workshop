class CreateParts < ActiveRecord::Migration[8.0]
  def change
    create_table :parts do |t|
      t.string :name, null: false
      t.string :original_code, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :stock, default: 0
      t.text :description
      t.string :category

      t.timestamps
    end

    add_index :parts, :original_code, unique: true
    add_index :parts, :category
  end
end
