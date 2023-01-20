# frozen_string_literal: true

# Module with methods for configuring the project
module ProjectConfig
  PROJECT_DIR = Dir.pwd.freeze
  CONFIG = JSON.load_file("#{PROJECT_DIR}/config/x2ttester_config.json")
  def self.host_config
    @host_config ||= HostActions.new.host_validations
  end

  def self.core_dir
    File.join(PROJECT_DIR, 'core')
  end

  def self.fonts_dir
    File.join(PROJECT_DIR, 'assets', 'fonts')
  end

  def self.reports_dir
    File.join(PROJECT_DIR, 'reports')
  end

  def self.tmp_dir
    File.join(PROJECT_DIR, 'tmp')
  end

  def self.x2ttester_config_path
    File.join(PROJECT_DIR, 'config', 'x2ttester_config.json')
  end
end
