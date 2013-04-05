class AddShortToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :short, :string
  end
end
