class AddLanguageToCenters < ActiveRecord::Migration[6.1]
  def change
    add_column :centers, :language, :string
  end
end
