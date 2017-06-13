require 'test_helper'
require 'stripe_mock'

class UsersControllerTest < ActionDispatch::IntegrationTest
  # include Devise::Test::ControllerHelpers
  setup do
    @user = create(:user)
  end

  test 'new' do
    get new_user_registration_path
    assert_response :success
  end

  test "should get new" do
    get new_user_registration_path
    assert_response :success
  end

  test 'create invalid' do
    post '/users', params: { user:
                             {first_name:         '',
                             last_name:           '',
                             email:               '',
                             encrypted_password:  ''} }
    assert_response :success
  end

  test 'create valid' do
    post '/users', params: { user:
                             {first_name:           'Test',
                             last_name:             'One',
                             email:                 'test@test.com',
                             password:              'password',
                             password_confirmation: 'password' } }
    assert_response :redirect
  end

  test 'show' do
    get '/users/edit' do
      assert_response :success
    end
  end

  test 'edit' do
    get '/users/edit' do
      assert_response :success
    end
  end

  test 'update invalid' do
    post user_session_path \
      "user[email]"    => @user.email,
      "user[password]" => @user.password

    patch '/users', params: { user:
                              { first_name:         '',
                                last_name:           '',
                                email:               '',
                                encrypted_password:  ''} }
    assert_response :success
  end

  test 'update valid' do
    post user_session_path \
      'user[email]'    => @user.email,
      'user[password]' => @user.password

    patch '/users', params: { user:
                              { first_name:           'Second',
                                last_name:             @user.last_name,
                                email:                 @user.email,
                                current_password:      @user.password}}
    assert_response :redirect
  end
end
