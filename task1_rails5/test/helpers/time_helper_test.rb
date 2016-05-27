require 'test_helper'

class TimeHelperTest < ActionView::TestCase
  test 'filter_query should not change correct value' do
    q = 'Moscow,New York'
    assert_equal filter_query(q), q
  end

  test 'filter_query should remove all not-allowed characters' do
    src = 'Moscow,$%&\'Bishkek,()*+-china,.:;<=>ddd,?@[\New York\]^_`{|}~"'
    dst = 'Moscow,Bishkek,china,ddd,New York'
    assert_equal filter_query(src), dst
  end
end