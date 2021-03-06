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

require File.expand_path('../../spec_helper', __FILE__)

describe ProjectTypesController do
  let(:current_user) { FactoryGirl.create(:admin) }

  before do
    User.stub(:current).and_return current_user
  end

  describe "index.html" do
    def fetch
      get "index"
    end
    it_should_behave_like "a controller action with require_admin"
  end

  describe "new.html" do
    def fetch
      get 'new'
    end
    it_should_behave_like "a controller action with require_admin"
  end

  describe "create.html" do
    def fetch
      post 'create', :project_type => FactoryGirl.build(:project_type).attributes
    end
    def expect_redirect_to
      Regexp.new(project_types_path)
    end
    it_should_behave_like "a controller action with require_admin"
  end

  describe "edit.html" do
    def fetch
      FactoryGirl.create(:project_type, :id => '1337')
      get 'edit', :id => '1337'
    end
    it_should_behave_like "a controller action with require_admin"
  end

  describe "update.html" do
    def fetch
      FactoryGirl.create(:project_type, :id => '1337')
      put 'update', :id => '1337', :project_type => { 'name' => "blubs" }
    end
    def expect_redirect_to
      project_types_path
    end
    it_should_behave_like "a controller action with require_admin"
  end

  describe "move.html" do
    def fetch
      FactoryGirl.create(:project_type, :id => '1337')
      post 'move', :id => '1337', :project_type => {:move_to => 'highest'}
    end
    def expect_redirect_to
      project_types_path
    end
    it_should_behave_like "a controller action with require_admin"
  end

  describe "confirm_destroy.html" do
    def fetch
      FactoryGirl.create(:project_type, :id => '1337')
      get 'confirm_destroy', :id => '1337'
    end
    it_should_behave_like "a controller action with require_admin"
  end

  describe "destroy.html" do
    def fetch
      FactoryGirl.create(:project_type, :id => '1337')
      post 'destroy', :id => '1337'
    end
    def expect_redirect_to
      project_types_path
    end
    it_should_behave_like "a controller action with require_admin"
  end
end
