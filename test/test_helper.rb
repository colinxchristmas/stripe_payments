ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/autorun"
require 'database_cleaner'
require 'stripe_mock'
include FactoryGirl::Syntax::Methods

class ActiveSupport::TestCase

  fixtures :all

  setup do
    DatabaseCleaner.start
    StripeMock.start
  end

  teardown do
    DatabaseCleaner.clean
    StripeMock.stop
  end
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    DatabaseCleaner.start
    StripeMock.start
  end

  teardown do
    DatabaseCleaner.clean
    StripeMock.stop
  end
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def sign_in(user)
    post user_session_url, params: { email: user.email, password: user.password }
  end
end

require 'mocha/setup'
