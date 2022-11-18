# frozen_string_literal: true

require_relative '../manager'

# class with some constants and static data
class StaticData
  PROJECT_DIR = Dir.pwd
  TMP_DIR = "#{PROJECT_DIR}/tmp/"
  CORE_DIR = "#{PROJECT_DIR}/core/"
  FONTS_DIR = "#{PROJECT_DIR}/assets/fonts/"
  HOST, ARCH, X2T, X2TTESTER, STANDARDTESTER = HostConfig.host_information
  X2T_PATH = "#{CORE_DIR}/#{X2T}"
  REPORTS_DIR = "#{PROJECT_DIR}/reports/"

  X2T_CONNECTIONS = JSON.load_file("#{PROJECT_DIR}/config/x2t_connections.json")
  CONFIG = JSON.load_file("#{PROJECT_DIR}/config.json")
end
