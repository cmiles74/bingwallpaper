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
    def initialize(market = DEFAULT_MARKET, index = DEFAULT_INDEX, storage_path = DEFAULT_STORAGE_PATH)

      @market = market
      @index = index
      @storage_path = storage_path

      # Ensure the storage path exists
      FileUtils.mkpath storage_path
    end

    # Constructs a full path for the provided partial URL.
    #
    # partial:: the end of the target URL
    def build_url(partial)

      return PROTO + DOMAIN + partial
    end

    # Returns the data URL for the image of the day.
    def get_data_url

      return build_url(PATH + '?format=' + FORMAT + '&idx=' + @index.to_s + '&n=1' + '&mkt=' + @market)
    end

    # Parses the XML data and returns a hash of image information.
    #
    # url:: complete path to the Bing image of the day
    def parse_xml(url)

      doc = Nokogiri::HTML(open(url))

      doc.xpath('//images/image').map do |image|

        # figure out the hi-res image path
        image_path = image.xpath('url').text.sub(image.xpath('url').text.rpartition("_").
                                                 last, '1920x1200.jpg')

        # build our hash of image data
        {:links => {:url => build_url(image_path),
                    :copyright_url => image.xpath('copyrightlink').text},
            :file_name => Pathname.new(image_path).basename.to_s,
            :copyright => image.xpath('copyright').text}
      end
    end

    # Returns a Pathname with location where the image from the
    # provided Bing image hash will be stored.
    #
    # image_data:: Hash of Bing image data
    def image_storage_path(image_data)
      Pathname.new @storage_path + "/" + image_data[:file_name]
    end

    # Downloads the Bing image from the provided image hash.
    #
    # image_date:: Hash of Bing image data
    def download_image(image_data)

      begin
        open(image_storage_path(image_data), 'wb') do |file|
          file << open(image_data[:links][:url]).read
        end
      rescue Exception => exception
        FileUtils.rm(image_storage_path(image_data))
        raise exception
      end
    end
  end
end
