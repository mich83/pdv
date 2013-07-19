# -*- encoding : utf-8 -*-
require 'test_helper'

class PriceTypesControllerTest < ActionController::TestCase
  setup do
    @price_type = price_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:price_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create price_type" do
    assert_difference('PriceType.count') do
      post :create, :price_type => @price_type.attributes
    end

    assert_redirected_to price_type_path(assigns(:price_type))
  end

  test "should show price_type" do
    get :show, :id => @price_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @price_type
    assert_response :success
  end

  test "should update price_type" do
    put :update, :id => @price_type, :price_type => @price_type.attributes
    assert_redirected_to price_type_path(assigns(:price_type))
  end

  test "should destroy price_type" do
    assert_difference('PriceType.count', -1) do
      delete :destroy, :id => @price_type
    end

    assert_redirected_to price_types_path
  end
end
