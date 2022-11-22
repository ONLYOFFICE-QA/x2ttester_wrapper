# frozen_string_literal: true

require_relative 'manager'

desc 'Download core'
task :core do |_t|
  CoreActions.new.getting_core
end


desc 'Convert via x2ttester'
task :convert, :input_format, :output_format, :list do |_t, args|
  Converter.new.conversion_via_x2ttester(args[:input_format], args[:output_format], args[:list])
end
