require 'test_helper'

class SaverecordsControllerTest < ActionController::TestCase
  setup do
    @saverecord = saverecords(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:saverecords)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create saverecord" do
    assert_difference('Saverecord.count') do
      post :create, saverecord: { saving_id: @saverecord.saving_id, srnextdate: @saverecord.srnextdate, srnowdate: @saverecord.srnowdate, srnowdetail: @saverecord.srnowdetail, srnowdiary: @saverecord.srnowdiary, srnownotice: @saverecord.srnownotice, srnowvalue: @saverecord.srnowvalue }
    end

    assert_redirected_to saverecord_path(assigns(:saverecord))
  end

  test "should show saverecord" do
    get :show, id: @saverecord
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @saverecord
    assert_response :success
  end

  test "should update saverecord" do
    patch :update, id: @saverecord, saverecord: { saving_id: @saverecord.saving_id, srnextdate: @saverecord.srnextdate, srnowdate: @saverecord.srnowdate, srnowdetail: @saverecord.srnowdetail, srnowdiary: @saverecord.srnowdiary, srnownotice: @saverecord.srnownotice, srnowvalue: @saverecord.srnowvalue }
    assert_redirected_to saverecord_path(assigns(:saverecord))
  end

  test "should destroy saverecord" do
    assert_difference('Saverecord.count', -1) do
      delete :destroy, id: @saverecord
    end

    assert_redirected_to saverecords_path
  end
end
