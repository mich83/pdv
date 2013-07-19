# -*- encoding : utf-8 -*-
require 'test_helper'

class CashDocsControllerTest < ActionController::TestCase
  setup do
    @cash_doc = cash_docs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cash_docs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cash_doc" do
    assert_difference('CashDoc.count') do
      post :create, :cash_doc => @cash_doc.attributes
    end

    assert_redirected_to cash_doc_path(assigns(:cash_doc))
  end

  test "should show cash_doc" do
    get :show, :id => @cash_doc
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @cash_doc
    assert_response :success
  end

  test "should update cash_doc" do
    put :update, :id => @cash_doc, :cash_doc => @cash_doc.attributes
    assert_redirected_to cash_doc_path(assigns(:cash_doc))
  end

  test "should destroy cash_doc" do
    assert_difference('CashDoc.count', -1) do
      delete :destroy, :id => @cash_doc
    end

    assert_redirected_to cash_docs_path
  end
end
