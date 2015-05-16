require 'test_helper'

class CreditHoldersControllerTest < ActionController::TestCase
  setup do
    @credit_holder = credit_holders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:credit_holders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create credit_holder" do
    assert_difference('CreditHolder.count') do
      post :create, credit_holder: { address: @credit_holder.address, contact_method: @credit_holder.contact_method, credits_total: @credit_holder.credits_total, email_address: @credit_holder.email_address, first_name: @credit_holder.first_name, last_name: @credit_holder.last_name, phone_number: @credit_holder.phone_number, zip_code: @credit_holder.zip_code }
    end

    assert_redirected_to credit_holder_path(assigns(:credit_holder))
  end

  test "should show credit_holder" do
    get :show, id: @credit_holder
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @credit_holder
    assert_response :success
  end

  test "should update credit_holder" do
    patch :update, id: @credit_holder, credit_holder: { address: @credit_holder.address, contact_method: @credit_holder.contact_method, credits_total: @credit_holder.credits_total, email_address: @credit_holder.email_address, first_name: @credit_holder.first_name, last_name: @credit_holder.last_name, phone_number: @credit_holder.phone_number, zip_code: @credit_holder.zip_code }
    assert_redirected_to credit_holder_path(assigns(:credit_holder))
  end

  test "should destroy credit_holder" do
    assert_difference('CreditHolder.count', -1) do
      delete :destroy, id: @credit_holder
    end

    assert_redirected_to credit_holders_path
  end
end
