ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/autorun"
require 'database_cleaner'
# require 'stripe_mock' # Not currently using stripe_mock but it is a good events testing gem.
include FactoryGirl::Syntax::Methods

class ActiveSupport::TestCase

  fixtures :all

  setup do
    DatabaseCleaner.start
    # StripeMock.start
  end

  teardown do
    DatabaseCleaner.clean
    # StripeMock.stop
  end
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def sign_in(user)
    post '/users/login', params: { email: user.email, password: user.password }
  end
end

require 'mocha/setup'
