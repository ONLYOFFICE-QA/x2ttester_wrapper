# frozen_string_literal: true


module X2tTesting
  # class generate xml_actions for x2t
  class X2tLibsXml

    def initialize
      @x2t_connections = JSON.load_file("#{__dir__}/assets/x2t_connections.json")
    end

    # Generates a file for x2t with paths to sdkjs libraries
    # @return [Xml]
    def doc_renderer_config
      Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.Settings do
          xml.file(@x2t_connections.fetch('native'))
          xml.file(@x2t_connections.fetch('jquery_native'))
          xml.allfonts(@x2t_connections.fetch('AllFonts'))
          xml.file(@x2t_connections.fetch('xregexp_all_min'))
          xml.sdkjs(@x2t_connections.fetch('sdkjs'))
        end
      end.to_xml
    end
  end
end
