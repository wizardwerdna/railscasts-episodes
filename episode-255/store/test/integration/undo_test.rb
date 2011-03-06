require 'test_helper'
require 'action_controller/vendor/html-scanner'

class UndoTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "product create notices with undo link" do
    post_via_redirect "/products"
    assert_response :success
    assert_select '#flash_notice a', "undo"
  end
  
  test "product update notices with undo link" do
    put_via_redirect "/products/1"
    assert_response :success
    assert_select '#flash_notice a', "undo"
  end
  
  test "product delete notices with undo link" do
    delete_via_redirect "/products/1"
    assert_response :success
    assert_select '#flash_notice a', "undo"
  end
  
  test "undo link creates notices with redo link" do
    post_via_redirect "/products"
    undo_href = ""
    assert_select '#flash_notice a' do |x|
      undo_href = x.first.attributes['href']
    end
    post_via_redirect undo_href, {}, {'HTTP_REFERER' => "/products"}
    assert_select '#flash_notice a', /redo/
  end
  
  test "redo link creates notices with undo link" do
    post_via_redirect "/products"
    undo_href = ""
    assert_select '#flash_notice a' do |a_tag|
      undo_href = a_tag.first.attributes['href']
    end
    post_via_redirect undo_href, {}, {'HTTP_REFERER' => "/products"}
    redo_href = ""
    assert_select '#flash_notice a' do |a_tag|
      redo_href = a_tag.first.attributes['href']
    end
    post_via_redirect redo_href, {}, {'HTTP_REFERER' => "/products"}
    assert_select '#flash_notice a', /undo/
  end
end
