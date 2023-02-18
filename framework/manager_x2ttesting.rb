# frozen_string_literal: true

require 'net/http'
require 'onlyoffice_logger_helper'
require 'onlyoffice_tcm_helper'
require 'json'
require 'nokogiri'
require 'uri'
require 'seven_zip_ruby'

require_relative './x2ttesting/only_office_x2t_libs/core'
require_relative './x2ttesting/only_office_x2t_libs/generators/url_generator'
require_relative './x2ttesting/host_control/host_config'
require_relative './x2ttesting/host_control/file_actions'
require_relative './x2ttesting/converter/x2ttester'
require_relative './x2ttesting/xml_actions/x2ttester_xml'
require_relative './x2ttesting/xml_actions/x2t_libs_xml'
require_relative './x2ttesting/handlers/exception_handler'

def core
  @core ||= X2tTesting::Core.new(
    JSON.load_file(File.join(Dir.pwd, 'x2ttester_config.json')),
    {
      tmp_dir: File.join(Dir.pwd, 'tmp'),
      x2t_dir: File.join(Dir.pwd, 'core')
    }
  )
end

def x2ttester
  @x2ttester ||= X2tTesting::X2tTester.new(
    JSON.load_file(File.join(Dir.pwd, 'x2ttester_config.json')),
    {
      tmp_dir: File.join(Dir.pwd, 'tmp'),
      x2t_dir: File.join(Dir.pwd, 'core'),
      fonts_dir: File.join(Dir.pwd, 'assets', 'fonts'),
      project_dir: Dir.pwd.freeze,
      report_dir: File.join(Dir.pwd, 'reports')
    }
  )
end
