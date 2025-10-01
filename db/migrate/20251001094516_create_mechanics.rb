class CreateMechanics < ActiveRecord::Migration[8.0]
  def change
    create_table :mechanics do |t|
      t.references :user, null: false, foreign_key: true
      t.string :professional_registration, null: false
      t.string :specialty
      t.boolean :asset, default: true

      t.timestamps
    end

    add_index :mechanics, :professional_registration, unique: true
  end
end
