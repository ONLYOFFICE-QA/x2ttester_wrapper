# frozen_string_literal: true

# Module with methods for configuring the project
module ProjectConfig
  def self.host_config
    @host_config ||= HostActions.new.host_validations
  end

  def self.core_dir
    "#{Dir.pwd}/core/"
  end

  def self.fonts_dir
    "#{Dir.pwd}/assets/fonts/"
  end

  def self.reports_dir
    "#{Dir.pwd}/reports/"
  end

  def self.tmp_dir
    "#{Dir.pwd}/tmp/"
  end
end
