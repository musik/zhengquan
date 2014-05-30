class AddColumnsToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :letter, :string,limit: 1
    add_column :companies, :content, :text
    Company.find_each do |r|
      r.letter = r.abbr[0]
      r.save
    end
  end
end
