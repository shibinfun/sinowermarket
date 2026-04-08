require "test_helper"

class SkusControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sku = skus(:sku_electronics)
    @sku.update(name: "Searchable Product")
  end

  test "should get index and show category banner" do
    get skus_url
    assert_response :success
    assert_select '[data-controller="category-tabs"]'
  end

  test "should get index with search query" do
    get skus_url, params: { query: "Searchable" }
    assert_response :success
    assert_select "h3", text: "Searchable Product"
  end

  test "should get index with price_asc sort" do
    get skus_url, params: { sort: "price_asc" }
    assert_response :success
    # Just verify it loads correctly
  end

  test "should get index with price_desc sort" do
    get skus_url, params: { sort: "price_desc" }
    assert_response :success
  end

  test "should filter by category" do
    category = categories(:sub_category)
    get skus_url, params: { category_id: category.id }
    assert_response :success
    assert_select "h1", text: category.name
  end

  test "should show sku prices in index" do
    @sku.update(current_price: 99.99, original_price: 129.99)
    get skus_url
    assert_response :success
    assert_select "span.text-2xl.font-black.text-blue-600", text: /\$99\.99/
    assert_select "span.text-sm.text-slate-400.line-through", text: /\$129\.99/
  end

  test "should show sku and show category banner" do
    get sku_url(@sku)
    assert_response :success
    assert_select '[data-controller="category-tabs"]'
  end
end
