require 'test_helper'

class Public::RequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get public_requests_new_url
    assert_response :success
  end

  test "should get index" do
    get public_requests_index_url
    assert_response :success
  end

  test "should get show" do
    get public_requests_show_url
    assert_response :success
  end

  test "should get edit" do
    get public_requests_edit_url
    assert_response :success
  end

end
