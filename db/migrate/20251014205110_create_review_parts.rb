class CreateReviewParts < ActiveRecord::Migration[8.0]
  def change
    create_table :review_parts do |t|
      t.references :review, null: false, foreign_key: true
      t.references :part, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.decimal :unit_price, precision: 10, scale: 2, null: false
      t.boolean :guarantee, default: false

      t.timestamps
    end

    add_index :review_parts, [ :review_id, :part_id ], unique: true
  end
end
