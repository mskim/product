
class SMGraphicModel
  attr_accessor :graphic_hash, :text_record, :image_record
  
  def initialize(hash)
    @graphic_hash=hash
    @text_record=hash[:text_record]
    @image_record=hash[:image_record]
    self
  end
  
  def replace_text(keys,data)
    
    return if @text_record[:att_string_array].length == 0
    str= @text_record[:att_string_array].first[:text]
    keys.each_with_index do |key, index|
      pattern="{{#{key}}}"
      str.gsub!(pattern,data[index])
    end
    @text_record[:att_string_array].first[:text]=str
    
  end
  
  def replace_image(key,data)
    
  end
  
end

class SMPageModel
  attr_accessor :graphics, :hash
  def initialize(hash)
    @hash=hash
    @graphics=[]
    hash[:graphics].each do |graphic|
      @graphics << SMGraphicModel.new(graphic)
    end
    self
  end
end

require 'yaml'
class SMDocumentModel
  attr_accessor :path, :document, :keys, :data, :document_hash, :output_path, :graphics
  attr_accessor :pages
  # copy_of_template_file is give at path
  # In the options we are give keys and data
  # we can replace the content at path with new data
  
  def initialize(path, options={})
    # super
    @path=path
    rlayout_yaml_path= @path + "/layout.yaml"
    @document_hash=YAML::load_file(rlayout_yaml_path)
    @keys=options[:keys] if options[:keys]
    @data=options[:data] if options[:data]
    # if the parameter is passed as Hash, instead of keys and values
    if options[:hash]
      @hash=options[:hash] 
      @keys=@hash.keys
      @data=@hash.values
    end
    # @pages=[]
    # document_hash[:pages].each do |page|
    #   @pages << SMPageModel.new(page)
    # end
    self
  end
  
  def save
     rlayout_yaml_path= @path + "/layout.yaml"
     File.open(rlayout_yaml_path, 'w' ) do |out|
       YAML.dump(@document_hash, out )
     end
     
  end
  
  def save_as(path)
    rlayout_yaml_path= @path + "/layout.yaml"
    system("mkdir -p #{path}") unless File.exists?(path)
    File.open(rlayout_yaml_path, 'w' ) do |out|
      YAML.dump(@document_hash, out )
    end
    
  end
  
  def replace_string
    str=@document_hash.to_s
    keys.each_with_index do |key, index|
      pattern="{{#{key}}}"
      str.gsub!(pattern,data[index]) 
    end
    @document_hash=eval(str)
    self
  end
  
  def parse_graphics
    @graphics=[]
    @pages.each do |page|
      @graphics += page.graphics
    end
  end
  
  def replace_data
    
    @graphics.each do |graphic|
      
      unless graphic.text_record.nil?
        graphic.replace_text(@keys,@data)
      end
      
      unless graphic.image_record.nil?
        graphic.replace_image(@keys,@data)
      end
    end
  end
  
  def update_rlayout
    
  end
    
  
  def self.from_yaml(path, options)
    require 'yaml'
    rlayout_yaml_path= path + "/layout.yaml"
    hash=YAML::load_file(rlayout_yaml_path)
    hash=hash.merge(options)
    doc=SMDocumentModel.new(path, hash)
    doc
  end
  
  def self.parse_csv(csv_path)
    require 'csv'
    unless File.exists?(csv_path)
      puts "#{csv_path} doesn't exist ..."
      return nil
    end
    
    rows=[]
    CSV.foreach(csv_path) do |line|
      rows << line
    end
    rows
  end
  
  def self.create_product_layout_from(template, csv_path, options={})
    @output_path=File.dirname(template) 
    @output_path=options[:output_path] if options[:output_path]
    @generated_documnets=[]
    rows= SMDocumentModel.parse_csv(csv_path)
    keys=rows[0]
    puts "Start creating PDF of #{rows.length-1}"
          
    rows.each_with_index do |row_data, index|
      next if index==0
      next unless row_data[0] # preventive in case the name field is empty
      puts "Creating #{row_data[0]}..."
      output_path=@output_path + "/#{row_data[0].gsub(" ","")}.rlayout"
      system("cp -r #{template} #{output_path}") unless File.exists?(output_path)        
      @variable_document = SMDocumentModel.from_yaml(output_path, :keys=>keys, :data=>row_data)  
      @variable_document.replace_string.save
      @generated_documnets << output_path
    end
    @generated_documnets
  end
end

require 'minitest/autorun'

describe 'create_product_layout_from' do
  before do
    @template= "/Users/mskim/Documents/rlayout_test/catalog/catalog_template1.rlayout"
    @csv_path= "/Users/mskim/Documents/rlayout_test/catalog/catalog.csv"
  end
  
  it 'should create multiple files' do
    files=SMDocumentModel.create_product_layout_from(@template, @csv_path)
    files.each do |path|
      system("open #{path}")
    end
  end  
end

