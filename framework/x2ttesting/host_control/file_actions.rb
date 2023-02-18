# frozen_string_literal: true

module X2tTesting
  # class for file management
  class FileActions
    # checks doubling folder after unpacking, removes doubling folder
    # @param [String] dir_path
    def self.fix_double_folder(dir_path)
      return unless Dir.exist?(File.join(dir_path, File.basename(dir_path)))

      OnlyofficeLoggerHelper.green_log('Fixing double folder')
      Dir[File.join(dir_path, File.basename(dir_path), '*')].each do |file|
        FileUtils.mv(file, dir_path)
      end
      FileUtils.rm_rf(File.join(dir_path, File.basename(dir_path)))
    end

    # Generates a command to get information about the status of the core on the server
    # @param [String] url
    # @return [Hash] headers in Hash format
    def self.get_headers(url)
      uri = URI.parse(url)
      headers = Net::HTTP.start(uri.hostname, uri.port, { use_ssl: uri.scheme == 'https' }) do |http|
        http.request(Net::HTTP::Head.new(uri))
      end
      return headers.to_hash if headers.code == '200'

      raise(OnlyofficeLoggerHelper.red_log("Can't get headers\nURL: #{@url}\nResponse:\n#{status.code}\n"))
    end

    # @param [String] url
    # @param [String] file_path  path where to download the file
    def self.download_file(url, file_path)
      File.open(file_path, 'wb') do |file|
        file.write(Net::HTTP.get_response(URI(url)).body)
      end
    end

    # @param [String] archive_path Path to the archive to unpack
    # @param [String] execute_path The path to the unpacking location
    # @param [Boolean] delete If true deletes the archive after downloading, by default it is false
    def self.unpacking_7z(archive_path, execute_path, delete: false)
      File.open(archive_path, 'rb') do |file|
        SevenZipRuby::Reader.open(file) do |szr|
          szr.extract_all execute_path
          FileUtils.rm_rf(archive_path) if delete
        end
        OnlyofficeLoggerHelper.green_log('Unpack completed')
      end
    end
  end
end
