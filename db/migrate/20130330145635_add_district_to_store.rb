class AddDistrictToStore < ActiveRecord::Migration
  def change
    add_column :stores, :district_id, :integer
    add_index :stores, :district_id
  end
end
