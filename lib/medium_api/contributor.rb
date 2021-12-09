module MediumApi
  class Contributor < Struct.new(:user_id, :publication_id, :role, keyword_init: true)
  end
end
