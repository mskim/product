# About Catalog Grid
# In the catalog pages, items are displayed in grid, usually in 3 by 3 or 3 by 2 grid.
# I am trying to automate the layout process of these pages and this is how we are going to do it.

# 3x3 means 3 unit column by 3unit rows
# and the following are the item size 
# we can describe catalog page as follows

# example grid_patterns
# {"2x3"=>[ [2, 2x2, 2x2],
#           [3, 2x2, 2x1,1x1,1x1],
#           [3, 2x2, 1x1,1x1,2x1],
#           [4, 2x2,1x1,1x1,1x1,1x1]]
#
# where the hash key is the grid pattern, first element of the array is the number of items and
# the rest of the description of the item size , 

require 'yaml'
GRID_PATTERNS={"2x3"=>[ %w[2 2x2 2x1],
                        %w[2 2x1 2x2],
                        %w[3 2x1 2x1 2x2],
                        %w[3 2x1 2x1 2x1],
                        %w[4 1x1 1x1 1x2 1x2],
                        %w[4 1x2 1x2 1x1 1x1],
                        %w[5 1x1 1x1 1x1 1x1 2x1],
                        %w[5 2x1 1x1 1x1 1x1 1x1],
                        %w[6 1x1 1x1 1x1 1x1 1x1 1x1]
                        
                      ],
              "3x3"=>[  %w[5 3x1 1x1 1x1 1x1 1x1],
                        %w[5 1x1 1x1 1x1 1x1 3x1],
                        %w[5 2x1 1x1 2x1 1x1 2x1 1x1 ],
                        %w[6 2x1 1x1 2x1 1x1 2x1 1x1 ],
                        %w[6 1x1 2x1 1x1 2x1 1x1 2x1 ],
                        %w[7 1x3 1x1 1x1 1x1 1x1 1x1 1x1],
                        %w[7 1x1 1x1 1x1 1x1 1x1 1x1 1x3],
                        %w[8 1x1 1x1 1x1 1x1 1x1 1x1 1x1 1x2],
                        %w[8 1x2 1x1 1x1 1x1 1x1 1x1 1x1 1x1],
                        %w[9 1x1 1x1 1x1 1x1 1x1 1x1 1x1 1x1 1x1]
                      ]
}

class ItemGraphic
  attr_accessor :frame, :image_path
  
  def initialize(options={})
    @frame      = options.fetch(:frame,[0,0,0,0])
    @image_path = options.fetch(:image_path,nil)
    self
  end
  # - :class: Image
  #   :frame: '{{20, 474.66666666666652}, {460, 205.33333333333326}}'
  #   :image_record:
  #     :klass: GImageRecord
  #     :image_path: /Users/mskim/Pictures/Photo_Booth/0.JPG
  #     :image_frame:
  #     - 0.0
  #     - 0.0
  #     - 0.0
  #     - 0.0
  
  def to_hash
    h={
      :frame       => @frame,
      :image_frame => @image_path
    }
  end
  
end

class CatalogGrid 
  attr_accessor :width,:height,:columns, :rows,:padding, :gutter
  attr_accessor :graphics_hash, :items_array, :grid_matrix, :item_pattern, :selected_pattern, :matching_patterns
  
  # return possible grid patterns for given grid_matrix, and the number of items
  def initialize(columns,rows, items_array, options={})
    @columns          = columns
    @rows             = rows
    @grid_matrix      = size_to_matrix(columns, rows)
    @selected_pattern = nil
    @width            = options.fetch(:width,500)
    @height           = options.fetch(:height,700)
    @padding          = options.fetch(:padding,5)
    @gutter           = options.fetch(:gutter,5)
    @items_array      = items_array
    @column_width= (@width - @padding*2 - ((@columns-1)*@gutter))/@columns
    @row_height= (@height - @padding*2 - ((@rows-1)*@gutter))/@rows 
    
    find_pattern
    layout_item
    self
  end
  
  # matrix_to_size(2,3) => "2x3"
  def matrix_to_size(matrix)
    matrix.split("x")
  end
  
  # size_to_matrix("2x3") => [2,3]
  def size_to_matrix(columns,rows)
    columns.to_s + "x" + rows.to_s
  end
  
  def size_of_matrix(matrix)
    width= @width - @padding*2 - ((@columns-1)*@gutter) 
    height= @height - @padding*2 - ((@rows-1)*@gutter) 
    return  width,  height  
  end
  
  def find_pattern
    number_of_items= @items_array.length
    g=GRID_PATTERNS[@grid_matrix]
    @matching_patterns=[]
    g.each do|pattern|
      @matching_patterns << pattern if pattern.first.to_i == number_of_items
    end
    @selected_pattern=@matching_patterns.first if @matching_patterns.length > 0
  end
  
  def layout_item
    x=@padding
    y=@padding
    @graphics_hash=[]
    @items_array.each_with_index do |item,i|
      item_pattern=@selected_pattern[i+1]
      unit_width=matrix_to_size(item_pattern)[0].to_i
      unit_height=matrix_to_size(item_pattern)[1].to_i
      
      frame=[x,y, @column_width*unit_width, @height*unit_height]
      # puts "frame:#{frame}"
      @graphics_hash << ItemGraphic.new(:frame=>frame, :image_path=>item).to_hash
      
      x+= @column_width + @gutter
      if (x + @column_width) > (@padding + @width)
        x=@padding
        y+=@row_height + @gutter
      end
    end
  end

  def generate_matrix_yaml
    layout_yml_template=<<EOF
    {{#{@graphics_hash.to_yaml}}}
EOF
  end
  

end

class CatalogPage
  attr_accessor :paper_type, :page_width, :page_height, :left_page, :page_number, :matrix, :header, :footer, :side_bar
  
  def initialize(options={})
    
  end
  
  def doc_info
    
  end
  
  def pages
    
  end
  
  def generate_rlayout_yaml
    hash ={
      :doc_info =>doc_info,
      :pages    =>pages
    }
    hash.to_yaml
  end
end


class SideBar
  attr_accessor :frame, :text
  
end

class Footer
  
end

class Header
  
end


require 'minitest/autorun'

describe 'CatalogGird' do
  before do
    @cGrid=CatalogGrid.new(2,3, %w[1.pdf 2.pdf 3.pdf 4.pdf 5.pdf])
  end
  
  it 'should find pattern' do
    @cGrid.must_be_kind_of CatalogGrid
  end
  
  it 'should find pattens' do
    patters=@cGrid.matching_patterns
    patters.must_be_kind_of Array
    patters.first.must_equal %w[5 1x1 1x1 1x1 1x1 2x1]
  end
  
  it 'should create layou_yml for page' do
    yaml=@cGrid.graphics_hash
    yaml.must_be_kind_of Array
    
  end
end