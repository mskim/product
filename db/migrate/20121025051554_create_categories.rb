class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :code
      t.string :name
      t.integer :display_order
      t.integer :catalog_id

      t.timestamps
    end
  end
end
