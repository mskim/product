class Page < ActiveRecord::Base
  attr_accessible :catalog_id, :category_id, :page_number
  has_many :items
  
  # cashing vaules
  def category
    @category ||= Category.find(category_id)
  end
  
  def items_per_page
    category.items_per_page
  end
  
  def category_items
    category_items.category_items
  end
  
  def layout_items(page_items)
    page_items.each do |page_item|
      page_item.page_id=id
      page_item.save
    end
  end
  
end
