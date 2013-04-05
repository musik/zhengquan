class AddStoreCountToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :stores_count, :integer
  end
end
