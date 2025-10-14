class CreateModelParts < ActiveRecord::Migration[8.0]
  def change
    create_table :model_parts do |t|
      t.references :model_motorcycle, null: false, foreign_key: true
      t.references :part, null: false, foreign_key: true
      t.boolean :mandatory_review, default: false
      t.integer :km_replacement

      t.timestamps
    end

    add_index :model_parts, [ :model_motorcycle_id, :part_id ], unique: true
  end
end
