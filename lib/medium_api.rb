require 'httparty'
require 'medium_api/version'
require 'medium_api/utils'
require 'medium_api/resource_api'
require 'medium_api/errors'
require 'medium_api/client'
require 'medium_api/configuration'
require 'medium_api/user'
require 'medium_api/publication'
require 'medium_api/post'
require 'medium_api/contributor'

module MediumApi
  class << self
    # Used for configuring MediumApi
    # @example
    # MediumApi.configure do |config|
    #   config.api_key = ''
    # end
    # @yield [MediumApi::Configuration]
    def configure
      yield configuration
    end

    # @return [MediumApi::Configuration]
    def configuration
      @configuration ||= Configuration.new
    end

    # Method to get current user for provided api_key
    # @return [MediumApi::User]
    def me
      attributes = client.me

      User.new(**Utils.underscore_keys(attributes.transform_keys(&:to_sym)))
    end

    # @return [MediumApi::Client]
    def client
      @client ||= Client.new(api_key: configuration.api_key)
    end
  end
end
