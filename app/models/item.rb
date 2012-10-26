# encoding: UTF-8

class Item < ActiveRecord::Base
  attr_accessible :brand, :catalog_id, :category, :code, :condition, :country_of_origin, :delivery_fee, :delivery_method, :description, :image_url, :inventory, :maker, :market_price, :name, :page_id, :price, :sub_category
  belongs_to :catalog
  belongs_to :page
  
  def setup
    # create_directory
  end
  
  def template
    template=catalog.template_path
  end

  # cashing vaules
  def catalog
    @catalog ||= Catalog.find(catalog_id)
  end
  
  def catalog_path
    catalog.path
  end
  
  def pdf_path
    catalog_path + "/#{id}.pdf"
  end
  
  def preview_page
    "/catalog/#{catalog_id}/#{id}.pdf"
  end
  
  def create_qrcode
    qr_content =name + "\n" +  email + "\n" + division + "\n" + title + "\n" + cell + "\n" + phone + "\n" + company.address
    qr_path =  qr_code_path + "/#{name}.png"  
    system "/usr/local/bin/qrencode -o #{qr_path} '#{qr_content}'"
  end
  
  def close_file_path
    catalog_path + "/close.rjob"
  end
  
  def generate_close
    yaml={:action=>"close"}.to_yaml
    File.open(close_file_path,'w') {|f| f.write yaml}
  end
  
  def generate_job
    job_hash={}
    job_hash[:action]="variable_printing"
    job_hash[:variables]=attributes
    url=File.basename(job_hash[:variables]["image_url"], ".jpg")
    job_hash[:variables]["image_url"]=url
    job_hash[:template] = template
    job_hash[:output_path] = pdf_path 
    job_hash[:preview] = "true";
    yaml=job_hash.to_yaml
    File.open(job_file_path,'w') {|f| f.write yaml}
  end
  
  def job_file_path
    job_file_path=catalog_path + "/#{id}.rjob"
  end
  
  def render_content
    generate_job
    generate_close unless File.exists?(close_file_path)
    # system("open -a /Applications/RLayoutEngine.app  #{job_file_path}")
    system("open #{job_file_path}")
    # cloase file
    system("open #{close_file_path}")
  end
end
