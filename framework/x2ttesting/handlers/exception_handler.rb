# frozen_string_literal: true


module X2tTesting
  # Custom Exception handler
  class RedStandardError < StandardError
    def initialize(msg = '')
      super
      OnlyofficeLoggerHelper.red_log(msg)
    end
  end
end
