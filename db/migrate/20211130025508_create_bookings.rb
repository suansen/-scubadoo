class CreateBookings < ActiveRecord::Migration[6.1]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.reference :listing
      t.integer :no_of_divers
      t.string :status
      t.integer :costs

      t.timestamps
    end
  end
end
