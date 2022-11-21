# frozen_string_literal: true

# a class with methods to control the conversion
class Converter
  # Run x2ttester
  # @param [String] conversion_direction Conversion direction
  # @param [String] core_num Number of threads to convert
  def conversion_via_x2ttester(core_num, conversion_direction)
    time_before = Time.now
    tmp_xml = XmlActions.new.generate_parameters(core_num, conversion_direction)
    system("#{ProjectConfig.core_dir}/#{ProjectConfig.host_config[:x2ttester]} #{tmp_xml.path}")
    p "Result time in seconds: #{Time.now - time_before}"
    tmp_xml.close!
  end
end
