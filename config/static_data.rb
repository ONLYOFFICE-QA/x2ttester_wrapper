# frozen_string_literal: true

require 'json'

# class with some constants and static data
class StaticData
  TMP_DIR = "#{Dir.pwd}/tmp"
  PROJECT_BIN_PATH = "#{Dir.pwd}/core"

  X2T_CONNECTIONS = JSON.load_file("#{Dir.pwd}/config/x2t_connections.json")
end
