class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.integer :page_number
      t.integer :catalog_id
      t.integer :category_id

      t.timestamps
    end
  end
end
