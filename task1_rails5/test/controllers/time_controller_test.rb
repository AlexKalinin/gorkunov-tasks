require 'test_helper'

class TimeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get time_url
    assert_response :success
  end

  # todo: cover the TimeController with tests
end
