require 'fileutils'
require 'pathname'
require 'nokogiri'
require 'open-uri'

module Bingwallpaper

  #
  # Provides a class that queries and fetches the Bing "image of the day".
  #
  class Image

    # Protocol for accessing Bing
    PROTO = 'https://'

    # Current Bing domain
    DOMAIN = 'www.bing.com'

    # Path for the image archive
    PATH = '/HPImageArchive.aspx'

    # Format for retrieving data
    FORMAT = 'xml'

    # Default market to fetch
    DEFAULT_MARKET = 'en-US'

    # Default index to fetch (today)
    DEFAULT_INDEX = 0

    # Default storage path
    DEFAULT_STORAGE_PATH = ENV['HOME'] + '/.config/bing_wallpaper'

    # Market to fetch
    attr_accessor :market

    # index to fetch
    attr_accessor :index

    # path for storing downloaded images
    attr_accessor :storage_path

    # Creates a new instance.
    #
    # market:: The market to use when fetching
    # index:: Index of the image to fetch (0 = today)
    # storage_path:: Path to directory for storing images
    def initialize(market = DEFAULT_MARKET, index = DEFAULT_INDEX,
                   storage_path = DEFAULT_STORAGE_PATH)

      @market = market
      @index = index
      @storage_path = storage_path

      # Ensure the storage path exists
      FileUtils.mkpath storage_path
    end

    # Constructs a full path for the provided partial URL.
    #
    # partial:: the end of the target URLm
    def build_url(partial)

      return PROTO + DOMAIN + partial
    end

    # Returns the data URL for the image of the day.
    def get_data_url

      return build_url(PATH + '?format=' + FORMAT + '&idx=' + @index.to_s +
                       '&n=1' + '&mkt=' + @market)
    end

    # Parses the XML data and returns a hash of image information.
    #
    # url:: complete path to the Bing image of the day
    def parse_xml(url)

      doc = Nokogiri::HTML(URI.open(url))

      doc.xpath('//images/image').map do |image|

        # figure out the hi-res image path
        image_path = image.xpath('url').text.sub(
          image.xpath('url').text.rpartition("_").last, '1920x1200.jpg')

        # store the other path as fallback
        image_fallback_path = image.xpath('url').text.to_s

        # build our hash of image data
        {:links => {:url => build_url(image_path),
                    :fallback_url => build_url(image_fallback_path),
                    :copyright_url => image.xpath('copyrightlink').text},
            :file_name => cleanup_filename(Pathname.new(image_path).basename.to_s),
            :fallback_file_name => Pathname.new(image_fallback_path).basename.to_s,
            :copyright => image.xpath('copyright').text}
      end
    end

    # Parses out a nice filename from the icky URL.
    #
    # filename:: Filename from the URL
    def cleanup_filename(filename)
      matches = /[A-Za-z0-9_-]+\.jpg/.match(filename)

      if matches.length > 0
        return matches[0]
      end

      return filename
    end

    # Returns a Pathname with location where the image from the
    # provided Bing image hash will be stored.
    #
    # file_name:: Path to the file storage location'
    def image_storage_path(file_name)
      Pathname.new @storage_path + "/" + file_name
    end

    # Downloads the image at the supplied URL and saves it to the
    # specified file.
    #
    # file_path:: Path for the storing image
    # url:: URL to the image to download
    def download_image(file_path, url)

      begin

        # download the hi-res image
        open(file_path, 'wb') do |file|
          file << URI.open(url).read
        end
      rescue Exception => exception
        file_path.delete
        raise exception
      end
    end
  end
end
