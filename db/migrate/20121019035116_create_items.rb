class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.string :category
      t.string :code
      t.string :brand
      t.float :price
      t.string :maker
      t.text :description
      t.string :country_of_origin
      t.string :delivery_method
      t.float :delivery_fee
      t.integer :inventory
      t.float :market_price
      t.string :sub_category
      t.string :condition
      t.string :image_url
      t.integer :catalog_id
      t.integer :page_id

      t.timestamps
    end
  end
end
