class Catalog < ActiveRecord::Base
  attr_accessible :description, :publication_date, :title
  
  has_many :items
  
  def setup
    system("mkdir -p #{path}") unless File.exists?(path)
    parse_csv
  end
  
  def csv_path
    path + "/#{title_with_under_bar}.csv"
  end
  
  def title_with_under_bar
    title.gsub(" ","_")
  end
  
  def path
    "#{Rails.root}/public/catalog/#{id}"
  end
  
  def template_path
    path + "/template.rlayout"
  end
  
  def parse_csv
    puts __method__
    require 'csv'
    unless File.exists?(csv_path)
      puts "No CSV file for #{title_with_under_bar} found..."
      return
    end
    # f=File.open(stamp_path, 'r')
    item_attribute_names=Item.attribute_names
    i=0
    CSV.foreach(csv_path) do |line|
      puts "row_array:#{line}"
      if i==0
        puts "#{i}"
        @keys=line 
      else
        puts "#{i}"
        @h={}
        @keys.each_with_index do |key, index|
          puts "key:#{key}"
          if item_attribute_names.include?(key)
            @h[key.to_sym]=line[index]
          end
        end
        name=line[@keys.index('name')]
        item=Item.where(:name=>name, :catalog_id=>id).first_or_create(:name=>name, :catalog_id=>id)
        item.update_attributes(@h)
        item.save
        item.setup
      end
      i+=1
    end
    
  end
  
end
