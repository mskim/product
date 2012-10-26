class Category < ActiveRecord::Base
  attr_accessible :catalog_id, :code, :display_order, :name
  has_many :pages
  
  def category_items
    @category_items ||= Item.where(:category == code)
  end
  
  def number_of_pages
    pages.length
  end
  
  def number_of_category_items
    category_items.length
  end
  
  def add_page(number_to_add)
    puts __method__
    puts "catalog_id:#{catalog_id}"
    number_to_add.times do |i|
      Page.create(:catalog_id=>catalog_id, :category_id=>id)
    end
  end
  
  def delete_page(number_to_delete)
    number_to_delete.times do 
      pages.last.destroy
    end
  end
  
  def items_per_page
    9
  end
  
  
  def layout_category
    pages_needed=0
    pages_needed = number_of_category_items / items_per_page
    
    remainer= number_of_category_items % items_per_page
    pages_needed += 1 if remainer > 0
    if pages.length < pages_needed
      additional_page_number= pages_needed - pages.length
      add_page(additional_page_number)
    elsif pages.length > pages_needed
      deleteing_page_number= pages_needed - pages.length
      delete_page(deleteing_page_number)
    end
    pages.each_with_index do |page,i|
      page_items=Item.where(:category=>code).offset(i*items_per_page).limit(items_per_page)
      page.layout_items(page_items)
      page.page_number=i + 1
      page.catalog_id=catalog_id
      page.save
    end
      
  end
end
