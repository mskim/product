class AddRowsAndColumnsToPage < ActiveRecord::Migration
  def change
    add_column :pages, :rows, :integer
    add_column :pages, :columns, :integer
  end
end
