class AddCompaniesCountToCity < ActiveRecord::Migration
  def change
    add_column :cities, :companies_count, :integer
  end
end
