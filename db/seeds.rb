#encoding: utf-8

  catalog=Catalog.first_or_create(:id=>1, :title=>"Sample Catalog",:publication_date=>Time.now, :description=> "This is a sample catalog")

  # 100.times do |i|
  #   name="Item #{i}"
  #   item=Item.where(:catalog_id=>1, :name=>name, ).first_or_create(:name=>name, :catalog_id=>catalog.id)
  #   item.category="Category #{i}"
  #   item.code="code #{i}"
  #   item.brand="brand #{i}"
  #   item.price=0.0
  #   item.maker="Some maker"
  #   item.description="This is some sample product item"
  #   item.country_of_origin="Made in China"
  #   item.delivery_method="Delibery Service"
  #   item.delivery_fee=0.0
  #   item.inventory=1000
  #   item.market_price=0.0
  #   item.inventory=1000
  #   item.sub_category="sub_category"
  #   item.condition="Good Condition"
  #   item.image_url="image_url"
  #   item.save
  #   # item.setup
  # end
  # 

