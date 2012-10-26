namespace :product do

    
  desc "copy catalog templates from global_item.rlayout to each catalog templates folder "
  task :setup_catalog =>:environment do
    puts "Running setup_catalog..."
    catalogs=Catalog.all
    catalogs.each do |catalog|
      puts "setting up catalog: #{catalog.title}..."
      catalog.setup
      catalog.parse_csv
    end
    
  end
  
  desc "create proper catalog folders for items"
  task :setup_item =>[:environment, :setup_catalog] do
    puts "Running setup_item..."
    items=Item.all
    items.each do |m|
      m.setup
    end
  end
  
  desc "Create pdf for all items  "
  task :render_items =>:environment do
    puts "Running create_item..."
    items=Item.all
    items.each do |m|
      m.render_content
    end
  end
    
  desc "Create csv file for all items of each catalog "
  task :create_csv =>:environment do
    puts "Running create_csv..."
    catalogs=Catalog.all
    catalogs.each do |c|
      c.generate_csv_file
    end
  end
  
  desc "Parse all Categories from items"
  task :parse_categories =>:environment do
    puts "Running parse_categories..."
    items=Item.all
    items.each do |i|
      category_code=i.category
      Category.find_or_create(:code=>category_code, :catalog_id=>1)
    end
  end
  
  desc "Layout pages for each category"
  task :layout_categories =>:environment do
    puts "Running layout_pages..."
    categories=Category.all
    categories.each do |c|
      c.layout_category
    end
  end

end