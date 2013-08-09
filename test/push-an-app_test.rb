require "minitest/autorun"
require 'net/http'

class CustomMiniTest
  class Unit < MiniTest::Unit
    def before_suites
      before_all if respond_to? :before_all
    end
  end
end

class TestPushAnApp < CustomMiniTest::Unit::TestCase
  def before_all
    delete_all_apps!
    cf_login_and_set_space
  end

  def delete_all_apps!
    return if system "cf apps" =~ /No applications/
    system "yes | cf delete hello hello-node"
  end

  def cf_login_and_set_space
    system "cf login --username admin --password password"
    system "cf space myspace"
  end

  def push_test_app(app_type)
    system "cd test/fixtures/apps/#{app_type}/ && cf push"
  end

  def test_we_can_push_a_ruby_app
    assert push_test_app :sinatra
  end

  def test_app_ruby_app_is_up
    content = Net::HTTP.get URI('http://hello.vcap.me')
    assert_match content, /Hello/
  end

  def test_we_can_push_a_nodejs_app
    assert push_test_app :nodejs
  end
end
