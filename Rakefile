# frozen_string_literal: true

require_relative 'manager'

desc 'Download core'
task :core do |_t|
  CoreActions.new.download_core
end


desc 'Convert via x2ttester'
task :convert, :direction, :cores do |_t, args|
  case args[:direction].to_sym
  when :pre
    conversion_direction = 'presentations'
  when :doc
    conversion_direction = 'documents'
  when :spr
    conversion_direction = 'spreadsheets'
  when :all
    conversion_direction =  'all'
  else
    conversion_direction = ''
    message = 'Input Error. Please, enter the correct parameters, Example: rake convert[direction,cores]'
    puts(message)
  end
  Converter.conversion_with_x2ttester(args[:cores], conversion_direction) if conversion_direction
end
