# frozen_string_literal: true

require_relative 'manager'

desc 'Download core'
task :core do |_t|
  CoreActions.new.download_core
end


desc 'Convert via x2ttester'
task :convert, :cores, :direction do |_t, args|
  case args[:direction].to_sym
  when :pre
    conversion_direction = 'presentations'
  when :doc
    conversion_direction = 'documents'
  when :spr
    conversion_direction = 'spreadsheets'
  when :all
    conversion_direction = 'all'
  else
    raise('Input Error. Please, enter the correct parameters, Example: rake convert[direction,cores]')
  end
  Converter.new.conversion_via_x2ttester(args[:cores], conversion_direction)
end
