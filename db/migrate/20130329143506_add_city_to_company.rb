class AddCityToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :city_id, :integer
    add_index :companies,:city_id
  end
end
