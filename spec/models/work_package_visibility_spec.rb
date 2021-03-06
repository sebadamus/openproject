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

require 'spec_helper'

describe "WorkPackage-Visibility" do

  let(:admin)    {FactoryGirl.create(:admin)}
  let(:anonymous){FactoryGirl.create(:anonymous)}
  let(:user)    {FactoryGirl.create(:user)}
  let(:public_project) {FactoryGirl.create(:project, is_public: true)}
  let(:private_project) {FactoryGirl.create(:project, is_public: false)}
  let(:other_project) {FactoryGirl.create(:project, is_public: true)}
  let(:view_work_packages) {FactoryGirl.create(:role, :permissions => [:view_work_packages])}

  describe "of public projects" do
    subject { FactoryGirl.create(:work_package, :project => public_project)}

    it "should be viewable by anonymous users, when the anonymous-role has the permission to view packages" do
      # it is not really clear, where these kind of "preconditions" belong to: This setting
      # is a default in Redmine::DefaultData::Loader - but this not loaded in the tests: here we
      # just make sure, that the workpackage is visible, when this permission is set
      Role.anonymous.add_permission! :view_work_packages
      WorkPackage.visible(anonymous).should include subject
    end

  end


  describe "of private projects" do
    subject { FactoryGirl.create(:work_package, :project => private_project)}

    it "should be visible for the admin, even if the project is private" do
      WorkPackage.visible(admin).should include subject
    end

    it "should not be visible for anonymous users, when the project is private" do
      WorkPackage.visible(anonymous).should_not include subject
    end

    it "should be visible for members of the project, that are allowed to view workpackages" do
      member = FactoryGirl.create(:member, user: user, project: private_project, role_ids: [view_work_packages.id])
      WorkPackage.visible(user).should include subject
    end

    it "should __not__ be visible for non-members of the project without the permission to view workpackages" do
      WorkPackage.visible(user).should_not include subject
    end

    it "should __not__ be visible for members of the project, without the right to view work_packages" do
      no_permission = FactoryGirl.create(:role, :permissions => [:no_permission])
      member = FactoryGirl.create(:member, user: user, project: private_project, role_ids: [no_permission.id])

      WorkPackage.visible(user).should_not include subject
    end
  end

end

