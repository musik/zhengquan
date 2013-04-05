class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.integer :oid
      t.string :name
      t.string :address
      t.string :address1
      t.string :contact
      t.string :sn
      t.string :capital
      t.string :postal
      t.string :email
      t.string :website
      t.string :phone
      t.string :scopes

      t.timestamps
    end
  end
end
