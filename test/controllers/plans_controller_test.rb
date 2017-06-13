require 'test_helper'
require 'stripe_mock'

class PlansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @plan = create(:plan)
    @user = create(:user)
    post user_session_path \
      "user[email]"    => @user.email,
      "user[password]" => @user.password
  end

  test "should get index" do
    get '/admin/plans'
    assert_response :success
  end

  test "should get new" do
    get new_plan_url
    assert_response :success
  end

  test "should create plan" do
    assert_difference('Plan.count') do
      post '/admin/plans', params: { plan: params(:valid) }
    end

    assert_redirected_to plan_url(Plan.last)
  end

  test "should create invalid plan" do
    # This works due to the if statement on plan.valid? in /services/create_stripe_plan.rb
    # scoped url '/admin/plans'
    post '/admin/plans', params: { plan: params(:invalid) }
    assert_response :success
  end

  test "should show plan" do
    # not a scoped url '/plans'
    get plan_url(@plan)
    assert_response :success
  end

  test "should get edit" do
    get "/admin/plans/#{@plan.id}/edit"
    assert_response :success
  end

  test "should update valid plan" do
    patch "/admin/plans/#{@plan.id}", params: { plan: params(:valid) }
    assert_redirected_to plan_url(@plan)
  end

  test "should update invalid plan" do
    patch "/admin/plans/#{@plan.id}", params: { plan: params(:invalid) }
    assert_response :success
  end

  test "should destroy plan" do
    assert_difference('Plan.count', -1) do
      delete "/admin/plans/#{@plan.id}"
    end

    assert_redirected_to plans_url
  end

  def params(kind = :valid)
    case kind
    when :invalid
      { amount: '', description: '', interval: '', name: '', published: '', stripe_id: '' }
    when :valid
      { amount: 2000, description: 'Second Plan is awesome', interval: 'month', name: 'Second Plan Name', published: true, stripe_id: 'second_stripe_plan'  }
    end
  end
end
