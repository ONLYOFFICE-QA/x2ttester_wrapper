# frozen_string_literal: true

# a class with methods to control the conversion
class Converter
  # Run x2ttester
  # @param [String] conversion_direction Conversion direction
  # @param [String] core_num Number of threads to convert
  def self.conversion_with_x2ttester(core_num, conversion_direction)
    time_before = Time.now
    tmp_xml = XmlActions.generate_param_for_x2ttester(core_num, conversion_direction)
    system("#{StaticData::CORE_DIR}/#{StaticData::X2TTESTER} #{tmp_xml.path}")
    p "Result time in seconds: #{Time.now - time_before}"
    tmp_xml.close!
  end
end

