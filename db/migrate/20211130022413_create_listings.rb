class CreateListings < ActiveRecord::Migration[6.1]
  def change
    create_table :listings do |t|
      t.string :category
      t.string :name
      t.text :description
      t.decimal :price
      t.date :date
      t.datetime :start_time
      t.integer :duration
      t.integer :dive_count
      t.integer :max_divers
      t.references :center, null: false, foreign_key: true

      t.timestamps
    end
  end
end
