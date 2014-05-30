class AddVnToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :vn, :integer,default: 1
  end
end
