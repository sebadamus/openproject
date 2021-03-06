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

#-- encoding: UTF-8
require File.join(File.dirname(__FILE__), 'test_helper')

class ConfigurationTest < Test::Unit::TestCase
  context 'Global configuration options' do
    setup do
      module Extension; end
      
      @options = {
        'class_name' => 'CustomVersion',
        :extend => Extension,
        :as => :parent
      }
      
      VestalVersions.configure do |config|
        @options.each do |key, value|
          config.send("#{key}=", value)
        end
      end

      @configuration = VestalVersions::Configuration.options
    end

    should 'should be a hash' do
      assert_kind_of Hash, @configuration
    end

    should 'have symbol keys' do
      assert @configuration.keys.all?{|k| k.is_a?(Symbol) }
    end

    should 'store values identical to those given' do
      assert_equal @options.symbolize_keys, @configuration
    end

    teardown do
      VestalVersions::Configuration.options.clear
    end
  end
end
