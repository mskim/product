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
  
  def collect_item_pdf_files
    item_pdf_files=[]
    pages.each do |page|
      page.items.each do |item|
        item_pdf_files << item.pdf_path
      end
    end
    item_pdf_files
  end
  
  def catalog_path
    @catalog ||=Catalog.find(catalog_id)
    @catalog.path
  end
  
  def template_path
    catalog_path + "/category_#{id}_template.rlayout"
  end
  
  def pdf_path
    catalog_path + "/category_#{id}.pdf"
  end
  
  def job_file_path
    job_file_path=catalog_path + "/category_#{id}.rjob"
  end
  
  def generate_job
    h={
      :action     =>"catalog_section",
      :pdf_files  => collect_item_pdf_files,
      :template   => template_path,
      :output_path => pdf_path,
      :preview     => "true"
    }
    yaml=h.to_yaml
    File.open(job_file_path,'w') {|f| f.write yaml}
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
