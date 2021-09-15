require 'test_helper'

class Members::NotificationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get members_notifications_index_url
    assert_response :success
  end

end
