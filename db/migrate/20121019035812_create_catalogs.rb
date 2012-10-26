class CreateCatalogs < ActiveRecord::Migration
  def change
    create_table :catalogs do |t|
      t.string :title
      t.date :publication_date
      t.text :description

      t.timestamps
    end
  end
end
