#-- encoding: UTF-8
#-- copyright
# OpenProject is a project management system.
#
# Copyright (C) 2012-2013 the OpenProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# See doc/COPYRIGHT.rdoc for more details.
#++
require File.expand_path('../../test_helper', __FILE__)
require 'issue_categories_controller'

# Re-raise errors caught by the controller.
class IssueCategoriesController; def rescue_action(e) raise e end; end

class IssueCategoriesControllerTest < ActionController::TestCase
  fixtures :all

  def setup
    super
    @controller = IssueCategoriesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    User.current = nil
    @request.session[:user_id] = 2
  end

  def test_get_new
    @request.session[:user_id] = 2 # manager
    get :new, :project_id => '1'
    assert_response :success
    assert_template 'new'
  end

  def test_post_new
    @request.session[:user_id] = 2 # manager
    assert_difference 'IssueCategory.count' do
      post :create, :project_id => '1', :category => {:name => 'New category', :assigned_to_id => 3}
    end
    assert_redirected_to '/projects/ecookbook/settings/categories'
    category = IssueCategory.find_by_name('New category')
    assert_not_nil category
    assert_equal 1, category.project_id
    assert_equal 3, category.assigned_to_id
  end

  def test_post_edit
    assert_no_difference 'IssueCategory.count' do
      post :update, :id => 2, :category => { :name => 'Testing' }
    end
    assert_redirected_to '/projects/ecookbook/settings/categories'
    assert_equal 'Testing', IssueCategory.find(2).name
  end

  def test_edit_not_found
    post :update, :id => 97, :category => { :name => 'Testing' }
    assert_response 404
  end

  def test_destroy_category_not_in_use
    delete :destroy, :id => 2
    assert_redirected_to '/projects/ecookbook/settings/categories'
    assert_nil IssueCategory.find_by_id(2)
  end

  def test_destroy_category_in_use
    delete :destroy, :id => 1
    assert_response :success
    assert_template 'destroy'
    assert_not_nil IssueCategory.find_by_id(1)
  end

  def test_destroy_category_in_use_with_reassignment
    issue = Issue.find(:first, :conditions => {:category_id => 1})
    delete :destroy, :id => 1, :todo => 'reassign', :reassign_to_id => 2
    assert_redirected_to '/projects/ecookbook/settings/categories'
    assert_nil IssueCategory.find_by_id(1)
    # check that the issue was reassign
    assert_equal 2, issue.reload.category_id
  end

  def test_destroy_category_in_use_without_reassignment
    issue = Issue.find(:first, :conditions => {:category_id => 1})
    delete :destroy, :id => 1, :todo => 'nullify'
    assert_redirected_to '/projects/ecookbook/settings/categories'
    assert_nil IssueCategory.find_by_id(1)
    # check that the issue category was nullified
    assert_nil issue.reload.category_id
  end
end
