module MediumApi
  class Publication < Struct.new(:id, :description, :name, :url, :image_url, keyword_init: true)
    include ResourceApi

    # @return [Array<Contributor>]
    def contributors
      data = client.publication_contributors(id)
      data.map do |contributor_attrs|
        Contributor.new(Utils.underscore_keys(contributor_attrs).transform_keys(&:to_sym))
      end
    end
  end
end
