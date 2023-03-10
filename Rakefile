# frozen_string_literal: true

require_relative 'framework/manager_x2ttesting'

desc 'Download core'
task :download_core do |_t|
  core.get
end


desc 'Convert via converter with indication of conversion directions'
task :convert, :input_format, :output_format do |_t, args|
  x2ttester.convert(args[:input_format], args[:output_format])
end

desc 'Convert via converter from file names array'
task :convert_array, :input_format, :output_format do |_t, args|
  x2ttester.convert_from_files_array(args[:input_format], args[:output_format])
end
