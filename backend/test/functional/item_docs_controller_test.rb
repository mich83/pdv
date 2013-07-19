# -*- encoding : utf-8 -*-
require 'test_helper'

class ItemDocsControllerTest < ActionController::TestCase
  setup do
    @item_doc = item_docs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:item_docs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create item_doc" do
    assert_difference('ItemDoc.count') do
      post :create, :item_doc => @item_doc.attributes
    end

    assert_redirected_to item_doc_path(assigns(:item_doc))
  end

  test "should show item_doc" do
    get :show, :id => @item_doc
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @item_doc
    assert_response :success
  end

  test "should update item_doc" do
    put :update, :id => @item_doc, :item_doc => @item_doc.attributes
    assert_redirected_to item_doc_path(assigns(:item_doc))
  end

  test "should destroy item_doc" do
    assert_difference('ItemDoc.count', -1) do
      delete :destroy, :id => @item_doc
    end

    assert_redirected_to item_docs_path
  end
end
