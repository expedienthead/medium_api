module MediumApi
  class User < Struct.new(:id, :username, :name, :url, :image_url, keyword_init: true)
    include ResourceApi

    # @param post_attributes
    # @return [MediumApi::Post]
    def create_post(post_attributes)
      data = client.create_user_post(id, post_attributes)

      Post.new(Utils.underscore_keys(data))
    end

    # @return [MediumApi::Publication]
    def publications
      data = client.user_publications(id)
      data.map do |publication_attributes|
        Publication.new(Utils.underscore_keys(publication_attributes.transform_keys(&:to_sym)))
      end
    end
  end
end
