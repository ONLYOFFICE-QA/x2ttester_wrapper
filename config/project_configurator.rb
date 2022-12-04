# frozen_string_literal: true

# Module with methods for configuring the project
module ProjectConfig
  PROJECT_DIR = Dir.pwd
  def self.host_config
    @host_config ||= HostActions.new.host_validations
  end

  def self.core_dir
    "#{PROJECT_DIR}/core/"
  end

  def self.fonts_dir
    "#{PROJECT_DIR}/assets/fonts/"
  end

  def self.reports_dir
    "#{PROJECT_DIR}/reports/"
  end

  def self.tmp_dir
    "#{PROJECT_DIR}/tmp/"
  end
end
