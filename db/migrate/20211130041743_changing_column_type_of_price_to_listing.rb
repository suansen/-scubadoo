class ChangingColumnTypeOfPriceToListing < ActiveRecord::Migration[6.1]
  def change
    change_column :listings, :price, :integer
  end
end
