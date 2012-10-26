require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  setup do
    @item = items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create item" do
    assert_difference('Item.count') do
      post :create, item: { brand: @item.brand, catalog_id: @item.catalog_id, category: @item.category, code: @item.code, condition: @item.condition, country_of_origin: @item.country_of_origin, delivery_fee: @item.delivery_fee, delivery_method: @item.delivery_method, description: @item.description, image_url: @item.image_url, inventory: @item.inventory, maker: @item.maker, market_price: @item.market_price, name: @item.name, page_id: @item.page_id, price: @item.price, sub_category: @item.sub_category }
    end

    assert_redirected_to item_path(assigns(:item))
  end

  test "should show item" do
    get :show, id: @item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @item
    assert_response :success
  end

  test "should update item" do
    put :update, id: @item, item: { brand: @item.brand, catalog_id: @item.catalog_id, category: @item.category, code: @item.code, condition: @item.condition, country_of_origin: @item.country_of_origin, delivery_fee: @item.delivery_fee, delivery_method: @item.delivery_method, description: @item.description, image_url: @item.image_url, inventory: @item.inventory, maker: @item.maker, market_price: @item.market_price, name: @item.name, page_id: @item.page_id, price: @item.price, sub_category: @item.sub_category }
    assert_redirected_to item_path(assigns(:item))
  end

  test "should destroy item" do
    assert_difference('Item.count', -1) do
      delete :destroy, id: @item
    end

    assert_redirected_to items_path
  end
end
