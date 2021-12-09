module MediumApi
  # @api private
  module Utils
    module_function

    def underscore_keys(hash)
      hash.transform_keys do |key|
        new_key = underscore(key.to_s)
        key.is_a?(Symbol) ? new_key.to_sym : new_key
      end
    end

    def underscore(string)
      string.gsub(/([A-Z])/, '_\1').downcase
    end

    def camelcase_keys(hash)
      hash.transform_keys do |key|
        new_key = camelcase(key.to_s)
        key.is_a?(Symbol) ? new_key.to_sym : new_key
      end
    end

    def camelcase(string)
      first_word, *words = string.split('_')

      [first_word, *words.map(&:capitalize)].join('')
    end
  end
end
