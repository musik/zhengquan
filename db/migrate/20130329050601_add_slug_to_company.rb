class AddSlugToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :slug, :string
    add_column :companies, :pinyin, :string
    add_column :companies, :abbr, :string
    add_index :companies,:slug
  end
end
