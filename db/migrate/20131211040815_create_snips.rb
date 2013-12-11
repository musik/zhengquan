class CreateSnips < ActiveRecord::Migration
  def change
    create_table :snips do |t|
      t.string :name
      t.text :body

      t.timestamps
    end
  end
end
