module MediumApi
  # A main class to make http calls to medium.com
  class Client
    include HTTParty

    base_uri 'https://api.medium.com/v1'

    attr_reader :api_key

    # @visibility private
    CODE_TO_ERROR = {
      400 => Error::BadRequestError,
      401 => Error::UnauthorizedError,
      403 => Error::ForbiddenError
    }.freeze

    def initialize(api_key:)
      @api_key = api_key
      self.class.headers('Authorization' => "Bearer #{@api_key}")
    end

    # Returns current user for specified api_key
    # @return [Hash]
    # @raise [MediumApi::Error::UnauthorizedError]
    def me
      with_error_handling do
        self.class.get('/me')
      end
    end

    # Return publications for provided user_id
    # @param user_id [String, Integer]
    # @return [Array<Hash>]
    # @raise [MediumApi::Error::UnauthorizedError]
    # @raise [MediumApi::Error::ForbiddenError]
    def user_publications(user_id)
      with_error_handling do
        self.class.get("/users/#{user_id}/publications")
      end
    end

    # Return contributors for provided publication_id
    # @param publication_id [String, Integer]
    # @return [Array<Hash>]
    # @raise [MediumApi::Error::UnauthorizedError]
    def publication_contributors(publication_id)
      with_error_handling do
        self.class.get("/publications/#{publication_id}/contributors")
      end
    end

    # Create user post for provided user_id
    # @param user_id [String, Integer]
    # @param post_attributes [Hash]
    # @return [Array<Hash>]
    # @see MediumApi::Post for possible post attributes
    # @raise [MediumApi::Error::UnauthorizedError]
    # @raise [MediumApi::Error::ForbiddenError]
    # @raise [MediumApi::Error::BadRequestError]
    def create_user_post(user_id, post_attributes)
      with_error_handling do
        self.class.post("/users/#{user_id}/posts", body: Utils.camelcase_keys(post_attributes))
      end
    end

    private

    def with_error_handling
      response = yield

      return response['data'] if response.success?

      message = response['errors'].first['message']
      error_class = CODE_TO_ERROR[response.code] || MediumApi::Error
      raise error_class, message
    end
  end
end
