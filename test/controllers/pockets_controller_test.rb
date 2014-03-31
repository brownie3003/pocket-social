require 'test_helper'

class PocketsControllerTest < ActionController::TestCase
  setup do
    @pocket = pockets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pockets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pocket" do
    assert_difference('Pocket.count') do
      post :create, pocket: { token: @pocket.token, username: @pocket.username }
    end

    assert_redirected_to pocket_path(assigns(:pocket))
  end

  test "should show pocket" do
    get :show, id: @pocket
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pocket
    assert_response :success
  end

  test "should update pocket" do
    patch :update, id: @pocket, pocket: { token: @pocket.token, username: @pocket.username }
    assert_redirected_to pocket_path(assigns(:pocket))
  end

  test "should destroy pocket" do
    assert_difference('Pocket.count', -1) do
      delete :destroy, id: @pocket
    end

    assert_redirected_to pockets_path
  end
end
