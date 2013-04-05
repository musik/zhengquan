class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.string :address
      t.string :contact
      t.string :phone
      t.string :email
      t.string :tousu
      t.references :company
      t.references :city
      t.references :province

      t.timestamps
    end
    add_index :stores, :company_id
    add_index :stores, :city_id
    add_index :stores, :province_id
  end
end
