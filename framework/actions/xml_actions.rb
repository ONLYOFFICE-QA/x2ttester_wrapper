# frozen_string_literal: true

# class for working with xml
class XmlActions
  # @param [Object] args
  # @return [Object]
  def self.generate_doc_renderer_xml(args)
    Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.Settings do
        xml.file(args.fetch('native'))
        xml.file(args.fetch('jquery_native'))
        xml.allfonts(args.fetch('AllFonts'))
        xml.file(args.fetch('xregexp_all_min'))
        xml.sdkjs(args.fetch('sdkjs'))
      end
    end.to_xml
  end

  # @param [Object] path_to
  # @return [Integer]
  def self.create_doc_renderer_config(path_to)
    File.write("#{path_to}/DoctRenderer.config", generate_doc_renderer_xml(StaticData::X2T_CONNECTIONS))
  end
end
