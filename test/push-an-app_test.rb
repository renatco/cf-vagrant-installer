require "minitest/autorun"

class TestPushAnApp < MiniTest::Unit::TestCase
  def setup
    cf_login_and_set_space
  end

  def cf_login_and_set_space
    system "cf login --username admin --password password"
    system "cf space myspace"
  end

  def push_sinatra_test_app(app_type)
    system "cd test/fixtures/apps/#{app_type}/ && cf push"
  end

  def test_we_can_push_a_ruby_app
    assert push_test_app(:sinatra)
  end

  def test_we_can_push_a_nodejs_app
    assert push_test_app(:nodejs)
  end
end
