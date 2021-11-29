class CreateCenters < ActiveRecord::Migration[6.1]
  def change
    create_table :centers do |t|
      t.string :name
      t.text :description
      t.string :address
      t.string :phone_number
      t.string :email
      t.string :location
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
