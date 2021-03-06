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

require 'rexml/document'

module OpenProject
  module VERSION #:nodoc:

    MAJOR = 3
    MINOR = 0
    PATCH = 0
    TINY  = PATCH # Redmine compat

    # Used by semver to define the special version (if any).
    # A special version "satify but have a lower precedence than the associated
    # normal version". So 2.0.0RC1 would be part of the 2.0.0 series but
    # be considered to be an older version.
    #
    #   1.4.0 < 2.0.0RC1 < 2.0.0RC2 < 2.0.0 < 2.1.0
    #
    # This method may be overridden by third party code to provide vendor or
    # distribution specific versions. They may or may not follow semver.org:
    #
    #   2.0.0debian-2
    def self.special
      'pre15'
    end

    def self.revision
      revision = `git rev-parse HEAD`
      if revision.present?
        revision.strip[0..8]
      else
        nil
      end
    end

    REVISION = self.revision
    ARRAY = [MAJOR, MINOR, PATCH, REVISION].compact
    STRING = ARRAY.join('.')

    def self.to_a; ARRAY end
    def self.to_s; STRING end
    def self.to_semver
      [MAJOR, MINOR, PATCH].join('.') + special
    end
  end
end
