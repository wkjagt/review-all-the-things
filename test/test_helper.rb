ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/mini_test'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def payload_for(filename)
    JSON.parse(get_json(filename), symbolize_names: true)
  end

  def get_json(filename)
    IO.read(File.expand_path("../#{filename}", __FILE__))
  end

  def raw_post(action, body)
    @request.env['RAW_POST_DATA'] = body
    response = post action
    @request.env.delete('RAW_POST_DATA')
    response
  end
end
