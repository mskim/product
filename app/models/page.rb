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
  
  def collect_item_pdf_files
    item_pdf_files=[]
    items.each do |item|
      item_pdf_files << item.pdf_path
    end
    item_pdf_files
  end
  
  def generate_rlayout
    
  end
  
  def generate_job
    h={
      :action       =>"catalog_page",
      :pdf_files    => collect_item_pdf_files,
      :template     => template_path,
      :output_path  => pdf_path,
      :preview      => "true"
    }
    yaml=h.to_yaml
    File.open(job_file_path,'w') {|f| f.write yaml}
  end
  
  def job_file_path
    catalog_path + "/page_#{id}.rjob"
  end
  
  def template_path
    catalog_path + "/page_#{id}_template.rlayout"
  end
  
  def pdf_path
    catalog_path + "/page_#{id}.pdf"
  end
  
end
